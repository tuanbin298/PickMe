package org.example.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "carts", indexes = {
    @Index(name = "idx_cart_customer_id", columnList = "customer_id"),
    @Index(name = "idx_cart_restaurant_id", columnList = "restaurant_id"),
    @Index(name = "idx_cart_created_at", columnList = "created_at")
})
public class Cart {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private User customer;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "restaurant_id", nullable = false)
    private Restaurant restaurant;
    
    // Cart items
    @OneToMany(mappedBy = "cart", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    private List<CartItem> cartItems = new ArrayList<>();
    
    // Pricing
    @Column(name = "subtotal", precision = 10, scale = 2)
    private BigDecimal subtotal = BigDecimal.ZERO;
    
    @Column(name = "total_amount", precision = 10, scale = 2)
    private BigDecimal totalAmount = BigDecimal.ZERO;
    
    @Column(name = "total_items")
    private Integer totalItems = 0;
    
    // Status
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private CartStatus status = CartStatus.ACTIVE;
    
    // Timestamps
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Cart status enum
    public enum CartStatus {
        ACTIVE,     // Cart đang được sử dụng
        CONVERTED,  // Đã convert thành order
        EXPIRED,    // Hết hạn (sau 24h không activity)
        CLEARED     // Đã clear manually
    }
    
    // Constructors
    public Cart() {
        this.createdAt = LocalDateTime.now();
    }
    
    public Cart(User customer, Restaurant restaurant) {
        this();
        this.customer = customer;
        this.restaurant = restaurant;
    }
    
    // Business Logic Methods
    public void addCartItem(MenuItem menuItem, Integer quantity, String specialInstructions) {
        // Check if item already exists in cart
        CartItem existingItem = findCartItemByMenuItem(menuItem.getId());
        
        if (existingItem != null) {
            // Update existing item quantity
            existingItem.updateQuantity(existingItem.getQuantity() + quantity);
            if (specialInstructions != null && !specialInstructions.trim().isEmpty()) {
                existingItem.setSpecialInstructions(specialInstructions);
            }
        } else {
            // Add new cart item
            CartItem cartItem = new CartItem(this, menuItem, quantity, specialInstructions);
            this.cartItems.add(cartItem);
        }
        
        recalculateTotals();
    }
    
    public void updateCartItemQuantity(Long cartItemId, Integer newQuantity) {
        CartItem cartItem = cartItems.stream()
            .filter(item -> item.getId().equals(cartItemId))
            .findFirst()
            .orElseThrow(() -> new IllegalArgumentException("Cart item not found"));
        
        if (newQuantity <= 0) {
            removeCartItem(cartItemId);
        } else {
            cartItem.updateQuantity(newQuantity);
            recalculateTotals();
        }
    }
    
    public void removeCartItem(Long cartItemId) {
        boolean removed = this.cartItems.removeIf(item -> item.getId().equals(cartItemId));
        if (removed) {
            recalculateTotals();
        }
    }
    
    public void clearCart() {
        this.cartItems.clear();
        this.status = CartStatus.CLEARED;
        recalculateTotals();
    }
    
    public void recalculateTotals() {
        this.subtotal = cartItems.stream()
            .map(CartItem::getTotalPrice)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        this.totalAmount = subtotal; // Có thể thêm delivery fee, service fee sau
        
        this.totalItems = cartItems.stream()
            .mapToInt(CartItem::getQuantity)
            .sum();
        
        this.updatedAt = LocalDateTime.now();
    }
    
    public boolean isEmpty() {
        return cartItems.isEmpty();
    }
    
    public boolean isActive() {
        return CartStatus.ACTIVE.equals(this.status);
    }
    
    public void convertToOrder() {
        this.status = CartStatus.CONVERTED;
        this.updatedAt = LocalDateTime.now();
    }
    
    public void expire() {
        this.status = CartStatus.EXPIRED;
        this.updatedAt = LocalDateTime.now();
    }
    
    private CartItem findCartItemByMenuItem(Long menuItemId) {
        return cartItems.stream()
            .filter(item -> item.getMenuItem().getId().equals(menuItemId))
            .findFirst()
            .orElse(null);
    }
    
    // Validation
    public boolean canAddItemFromRestaurant(Long restaurantId) {
        // Cart chỉ có thể chứa items từ 1 restaurant
        return isEmpty() || this.restaurant.getId().equals(restaurantId);
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public User getCustomer() {
        return customer;
    }
    
    public void setCustomer(User customer) {
        this.customer = customer;
    }
    
    public Restaurant getRestaurant() {
        return restaurant;
    }
    
    public void setRestaurant(Restaurant restaurant) {
        this.restaurant = restaurant;
    }
    
    public List<CartItem> getCartItems() {
        return cartItems;
    }
    
    public void setCartItems(List<CartItem> cartItems) {
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
    
    public CartStatus getStatus() {
        return status;
    }
    
    public void setStatus(CartStatus status) {
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
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}