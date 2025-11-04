package org.example.dto.response;

import java.util.List;

/**
 * DTO cho response danh sách reviews đơn giản
 */
public class ReviewListResponse {
    
    private List<ReviewResponse> reviews;
    private Double averageRating;
    private Integer totalReviews;
    
    // Constructors
    public ReviewListResponse() {}
    
    public ReviewListResponse(List<ReviewResponse> reviews, Double averageRating, Integer totalReviews) {
        this.reviews = reviews;
        this.averageRating = averageRating;
        this.totalReviews = totalReviews;
    }
    
    // Getters and Setters
    public List<ReviewResponse> getReviews() {
        return reviews;
    }
    
    public void setReviews(List<ReviewResponse> reviews) {
        this.reviews = reviews;
    }
    
    public Double getAverageRating() {
        return averageRating;
    }
    
    public void setAverageRating(Double averageRating) {
        this.averageRating = averageRating;
    }
    
    public Integer getTotalReviews() {
        return totalReviews;
    }
    
    public void setTotalReviews(Integer totalReviews) {
        this.totalReviews = totalReviews;
    }
}