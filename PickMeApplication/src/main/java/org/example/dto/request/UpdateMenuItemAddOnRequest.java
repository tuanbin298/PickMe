package org.example.dto.request;

import jakarta.validation.constraints.DecimalMin;

import java.math.BigDecimal;

public class UpdateMenuItemAddOnRequest {
    
    private String name;
    
    private String description;
    
    @DecimalMin(value = "0.0", message = "Add-on price must be non-negative")
    private BigDecimal price;
    
    private String category;
    
    private Integer displayOrder;
    
    private Integer maxQuantity;
    
    private Boolean isRequired;
    
    private Boolean isAvailable;
    
    // Getters and Setters
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
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public Integer getDisplayOrder() {
        return displayOrder;
    }
    
    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }
    
    public Integer getMaxQuantity() {
        return maxQuantity;
    }
    
    public void setMaxQuantity(Integer maxQuantity) {
        this.maxQuantity = maxQuantity;
    }
    
    public Boolean getIsRequired() {
        return isRequired;
    }
    
    public void setIsRequired(Boolean isRequired) {
        this.isRequired = isRequired;
    }
    
    public Boolean getIsAvailable() {
        return isAvailable;
    }
    
    public void setIsAvailable(Boolean isAvailable) {
        this.isAvailable = isAvailable;
    }
}