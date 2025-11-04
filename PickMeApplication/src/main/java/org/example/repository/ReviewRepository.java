package org.example.repository;

import org.example.entity.Review;
import org.example.entity.ReviewType;
import org.example.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    
    // Tìm reviews theo target (Restaurant, MenuItem, Order)
    List<Review> findByTargetIdAndReviewTypeAndIsHiddenFalse(Long targetId, ReviewType reviewType);
    
    Page<Review> findByTargetIdAndReviewTypeAndIsHiddenFalse(Long targetId, ReviewType reviewType, Pageable pageable);
    
    // Tìm reviews của một user
    Page<Review> findByReviewerOrderByCreatedAtDesc(User reviewer, Pageable pageable);
    
    Page<Review> findByReviewerAndReviewTypeOrderByCreatedAtDesc(User reviewer, ReviewType reviewType, Pageable pageable);
    
    // Kiểm tra user đã review chưa
    boolean existsByReviewerAndTargetIdAndReviewType(User reviewer, Long targetId, ReviewType reviewType);
    
    Optional<Review> findByReviewerAndTargetIdAndReviewType(User reviewer, Long targetId, ReviewType reviewType);
    
    // Tìm reviews theo Order
    List<Review> findByOrderId(Long orderId);
    
    Page<Review> findByOrderId(Long orderId, Pageable pageable);
    
    // Tìm reviews theo rating
    List<Review> findByTargetIdAndReviewTypeAndOverallRatingAndIsHiddenFalse(
        Long targetId, ReviewType reviewType, Integer rating);
    
    // Reviews có phản hồi từ owner
    @Query("SELECT r FROM Review r WHERE r.targetId = :targetId AND r.reviewType = :reviewType " +
           "AND r.ownerResponse IS NOT NULL AND r.isHidden = false")
    List<Review> findReviewsWithOwnerResponse(@Param("targetId") Long targetId, 
                                             @Param("reviewType") ReviewType reviewType);
    
    // Reviews chưa có phản hồi từ owner
    @Query("SELECT r FROM Review r WHERE r.targetId = :targetId AND r.reviewType = :reviewType " +
           "AND r.ownerResponse IS NULL AND r.isHidden = false ORDER BY r.createdAt DESC")
    List<Review> findReviewsWithoutOwnerResponse(@Param("targetId") Long targetId, 
                                                @Param("reviewType") ReviewType reviewType);
    
    // Reviews trong khoảng thời gian
    @Query("SELECT r FROM Review r WHERE r.targetId = :targetId AND r.reviewType = :reviewType " +
           "AND r.createdAt BETWEEN :startDate AND :endDate AND r.isHidden = false")
    List<Review> findReviewsByDateRange(@Param("targetId") Long targetId,
                                       @Param("reviewType") ReviewType reviewType,
                                       @Param("startDate") LocalDateTime startDate,
                                       @Param("endDate") LocalDateTime endDate);
    
    // Tính average rating
    @Query("SELECT AVG(r.overallRating) FROM Review r WHERE r.targetId = :targetId " +
           "AND r.reviewType = :reviewType AND r.isHidden = false")
    Optional<Double> findAverageRatingByTarget(@Param("targetId") Long targetId, 
                                              @Param("reviewType") ReviewType reviewType);
    
    // Đếm reviews theo rating
    @Query("SELECT COUNT(r) FROM Review r WHERE r.targetId = :targetId AND r.reviewType = :reviewType " +
           "AND r.overallRating = :rating AND r.isHidden = false")
    Long countByTargetAndRating(@Param("targetId") Long targetId,
                               @Param("reviewType") ReviewType reviewType,
                               @Param("rating") Integer rating);
    
    // Reviews cần moderation (được report hoặc có từ khóa nhạy cảm)
    @Query("SELECT r FROM Review r WHERE r.isHidden = false AND " +
           "(LOWER(r.comment) LIKE %:keyword% OR LOWER(r.comment) LIKE %:keyword2%)")
    List<Review> findReviewsNeedingModeration(@Param("keyword") String keyword, 
                                             @Param("keyword2") String keyword2);
    
    // Reviews được tạo trong X ngày qua
    @Query("SELECT r FROM Review r WHERE r.targetId = :targetId AND r.reviewType = :reviewType " +
           "AND r.createdAt >= :sinceDate AND r.isHidden = false")
    List<Review> findRecentReviews(@Param("targetId") Long targetId,
                                  @Param("reviewType") ReviewType reviewType,
                                  @Param("sinceDate") LocalDateTime sinceDate);
    
    // Top reviews (rating cao + có nhiều tương tác)
    @Query("SELECT r FROM Review r WHERE r.targetId = :targetId AND r.reviewType = :reviewType " +
           "AND r.overallRating >= 4 AND r.isHidden = false AND LENGTH(r.comment) > 50 " +
           "ORDER BY r.overallRating DESC, r.createdAt DESC")
    Page<Review> findTopReviews(@Param("targetId") Long targetId,
                               @Param("reviewType") ReviewType reviewType,
                               Pageable pageable);
    
    // Reviews của restaurants thuộc sở hữu của một user
    @Query("SELECT r FROM Review r JOIN r.order o JOIN o.restaurant rest " +
           "WHERE rest.owner = :owner AND r.reviewType = 'RESTAURANT' AND r.isHidden = false " +
           "ORDER BY r.createdAt DESC")
    Page<Review> findReviewsForOwnerRestaurants(@Param("owner") User owner, Pageable pageable);
    
    // Thống kê reviews theo tháng
    @Query("SELECT EXTRACT(MONTH FROM r.createdAt) as month, COUNT(r) as count, AVG(r.overallRating) as avgRating " +
           "FROM Review r WHERE r.targetId = :targetId AND r.reviewType = :reviewType " +
           "AND r.createdAt >= :startDate AND r.isHidden = false " +
           "GROUP BY EXTRACT(MONTH FROM r.createdAt) ORDER BY month")
    List<Object[]> findMonthlyReviewStatistics(@Param("targetId") Long targetId,
                                              @Param("reviewType") ReviewType reviewType,
                                              @Param("startDate") LocalDateTime startDate);
    
    // Reviews có thể chỉnh sửa được (trong deadline)
    @Query("SELECT r FROM Review r WHERE r.reviewer = :reviewer AND r.editDeadline > :now " +
           "AND r.isHidden = false ORDER BY r.createdAt DESC")
    List<Review> findEditableReviewsByReviewer(@Param("reviewer") User reviewer, 
                                              @Param("now") LocalDateTime now);
    
    // Xóa reviews cũ đã hết hạn chỉnh sửa (cleanup job)
    @Query("SELECT r FROM Review r WHERE r.editDeadline < :cutoffDate AND r.isEdited = false")
    List<Review> findExpiredReviews(@Param("cutoffDate") LocalDateTime cutoffDate);
    
    // Reviews có hình ảnh
    @Query("SELECT r FROM Review r WHERE r.targetId = :targetId AND r.reviewType = :reviewType " +
           "AND SIZE(r.imageUrls) > 0 AND r.isHidden = false ORDER BY r.createdAt DESC")
    Page<Review> findReviewsWithImages(@Param("targetId") Long targetId,
                                      @Param("reviewType") ReviewType reviewType,
                                      Pageable pageable);
    
    // Đếm total reviews cho một target
    @Query("SELECT COUNT(r) FROM Review r WHERE r.targetId = :targetId AND r.reviewType = :reviewType " +
           "AND r.isHidden = false")
    Long countByTargetIdAndReviewTypeAndIsHiddenFalse(@Param("targetId") Long targetId, 
                                                     @Param("reviewType") ReviewType reviewType);
                                                     
    // Additional methods for review validation
    @Query("SELECT r FROM Review r WHERE r.reviewer.id = :userId AND r.targetId = :restaurantId AND r.reviewType = :reviewType")
    Optional<Review> findByUserIdAndRestaurantIdAndReviewType(@Param("userId") Long userId, @Param("restaurantId") Long restaurantId, @Param("reviewType") ReviewType reviewType);
    
    @Query("SELECT r FROM Review r WHERE r.reviewer.id = :userId AND r.targetId = :menuItemId AND r.reviewType = :reviewType")
    Optional<Review> findByUserIdAndMenuItemIdAndReviewType(@Param("userId") Long userId, @Param("menuItemId") Long menuItemId, @Param("reviewType") ReviewType reviewType);
    
    @Query("SELECT r FROM Review r WHERE r.reviewer.id = :userId AND r.order.id = :orderId AND r.reviewType = :reviewType")
    Optional<Review> findByUserIdAndOrderIdAndReviewType(@Param("userId") Long userId, @Param("orderId") Long orderId, @Param("reviewType") ReviewType reviewType);
    
    // Non-paginated methods for simplified responses
    List<Review> findByTargetIdAndReviewTypeAndIsHiddenFalseOrderByCreatedAtDesc(Long targetId, ReviewType reviewType);
    
    List<Review> findByReviewerAndIsHiddenFalseOrderByCreatedAtDesc(User reviewer);
}