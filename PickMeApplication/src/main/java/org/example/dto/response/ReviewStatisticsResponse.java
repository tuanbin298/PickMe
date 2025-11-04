package org.example.dto.response;

import org.example.entity.ReviewType;
import java.time.LocalDateTime;
import java.util.Map;

/**
 * DTO cho response review statistics
 */
public class ReviewStatisticsResponse {
    
    private Long id;
    private Long targetId;
    private ReviewType targetType;
    private Double averageRating;
    private Integer totalReviews;
    private Integer fiveStarCount;
    private Integer fourStarCount;
    private Integer threeStarCount;
    private Integer twoStarCount;
    private Integer oneStarCount;
    private Map<Integer, Integer> ratingDistribution;
    private Map<Integer, Double> ratingDistributionPercentage;
    private Integer mostCommonRating;
    private Double satisfactionRate;
    
    // Order experience averages (if applicable)
    private Double avgFoodQuality;
    private Double avgService;
    private Double avgDeliveryTime;
    private Double avgPackaging;
    private Double avgValueForMoney;
    private Double avgOrderAccuracy;
    
    // Trending data
    private Double ratingTrend7Days;
    private Double ratingTrend30Days;
    private Integer reviewsLast7Days;
    private Integer reviewsLast30Days;
    private Boolean isPositiveTrend;
    private Boolean isNegativeTrend;
    
    private LocalDateTime lastUpdated;
    private LocalDateTime createdAt;
    
    // Constructors
    public ReviewStatisticsResponse() {}
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getTargetId() {
        return targetId;
    }
    
    public void setTargetId(Long targetId) {
        this.targetId = targetId;
    }
    
    public ReviewType getTargetType() {
        return targetType;
    }
    
    public void setTargetType(ReviewType targetType) {
        this.targetType = targetType;
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
    
    public Integer getFiveStarCount() {
        return fiveStarCount;
    }
    
    public void setFiveStarCount(Integer fiveStarCount) {
        this.fiveStarCount = fiveStarCount;
    }
    
    public Integer getFourStarCount() {
        return fourStarCount;
    }
    
    public void setFourStarCount(Integer fourStarCount) {
        this.fourStarCount = fourStarCount;
    }
    
    public Integer getThreeStarCount() {
        return threeStarCount;
    }
    
    public void setThreeStarCount(Integer threeStarCount) {
        this.threeStarCount = threeStarCount;
    }
    
    public Integer getTwoStarCount() {
        return twoStarCount;
    }
    
    public void setTwoStarCount(Integer twoStarCount) {
        this.twoStarCount = twoStarCount;
    }
    
    public Integer getOneStarCount() {
        return oneStarCount;
    }
    
    public void setOneStarCount(Integer oneStarCount) {
        this.oneStarCount = oneStarCount;
    }
    
    public Map<Integer, Integer> getRatingDistribution() {
        return ratingDistribution;
    }
    
    public void setRatingDistribution(Map<Integer, Integer> ratingDistribution) {
        this.ratingDistribution = ratingDistribution;
    }
    
    public Map<Integer, Double> getRatingDistributionPercentage() {
        return ratingDistributionPercentage;
    }
    
    public void setRatingDistributionPercentage(Map<Integer, Double> ratingDistributionPercentage) {
        this.ratingDistributionPercentage = ratingDistributionPercentage;
    }
    
    public Integer getMostCommonRating() {
        return mostCommonRating;
    }
    
    public void setMostCommonRating(Integer mostCommonRating) {
        this.mostCommonRating = mostCommonRating;
    }
    
    public Double getSatisfactionRate() {
        return satisfactionRate;
    }
    
    public void setSatisfactionRate(Double satisfactionRate) {
        this.satisfactionRate = satisfactionRate;
    }
    
    public Double getAvgFoodQuality() {
        return avgFoodQuality;
    }
    
    public void setAvgFoodQuality(Double avgFoodQuality) {
        this.avgFoodQuality = avgFoodQuality;
    }
    
    public Double getAvgService() {
        return avgService;
    }
    
    public void setAvgService(Double avgService) {
        this.avgService = avgService;
    }
    
    public Double getAvgDeliveryTime() {
        return avgDeliveryTime;
    }
    
    public void setAvgDeliveryTime(Double avgDeliveryTime) {
        this.avgDeliveryTime = avgDeliveryTime;
    }
    
    public Double getAvgPackaging() {
        return avgPackaging;
    }
    
    public void setAvgPackaging(Double avgPackaging) {
        this.avgPackaging = avgPackaging;
    }
    
    public Double getAvgValueForMoney() {
        return avgValueForMoney;
    }
    
    public void setAvgValueForMoney(Double avgValueForMoney) {
        this.avgValueForMoney = avgValueForMoney;
    }
    
    public Double getAvgOrderAccuracy() {
        return avgOrderAccuracy;
    }
    
    public void setAvgOrderAccuracy(Double avgOrderAccuracy) {
        this.avgOrderAccuracy = avgOrderAccuracy;
    }
    
    public Double getRatingTrend7Days() {
        return ratingTrend7Days;
    }
    
    public void setRatingTrend7Days(Double ratingTrend7Days) {
        this.ratingTrend7Days = ratingTrend7Days;
    }
    
    public Double getRatingTrend30Days() {
        return ratingTrend30Days;
    }
    
    public void setRatingTrend30Days(Double ratingTrend30Days) {
        this.ratingTrend30Days = ratingTrend30Days;
    }
    
    public Integer getReviewsLast7Days() {
        return reviewsLast7Days;
    }
    
    public void setReviewsLast7Days(Integer reviewsLast7Days) {
        this.reviewsLast7Days = reviewsLast7Days;
    }
    
    public Integer getReviewsLast30Days() {
        return reviewsLast30Days;
    }
    
    public void setReviewsLast30Days(Integer reviewsLast30Days) {
        this.reviewsLast30Days = reviewsLast30Days;
    }
    
    public Boolean getIsPositiveTrend() {
        return isPositiveTrend;
    }
    
    public void setIsPositiveTrend(Boolean isPositiveTrend) {
        this.isPositiveTrend = isPositiveTrend;
    }
    
    public Boolean getIsNegativeTrend() {
        return isNegativeTrend;
    }
    
    public void setIsNegativeTrend(Boolean isNegativeTrend) {
        this.isNegativeTrend = isNegativeTrend;
    }
    
    public LocalDateTime getLastUpdated() {
        return lastUpdated;
    }
    
    public void setLastUpdated(LocalDateTime lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}