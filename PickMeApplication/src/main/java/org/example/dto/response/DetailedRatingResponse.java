package org.example.dto.response;

import java.time.LocalDateTime;

/**
 * DTO cho response detailed rating
 */
public class DetailedRatingResponse {
    
    private Long id;
    private Long reviewId;
    private Integer foodQualityRating;
    private Integer serviceRating;
    private Integer deliveryTimeRating;
    private Integer packagingRating;
    private Integer valueForMoneyRating;
    private Integer orderAccuracyRating;
    private Double averageRating;
    private Integer completedRatingsCount;
    private Boolean hasAllRatings;
    private String bestAspect;
    private String worstAspect;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Constructors
    public DetailedRatingResponse() {}
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getReviewId() {
        return reviewId;
    }
    
    public void setReviewId(Long reviewId) {
        this.reviewId = reviewId;
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
    
    public Double getAverageRating() {
        return averageRating;
    }
    
    public void setAverageRating(Double averageRating) {
        this.averageRating = averageRating;
    }
    
    public Integer getCompletedRatingsCount() {
        return completedRatingsCount;
    }
    
    public void setCompletedRatingsCount(Integer completedRatingsCount) {
        this.completedRatingsCount = completedRatingsCount;
    }
    
    public Boolean getHasAllRatings() {
        return hasAllRatings;
    }
    
    public void setHasAllRatings(Boolean hasAllRatings) {
        this.hasAllRatings = hasAllRatings;
    }
    
    public String getBestAspect() {
        return bestAspect;
    }
    
    public void setBestAspect(String bestAspect) {
        this.bestAspect = bestAspect;
    }
    
    public String getWorstAspect() {
        return worstAspect;
    }
    
    public void setWorstAspect(String worstAspect) {
        this.worstAspect = worstAspect;
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
}