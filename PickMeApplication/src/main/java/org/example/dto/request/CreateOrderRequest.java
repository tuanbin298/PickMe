package org.example.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;
import java.util.List;

public class CreateOrderRequest {
    
    @NotNull(message = "Restaurant ID is required")
    private Long restaurantId;
    
    @Valid
    private List<OrderItemRequest> orderItems; // Optional - có thể tạo order trống trước
    
    private String deliveryAddress;
    
    private Double pickupLatitude;
    private Double pickupLongitude;
    
    private Double currentLatitude;
    private Double currentLongitude;
    
    @NotNull(message = "Preferred pickup time is required")
    private LocalDateTime preferredPickupTime;
    
    private String specialInstructions;
    
    // Getters and Setters
    public Long getRestaurantId() {
        return restaurantId;
    }
    
    public void setRestaurantId(Long restaurantId) {
        this.restaurantId = restaurantId;
    }
    
    public List<OrderItemRequest> getOrderItems() {
        return orderItems;
    }
    
    public void setOrderItems(List<OrderItemRequest> orderItems) {
        this.orderItems = orderItems;
    }
    
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