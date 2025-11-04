package org.example.service;

import org.example.entity.*;
import org.example.exception.BusinessException;
import org.example.repository.OrderRepository;
import org.example.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;

/**
 * Service for validating review business rules and eligibility
 */
@Service
public class ReviewValidationService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private ReviewRepository reviewRepository;

    // Business rules constants
    private static final int REVIEW_WINDOW_DAYS = 30; // Days after order completion to allow reviews
    private static final int EDIT_WINDOW_HOURS = 24; // Hours after review creation to allow edits
    private static final int MIN_REVIEW_LENGTH = 10;
    private static final int MAX_REVIEW_LENGTH = 1000;

    /**
     * Validates if user can create a restaurant review
     */
    public void validateRestaurantReview(Long userId, Long restaurantId, String content, Integer rating) {
        // Basic validation
        validateReviewContent(content);
        validateRating(rating);

        // Check if user has completed orders from this restaurant
        List<Order> completedOrders = orderRepository.findByUserIdAndRestaurantIdAndStatus(
                userId, restaurantId, Order.OrderStatus.COMPLETED);
        
        if (completedOrders.isEmpty()) {
            throw new BusinessException("Bạn chỉ có thể đánh giá nhà hàng sau khi đã hoàn thành đơn hàng");
        }

        // Check if user already reviewed this restaurant
        Optional<Review> existingReview = reviewRepository.findByUserIdAndRestaurantIdAndReviewType(
                userId, restaurantId, ReviewType.RESTAURANT);
        
        if (existingReview.isPresent()) {
            throw new BusinessException("Bạn đã đánh giá nhà hàng này rồi");
        }

        // Check review window (within 30 days of last order)
        LocalDateTime latestOrderTime = completedOrders.stream()
                .map(Order::getCreatedAt)
                .max(LocalDateTime::compareTo)
                .orElseThrow();

        if (ChronoUnit.DAYS.between(latestOrderTime, LocalDateTime.now()) > REVIEW_WINDOW_DAYS) {
            throw new BusinessException("Thời gian đánh giá đã hết hạn (30 ngày sau khi hoàn thành đơn hàng)");
        }
    }

    /**
     * Validates if user can create a menu item review
     */
    public void validateMenuItemReview(Long userId, Long menuItemId, String content, Integer rating) {
        // Basic validation
        validateReviewContent(content);
        validateRating(rating);

        // Check if user has ordered this menu item
        List<Order> ordersWithItem = orderRepository.findOrdersWithMenuItem(userId, menuItemId, Order.OrderStatus.COMPLETED);
        
        if (ordersWithItem.isEmpty()) {
            throw new BusinessException("Bạn chỉ có thể đánh giá món ăn sau khi đã đặt và nhận hàng");
        }

        // Check if user already reviewed this menu item
        Optional<Review> existingReview = reviewRepository.findByUserIdAndMenuItemIdAndReviewType(
                userId, menuItemId, ReviewType.MENU_ITEM);
        
        if (existingReview.isPresent()) {
            throw new BusinessException("Bạn đã đánh giá món ăn này rồi");
        }

        // Check review window
        LocalDateTime latestOrderTime = ordersWithItem.stream()
                .map(Order::getCreatedAt)
                .max(LocalDateTime::compareTo)
                .orElseThrow();

        if (ChronoUnit.DAYS.between(latestOrderTime, LocalDateTime.now()) > REVIEW_WINDOW_DAYS) {
            throw new BusinessException("Thời gian đánh giá đã hết hạn (30 ngày sau khi hoàn thành đơn hàng)");
        }
    }

    /**
     * Validates if user can create an order review
     */
    public void validateOrderReview(Long userId, Long orderId, String content, Integer rating) {
        // Basic validation
        validateReviewContent(content);
        validateRating(rating);

        // Check if order exists and belongs to user
        Order order = orderRepository.findByIdAndUserId(orderId, userId)
                .orElseThrow(() -> new BusinessException("Đơn hàng không tồn tại hoặc không thuộc về bạn"));

        // Check if order is completed
        if (order.getStatus() != Order.OrderStatus.COMPLETED) {
            throw new BusinessException("Chỉ có thể đánh giá đơn hàng đã hoàn thành");
        }

        // Check if user already reviewed this order
        Optional<Review> existingReview = reviewRepository.findByUserIdAndOrderIdAndReviewType(
                userId, orderId, ReviewType.ORDER_EXPERIENCE);
        
        if (existingReview.isPresent()) {
            throw new BusinessException("Bạn đã đánh giá đơn hàng này rồi");
        }

        // Check review window
        if (ChronoUnit.DAYS.between(order.getCreatedAt(), LocalDateTime.now()) > REVIEW_WINDOW_DAYS) {
            throw new BusinessException("Thời gian đánh giá đã hết hạn (30 ngày sau khi hoàn thành đơn hàng)");
        }
    }

    /**
     * Validates if user can edit a review
     */
    public void validateReviewEdit(Long userId, Long reviewId, String newContent, Integer newRating) {
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new BusinessException("Đánh giá không tồn tại"));

        // Check ownership
        if (!review.getReviewer().getId().equals(userId)) {
            throw new BusinessException("Bạn không có quyền chỉnh sửa đánh giá này");
        }

        // Check if review is still editable (within 24 hours)
        if (ChronoUnit.HOURS.between(review.getCreatedAt(), LocalDateTime.now()) > EDIT_WINDOW_HOURS) {
            throw new BusinessException("Không thể chỉnh sửa đánh giá sau 24 giờ");
        }

        // Validate new content and rating
        if (newContent != null) {
            validateReviewContent(newContent);
        }
        if (newRating != null) {
            validateRating(newRating);
        }
    }

    /**
     * Validates if restaurant owner can respond to a review
     */
    public void validateOwnerResponse(Long ownerId, Long reviewId, String response) {
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new BusinessException("Đánh giá không tồn tại"));

        // Check if owner owns the restaurant being reviewed
        Restaurant restaurant = review.getOrder().getRestaurant();
        if (restaurant == null || !restaurant.getOwner().getId().equals(ownerId)) {
            throw new BusinessException("Bạn chỉ có thể phản hồi đánh giá của nhà hàng mình quản lý");
        }

        // Check if already responded
        if (review.getOwnerResponse() != null && !review.getOwnerResponse().trim().isEmpty()) {
            throw new BusinessException("Bạn đã phản hồi đánh giá này rồi");
        }

        // Validate response content
        if (response == null || response.trim().isEmpty()) {
            throw new BusinessException("Nội dung phản hồi không được để trống");
        }

        if (response.length() > MAX_REVIEW_LENGTH) {
            throw new BusinessException("Phản hồi không được vượt quá " + MAX_REVIEW_LENGTH + " ký tự");
        }
    }

    /**
     * Validates review content
     */
    private void validateReviewContent(String content) {
        if (content == null || content.trim().isEmpty()) {
            throw new BusinessException("Nội dung đánh giá không được để trống");
        }

        if (content.trim().length() < MIN_REVIEW_LENGTH) {
            throw new BusinessException("Nội dung đánh giá phải có ít nhất " + MIN_REVIEW_LENGTH + " ký tự");
        }

        if (content.length() > MAX_REVIEW_LENGTH) {
            throw new BusinessException("Nội dung đánh giá không được vượt quá " + MAX_REVIEW_LENGTH + " ký tự");
        }

        // Check for inappropriate content (basic check)
        String lowerContent = content.toLowerCase();
        if (containsInappropriateContent(lowerContent)) {
            throw new BusinessException("Nội dung đánh giá chứa từ ngữ không phù hợp");
        }
    }

    /**
     * Validates rating value
     */
    private void validateRating(Integer rating) {
        if (rating == null) {
            throw new BusinessException("Đánh giá sao là bắt buộc");
        }

        if (rating < 1 || rating > 5) {
            throw new BusinessException("Đánh giá sao phải từ 1 đến 5");
        }
    }

    /**
     * Basic inappropriate content detection
     */
    private boolean containsInappropriateContent(String content) {
        // Simple list of inappropriate words - should be expanded and moved to configuration
        String[] inappropriateWords = {
            "spam", "fake", "scam", "cheat", "fraud"
            // Add more inappropriate words as needed
        };

        for (String word : inappropriateWords) {
            if (content.contains(word)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Checks if user is eligible to review a restaurant
     */
    public boolean isEligibleToReviewRestaurant(Long userId, Long restaurantId) {
        try {
            // Check if user has completed orders
            List<Order> completedOrders = orderRepository.findByUserIdAndRestaurantIdAndStatus(
                    userId, restaurantId, Order.OrderStatus.COMPLETED);
            
            if (completedOrders.isEmpty()) {
                return false;
            }

            // Check if already reviewed
            Optional<Review> existingReview = reviewRepository.findByUserIdAndRestaurantIdAndReviewType(
                    userId, restaurantId, ReviewType.RESTAURANT);
            
            if (existingReview.isPresent()) {
                return false;
            }

            // Check time window
            LocalDateTime latestOrderTime = completedOrders.stream()
                    .map(Order::getCreatedAt)
                    .max(LocalDateTime::compareTo)
                    .orElse(LocalDateTime.MIN);

            return ChronoUnit.DAYS.between(latestOrderTime, LocalDateTime.now()) <= REVIEW_WINDOW_DAYS;

        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Checks if user is eligible to review a menu item
     */
    public boolean isEligibleToReviewMenuItem(Long userId, Long menuItemId) {
        try {
            // Check if user has ordered this item
            List<Order> ordersWithItem = orderRepository.findOrdersWithMenuItem(userId, menuItemId, Order.OrderStatus.COMPLETED);
            
            if (ordersWithItem.isEmpty()) {
                return false;
            }

            // Check if already reviewed
            Optional<Review> existingReview = reviewRepository.findByUserIdAndMenuItemIdAndReviewType(
                    userId, menuItemId, ReviewType.MENU_ITEM);
            
            if (existingReview.isPresent()) {
                return false;
            }

            // Check time window
            LocalDateTime latestOrderTime = ordersWithItem.stream()
                    .map(Order::getCreatedAt)
                    .max(LocalDateTime::compareTo)
                    .orElse(LocalDateTime.MIN);

            return ChronoUnit.DAYS.between(latestOrderTime, LocalDateTime.now()) <= REVIEW_WINDOW_DAYS;

        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Gets review eligibility details for a user and restaurant
     */
    public ReviewEligibilityInfo getReviewEligibility(Long userId, Long restaurantId) {
        ReviewEligibilityInfo info = new ReviewEligibilityInfo();
        
        try {
            // Check completed orders
            List<Order> completedOrders = orderRepository.findByUserIdAndRestaurantIdAndStatus(
                    userId, restaurantId, Order.OrderStatus.COMPLETED);
            
            info.setHasCompletedOrders(!completedOrders.isEmpty());
            
            if (!completedOrders.isEmpty()) {
                LocalDateTime latestOrderTime = completedOrders.stream()
                        .map(Order::getCreatedAt)
                        .max(LocalDateTime::compareTo)
                        .orElse(LocalDateTime.MIN);
                
                info.setLatestOrderTime(latestOrderTime);
                
                long daysElapsed = ChronoUnit.DAYS.between(latestOrderTime, LocalDateTime.now());
                info.setDaysElapsed((int) daysElapsed);
                info.setWithinReviewWindow(daysElapsed <= REVIEW_WINDOW_DAYS);
            }

            // Check existing review
            Optional<Review> existingReview = reviewRepository.findByUserIdAndRestaurantIdAndReviewType(
                    userId, restaurantId, ReviewType.RESTAURANT);
            
            info.setAlreadyReviewed(existingReview.isPresent());
            if (existingReview.isPresent()) {
                info.setExistingReviewId(existingReview.get().getId());
            }

            // Determine eligibility
            info.setEligible(info.isHasCompletedOrders() && !info.isAlreadyReviewed() && info.isWithinReviewWindow());

        } catch (Exception e) {
            info.setEligible(false);
            info.setError(e.getMessage());
        }

        return info;
    }

    /**
     * Inner class for review eligibility information
     */
    public static class ReviewEligibilityInfo {
        private boolean eligible;
        private boolean hasCompletedOrders;
        private boolean alreadyReviewed;
        private boolean withinReviewWindow;
        private LocalDateTime latestOrderTime;
        private int daysElapsed;
        private Long existingReviewId;
        private String error;

        // Getters and setters
        public boolean isEligible() { return eligible; }
        public void setEligible(boolean eligible) { this.eligible = eligible; }

        public boolean isHasCompletedOrders() { return hasCompletedOrders; }
        public void setHasCompletedOrders(boolean hasCompletedOrders) { this.hasCompletedOrders = hasCompletedOrders; }

        public boolean isAlreadyReviewed() { return alreadyReviewed; }
        public void setAlreadyReviewed(boolean alreadyReviewed) { this.alreadyReviewed = alreadyReviewed; }

        public boolean isWithinReviewWindow() { return withinReviewWindow; }
        public void setWithinReviewWindow(boolean withinReviewWindow) { this.withinReviewWindow = withinReviewWindow; }

        public LocalDateTime getLatestOrderTime() { return latestOrderTime; }
        public void setLatestOrderTime(LocalDateTime latestOrderTime) { this.latestOrderTime = latestOrderTime; }

        public int getDaysElapsed() { return daysElapsed; }
        public void setDaysElapsed(int daysElapsed) { this.daysElapsed = daysElapsed; }

        public Long getExistingReviewId() { return existingReviewId; }
        public void setExistingReviewId(Long existingReviewId) { this.existingReviewId = existingReviewId; }

        public String getError() { return error; }
        public void setError(String error) { this.error = error; }
    }
}