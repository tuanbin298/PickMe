package org.example.dto.response;

import org.example.entity.UserAddress;

import java.time.LocalDateTime;

public class UserAddressResponse {
    
    private Long id;
    private String addressName;
    private String fullAddress;
    private Double latitude;
    private Double longitude;
    private Boolean isDefault;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Constructors
    public UserAddressResponse() {}
    
    public UserAddressResponse(UserAddress userAddress) {
        this.id = userAddress.getId();
        this.addressName = userAddress.getAddressName();
        this.fullAddress = userAddress.getFullAddress();
        this.isDefault = userAddress.getIsDefault();
        this.createdAt = userAddress.getCreatedAt();
        this.updatedAt = userAddress.getUpdatedAt();
        
        // Extract coordinates if location exists
        if (userAddress.getLocation() != null) {
            this.longitude = userAddress.getLocation().getX();
            this.latitude = userAddress.getLocation().getY();
        }
    }
    
    // Static factory method
    public static UserAddressResponse from(UserAddress userAddress) {
        return new UserAddressResponse(userAddress);
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getAddressName() {
        return addressName;
    }
    
    public void setAddressName(String addressName) {
        this.addressName = addressName;
    }
    
    public String getFullAddress() {
        return fullAddress;
    }
    
    public void setFullAddress(String fullAddress) {
        this.fullAddress = fullAddress;
    }
    
    public Double getLatitude() {
        return latitude;
    }
    
    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }
    
    public Double getLongitude() {
        return longitude;
    }
    
    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }
    
    public Boolean getIsDefault() {
        return isDefault;
    }
    
    public void setIsDefault(Boolean isDefault) {
        this.isDefault = isDefault;
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
    
    // Helper methods
    public boolean hasCoordinates() {
        return latitude != null && longitude != null;
    }
}