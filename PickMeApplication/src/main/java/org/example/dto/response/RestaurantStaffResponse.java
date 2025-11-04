package org.example.dto.response;

import java.time.LocalDateTime;

public class RestaurantStaffResponse {
    
    private Long id;
    private UserResponse staffUser;
    private RestaurantResponse restaurant;
    private UserResponse owner;
    private String position;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Constructors
    public RestaurantStaffResponse() {}
    
    public RestaurantStaffResponse(Long id, UserResponse staffUser, RestaurantResponse restaurant,
                                 UserResponse owner, String position, Boolean isActive,
                                 LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.staffUser = staffUser;
        this.restaurant = restaurant;
        this.owner = owner;
        this.position = position;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public UserResponse getStaffUser() {
        return staffUser;
    }
    
    public void setStaffUser(UserResponse staffUser) {
        this.staffUser = staffUser;
    }
    
    public RestaurantResponse getRestaurant() {
        return restaurant;
    }
    
    public void setRestaurant(RestaurantResponse restaurant) {
        this.restaurant = restaurant;
    }
    
    public UserResponse getOwner() {
        return owner;
    }
    
    public void setOwner(UserResponse owner) {
        this.owner = owner;
    }
    
    public String getPosition() {
        return position;
    }
    
    public void setPosition(String position) {
        this.position = position;
    }
    
    public Boolean getIsActive() {
        return isActive;
    }
    
    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}