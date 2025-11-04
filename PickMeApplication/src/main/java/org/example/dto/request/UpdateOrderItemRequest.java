package org.example.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

import java.util.List;

public class UpdateOrderItemRequest {
    
    @NotNull(message = "Order item ID is required")
    private Long orderItemId;
    
    @Min(value = 1, message = "Quantity must be at least 1")
    private Integer quantity;
    
    private String specialInstructions;
    
    @Valid
    private List<AddOnRequest> addOns;
    
    // Getters and Setters
    public Long getOrderItemId() {
        return orderItemId;
    }
    
    public void setOrderItemId(Long orderItemId) {
        this.orderItemId = orderItemId;
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