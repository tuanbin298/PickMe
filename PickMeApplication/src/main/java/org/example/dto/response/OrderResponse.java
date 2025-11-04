package org.example.dto.response;

import org.example.entity.Order;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class OrderResponse {
    
    private Long id;
    private String qrCode;
    private UserResponse customer;
    private RestaurantSummaryResponse restaurant;
    private String deliveryAddress;
    private Double pickupLatitude;
    private Double pickupLongitude;
    private Double currentLatitude;
    private Double currentLongitude;
    private LocalDateTime preferredPickupTime;
    private LocalDateTime estimatedReadyTime;
    private LocalDateTime actualReadyTime;
    private LocalDateTime pickupTime;
    private BigDecimal subtotal;
    private BigDecimal deliveryFee;
    private BigDecimal serviceFee;
    private BigDecimal discountAmount;
    private BigDecimal totalAmount;
    private Order.OrderStatus status;
    private Order.PaymentStatus paymentStatus;
    private String specialInstructions;
    private List<OrderItemResponse> orderItems;
    private Integer totalItems;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getQrCode() {
        return qrCode;
    }
    
    public void setQrCode(String qrCode) {
        this.qrCode = qrCode;
    }
    
    public UserResponse getCustomer() {
        return customer;
    }
    
    public void setCustomer(UserResponse customer) {
        this.customer = customer;
    }
    
    public RestaurantSummaryResponse getRestaurant() {
        return restaurant;
    }
    
    public void setRestaurant(RestaurantSummaryResponse restaurant) {
        this.restaurant = restaurant;
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
    
    public LocalDateTime getEstimatedReadyTime() {
        return estimatedReadyTime;
    }
    
    public void setEstimatedReadyTime(LocalDateTime estimatedReadyTime) {
        this.estimatedReadyTime = estimatedReadyTime;
    }
    
    public LocalDateTime getActualReadyTime() {
        return actualReadyTime;
    }
    
    public void setActualReadyTime(LocalDateTime actualReadyTime) {
        this.actualReadyTime = actualReadyTime;
    }
    
    public LocalDateTime getPickupTime() {
        return pickupTime;
    }
    
    public void setPickupTime(LocalDateTime pickupTime) {
        this.pickupTime = pickupTime;
    }
    
    public BigDecimal getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
    
    public BigDecimal getDeliveryFee() {
        return deliveryFee;
    }
    
    public void setDeliveryFee(BigDecimal deliveryFee) {
        this.deliveryFee = deliveryFee;
    }
    
    public BigDecimal getServiceFee() {
        return serviceFee;
    }
    
    public void setServiceFee(BigDecimal serviceFee) {
        this.serviceFee = serviceFee;
    }
    
    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }
    
    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }
    
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public Order.OrderStatus getStatus() {
        return status;
    }
    
    public void setStatus(Order.OrderStatus status) {
        this.status = status;
    }
    
    public Order.PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(Order.PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public String getSpecialInstructions() {
        return specialInstructions;
    }
    
    public void setSpecialInstructions(String specialInstructions) {
        this.specialInstructions = specialInstructions;
    }
    
    public List<OrderItemResponse> getOrderItems() {
        return orderItems;
    }
    
    public void setOrderItems(List<OrderItemResponse> orderItems) {
        this.orderItems = orderItems;
    }
    
    public Integer getTotalItems() {
        return totalItems;
    }
    
    public void setTotalItems(Integer totalItems) {
        this.totalItems = totalItems;
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