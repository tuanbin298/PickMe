package org.example.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

import java.util.List;

public class OrderItemRequest {
    
    @NotNull(message = "Menu item ID is required")
    private Long menuItemId;
    
    @NotNull(message = "Quantity is required")
    @Min(value = 1, message = "Quantity must be at least 1")
    private Integer quantity;
    
    private String specialInstructions;
    
    @Valid
    private List<AddOnRequest> addOns;
    
    // Getters and Setters
    public Long getMenuItemId() {
        return menuItemId;
    }
    
    public void setMenuItemId(Long menuItemId) {
        this.menuItemId = menuItemId;
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
    
    public String getSpecialInstructions() {
        return specialInstructions;
    }
    
    public void setSpecialInstructions(String specialInstructions) {
        this.specialInstructions = specialInstructions;
    }
    
    public List<AddOnRequest> getAddOns() {
        return addOns;
    }
    
    public void setAddOns(List<AddOnRequest> addOns) {
        this.addOns = addOns;
    }
}