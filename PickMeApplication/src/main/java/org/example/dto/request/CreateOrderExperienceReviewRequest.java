package org.example.dto.request;

import jakarta.validation.constraints.*;
import java.util.List;

/**
 * DTO cho request tạo review trải nghiệm đơn hàng
 */
public class CreateOrderExperienceReviewRequest {
    
    @NotNull(message = "Order ID is required")
    private Long orderId;
    
    @Min(value = 1, message = "Overall rating must be at least 1")
    @Max(value = 5, message = "Overall rating must be at most 5")
    @NotNull(message = "Overall rating is required")
    private Integer overallRating;
    
    @Size(min = 10, max = 1000, message = "Comment must be between 10 and 1000 characters")
    @NotBlank(message = "Comment is required")
    private String comment;
    
    @Size(max = 5, message = "Maximum 5 images allowed")
    private List<String> imageUrls;
    
    // Detailed ratings (optional)
    @Min(value = 1, message = "Food quality rating must be at least 1")
    @Max(value = 5, message = "Food quality rating must be at most 5")
    private Integer foodQualityRating;
    
    @Min(value = 1, message = "Service rating must be at least 1")
    @Max(value = 5, message = "Service rating must be at most 5")
    private Integer serviceRating;
    
    @Min(value = 1, message = "Delivery time rating must be at least 1")
    @Max(value = 5, message = "Delivery time rating must be at most 5")
    private Integer deliveryTimeRating;
    
    @Min(value = 1, message = "Packaging rating must be at least 1")
    @Max(value = 5, message = "Packaging rating must be at most 5")
    private Integer packagingRating;
    
    @Min(value = 1, message = "Value for money rating must be at least 1")
    @Max(value = 5, message = "Value for money rating must be at most 5")
    private Integer valueForMoneyRating;
    
    @Min(value = 1, message = "Order accuracy rating must be at least 1")
    @Max(value = 5, message = "Order accuracy rating must be at most 5")
    private Integer orderAccuracyRating;
    
    // Constructors
    public CreateOrderExperienceReviewRequest() {}
    
    public CreateOrderExperienceReviewRequest(Long orderId, Integer overallRating, String comment) {
        this.orderId = orderId;
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
    
    public Integer getFoodQualityRating() {
        return foodQualityRating;
    }
    
    public void setFoodQualityRating(Integer foodQualityRating) {
        this.foodQualityRating = foodQualityRating;
    }
    
    public Integer getServiceRating() {
        return serviceRating;
    }
    
    public void setServiceRating(Integer serviceRating) {
        this.serviceRating = serviceRating;
    }
    
    public Integer getDeliveryTimeRating() {
        return deliveryTimeRating;
    }
    
    public void setDeliveryTimeRating(Integer deliveryTimeRating) {
        this.deliveryTimeRating = deliveryTimeRating;
    }
    
    public Integer getPackagingRating() {
        return packagingRating;
    }
    
    public void setPackagingRating(Integer packagingRating) {
        this.packagingRating = packagingRating;
    }
    
    public Integer getValueForMoneyRating() {
        return valueForMoneyRating;
    }
    
    public void setValueForMoneyRating(Integer valueForMoneyRating) {
        this.valueForMoneyRating = valueForMoneyRating;
    }
    
    public Integer getOrderAccuracyRating() {
        return orderAccuracyRating;
    }
    
    public void setOrderAccuracyRating(Integer orderAccuracyRating) {
        this.orderAccuracyRating = orderAccuracyRating;
    }
}