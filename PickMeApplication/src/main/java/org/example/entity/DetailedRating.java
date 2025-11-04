package org.example.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import java.time.LocalDateTime;

/**
 * Entity để lưu trữ đánh giá chi tiết cho Order Experience Reviews
 * Chia nhỏ rating thành các khía cạnh cụ thể
 */
@Entity
@Table(name = "detailed_ratings", indexes = {
    @Index(name = "idx_detailed_rating_review_id", columnList = "review_id")
})
public class DetailedRating {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // Liên kết tới Review chính
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "review_id", nullable = false, unique = true)
    private Review review;
    
    // Đánh giá chất lượng món ăn (1-5 sao)
    @Min(value = 1, message = "Food quality rating must be at least 1")
    @Max(value = 5, message = "Food quality rating must be at most 5")
    @Column(name = "food_quality_rating")
    private Integer foodQualityRating;
    
    // Đánh giá dịch vụ (1-5 sao)
    @Min(value = 1, message = "Service rating must be at least 1")
    @Max(value = 5, message = "Service rating must be at most 5")
    @Column(name = "service_rating")
    private Integer serviceRating;
    
    // Đánh giá thời gian giao hàng/chuẩn bị (1-5 sao)
    @Min(value = 1, message = "Delivery time rating must be at least 1")
    @Max(value = 5, message = "Delivery time rating must be at most 5")
    @Column(name = "delivery_time_rating")
    private Integer deliveryTimeRating;
    
    // Đánh giá đóng gói (1-5 sao)
    @Min(value = 1, message = "Packaging rating must be at least 1")
    @Max(value = 5, message = "Packaging rating must be at most 5")
    @Column(name = "packaging_rating")
    private Integer packagingRating;
    
    // Đánh giá giá trị so với tiền bỏ ra (1-5 sao)
    @Min(value = 1, message = "Value for money rating must be at least 1")
    @Max(value = 5, message = "Value for money rating must be at most 5")
    @Column(name = "value_for_money_rating")
    private Integer valueForMoneyRating;
    
    // Đánh giá sự chính xác của đơn hàng (1-5 sao)
    @Min(value = 1, message = "Order accuracy rating must be at least 1")
    @Max(value = 5, message = "Order accuracy rating must be at most 5")
    @Column(name = "order_accuracy_rating")
    private Integer orderAccuracyRating;
    
    // Timestamps
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Constructors
    public DetailedRating() {
        this.createdAt = LocalDateTime.now();
    }
    
    public DetailedRating(Review review) {
        this();
        this.review = review;
    }
    
    public DetailedRating(Review review, Integer foodQuality, Integer service, 
                         Integer deliveryTime, Integer packaging, Integer valueForMoney, 
                         Integer orderAccuracy) {
        this();
        this.review = review;
        this.foodQualityRating = foodQuality;
        this.serviceRating = service;
        this.deliveryTimeRating = deliveryTime;
        this.packagingRating = packaging;
        this.valueForMoneyRating = valueForMoney;
        this.orderAccuracyRating = orderAccuracy;
    }
    
    // Business Logic Methods
    
    /**
     * Tính rating trung bình của tất cả các khía cạnh
     */
    public Double calculateAverageRating() {
        int count = 0;
        int total = 0;
        
        if (foodQualityRating != null) {
            total += foodQualityRating;
            count++;
        }
        if (serviceRating != null) {
            total += serviceRating;
            count++;
        }
        if (deliveryTimeRating != null) {
            total += deliveryTimeRating;
            count++;
        }
        if (packagingRating != null) {
            total += packagingRating;
            count++;
        }
        if (valueForMoneyRating != null) {
            total += valueForMoneyRating;
            count++;
        }
        if (orderAccuracyRating != null) {
            total += orderAccuracyRating;
            count++;
        }
        
        return count > 0 ? (double) total / count : 0.0;
    }
    
    /**
     * Kiểm tra xem có ít nhất 1 rating được điền không
     */
    public boolean hasAnyRating() {
        return foodQualityRating != null || 
               serviceRating != null || 
               deliveryTimeRating != null || 
               packagingRating != null || 
               valueForMoneyRating != null || 
               orderAccuracyRating != null;
    }
    
    /**
     * Kiểm tra xem tất cả ratings có được điền không
     */
    public boolean hasAllRatings() {
        return foodQualityRating != null && 
               serviceRating != null && 
               deliveryTimeRating != null && 
               packagingRating != null && 
               valueForMoneyRating != null && 
               orderAccuracyRating != null;
    }
    
    /**
     * Đếm số lượng ratings đã được điền
     */
    public int getCompletedRatingsCount() {
        int count = 0;
        if (foodQualityRating != null) count++;
        if (serviceRating != null) count++;
        if (deliveryTimeRating != null) count++;
        if (packagingRating != null) count++;
        if (valueForMoneyRating != null) count++;
        if (orderAccuracyRating != null) count++;
        return count;
    }
    
    /**
     * Tìm khía cạnh được đánh giá cao nhất
     */
    public String getBestAspect() {
        Integer maxRating = 0;
        String bestAspect = null;
        
        if (foodQualityRating != null && foodQualityRating > maxRating) {
            maxRating = foodQualityRating;
            bestAspect = "Food Quality";
        }
        if (serviceRating != null && serviceRating > maxRating) {
            maxRating = serviceRating;
            bestAspect = "Service";
        }
        if (deliveryTimeRating != null && deliveryTimeRating > maxRating) {
            maxRating = deliveryTimeRating;
            bestAspect = "Delivery Time";
        }
        if (packagingRating != null && packagingRating > maxRating) {
            maxRating = packagingRating;
            bestAspect = "Packaging";
        }
        if (valueForMoneyRating != null && valueForMoneyRating > maxRating) {
            maxRating = valueForMoneyRating;
            bestAspect = "Value for Money";
        }
        if (orderAccuracyRating != null && orderAccuracyRating > maxRating) {
            maxRating = orderAccuracyRating;
            bestAspect = "Order Accuracy";
        }
        
        return bestAspect;
    }
    
    /**
     * Tìm khía cạnh cần cải thiện nhất (điểm thấp nhất)
     */
    public String getWorstAspect() {
        Integer minRating = 6; // Bắt đầu từ 6 để so sánh
        String worstAspect = null;
        
        if (foodQualityRating != null && foodQualityRating < minRating) {
            minRating = foodQualityRating;
            worstAspect = "Food Quality";
        }
        if (serviceRating != null && serviceRating < minRating) {
            minRating = serviceRating;
            worstAspect = "Service";
        }
        if (deliveryTimeRating != null && deliveryTimeRating < minRating) {
            minRating = deliveryTimeRating;
            worstAspect = "Delivery Time";
        }
        if (packagingRating != null && packagingRating < minRating) {
            minRating = packagingRating;
            worstAspect = "Packaging";
        }
        if (valueForMoneyRating != null && valueForMoneyRating < minRating) {
            minRating = valueForMoneyRating;
            worstAspect = "Value for Money";
        }
        if (orderAccuracyRating != null && orderAccuracyRating < minRating) {
            minRating = orderAccuracyRating;
            worstAspect = "Order Accuracy";
        }
        
        return worstAspect;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Review getReview() {
        return review;
    }
    
    public void setReview(Review review) {
        this.review = review;
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
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}