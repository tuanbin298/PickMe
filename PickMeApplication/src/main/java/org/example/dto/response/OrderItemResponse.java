package org.example.dto.response;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class OrderItemResponse {
    
    private Long id;
    private Long menuItemId;
    private String menuItemName;
    private String menuItemDescription;
    private String menuItemCategory;
    private String menuItemImageUrl;
    private Integer quantity;
    private BigDecimal unitPrice;
    private BigDecimal subtotal;
    private BigDecimal totalPrice;
    private String specialInstructions;
    private List<OrderAddOnResponse> addOns;
    private LocalDateTime createdAt;
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getMenuItemId() {
        return menuItemId;
    }
    
    public void setMenuItemId(Long menuItemId) {
        this.menuItemId = menuItemId;
    }
    
    public String getMenuItemName() {
        return menuItemName;
    }
    
    public void setMenuItemName(String menuItemName) {
        this.menuItemName = menuItemName;
    }
    
    public String getMenuItemDescription() {
        return menuItemDescription;
    }
    
    public void setMenuItemDescription(String menuItemDescription) {
        this.menuItemDescription = menuItemDescription;
    }
    
    public String getMenuItemCategory() {
        return menuItemCategory;
    }
    
    public void setMenuItemCategory(String menuItemCategory) {
        this.menuItemCategory = menuItemCategory;
    }
    
    public String getMenuItemImageUrl() {
        return menuItemImageUrl;
    }
    
    public void setMenuItemImageUrl(String menuItemImageUrl) {
        this.menuItemImageUrl = menuItemImageUrl;
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
    
    public BigDecimal getUnitPrice() {
        return unitPrice;
    }
    
    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }
    
    public BigDecimal getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
    
    public BigDecimal getTotalPrice() {
        return totalPrice;
    }
    
    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
    
    public String getSpecialInstructions() {
        return specialInstructions;
    }
    
    public void setSpecialInstructions(String specialInstructions) {
        this.specialInstructions = specialInstructions;
    }
    
    public List<OrderAddOnResponse> getAddOns() {
        return addOns;
    }
    
    public void setAddOns(List<OrderAddOnResponse> addOns) {
        this.addOns = addOns;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}