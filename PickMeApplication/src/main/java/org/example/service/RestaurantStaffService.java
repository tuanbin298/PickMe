package org.example.service;

import org.example.dto.mapper.RestaurantStaffMapper;
import org.example.dto.response.RestaurantStaffResponse;
import org.example.entity.RestaurantStaff;
import org.example.entity.User;
import org.example.entity.Restaurant;
import org.example.repository.RestaurantStaffRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class RestaurantStaffService {
    
    @Autowired
    private RestaurantStaffRepository restaurantStaffRepository;
    
    @Autowired
    private RestaurantStaffMapper restaurantStaffMapper;
    
    /**
     * Create new staff account
     */
    public RestaurantStaffResponse createStaffAccount(User owner, User staffUser, Restaurant restaurant, String position) {
        RestaurantStaff restaurantStaff = new RestaurantStaff(staffUser, restaurant, owner, position);
        RestaurantStaff savedStaff = restaurantStaffRepository.save(restaurantStaff);
        return restaurantStaffMapper.toResponse(savedStaff);
    }
    
    /**
     * Get all staff by owner ID
     */
    public List<RestaurantStaffResponse> getStaffByOwner(Long ownerId) {
        List<RestaurantStaff> staffList = restaurantStaffRepository.findByOwnerIdAndIsActiveTrue(ownerId);
        return restaurantStaffMapper.toResponseList(staffList);
    }
    
    /**
     * Get all staff by restaurant ID
     */
    public List<RestaurantStaffResponse> getStaffByRestaurant(Long restaurantId) {
        List<RestaurantStaff> staffList = restaurantStaffRepository.findByRestaurantIdAndIsActiveTrue(restaurantId);
        return restaurantStaffMapper.toResponseList(staffList);
    }
    
    /**
     * Get staff by ID
     */
    public Optional<RestaurantStaffResponse> getStaffById(Long staffId) {
        Optional<RestaurantStaff> staff = restaurantStaffRepository.findById(staffId);
        return staff.map(restaurantStaffMapper::toResponse);
    }
    
    /**
     * Update staff position
     */
    public RestaurantStaffResponse updateStaffPosition(Long staffId, String newPosition) {
        Optional<RestaurantStaff> optionalStaff = restaurantStaffRepository.findById(staffId);
        if (optionalStaff.isPresent()) {
            RestaurantStaff staff = optionalStaff.get();
            staff.setPosition(newPosition);
            RestaurantStaff updatedStaff = restaurantStaffRepository.save(staff);
            return restaurantStaffMapper.toResponse(updatedStaff);
        }
        return null;
    }
    
    /**
     * Deactivate staff
     */
    public RestaurantStaffResponse deactivateStaff(Long staffId) {
        Optional<RestaurantStaff> optionalStaff = restaurantStaffRepository.findById(staffId);
        if (optionalStaff.isPresent()) {
            RestaurantStaff staff = optionalStaff.get();
            staff.setIsActive(false);
            RestaurantStaff updatedStaff = restaurantStaffRepository.save(staff);
            return restaurantStaffMapper.toResponse(updatedStaff);
        }
        return null;
    }
    
    /**
     * Activate staff
     */
    public RestaurantStaffResponse activateStaff(Long staffId) {
        Optional<RestaurantStaff> optionalStaff = restaurantStaffRepository.findById(staffId);
        if (optionalStaff.isPresent()) {
            RestaurantStaff staff = optionalStaff.get();
            staff.setIsActive(true);
            RestaurantStaff updatedStaff = restaurantStaffRepository.save(staff);
            return restaurantStaffMapper.toResponse(updatedStaff);
        }
        return null;
    }
}