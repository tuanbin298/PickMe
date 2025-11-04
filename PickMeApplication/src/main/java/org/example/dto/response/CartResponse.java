package org.example.dto.response;

import org.example.entity.Cart;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class CartResponse {
    
    private Long id;
    private RestaurantSummaryResponse restaurant;
    private List<CartItemResponse> cartItems;
    private BigDecimal subtotal;
    private BigDecimal totalAmount;
    private Integer totalItems;
    private Cart.CartStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public RestaurantSummaryResponse getRestaurant() {
        return restaurant;
    }
    
    public void setRestaurant(RestaurantSummaryResponse restaurant) {
        this.restaurant = restaurant;
    }
    
    public List<CartItemResponse> getCartItems() {
        return cartItems;
    }
    
    public void setCartItems(List<CartItemResponse> cartItems) {
        this.cartItems = cartItems;
    }
    
    public BigDecimal getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
    
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public Integer getTotalItems() {
        return totalItems;
    }
    
    public void setTotalItems(Integer totalItems) {
        this.totalItems = totalItems;
    }
    
    public Cart.CartStatus getStatus() {
        return status;
    }
    
    public void setStatus(Cart.CartStatus status) {
        this.status = status;
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