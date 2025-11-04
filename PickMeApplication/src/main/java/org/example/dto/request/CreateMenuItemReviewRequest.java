package org.example.dto.request;

import jakarta.validation.constraints.*;
import java.util.List;

/**
 * DTO cho request tạo review món ăn
 */
public class CreateMenuItemReviewRequest {
    
    @NotNull(message = "Order ID is required")
    private Long orderId;
    
    @NotNull(message = "Menu item ID is required")
    private Long menuItemId;
    
    @Min(value = 1, message = "Rating must be at least 1")
    @Max(value = 5, message = "Rating must be at most 5")
    @NotNull(message = "Overall rating is required")
    private Integer overallRating;
    
    @Size(min = 10, max = 1000, message = "Comment must be between 10 and 1000 characters")
    @NotBlank(message = "Comment is required")
    private String comment;
    
    @Size(max = 5, message = "Maximum 5 images allowed")
    private List<String> imageUrls;
    
    // Constructors
    public CreateMenuItemReviewRequest() {}
    
    public CreateMenuItemReviewRequest(Long orderId, Long menuItemId, Integer overallRating, String comment) {
        this.orderId = orderId;
        this.menuItemId = menuItemId;
        this.overallRating = overallRating;
        this.comment = comment;
    }
    
    // Getters and Setters
    public Long getOrderId() {
        return orderId;
    }
    
    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }
    
    public Long getMenuItemId() {
        return menuItemId;
    }
    
    public void setMenuItemId(Long menuItemId) {
        this.menuItemId = menuItemId;
    }
    
    public Integer getOverallRating() {
        return overallRating;
    }
    
    public void setOverallRating(Integer overallRating) {
        this.overallRating = overallRating;
    }
    
    public String getComment() {
        return comment;
    }
    
    public void setComment(String comment) {
        this.comment = comment;
    }
    
    public List<String> getImageUrls() {
        return imageUrls;
    }
    
    public void setImageUrls(List<String> imageUrls) {
        this.imageUrls = imageUrls;
    }
}