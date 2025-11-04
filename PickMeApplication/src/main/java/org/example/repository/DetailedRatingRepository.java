package org.example.repository;

import org.example.entity.DetailedRating;
import org.example.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface DetailedRatingRepository extends JpaRepository<DetailedRating, Long> {
    
    // Tìm detailed rating theo review
    Optional<DetailedRating> findByReview(Review review);
    
    Optional<DetailedRating> findByReviewId(Long reviewId);
    
    // Tìm detailed ratings cho một restaurant (thông qua orders)
    @Query("SELECT dr FROM DetailedRating dr JOIN dr.review r JOIN r.order o " +
           "WHERE o.restaurant.id = :restaurantId AND r.isHidden = false")
    List<DetailedRating> findByRestaurantId(@Param("restaurantId") Long restaurantId);
    
    // Tính average ratings cho từng khía cạnh của restaurant
    @Query("SELECT " +
           "AVG(dr.foodQualityRating) as avgFoodQuality, " +
           "AVG(dr.serviceRating) as avgService, " +
           "AVG(dr.deliveryTimeRating) as avgDeliveryTime, " +
           "AVG(dr.packagingRating) as avgPackaging, " +
           "AVG(dr.valueForMoneyRating) as avgValueForMoney, " +
           "AVG(dr.orderAccuracyRating) as avgOrderAccuracy " +
           "FROM DetailedRating dr JOIN dr.review r JOIN r.order o " +
           "WHERE o.restaurant.id = :restaurantId AND r.isHidden = false")
    Object[] findAverageRatingsByRestaurant(@Param("restaurantId") Long restaurantId);
    
    // Tính average ratings trong khoảng thời gian
    @Query("SELECT " +
           "AVG(dr.foodQualityRating) as avgFoodQuality, " +
           "AVG(dr.serviceRating) as avgService, " +
           "AVG(dr.deliveryTimeRating) as avgDeliveryTime, " +
           "AVG(dr.packagingRating) as avgPackaging, " +
           "AVG(dr.valueForMoneyRating) as avgValueForMoney, " +
           "AVG(dr.orderAccuracyRating) as avgOrderAccuracy " +
           "FROM DetailedRating dr JOIN dr.review r JOIN r.order o " +
           "WHERE o.restaurant.id = :restaurantId AND r.isHidden = false " +
           "AND dr.createdAt BETWEEN :startDate AND :endDate")
    Object[] findAverageRatingsByRestaurantAndDateRange(@Param("restaurantId") Long restaurantId,
                                                       @Param("startDate") LocalDateTime startDate,
                                                       @Param("endDate") LocalDateTime endDate);
    
    // Tìm khía cạnh được đánh giá cao nhất của restaurant
    @Query("SELECT " +
           "CASE " +
           "WHEN AVG(dr.foodQualityRating) = MAX_RATING.max_rating THEN 'Food Quality' " +
           "WHEN AVG(dr.serviceRating) = MAX_RATING.max_rating THEN 'Service' " +
           "WHEN AVG(dr.deliveryTimeRating) = MAX_RATING.max_rating THEN 'Delivery Time' " +
           "WHEN AVG(dr.packagingRating) = MAX_RATING.max_rating THEN 'Packaging' " +
           "WHEN AVG(dr.valueForMoneyRating) = MAX_RATING.max_rating THEN 'Value for Money' " +
           "WHEN AVG(dr.orderAccuracyRating) = MAX_RATING.max_rating THEN 'Order Accuracy' " +
           "END as bestAspect " +
           "FROM DetailedRating dr JOIN dr.review r JOIN r.order o, " +
           "(SELECT GREATEST(" +
           "AVG(dr2.foodQualityRating), AVG(dr2.serviceRating), AVG(dr2.deliveryTimeRating), " +
           "AVG(dr2.packagingRating), AVG(dr2.valueForMoneyRating), AVG(dr2.orderAccuracyRating)" +
           ") as max_rating " +
           "FROM DetailedRating dr2 JOIN dr2.review r2 JOIN r2.order o2 " +
           "WHERE o2.restaurant.id = :restaurantId AND r2.isHidden = false) MAX_RATING " +
           "WHERE o.restaurant.id = :restaurantId AND r.isHidden = false " +
           "GROUP BY MAX_RATING.max_rating")
    List<String> findBestAspectsByRestaurant(@Param("restaurantId") Long restaurantId);
    
    // Tìm khía cạnh cần cải thiện nhất của restaurant  
    @Query("SELECT " +
           "CASE " +
           "WHEN AVG(dr.foodQualityRating) = MIN_RATING.min_rating THEN 'Food Quality' " +
           "WHEN AVG(dr.serviceRating) = MIN_RATING.min_rating THEN 'Service' " +
           "WHEN AVG(dr.deliveryTimeRating) = MIN_RATING.min_rating THEN 'Delivery Time' " +
           "WHEN AVG(dr.packagingRating) = MIN_RATING.min_rating THEN 'Packaging' " +
           "WHEN AVG(dr.valueForMoneyRating) = MIN_RATING.min_rating THEN 'Value for Money' " +
           "WHEN AVG(dr.orderAccuracyRating) = MIN_RATING.min_rating THEN 'Order Accuracy' " +
           "END as worstAspect " +
           "FROM DetailedRating dr JOIN dr.review r JOIN r.order o, " +
           "(SELECT LEAST(" +
           "COALESCE(AVG(dr2.foodQualityRating), 5), COALESCE(AVG(dr2.serviceRating), 5), " +
           "COALESCE(AVG(dr2.deliveryTimeRating), 5), COALESCE(AVG(dr2.packagingRating), 5), " +
           "COALESCE(AVG(dr2.valueForMoneyRating), 5), COALESCE(AVG(dr2.orderAccuracyRating), 5)" +
           ") as min_rating " +
           "FROM DetailedRating dr2 JOIN dr2.review r2 JOIN r2.order o2 " +
           "WHERE o2.restaurant.id = :restaurantId AND r2.isHidden = false) MIN_RATING " +
           "WHERE o.restaurant.id = :restaurantId AND r.isHidden = false " +
           "GROUP BY MIN_RATING.min_rating")
    List<String> findWorstAspectsByRestaurant(@Param("restaurantId") Long restaurantId);
    
    // Đếm số detailed ratings có đủ tất cả fields
    @Query("SELECT COUNT(dr) FROM DetailedRating dr JOIN dr.review r " +
           "WHERE dr.foodQualityRating IS NOT NULL AND dr.serviceRating IS NOT NULL " +
           "AND dr.deliveryTimeRating IS NOT NULL AND dr.packagingRating IS NOT NULL " +
           "AND dr.valueForMoneyRating IS NOT NULL AND dr.orderAccuracyRating IS NOT NULL " +
           "AND r.isHidden = false")
    Long countCompleteDetailedRatings();
    
    // Tìm detailed ratings với rating thấp (cần attention)
    @Query("SELECT dr FROM DetailedRating dr JOIN dr.review r JOIN r.order o " +
           "WHERE o.restaurant.id = :restaurantId AND r.isHidden = false " +
           "AND (dr.foodQualityRating <= 2 OR dr.serviceRating <= 2 OR " +
           "dr.deliveryTimeRating <= 2 OR dr.packagingRating <= 2 OR " +
           "dr.valueForMoneyRating <= 2 OR dr.orderAccuracyRating <= 2) " +
           "ORDER BY dr.createdAt DESC")
    List<DetailedRating> findLowRatingsByRestaurant(@Param("restaurantId") Long restaurantId);
    
    // Thống kê chi tiết theo tháng
    @Query("SELECT " +
           "EXTRACT(MONTH FROM dr.createdAt) as month, " +
           "AVG(dr.foodQualityRating) as avgFoodQuality, " +
           "AVG(dr.serviceRating) as avgService, " +
           "AVG(dr.deliveryTimeRating) as avgDeliveryTime, " +
           "AVG(dr.packagingRating) as avgPackaging, " +
           "AVG(dr.valueForMoneyRating) as avgValueForMoney, " +
           "AVG(dr.orderAccuracyRating) as avgOrderAccuracy, " +
           "COUNT(dr) as totalRatings " +
           "FROM DetailedRating dr JOIN dr.review r JOIN r.order o " +
           "WHERE o.restaurant.id = :restaurantId AND r.isHidden = false " +
           "AND dr.createdAt >= :startDate " +
           "GROUP BY EXTRACT(MONTH FROM dr.createdAt) " +
           "ORDER BY month")
    List<Object[]> findMonthlyDetailedStatistics(@Param("restaurantId") Long restaurantId,
                                                 @Param("startDate") LocalDateTime startDate);
    
    // Tìm trends - so sánh với kỳ trước
    @Query("SELECT " +
           "AVG(CASE WHEN dr.createdAt >= :recentStartDate THEN dr.foodQualityRating END) - " +
           "AVG(CASE WHEN dr.createdAt < :recentStartDate AND dr.createdAt >= :oldStartDate THEN dr.foodQualityRating END) as foodQualityTrend, " +
           "AVG(CASE WHEN dr.createdAt >= :recentStartDate THEN dr.serviceRating END) - " +
           "AVG(CASE WHEN dr.createdAt < :recentStartDate AND dr.createdAt >= :oldStartDate THEN dr.serviceRating END) as serviceTrend, " +
           "AVG(CASE WHEN dr.createdAt >= :recentStartDate THEN dr.deliveryTimeRating END) - " +
           "AVG(CASE WHEN dr.createdAt < :recentStartDate AND dr.createdAt >= :oldStartDate THEN dr.deliveryTimeRating END) as deliveryTimeTrend " +
           "FROM DetailedRating dr JOIN dr.review r JOIN r.order o " +
           "WHERE o.restaurant.id = :restaurantId AND r.isHidden = false " +
           "AND dr.createdAt >= :oldStartDate")
    Object[] findDetailedRatingTrends(@Param("restaurantId") Long restaurantId,
                                     @Param("recentStartDate") LocalDateTime recentStartDate,
                                     @Param("oldStartDate") LocalDateTime oldStartDate);
    
    // Tìm detailed ratings của một customer
    @Query("SELECT dr FROM DetailedRating dr JOIN dr.review r " +
           "WHERE r.reviewer.id = :customerId AND r.isHidden = false " +
           "ORDER BY dr.createdAt DESC")
    List<DetailedRating> findByCustomerId(@Param("customerId") Long customerId);
}