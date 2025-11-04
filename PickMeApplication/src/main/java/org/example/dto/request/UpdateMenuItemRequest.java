package org.example.dto.request;

import jakarta.validation.constraints.DecimalMin;

import java.math.BigDecimal;
import java.util.List;

/**
 * DTO Request để cập nhật MenuItem
 * Tất cả các field đều optional, chỉ cập nhật field nào không null
 */
public class UpdateMenuItemRequest {
    
    private String name;
    
    private String description;
    
    @DecimalMin(value = "0.0", inclusive = false, message = "Price must be greater than 0")
    private BigDecimal price;
    
    private String category;
    
    private String imageUrl;
    
    private Boolean isAvailable;
    
    private Integer preparationTimeMinutes;
    
    private List<String> tags;
    
    // Constructors
    public UpdateMenuItemRequest() {}
    
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
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public Boolean getIsAvailable() {
        return isAvailable;
    }
    
    public void setIsAvailable(Boolean isAvailable) {
        this.isAvailable = isAvailable;
    }
    
    public Integer getPreparationTimeMinutes() {
        return preparationTimeMinutes;
    }
    
    public void setPreparationTimeMinutes(Integer preparationTimeMinutes) {
        this.preparationTimeMinutes = preparationTimeMinutes;
    }
    
    public List<String> getTags() {
        return tags;
    }
    
    public void setTags(List<String> tags) {
        this.tags = tags;
    }
    
    // Utility methods to check if fields are provided
    public boolean hasName() {
        return name != null && !name.trim().isEmpty();
    }
    
    public boolean hasDescription() {
        return description != null;
    }
    
    public boolean hasPrice() {
        return price != null;
    }
    
    public boolean hasCategory() {
        return category != null;
    }
    
    public boolean hasImageUrl() {
        return imageUrl != null;
    }
    
    public boolean hasIsAvailable() {
        return isAvailable != null;
    }
    
    public boolean hasPreparationTime() {
        return preparationTimeMinutes != null;
    }
    
    public boolean hasTags() {
        return tags != null;
    }
}