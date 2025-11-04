package org.example.dto.response;

import org.example.entity.ReviewType;
import java.time.LocalDateTime;
import java.util.List;

/**
 * DTO cho response review đơn giản
 */
public class
ReviewResponse {
    
    private Long id;
    private String reviewerName;
    private ReviewType reviewType;
    private Integer rating;
    private String comment;
    private String ownerResponse;
    private LocalDateTime createdAt;
    private Long restaurantId;
    private String restaurantName;
    private List<String> imageUrls;
    
    // Constructors
    public ReviewResponse() {}
    
    public ReviewResponse(Long id, String reviewerName, ReviewType reviewType, 
                         Integer rating, String comment, String ownerResponse, LocalDateTime createdAt,
                         Long restaurantId, String restaurantName, List<String> imageUrls) {
        this.id = id;
        this.reviewerName = reviewerName;
        this.reviewType = reviewType;
        this.rating = rating;
        this.comment = comment;
        this.ownerResponse = ownerResponse;
        this.createdAt = createdAt;
        this.restaurantId = restaurantId;
        this.restaurantName = restaurantName;
        this.imageUrls = imageUrls;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getReviewerName() {
        return reviewerName;
    }
    
    public void setReviewerName(String reviewerName) {
        this.reviewerName = reviewerName;
    }
    
    public ReviewType getReviewType() {
        return reviewType;
    }
    
    public void setReviewType(ReviewType reviewType) {
        this.reviewType = reviewType;
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
    
    public String getOwnerResponse() {
        return ownerResponse;
    }
    
    public void setOwnerResponse(String ownerResponse) {
        this.ownerResponse = ownerResponse;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
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
    
    public List<String> getImageUrls() {
        return imageUrls;
    }
    
    public void setImageUrls(List<String> imageUrls) {
        this.imageUrls = imageUrls;
    }
}