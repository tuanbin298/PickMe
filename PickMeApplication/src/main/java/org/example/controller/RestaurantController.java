package org.example.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.example.dto.mapper.RestaurantMapper;
import org.example.dto.request.CreateRestaurantRequest;
import org.example.dto.request.CreateStaffAccountRequest;
import org.example.dto.response.RestaurantResponse;
import org.example.dto.response.RestaurantStatusResponse;
import org.example.entity.Restaurant;
import org.example.dto.response.RestaurantStaffResponse;
import org.example.entity.Role;
import org.example.entity.User;
import org.example.exception.AccessDeniedException;
import org.example.service.RestaurantService;
import org.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/restaurants")
@Tag(name = "Restaurant Management", description = "APIs for managing restaurants and staff")
@SecurityRequirement(name = "Bearer Authentication")
public class RestaurantController {
    
    @Autowired
    private RestaurantService restaurantService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private RestaurantMapper restaurantMapper;
    
    @PostMapping
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    @Operation(summary = "Create a new restaurant", description = "Create a new restaurant (Owner only)")
    public ResponseEntity<RestaurantResponse> createRestaurant(
            @Valid @RequestBody CreateRestaurantRequest request,
            Authentication authentication) {
        
        User currentUser = userService.findByEmail(authentication.getName());
        
        // Convert DTO to Entity
        Restaurant restaurant = new Restaurant();
        restaurant.setName(request.getName());
        restaurant.setDescription(request.getDescription());
        restaurant.setAddress(request.getAddress());
        restaurant.setPhoneNumber(request.getPhoneNumber());
        restaurant.setEmail(request.getEmail());
        restaurant.setImageUrl(request.getImageUrl());
        restaurant.setOpeningTime(request.getOpeningTime());
        restaurant.setClosingTime(request.getClosingTime());
        restaurant.setCategories(request.getCategories());
        
        // Set location
        restaurant.setLocation(restaurantService.createPoint(request.getLatitude(), request.getLongitude()));
        
        Restaurant createdRestaurant = restaurantService.createRestaurant(currentUser, restaurant);
        RestaurantResponse response = restaurantMapper.toResponse(createdRestaurant);
        
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/my-restaurants")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    @Operation(summary = "Get my restaurants", description = "Get all restaurants owned by current user")
    public ResponseEntity<List<RestaurantResponse>> getMyRestaurants(Authentication authentication) {
        User currentUser = userService.findByEmail(authentication.getName());
        List<Restaurant> restaurants = restaurantService.getRestaurantsByOwner(currentUser.getId());
        List<RestaurantResponse> responses = restaurantMapper.toResponseList(restaurants);
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/my-restaurants/approved")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    @Operation(summary = "Get my approved restaurants", description = "Get approved restaurants owned by current user")
    public ResponseEntity<List<RestaurantResponse>> getMyApprovedRestaurants(Authentication authentication) {
        User currentUser = userService.findByEmail(authentication.getName());
        List<Restaurant> restaurants = restaurantService.getApprovedRestaurantsByOwner(currentUser.getId());
        List<RestaurantResponse> responses = restaurantMapper.toResponseList(restaurants);
        return ResponseEntity.ok(responses);
    }
    
    @PutMapping("/{restaurantId}")
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('RESTAURANT_STAFF')")
    @Operation(summary = "Update restaurant", description = "Update restaurant information (Owner/Staff only)")
    public ResponseEntity<RestaurantResponse> updateRestaurant(
            @PathVariable Long restaurantId,
            @Valid @RequestBody CreateRestaurantRequest request,
            Authentication authentication) {
        
        User currentUser = userService.findByEmail(authentication.getName());
        
        Restaurant updatedRestaurant = new Restaurant();
        updatedRestaurant.setName(request.getName());
        updatedRestaurant.setDescription(request.getDescription());
        updatedRestaurant.setAddress(request.getAddress());
        updatedRestaurant.setPhoneNumber(request.getPhoneNumber());
        updatedRestaurant.setEmail(request.getEmail());
        updatedRestaurant.setImageUrl(request.getImageUrl());
        updatedRestaurant.setOpeningTime(request.getOpeningTime());
        updatedRestaurant.setClosingTime(request.getClosingTime());
        updatedRestaurant.setCategories(request.getCategories());
        
        if (request.getLatitude() != null && request.getLongitude() != null) {
            updatedRestaurant.setLocation(
                restaurantService.createPoint(request.getLatitude(), request.getLongitude())
            );
        }
        
        Restaurant restaurant = restaurantService.updateRestaurant(restaurantId, updatedRestaurant, currentUser);
        RestaurantResponse response = restaurantMapper.toResponse(restaurant);
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/{restaurantId}/staff")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    @Operation(summary = "Create staff account", description = "Create sub-account for restaurant staff (Owner only)")
    public ResponseEntity<RestaurantStaffResponse> createStaffAccount(
            @PathVariable Long restaurantId,
            @Valid @RequestBody CreateStaffAccountRequest request,
            Authentication authentication) {
        
        User currentUser = userService.findByEmail(authentication.getName());
        
        // Create new user for staff
        User staffUser = new User();
        staffUser.setEmail(request.getEmail());
        staffUser.setPassword(passwordEncoder.encode(request.getPassword()));
        staffUser.setFullName(request.getFullName());
        staffUser.setPhoneNumber(request.getPhoneNumber());
        staffUser.setRole(Role.RESTAURANT_STAFF);
        
        // Save user first
        User savedStaffUser = userService.createUser(staffUser);
        
        // Create staff assignment
        RestaurantStaffResponse restaurantStaff = restaurantService.createStaffAccount(
            currentUser, savedStaffUser, restaurantId, request.getPosition()
        );
        
        return ResponseEntity.ok(restaurantStaff);
    }
    
    @GetMapping("/my-staff")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    @Operation(summary = "Get my staff", description = "Get all staff created by current owner")
    public ResponseEntity<List<RestaurantStaffResponse>> getMyStaff(Authentication authentication) {
        User currentUser = userService.findByEmail(authentication.getName());
        List<RestaurantStaffResponse> staff = restaurantService.getStaffByOwner(currentUser.getId());
        return ResponseEntity.ok(staff);
    }
    
    @GetMapping("/{restaurantId}/staff")
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('RESTAURANT_STAFF')")
    @Operation(summary = "Get restaurant staff", description = "Get staff of a specific restaurant")
    public ResponseEntity<List<RestaurantStaffResponse>> getRestaurantStaff(
            @PathVariable Long restaurantId,
            Authentication authentication) {
        
        User currentUser = userService.findByEmail(authentication.getName());
        
        // Check access (additional business logic check)
        if (!restaurantService.hasRestaurantAccess(currentUser, restaurantId)) {
            return ResponseEntity.status(403).build();
        }
        
        List<RestaurantStaffResponse> staff = restaurantService.getStaffByRestaurant(restaurantId);
        return ResponseEntity.ok(staff);
    }

    // Public endpoints for customers (no authentication required)
    @GetMapping("/public")
    @Operation(summary = "Get approved restaurants", description = "Get all approved restaurants for public viewing")
    public ResponseEntity<List<RestaurantResponse>> getApprovedRestaurants() {
        List<Restaurant> approvedRestaurants = restaurantService.getApprovedRestaurants();
        List<RestaurantResponse> responses = restaurantMapper.toPublicResponseList(approvedRestaurants);
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/public/{restaurantId}")
    @Operation(summary = "Get restaurant details", description = "Get restaurant details for public viewing")
    public ResponseEntity<RestaurantResponse> getRestaurantDetails(@PathVariable Long restaurantId) {
        Optional<Restaurant> restaurantOpt = restaurantService.getApprovedRestaurantById(restaurantId);
        if (restaurantOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        RestaurantResponse response = restaurantMapper.toPublicResponse(restaurantOpt.get());
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/public/nearby")
    @Operation(summary = "Find nearby restaurants", description = "Find restaurants near a location")
    public ResponseEntity<List<RestaurantResponse>> getNearbyRestaurants(
            @RequestParam double latitude,
            @RequestParam double longitude,
            @RequestParam(defaultValue = "5000") double radius) {
        // This would use LocationService to find nearby restaurants
        // For now, we'll return empty list - this should be implemented properly
        List<RestaurantResponse> responses = restaurantMapper.toPublicResponseList(List.of());
        return ResponseEntity.ok(responses);
    }
    
    // Restaurant Status APIs
    
    @GetMapping("/{id}/status")
    @Operation(summary = "Get restaurant status", description = "Get current open/closed status of a restaurant")
    public ResponseEntity<RestaurantStatusResponse> getRestaurantStatus(@PathVariable Long id) {
        Restaurant restaurant = restaurantService.getRestaurantStatus(id);
        RestaurantStatusResponse response = restaurantService.toStatusResponse(restaurant);
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/status/open")
    @Operation(summary = "Get open restaurants", description = "Get all currently open restaurants")
    public ResponseEntity<List<RestaurantStatusResponse>> getOpenRestaurants() {
        List<Restaurant> openRestaurants = restaurantService.getOpenRestaurants();
        List<RestaurantStatusResponse> responses = openRestaurants.stream()
            .map(restaurantService::toStatusResponse)
            .toList();
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/status/nearby-open")
    @Operation(summary = "Get nearby open restaurants", description = "Get currently open restaurants near a location")
    public ResponseEntity<List<RestaurantStatusResponse>> getNearbyOpenRestaurants(
            @RequestParam double latitude,
            @RequestParam double longitude,
            @RequestParam(defaultValue = "5.0") double radiusKm) {
        
        List<Restaurant> nearbyOpenRestaurants = restaurantService.getNearbyOpenRestaurants(
            latitude, longitude, radiusKm);
        
        List<RestaurantStatusResponse> responses = nearbyOpenRestaurants.stream()
            .map(restaurantService::toStatusResponse)
            .toList();
        
        return ResponseEntity.ok(responses);
    }
    
    @PostMapping("/status/batch")
    @Operation(summary = "Get status for multiple restaurants", description = "Get status for multiple restaurants by IDs")
    public ResponseEntity<List<RestaurantStatusResponse>> getRestaurantsStatus(
            @RequestBody List<Long> restaurantIds) {
        
        List<Restaurant> restaurants = restaurantService.getRestaurantsStatus(restaurantIds);
        List<RestaurantStatusResponse> responses = restaurants.stream()
            .map(restaurantService::toStatusResponse)
            .toList();
        
        return ResponseEntity.ok(responses);
    }
}