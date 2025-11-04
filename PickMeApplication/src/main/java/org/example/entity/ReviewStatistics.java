package org.example.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Entity để cache thống kê review cho performance
 * Denormalized data để tránh tính toán phức tạp khi query
 */
@Entity
@Table(name = "review_statistics", indexes = {
    @Index(name = "idx_review_stats_target", columnList = "target_type, target_id"),
    @Index(name = "idx_review_stats_rating", columnList = "average_rating"),
    @Index(name = "idx_review_stats_updated", columnList = "last_updated")
})
public class ReviewStatistics {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // ID của đối tượng được review (Restaurant ID hoặc MenuItem ID)
    @Column(name = "target_id", nullable = false)
    private Long targetId;
    
    // Loại đối tượng được review
    @Enumerated(EnumType.STRING)
    @Column(name = "target_type", nullable = false)
    private ReviewType targetType;
    
    // Thống kê rating tổng thể
    @Column(name = "average_rating")
    private Double averageRating = 0.0;
    
    @Column(name = "total_reviews", nullable = false)
    private Integer totalReviews = 0;
    
    // Phân bố rating (1-5 sao)
    @Column(name = "five_star_count", nullable = false)
    private Integer fiveStarCount = 0;
    
    @Column(name = "four_star_count", nullable = false)
    private Integer fourStarCount = 0;
    
    @Column(name = "three_star_count", nullable = false)
    private Integer threeStarCount = 0;
    
    @Column(name = "two_star_count", nullable = false)
    private Integer twoStarCount = 0;
    
    @Column(name = "one_star_count", nullable = false)
    private Integer oneStarCount = 0;
    
    // Thống kê cho Order Experience (nếu áp dụng)
    @Column(name = "avg_food_quality")
    private Double avgFoodQuality;
    
    @Column(name = "avg_service")
    private Double avgService;
    
    @Column(name = "avg_delivery_time")
    private Double avgDeliveryTime;
    
    @Column(name = "avg_packaging")
    private Double avgPackaging;
    
    @Column(name = "avg_value_for_money")
    private Double avgValueForMoney;
    
    @Column(name = "avg_order_accuracy")
    private Double avgOrderAccuracy;
    
    // Thống kê trending
    @Column(name = "rating_trend_7_days")
    private Double ratingTrend7Days = 0.0; // +/- so với 7 ngày trước
    
    @Column(name = "rating_trend_30_days")
    private Double ratingTrend30Days = 0.0; // +/- so với 30 ngày trước
    
    @Column(name = "reviews_last_7_days", nullable = false)
    private Integer reviewsLast7Days = 0;
    
    @Column(name = "reviews_last_30_days", nullable = false)
    private Integer reviewsLast30Days = 0;
    
    // Timestamps
    @Column(name = "last_updated", nullable = false)
    private LocalDateTime lastUpdated;
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    // Constructors
    public ReviewStatistics() {
        this.createdAt = LocalDateTime.now();
        this.lastUpdated = LocalDateTime.now();
    }
    
    public ReviewStatistics(Long targetId, ReviewType targetType) {
        this();
        this.targetId = targetId;
        this.targetType = targetType;
    }
    
    // Business Logic Methods
    
    /**
     * Cập nhật thống kê khi có review mới
     */
    public void addReview(Integer rating) {
        this.totalReviews++;
        
        // Cập nhật phân bố rating
        switch (rating) {
            case 5: this.fiveStarCount++; break;
            case 4: this.fourStarCount++; break;
            case 3: this.threeStarCount++; break;
            case 2: this.twoStarCount++; break;
            case 1: this.oneStarCount++; break;
        }
        
        // Tính lại average rating
        recalculateAverageRating();
        this.lastUpdated = LocalDateTime.now();
    }
    
    /**
     * Cập nhật thống kê khi xóa review
     */
    public void removeReview(Integer rating) {
        if (this.totalReviews > 0) {
            this.totalReviews--;
            
            // Cập nhật phân bố rating
            switch (rating) {
                case 5: this.fiveStarCount = Math.max(0, this.fiveStarCount - 1); break;
                case 4: this.fourStarCount = Math.max(0, this.fourStarCount - 1); break;
                case 3: this.threeStarCount = Math.max(0, this.threeStarCount - 1); break;
                case 2: this.twoStarCount = Math.max(0, this.twoStarCount - 1); break;
                case 1: this.oneStarCount = Math.max(0, this.oneStarCount - 1); break;
            }
            
            // Tính lại average rating
            recalculateAverageRating();
            this.lastUpdated = LocalDateTime.now();
        }
    }
    
    /**
     * Cập nhật thống kê khi sửa review
     */
    public void updateReview(Integer oldRating, Integer newRating) {
        removeReview(oldRating);
        addReview(newRating);
    }
    
    /**
     * Tính lại average rating từ phân bố
     */
    private void recalculateAverageRating() {
        if (this.totalReviews == 0) {
            this.averageRating = 0.0;
            return;
        }
        
        int totalPoints = (fiveStarCount * 5) + (fourStarCount * 4) + 
                         (threeStarCount * 3) + (twoStarCount * 2) + (oneStarCount * 1);
        
        this.averageRating = Math.round((double) totalPoints / this.totalReviews * 100.0) / 100.0;
    }
    
    /**
     * Lấy phân bố rating dưới dạng Map
     */
    public Map<Integer, Integer> getRatingDistribution() {
        Map<Integer, Integer> distribution = new HashMap<>();
        distribution.put(5, fiveStarCount);
        distribution.put(4, fourStarCount);
        distribution.put(3, threeStarCount);
        distribution.put(2, twoStarCount);
        distribution.put(1, oneStarCount);
        return distribution;
    }
    
    /**
     * Lấy phân bố rating dưới dạng phần trăm
     */
    public Map<Integer, Double> getRatingDistributionPercentage() {
        Map<Integer, Double> percentages = new HashMap<>();
        
        if (totalReviews == 0) {
            for (int i = 1; i <= 5; i++) {
                percentages.put(i, 0.0);
            }
            return percentages;
        }
        
        percentages.put(5, Math.round((double) fiveStarCount / totalReviews * 100.0 * 100.0) / 100.0);
        percentages.put(4, Math.round((double) fourStarCount / totalReviews * 100.0 * 100.0) / 100.0);
        percentages.put(3, Math.round((double) threeStarCount / totalReviews * 100.0 * 100.0) / 100.0);
        percentages.put(2, Math.round((double) twoStarCount / totalReviews * 100.0 * 100.0) / 100.0);
        percentages.put(1, Math.round((double) oneStarCount / totalReviews * 100.0 * 100.0) / 100.0);
        
        return percentages;
    }
    
    /**
     * Lấy rating phổ biến nhất
     */
    public Integer getMostCommonRating() {
        int maxCount = Math.max(Math.max(Math.max(Math.max(
            fiveStarCount, fourStarCount), threeStarCount), twoStarCount), oneStarCount);
        
        if (maxCount == 0) return null;
        
        if (fiveStarCount == maxCount) return 5;
        if (fourStarCount == maxCount) return 4;
        if (threeStarCount == maxCount) return 3;
        if (twoStarCount == maxCount) return 2;
        return 1;
    }
    
    /**
     * Kiểm tra xem có đang trend tích cực không
     */
    public boolean isPositiveTrend() {
        return ratingTrend7Days != null && ratingTrend7Days > 0.1; // Tăng >0.1 điểm trong 7 ngày
    }
    
    /**
     * Kiểm tra xem có đang trend tiêu cực không
     */
    public boolean isNegativeTrend() {
        return ratingTrend7Days != null && ratingTrend7Days < -0.1; // Giảm >0.1 điểm trong 7 ngày
    }
    
    /**
     * Lấy mức độ satisfaction (dựa trên % rating 4-5 sao)
     */
    public Double getSatisfactionRate() {
        if (totalReviews == 0) return 0.0;
        
        int satisfiedCount = fiveStarCount + fourStarCount;
        return Math.round((double) satisfiedCount / totalReviews * 100.0 * 100.0) / 100.0;
    }
    
    /**
     * Reset tất cả thống kê về 0
     */
    public void reset() {
        this.averageRating = 0.0;
        this.totalReviews = 0;
        this.fiveStarCount = 0;
        this.fourStarCount = 0;
        this.threeStarCount = 0;
        this.twoStarCount = 0;
        this.oneStarCount = 0;
        this.ratingTrend7Days = 0.0;
        this.ratingTrend30Days = 0.0;
        this.reviewsLast7Days = 0;
        this.reviewsLast30Days = 0;
        this.lastUpdated = LocalDateTime.now();
    }
    
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