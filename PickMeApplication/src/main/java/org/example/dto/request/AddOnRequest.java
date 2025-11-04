package org.example.dto.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public class AddOnRequest {
    
    @NotNull(message = "Menu item add-on ID is required")
    private Long menuItemAddOnId;
    
    @NotNull(message = "Quantity is required")
    @Min(value = 1, message = "Quantity must be at least 1")
    private Integer quantity = 1;
    
    // Constructors
    public AddOnRequest() {}
    
    public AddOnRequest(Long menuItemAddOnId, Integer quantity) {
        this.menuItemAddOnId = menuItemAddOnId;
        this.quantity = quantity;
    }
    
    // Getters and Setters
    public Long getMenuItemAddOnId() {
        return menuItemAddOnId;
    }
    
    public void setMenuItemAddOnId(Long menuItemAddOnId) {
        this.menuItemAddOnId = menuItemAddOnId;
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}