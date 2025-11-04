package org.example.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;

/**
 * Response DTO for review eligibility information
 */
@Schema(description = "Review eligibility information")
public class ReviewEligibilityResponse {
    
    @Schema(description = "Whether user is eligible to create review", example = "true")
    private boolean eligible;
    
    @Schema(description = "Whether user has completed orders", example = "true") 
    private boolean hasCompletedOrders;
    
    @Schema(description = "Whether user already reviewed this item", example = "false")
    private boolean alreadyReviewed;
    
    @Schema(description = "Whether review is within time window", example = "true")
    private boolean withinReviewWindow;
    
    @Schema(description = "Days elapsed since last order", example = "3")
    private int daysElapsed;
    
    @Schema(description = "Time of latest order", example = "2024-01-15T14:30:00")
    private LocalDateTime latestOrderTime;
    
    @Schema(description = "Existing review ID if already reviewed", example = "123")
    private Long existingReviewId;
    
    @Schema(description = "Error message if eligibility check failed")
    private String error;
    
    @Schema(description = "Can review (deprecated - use eligible)", example = "true")
    private boolean canReview;
    
    @Schema(description = "Reason for eligibility status")
    private String reason;

    // Constructors
    public ReviewEligibilityResponse() {}

    // Getters and setters
    public boolean isEligible() {
        return eligible;
    }

    public void setEligible(boolean eligible) {
        this.eligible = eligible;
    }

    public boolean isHasCompletedOrders() {
        return hasCompletedOrders;
    }

    public void setHasCompletedOrders(boolean hasCompletedOrders) {
        this.hasCompletedOrders = hasCompletedOrders;
    }

    public boolean isAlreadyReviewed() {
        return alreadyReviewed;
    }

    public void setAlreadyReviewed(boolean alreadyReviewed) {
        this.alreadyReviewed = alreadyReviewed;
    }

    public boolean isWithinReviewWindow() {
        return withinReviewWindow;
    }

    public void setWithinReviewWindow(boolean withinReviewWindow) {
        this.withinReviewWindow = withinReviewWindow;
    }

    public int getDaysElapsed() {
        return daysElapsed;
    }

    public void setDaysElapsed(int daysElapsed) {
        this.daysElapsed = daysElapsed;
    }

    public LocalDateTime getLatestOrderTime() {
        return latestOrderTime;
    }

    public void setLatestOrderTime(LocalDateTime latestOrderTime) {
        this.latestOrderTime = latestOrderTime;
    }

    public Long getExistingReviewId() {
        return existingReviewId;
    }

    public void setExistingReviewId(Long existingReviewId) {
        this.existingReviewId = existingReviewId;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public boolean isCanReview() {
        return canReview;
    }

    public void setCanReview(boolean canReview) {
        this.canReview = canReview;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }
}