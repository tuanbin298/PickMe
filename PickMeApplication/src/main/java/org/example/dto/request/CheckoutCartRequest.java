package org.example.dto.request;

import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;

public class CheckoutCartRequest {
    
    private String deliveryAddress;
    
    private Double pickupLatitude;
    private Double pickupLongitude;
    
    private Double currentLatitude;
    private Double currentLongitude;
    
    @NotNull(message = "Preferred pickup time is required")
    private LocalDateTime preferredPickupTime;
    
    private String specialInstructions;
    
    // Getters and Setters
    public String getDeliveryAddress() {
        return deliveryAddress;
    }
    
    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }
    
    public Double getPickupLatitude() {
        return pickupLatitude;
    }
    
    public void setPickupLatitude(Double pickupLatitude) {
        this.pickupLatitude = pickupLatitude;
    }
    
    public Double getPickupLongitude() {
        return pickupLongitude;
    }
    
    public void setPickupLongitude(Double pickupLongitude) {
        this.pickupLongitude = pickupLongitude;
    }
    
    public Double getCurrentLatitude() {
        return currentLatitude;
    }
    
    public void setCurrentLatitude(Double currentLatitude) {
        this.currentLatitude = currentLatitude;
    }
    
    public Double getCurrentLongitude() {
        return currentLongitude;
    }
    
    public void setCurrentLongitude(Double currentLongitude) {
        this.currentLongitude = currentLongitude;
    }
    
    public LocalDateTime getPreferredPickupTime() {
        return preferredPickupTime;
    }
    
    public void setPreferredPickupTime(LocalDateTime preferredPickupTime) {
        this.preferredPickupTime = preferredPickupTime;
    }
    
    public String getSpecialInstructions() {
        return specialInstructions;
    }
    
    public void setSpecialInstructions(String specialInstructions) {
        this.specialInstructions = specialInstructions;
    }
}