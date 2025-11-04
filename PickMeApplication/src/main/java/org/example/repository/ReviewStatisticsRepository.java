package org.example.repository;

import org.example.entity.ReviewStatistics;
import org.example.entity.ReviewType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface ReviewStatisticsRepository extends JpaRepository<ReviewStatistics, Long> {
    
    // Tìm statistics theo target
    Optional<ReviewStatistics> findByTargetIdAndTargetType(Long targetId, ReviewType targetType);
    
    // Tìm tất cả statistics của một loại
    List<ReviewStatistics> findByTargetTypeOrderByAverageRatingDesc(ReviewType targetType);
    
    // Top rated targets theo loại
    @Query("SELECT rs FROM ReviewStatistics rs WHERE rs.targetType = :targetType " +
           "AND rs.totalReviews >= :minReviews ORDER BY rs.averageRating DESC, rs.totalReviews DESC")
    List<ReviewStatistics> findTopRatedByType(@Param("targetType") ReviewType targetType, 
                                             @Param("minReviews") Integer minReviews);
    
    // Trending up (cải thiện rating trong thời gian gần đây)
    @Query("SELECT rs FROM ReviewStatistics rs WHERE rs.targetType = :targetType " +
           "AND rs.ratingTrend7Days > 0.1 ORDER BY rs.ratingTrend7Days DESC")
    List<ReviewStatistics> findTrendingUpByType(@Param("targetType") ReviewType targetType);
    
    // Trending down (giảm rating trong thời gian gần đây)  
    @Query("SELECT rs FROM ReviewStatistics rs WHERE rs.targetType = :targetType " +
           "AND rs.ratingTrend7Days < -0.1 ORDER BY rs.ratingTrend7Days ASC")
    List<ReviewStatistics> findTrendingDownByType(@Param("targetType") ReviewType targetType);
    
    // Most reviewed (nhiều reviews nhất)
    @Query("SELECT rs FROM ReviewStatistics rs WHERE rs.targetType = :targetType " +
           "AND rs.lastUpdated >= :sinceDate ORDER BY rs.totalReviews DESC")
    List<ReviewStatistics> findMostReviewedByType(@Param("targetType") ReviewType targetType,
                                                 @Param("sinceDate") LocalDateTime sinceDate);
    
    // Cần cải thiện (rating thấp nhưng có nhiều reviews)
    @Query("SELECT rs FROM ReviewStatistics rs WHERE rs.targetType = :targetType " +
           "AND rs.averageRating < :maxRating AND rs.totalReviews >= :minReviews " +
           "ORDER BY rs.totalReviews DESC, rs.averageRating ASC")
    List<ReviewStatistics> findNeedingImprovementByType(@Param("targetType") ReviewType targetType,
                                                       @Param("maxRating") Double maxRating,
                                                       @Param("minReviews") Integer minReviews);
    
    // Statistics trong khoảng rating
    @Query("SELECT rs FROM ReviewStatistics rs WHERE rs.targetType = :targetType " +
           "AND rs.averageRating BETWEEN :minRating AND :maxRating " +
           "ORDER BY rs.averageRating DESC")
    List<ReviewStatistics> findByRatingRange(@Param("targetType") ReviewType targetType,
                                            @Param("minRating") Double minRating,
                                            @Param("maxRating") Double maxRating);
    
    // Recently active (có reviews mới trong X ngày)
    @Query("SELECT rs FROM ReviewStatistics rs WHERE rs.targetType = :targetType " +
           "AND rs.reviewsLast7Days > 0 ORDER BY rs.reviewsLast7Days DESC")
    List<ReviewStatistics> findRecentlyActiveByType(@Param("targetType") ReviewType targetType);
    
    // Inactive (không có reviews gần đây)
    @Query("SELECT rs FROM ReviewStatistics rs WHERE rs.targetType = :targetType " +
           "AND rs.reviewsLast30Days = 0 AND rs.totalReviews > 0 " +
           "ORDER BY rs.lastUpdated ASC")
    List<ReviewStatistics> findInactiveByType(@Param("targetType") ReviewType targetType);
    
    // Tổng thống kê hệ thống
    @Query("SELECT " +
           "SUM(rs.totalReviews) as totalReviews, " +
           "AVG(rs.averageRating) as overallAverage, " +
           "COUNT(rs) as totalTargets, " +
           "SUM(rs.fiveStarCount) as totalFiveStars, " +
           "SUM(rs.fourStarCount) as totalFourStars, " +
           "SUM(rs.threeStarCount) as totalThreeStars, " +
           "SUM(rs.twoStarCount) as totalTwoStars, " +
           "SUM(rs.oneStarCount) as totalOneStars " +
           "FROM ReviewStatistics rs WHERE rs.targetType = :targetType")
    Object[] findSystemStatsByType(@Param("targetType") ReviewType targetType);
    
    // Statistics cần update (cũ quá)
    @Query("SELECT rs FROM ReviewStatistics rs WHERE rs.lastUpdated < :cutoffDate")
    List<ReviewStatistics> findStaleStatistics(@Param("cutoffDate") LocalDateTime cutoffDate);
    
    // High satisfaction rate (nhiều reviews 4-5 sao)
    @Query("SELECT rs FROM ReviewStatistics rs WHERE rs.targetType = :targetType " +
           "AND (rs.fiveStarCount + rs.fourStarCount) * 100.0 / rs.totalReviews >= :minSatisfactionRate " +
           "AND rs.totalReviews >= :minReviews " +
           "ORDER BY (rs.fiveStarCount + rs.fourStarCount) * 100.0 / rs.totalReviews DESC")
    List<ReviewStatistics> findHighSatisfactionByType(@Param("targetType") ReviewType targetType,
                                                     @Param("minSatisfactionRate") Double minSatisfactionRate,
                                                     @Param("minReviews") Integer minReviews);
    
    // Low satisfaction rate (nhiều reviews 1-2 sao)
    @Query("SELECT rs FROM ReviewStatistics rs WHERE rs.targetType = :targetType " +
           "AND (rs.oneStarCount + rs.twoStarCount) * 100.0 / rs.totalReviews >= :minUnsatisfactionRate " +
           "AND rs.totalReviews >= :minReviews " +
           "ORDER BY (rs.oneStarCount + rs.twoStarCount) * 100.0 / rs.totalReviews DESC")
    List<ReviewStatistics> findLowSatisfactionByType(@Param("targetType") ReviewType targetType,
                                                    @Param("minUnsatisfactionRate") Double minUnsatisfactionRate,
                                                    @Param("minReviews") Integer minReviews);
    
    // Phân bố rating của hệ thống
    @Query("SELECT " +
           "rs.targetType, " +
           "CASE " +
           "WHEN rs.averageRating >= 4.5 THEN 'Excellent' " +
           "WHEN rs.averageRating >= 4.0 THEN 'Very Good' " +
           "WHEN rs.averageRating >= 3.5 THEN 'Good' " +
           "WHEN rs.averageRating >= 3.0 THEN 'Average' " +
           "ELSE 'Below Average' END as ratingCategory, " +
           "COUNT(rs) as count " +
           "FROM ReviewStatistics rs " +
           "WHERE rs.totalReviews >= :minReviews " +
           "GROUP BY rs.targetType, " +
           "CASE " +
           "WHEN rs.averageRating >= 4.5 THEN 'Excellent' " +
           "WHEN rs.averageRating >= 4.0 THEN 'Very Good' " +
           "WHEN rs.averageRating >= 3.5 THEN 'Good' " +
           "WHEN rs.averageRating >= 3.0 THEN 'Average' " +
           "ELSE 'Below Average' END " +
           "ORDER BY rs.targetType, ratingCategory")
    List<Object[]> findRatingDistributionByType(@Param("minReviews") Integer minReviews);
    
    // Tìm statistics của restaurants thuộc owner
    @Query("SELECT rs FROM ReviewStatistics rs WHERE rs.targetType = 'RESTAURANT' " +
           "AND rs.targetId IN (SELECT r.id FROM Restaurant r WHERE r.owner.id = :ownerId)")
    List<ReviewStatistics> findByRestaurantOwnerId(@Param("ownerId") Long ownerId);
    
    // Đếm số targets có ít nhất X reviews
    @Query("SELECT COUNT(rs) FROM ReviewStatistics rs WHERE rs.targetType = :targetType " +
           "AND rs.totalReviews >= :minReviews")
    Long countTargetsWithMinReviews(@Param("targetType") ReviewType targetType, 
                                   @Param("minReviews") Integer minReviews);
    
    // Tìm statistics bị outlier (rating quá cao/thấp so với số reviews)
    @Query("SELECT rs FROM ReviewStatistics rs WHERE rs.targetType = :targetType " +
           "AND ((rs.averageRating >= 4.8 AND rs.totalReviews <= 5) " +
           "OR (rs.averageRating <= 1.5 AND rs.totalReviews <= 3)) " +
           "ORDER BY ABS(rs.averageRating - 3.0) DESC")
    List<ReviewStatistics> findPotentialOutliers(@Param("targetType") ReviewType targetType);
}