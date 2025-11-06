package org.example.dto.response;

import org.example.entity.Review;
import org.example.entity.ReviewType;

import java.time.LocalDateTime;

public class AdminFeedbackResponse {
    
    private Long id;
    private Long restaurantId;
    private String restaurantName;
    private Long customerId;
    private String customerName;
    private Integer rating;
    private String comment;
    private ReviewType reviewType;
    private LocalDateTime createdAt;
    
    // Constructors
    public AdminFeedbackResponse() {}
    
    public AdminFeedbackResponse(Review review) {
        this.id = review.getId();
        this.customerId = review.getReviewer() != null ? review.getReviewer().getId() : null;
        this.customerName = review.getReviewer() != null ? review.getReviewer().getFullName() : null;
        this.rating = review.getOverallRating();
        this.comment = review.getComment();
        this.reviewType = review.getReviewType();
        this.createdAt = review.getCreatedAt();
        
        // Set restaurant info based on review type
        if (review.getReviewType() == ReviewType.RESTAURANT) {
            this.restaurantId = review.getTargetId();
            // Restaurant name will be set by the service layer
        } else if (review.getOrder() != null && review.getOrder().getRestaurant() != null) {
            this.restaurantId = review.getOrder().getRestaurant().getId();
            this.restaurantName = review.getOrder().getRestaurant().getName();
        }
    }
    
    // Static factory method
    public static AdminFeedbackResponse from(Review review) {
        return new AdminFeedbackResponse(review);
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getRestaurantId() {
        return restaurantId;
    }
    
    public void setRestaurantId(Long restaurantId) {
        this.restaurantId = restaurantId;
    }
    
    public String getRestaurantName() {
        return restaurantName;
    }
    
    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }
    
    public Long getCustomerId() {
        return customerId;
    }
    
    public void setCustomerId(Long customerId) {
        this.customerId = customerId;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public Integer getRating() {
        return rating;
    }
    
    public void setRating(Integer rating) {
        this.rating = rating;
    }
    
    public String getComment() {
        return comment;
    }
    
    public void setComment(String comment) {
        this.comment = comment;
    }
    
    public ReviewType getReviewType() {
        return reviewType;
    }
    
    public void setReviewType(ReviewType reviewType) {
        this.reviewType = reviewType;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}