package org.example.dto.request;

import jakarta.validation.constraints.Size;

public class UpdateAddressRequest {
    
    @Size(max = 100, message = "Address name must not exceed 100 characters")
    private String addressName;
    
    @Size(max = 500, message = "Full address must not exceed 500 characters")
    private String fullAddress;
    
    private Double latitude;
    private Double longitude;
    
    private Boolean isDefault;
    
    // Constructors
    public UpdateAddressRequest() {}
    
    // Getters and Setters
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
    
    // Validation helpers
    public boolean hasValidCoordinates() {
        return latitude != null && longitude != null &&
               latitude >= -90 && latitude <= 90 &&
               longitude >= -180 && longitude <= 180;
    }
    
    public boolean hasUpdates() {
        return addressName != null || fullAddress != null || 
               latitude != null || longitude != null || isDefault != null;
    }
}