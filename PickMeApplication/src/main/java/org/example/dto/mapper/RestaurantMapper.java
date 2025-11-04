package org.example.dto.mapper;

import org.example.dto.response.RestaurantResponse;
import org.example.entity.Restaurant;
import org.locationtech.jts.geom.Point;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class RestaurantMapper {
    
    /**
     * Convert Restaurant entity to RestaurantResponse DTO
     * @param restaurant Restaurant entity
     * @return RestaurantResponse DTO
     */
    public RestaurantResponse toResponse(Restaurant restaurant) {
        if (restaurant == null) {
            return null;
        }
        
        RestaurantResponse response = new RestaurantResponse();
        
        // Basic information
        response.setId(restaurant.getId());
        response.setName(restaurant.getName());
        response.setDescription(restaurant.getDescription());
        response.setAddress(restaurant.getAddress());
        response.setPhoneNumber(restaurant.getPhoneNumber());
        response.setEmail(restaurant.getEmail());
        response.setImageUrl(restaurant.getImageUrl());
        
        // Location information
        if (restaurant.getLocation() != null) {
            Point location = restaurant.getLocation();
            response.setLatitude(location.getY()); // Y = Latitude
            response.setLongitude(location.getX()); // X = Longitude
        }
        
        // Business hours
        response.setOpeningTime(restaurant.getOpeningTime());
        response.setClosingTime(restaurant.getClosingTime());
        
        // Status and rating
        response.setIsActive(restaurant.getIsActive());
        response.setRating(restaurant.getRating());
        response.setTotalReviews(restaurant.getTotalReviews());
        
        // Owner information (basic info for security)
        if (restaurant.getOwner() != null) {
            response.setOwnerId(restaurant.getOwner().getId());
            response.setOwnerName(restaurant.getOwner().getFullName());
        }
        
        // Approval information
        response.setApprovalStatus(restaurant.getApprovalStatus());
        if (restaurant.getApprovedBy() != null) {
            response.setApprovedBy(restaurant.getApprovedBy().getId());
            response.setApprovedByName(restaurant.getApprovedBy().getFullName());
        }
        response.setApprovedAt(restaurant.getApprovedAt());
        response.setRejectionReason(restaurant.getRejectionReason());
        
        // Categories
        response.setCategories(restaurant.getCategories());
        
        // Timestamps
        response.setCreatedAt(restaurant.getCreatedAt());
        response.setUpdatedAt(restaurant.getUpdatedAt());
        
        // Computed fields
        response.setIsOpen(restaurant.isOpen());
        response.setIsApproved(restaurant.isApproved());
        
        return response;
    }
    
    /**
     * Convert list of Restaurant entities to list of RestaurantResponse DTOs
     * @param restaurants List of Restaurant entities
     * @return List of RestaurantResponse DTOs
     */
    public List<RestaurantResponse> toResponseList(List<Restaurant> restaurants) {
        if (restaurants == null) {
            return null;
        }
        
        return restaurants.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }
    
    /**
     * Convert Restaurant entity to public RestaurantResponse (limited info for customers)
     * @param restaurant Restaurant entity
     * @return RestaurantResponse DTO with limited information
     */
    public RestaurantResponse toPublicResponse(Restaurant restaurant) {
        if (restaurant == null) {
            return null;
        }
        
        RestaurantResponse response = new RestaurantResponse();
        
        // Basic public information only
        response.setId(restaurant.getId());
        response.setName(restaurant.getName());
        response.setDescription(restaurant.getDescription());
        response.setAddress(restaurant.getAddress());
        response.setPhoneNumber(restaurant.getPhoneNumber());
        response.setImageUrl(restaurant.getImageUrl());
        
        // Location information
        if (restaurant.getLocation() != null) {
            Point location = restaurant.getLocation();
            response.setLatitude(location.getY());
            response.setLongitude(location.getX());
        }
        
        // Business hours
        response.setOpeningTime(restaurant.getOpeningTime());
        response.setClosingTime(restaurant.getClosingTime());
        
        // Public status and rating
        response.setRating(restaurant.getRating());
        response.setTotalReviews(restaurant.getTotalReviews());
        
        // Categories
        response.setCategories(restaurant.getCategories());
        
        // Computed fields
        response.setIsOpen(restaurant.isOpen());
        response.setIsApproved(restaurant.isApproved());
        
        // Hide sensitive information for public access
        // - Owner details
        // - Approval details  
        // - Email
        // - Creation/update timestamps
        
        return response;
    }
    
    /**
     * Convert list of Restaurant entities to list of public RestaurantResponse DTOs
     * @param restaurants List of Restaurant entities
     * @return List of public RestaurantResponse DTOs
     */
    public List<RestaurantResponse> toPublicResponseList(List<Restaurant> restaurants) {
        if (restaurants == null) {
            return null;
        }
        
        return restaurants.stream()
                .map(this::toPublicResponse)
                .collect(Collectors.toList());
    }
    
    /**
     * Convert Restaurant entity to basic RestaurantResponse (minimal info for references)
     * @param restaurant Restaurant entity
     * @return RestaurantResponse DTO with basic information
     */
    public RestaurantResponse toBasicResponse(Restaurant restaurant) {
        if (restaurant == null) {
            return null;
        }
        
        RestaurantResponse response = new RestaurantResponse();
        response.setId(restaurant.getId());
        response.setName(restaurant.getName());
        response.setAddress(restaurant.getAddress());
        response.setPhoneNumber(restaurant.getPhoneNumber());
        response.setIsActive(restaurant.getIsActive());
        
        return response;
    }
}