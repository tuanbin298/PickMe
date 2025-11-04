package org.example.service;

import org.example.dto.mapper.RestaurantStaffMapper;
import org.example.dto.response.RestaurantStaffResponse;
import org.example.dto.response.RestaurantStatusResponse;
import org.example.entity.ApprovalStatus;
import org.example.entity.Restaurant;
import org.example.entity.RestaurantStaff;
import org.example.entity.Role;
import org.example.entity.User;
import org.example.exception.AccessDeniedException;
import org.example.repository.RestaurantRepository;
import org.example.repository.RestaurantStaffRepository;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.Coordinate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class RestaurantService {
    
    @Autowired
    private RestaurantRepository restaurantRepository;
    
    @Autowired
    private RestaurantStaffRepository restaurantStaffRepository;
    
    @Autowired
    private RestaurantStaffMapper restaurantStaffMapper;
    
    @Autowired
    private GeometryFactory geometryFactory;
    
    // SRID 4326 là WGS84 (World Geodetic System 1984) - standard cho GPS coordinates
    private static final int SRID = 4326;
    
    /**
     * Tạo restaurant mới (chỉ RESTAURANT_OWNER có thể tạo)
     */
    public Restaurant createRestaurant(User owner, Restaurant restaurant) {
        validateRestaurantOwner(owner);
        
        restaurant.setOwner(owner);
        restaurant.setApprovalStatus(ApprovalStatus.PENDING);
        restaurant.setCreatedAt(LocalDateTime.now());
        
        return restaurantRepository.save(restaurant);
    }
    
    /**
     * Lấy tất cả restaurant của một owner
     */
    public List<Restaurant> getRestaurantsByOwner(Long ownerId) {
        return restaurantRepository.findByOwnerIdAndIsActiveTrue(ownerId);
    }
    
    /**
     * Lấy tất cả restaurant đã được duyệt của một owner
     */
    public List<Restaurant> getApprovedRestaurantsByOwner(Long ownerId) {
        return restaurantRepository.findApprovedRestaurantsByOwnerId(ownerId);
    }
    
    /**
     * Admin approve restaurant
     */
    public Restaurant approveRestaurant(Long restaurantId, User admin) {
        validateAdmin(admin);
        
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
            .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        restaurant.approve(admin);
        return restaurantRepository.save(restaurant);
    }
    
    /**
     * Admin reject restaurant
     */
    public Restaurant rejectRestaurant(Long restaurantId, User admin, String reason) {
        validateAdmin(admin);
        
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
            .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        restaurant.reject(admin, reason);
        return restaurantRepository.save(restaurant);
    }

    public List<Restaurant> getApprovedRestaurants() {
        return restaurantRepository.findByApprovalStatus(ApprovalStatus.APPROVED);
    }

    public Optional<Restaurant> getApprovedRestaurantById(Long id) {
        return restaurantRepository.findByIdAndApprovalStatus(id, ApprovalStatus.APPROVED);
    }

    public List<Restaurant> getAllRestaurants(User admin) {
        validateAdmin(admin);
        return restaurantRepository.findAll();
    }

    public List<Restaurant> getPendingApprovalRestaurants(User admin) {
        validateAdmin(admin);
        return restaurantRepository.findPendingApprovalRestaurants();
    }
    
    /**
     * Cập nhật restaurant (chỉ owner hoặc staff của restaurant đó)
     */
    public Restaurant updateRestaurant(Long restaurantId, Restaurant updatedRestaurant, User user) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
            .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        validateRestaurantAccess(user, restaurant);
        
        // Update fields
        restaurant.setName(updatedRestaurant.getName());
        restaurant.setDescription(updatedRestaurant.getDescription());
        restaurant.setAddress(updatedRestaurant.getAddress());
        restaurant.setPhoneNumber(updatedRestaurant.getPhoneNumber());
        restaurant.setEmail(updatedRestaurant.getEmail());
        restaurant.setImageUrl(updatedRestaurant.getImageUrl());
        restaurant.setOpeningTime(updatedRestaurant.getOpeningTime());
        restaurant.setClosingTime(updatedRestaurant.getClosingTime());
        restaurant.setCategories(updatedRestaurant.getCategories());
        
        // Location update
        if (updatedRestaurant.getLocation() != null) {
            restaurant.setLocation(updatedRestaurant.getLocation());
        }
        
        restaurant.setUpdatedAt(LocalDateTime.now());
        
        return restaurantRepository.save(restaurant);
    }
    
    /**
     * Tạo sub-account cho staff (chỉ owner)
     */
    public RestaurantStaffResponse createStaffAccount(User owner, User staffUser, Long restaurantId, String position) {
        validateRestaurantOwner(owner);
        
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
            .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        // Verify restaurant belongs to this owner
        if (!restaurant.getOwner().getId().equals(owner.getId())) {
            throw new AccessDeniedException("You don't own this restaurant");
        }
        
        // Set staff role
        staffUser.setRole(Role.RESTAURANT_STAFF);
        
        RestaurantStaff restaurantStaff = new RestaurantStaff(staffUser, restaurant, owner, position);
        RestaurantStaff savedStaff = restaurantStaffRepository.save(restaurantStaff);
        
        return restaurantStaffMapper.toResponse(savedStaff);
    }
    
    /**
     * Lấy tất cả staff của owner
     */
    public List<RestaurantStaffResponse> getStaffByOwner(Long ownerId) {
        List<RestaurantStaff> staffList = restaurantStaffRepository.findByOwnerIdAndIsActiveTrue(ownerId);
        return restaurantStaffMapper.toResponseList(staffList);
    }
    
    /**
     * Lấy tất cả staff của một restaurant
     */
    public List<RestaurantStaffResponse> getStaffByRestaurant(Long restaurantId) {
        List<RestaurantStaff> staffList = restaurantStaffRepository.findByRestaurantIdAndIsActiveTrue(restaurantId);
        return restaurantStaffMapper.toResponseList(staffList);
    }
    
    /**
     * Kiểm tra user có quyền truy cập restaurant không
     */
    public boolean hasRestaurantAccess(User user, Long restaurantId) {
        if (user.getRole() == Role.ADMIN) {
            return true;
        }
        
        Restaurant restaurant = restaurantRepository.findById(restaurantId).orElse(null);
        if (restaurant == null) {
            return false;
        }
        
        // Owner có quyền truy cập tất cả restaurants của mình
        if (user.getRole() == Role.RESTAURANT_OWNER && 
            restaurant.getOwner().getId().equals(user.getId())) {
            return true;
        }
        
        // Staff chỉ có quyền truy cập restaurant được assign
        if (user.getRole() == Role.RESTAURANT_STAFF) {
            Optional<RestaurantStaff> staffAssignment = 
                restaurantStaffRepository.findStaffAssignment(user.getId(), restaurantId);
            return staffAssignment.isPresent();
        }
        
        return false;
    }
    
    /**
     * Tạo Point từ latitude và longitude với SRID 4326
     */
    public Point createPoint(double latitude, double longitude) {
        // Validate coordinates
        if (latitude < -90 || latitude > 90) {
            throw new IllegalArgumentException("Latitude must be between -90 and 90 degrees");
        }
        if (longitude < -180 || longitude > 180) {
            throw new IllegalArgumentException("Longitude must be between -180 and 180 degrees");
        }
        
        Point point = geometryFactory.createPoint(new Coordinate(longitude, latitude));
        point.setSRID(SRID);
        return point;
    }
    
    // Private helper methods
    private void validateAdmin(User user) {
        if (user.getRole() != Role.ADMIN) {
            throw new AccessDeniedException("Only admin can perform this action");
        }
    }
    
    private void validateRestaurantOwner(User user) {
        if (user.getRole() != Role.RESTAURANT_OWNER) {
            throw new AccessDeniedException("Only restaurant owner can perform this action");
        }
    }
    
    private void validateRestaurantAccess(User user, Restaurant restaurant) {
        if (!hasRestaurantAccess(user, restaurant.getId())) {
            throw new AccessDeniedException("You don't have access to this restaurant");
        }
    }
    
    /**
     * Get restaurant status (open/closed)
     */
    public Restaurant getRestaurantStatus(Long restaurantId) {
        return restaurantRepository.findById(restaurantId)
            .orElseThrow(() -> new IllegalArgumentException("Restaurant not found"));
    }
    
    /**
     * Get status for multiple restaurants
     */
    public List<Restaurant> getRestaurantsStatus(List<Long> restaurantIds) {
        return restaurantRepository.findAllById(restaurantIds);
    }
    
    /**
     * Get all open restaurants
     */
    public List<Restaurant> getOpenRestaurants() {
        return restaurantRepository.findAllActiveAndApproved().stream()
            .filter(Restaurant::isOpen)
            .toList();
    }
    
    /**
     * Get nearby open restaurants
     */
    public List<Restaurant> getNearbyOpenRestaurants(double latitude, double longitude, double radiusKm) {
        // Convert kilometers to meters for the repository method
        double radiusMeters = radiusKm * 1000;
        List<Restaurant> nearbyRestaurants = restaurantRepository.findRestaurantsWithinRadius(latitude, longitude, radiusMeters);
        return nearbyRestaurants.stream()
            .filter(Restaurant::isOpen)
            .toList();
    }
    
    /**
     * Convert Restaurant to RestaurantStatusResponse
     */
    public RestaurantStatusResponse toStatusResponse(Restaurant restaurant) {
        RestaurantStatusResponse response = new RestaurantStatusResponse();
        response.setId(restaurant.getId());
        response.setName(restaurant.getName());
        response.setStatus(restaurant.getOpenStatus());
        response.setIsOpen(restaurant.isOpen());
        response.setOpeningTime(restaurant.getOpeningTime());
        response.setClosingTime(restaurant.getClosingTime());
        
        long minutesUntilChange = restaurant.getMinutesUntilStatusChange();
        response.setMinutesUntilStatusChange(minutesUntilChange >= 0 ? minutesUntilChange : null);
        
        // Generate status message
        response.setStatusMessage(generateStatusMessage(restaurant));
        
        return response;
    }
    
    private String generateStatusMessage(Restaurant restaurant) {
        String status = restaurant.getOpenStatus();
        long minutesUntil = restaurant.getMinutesUntilStatusChange();
        
        switch (status) {
            case "OPEN":
                if (minutesUntil > 0) {
                    long hours = minutesUntil / 60;
                    long mins = minutesUntil % 60;
                    if (hours > 0) {
                        return String.format("Open • Closes in %d hours %d minutes", hours, mins);
                    } else {
                        return String.format("Open • Closes in %d minutes", mins);
                    }
                }
                return "Open";
                
            case "CLOSED":
                if (minutesUntil > 0) {
                    long hours = minutesUntil / 60;
                    long mins = minutesUntil % 60;
                    if (hours > 0) {
                        return String.format("Closed • Opens in %d hours %d minutes", hours, mins);
                    } else {
                        return String.format("Closed • Opens in %d minutes", mins);
                    }
                }
                return "Closed";
                
            case "INACTIVE":
                return "Restaurant is temporarily inactive";
                
            case "PENDING_APPROVAL":
                return "Restaurant is pending approval";
                
            case "NO_HOURS_SET":
                return "Opening hours not set";
                
            default:
                return status;
        }
    }
}