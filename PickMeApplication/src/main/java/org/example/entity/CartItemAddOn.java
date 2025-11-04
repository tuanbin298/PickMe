package org.example.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

@Entity
@Table(name = "cart_item_add_ons")
public class CartItemAddOn {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cart_item_id", nullable = false)
    private CartItem cartItem;
    
    @NotBlank(message = "Add-on name is required")
    @Column(name = "name", nullable = false)
    private String name; // "Extra cheese", "Thêm trứng", "Size lớn"
    
    @Column(name = "description")
    private String description; // Mô tả chi tiết add-on
    
    @NotNull(message = "Add-on price is required")
    @DecimalMin(value = "0.0", message = "Add-on price must be non-negative")
    @Column(name = "price", precision = 10, scale = 2, nullable = false)
    private BigDecimal price; // Giá add-on
    
    @NotNull(message = "Quantity is required")
    @Min(value = 1, message = "Quantity must be at least 1")
    @Column(name = "quantity", nullable = false)
    private Integer quantity = 1;
    
    // Constructors
    public CartItemAddOn() {}
    
    public CartItemAddOn(CartItem cartItem, String name, String description, BigDecimal price) {
        this.cartItem = cartItem;
        this.name = name;
        this.description = description;
        this.price = price;
        this.quantity = 1;
    }
    
    public CartItemAddOn(CartItem cartItem, String name, String description, BigDecimal price, Integer quantity) {
        this.cartItem = cartItem;
        this.name = name;
        this.description = description;
        this.price = price;
        this.quantity = quantity;
    }
    
    // Business Logic Methods
    public BigDecimal getTotalPrice() {
        return price.multiply(BigDecimal.valueOf(quantity));
    }
    
    public void updateQuantity(Integer newQuantity) {
        if (newQuantity < 1) {
            throw new IllegalArgumentException("Quantity must be at least 1");
        }
        this.quantity = newQuantity;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public CartItem getCartItem() {
        return cartItem;
    }
    
    public void setCartItem(CartItem cartItem) {
        this.cartItem = cartItem;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}