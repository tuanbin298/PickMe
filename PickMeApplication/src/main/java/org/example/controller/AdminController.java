package org.example.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.dto.mapper.RestaurantMapper;
import org.example.dto.response.RestaurantResponse;
import org.example.entity.Restaurant;
import org.example.entity.User;
import org.example.service.RestaurantService;
import org.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "http://localhost:5173", allowedHeaders = "*", allowCredentials = "true")
@RequestMapping("/api/admin")
@Tag(name = "Admin Management", description = "APIs for admin operations")
@SecurityRequirement(name = "Bearer Authentication")
public class AdminController {
    
    @Autowired
    private RestaurantService restaurantService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private RestaurantMapper restaurantMapper;

    @GetMapping("/restaurants")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all restaurants", description = "Get all restaurants (Admin only)")
    public ResponseEntity<List<RestaurantResponse>> getAllRestaurants(Authentication authentication) {
        User currentUser = userService.findByEmail(authentication.getName());
        List<Restaurant> allRestaurants = restaurantService.getAllRestaurants(currentUser);
        List<RestaurantResponse> responses = restaurantMapper.toResponseList(allRestaurants);
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/restaurants/pending")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get pending restaurants", description = "Get all restaurants waiting for approval (Admin only)")
    public ResponseEntity<List<RestaurantResponse>> getPendingRestaurants(Authentication authentication) {
        User currentUser = userService.findByEmail(authentication.getName());
        List<Restaurant> pendingRestaurants = restaurantService.getPendingApprovalRestaurants(currentUser);
        List<RestaurantResponse> responses = restaurantMapper.toResponseList(pendingRestaurants);
        return ResponseEntity.ok(responses);
    }
    
    @PostMapping("/restaurants/{restaurantId}/approve")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Approve restaurant", description = "Approve a restaurant (Admin only)")
    public ResponseEntity<RestaurantResponse> approveRestaurant(
            @PathVariable Long restaurantId,
            Authentication authentication) {
        
        User currentUser = userService.findByEmail(authentication.getName());
        Restaurant approvedRestaurant = restaurantService.approveRestaurant(restaurantId, currentUser);
        RestaurantResponse response = restaurantMapper.toResponse(approvedRestaurant);
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/restaurants/{restaurantId}/reject")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Reject restaurant", description = "Reject a restaurant with reason (Admin only)")
    public ResponseEntity<RestaurantResponse> rejectRestaurant(
            @PathVariable Long restaurantId,
            @RequestParam String reason,
            Authentication authentication) {
        
        User currentUser = userService.findByEmail(authentication.getName());
        Restaurant rejectedRestaurant = restaurantService.rejectRestaurant(restaurantId, currentUser, reason);
        RestaurantResponse response = restaurantMapper.toResponse(rejectedRestaurant);
        return ResponseEntity.ok(response);
    }
}