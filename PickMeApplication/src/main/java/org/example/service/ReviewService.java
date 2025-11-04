package org.example.service;

import org.example.dto.request.*;

import org.example.dto.response.ReviewListResponse;
import org.example.dto.response.ReviewResponse;
import org.example.dto.response.ReviewStatisticsResponse;
import org.example.entity.*;
import org.example.exception.BusinessException;
import org.example.exception.ResourceNotFoundException;
import org.example.exception.UnauthorizedException;
import org.example.repository.*;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;




import java.util.List;

import java.util.stream.Collectors;

@Service
@Transactional
public class ReviewService {
    
    @Autowired
    private ReviewRepository reviewRepository;
    
    @Autowired
    private DetailedRatingRepository detailedRatingRepository;
    
    @Autowired
    private ReviewStatisticsRepository reviewStatisticsRepository;
    
    @Autowired
    private ReviewValidationService reviewValidationService;
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private RestaurantRepository restaurantRepository;
    
    @Autowired
    private MenuItemRepository menuItemRepository;
    
    // Create Restaurant Review
    public ReviewResponse createRestaurantReview(Long restaurantId, CreateRestaurantReviewRequest request) {
        User customer = getCurrentUser();
        validateCustomerRole(customer);
        
        // Basic validation
        reviewValidationService.validateRestaurantReview(
                customer.getId(), restaurantId, request.getComment(), request.getOverallRating());
        
        Order order = validateOrderForReview(request.getOrderId(), customer);
        validateRestaurantOrder(order, restaurantId);
        validateNoExistingRestaurantReview(customer, restaurantId);
        
        Review review = new Review(customer, order, ReviewType.RESTAURANT, restaurantId, 
                                  request.getOverallRating(), request.getComment());
        
        // Set image URLs if provided
        if (request.getImageUrls() != null) {
            review.setImageUrls(request.getImageUrls());
        }
        
        review = reviewRepository.save(review);
        
        // Update restaurant rating
        updateRestaurantRating(restaurantId);
        
        return convertToReviewResponse(review);
    }
    
    // Create Menu Item Review
    public ReviewResponse createMenuItemReview(Long menuItemId, CreateMenuItemReviewRequest request) {
        User customer = getCurrentUser();
        validateCustomerRole(customer);
        
        // Basic validation
        reviewValidationService.validateMenuItemReview(
                customer.getId(), menuItemId, request.getComment(), request.getOverallRating());
        
        Order order = validateOrderForReview(request.getOrderId(), customer);
        validateMenuItemInOrder(order, request.getMenuItemId(), menuItemId);
        
        Review review = new Review(customer, order, ReviewType.MENU_ITEM, menuItemId,
                                  request.getOverallRating(), request.getComment());
        
        // Set image URLs if provided
        if (request.getImageUrls() != null) {
            review.setImageUrls(request.getImageUrls());
        }
        
        review = reviewRepository.save(review);
        
        // Update menu item rating
        updateMenuItemRating(menuItemId);
        
        return convertToReviewResponse(review);
    }
    
    // Create Order Experience Review
    public ReviewResponse createOrderExperienceReview(CreateOrderExperienceReviewRequest request) {
        User customer = getCurrentUser();
        validateCustomerRole(customer);
        
        Order order = validateOrderForReview(request.getOrderId(), customer);
        validateNoExistingOrderExperienceReview(customer, request.getOrderId());
        
        Review review = new Review(customer, order, ReviewType.ORDER_EXPERIENCE, request.getOrderId(),
                                  request.getOverallRating(), request.getComment());
        
        // Set image URLs if provided
        if (request.getImageUrls() != null) {
            review.setImageUrls(request.getImageUrls());
        }
        
        review = reviewRepository.save(review);
        
        return convertToReviewResponse(review);
    }
    
    // Update Review
    public ReviewResponse updateReview(Long reviewId, UpdateReviewRequest request) {
        User currentUser = getCurrentUser();
        Review review = getReviewById(reviewId);
        
        validateReviewOwner(review, currentUser);
        validateReviewCanBeEdited(review);
        
        // Update basic fields
        if (request.getOverallRating() != null) {
            review.setOverallRating(request.getOverallRating());
        }
        if (request.getComment() != null) {
            review.setComment(request.getComment());
        }
        if (request.getImageUrls() != null) {
            review.setImageUrls(request.getImageUrls());
        }
        
        review.setIsEdited(true);
        review = reviewRepository.save(review);
        
        // Update rating after review update
        if (review.getReviewType() == ReviewType.RESTAURANT) {
            updateRestaurantRating(review.getTargetId());
        } else if (review.getReviewType() == ReviewType.MENU_ITEM) {
            updateMenuItemRating(review.getTargetId());
        }
        
        return convertToReviewResponse(review);
    }
    
    // Delete Review
    public void deleteReview(Long reviewId) {
        User currentUser = getCurrentUser();
        Review review = getReviewById(reviewId);
        
        validateReviewOwner(review, currentUser);
        validateReviewCanBeDeleted(review);
        
        // Store values before deletion
        ReviewType reviewType = review.getReviewType();
        Long targetId = review.getTargetId();
        
        // Delete detailed rating if exists
        detailedRatingRepository.findByReview(review).ifPresent(detailedRatingRepository::delete);
        
        // Delete review
        reviewRepository.delete(review);
        
        // Update rating after review deletion
        if (reviewType == ReviewType.RESTAURANT) {
            updateRestaurantRating(targetId);
        } else if (reviewType == ReviewType.MENU_ITEM) {
            updateMenuItemRating(targetId);
        }
    }
    
    // Add Owner Response
    public ReviewResponse addOwnerResponse(Long reviewId, OwnerResponseRequest request) {
        User owner = getCurrentUser();
        validateRestaurantOwnerRole(owner);
        
        Review review = getReviewById(reviewId);
        validateOwnerCanRespond(review, owner);
        
        review.addOwnerResponse(owner, request.getResponse());
        review = reviewRepository.save(review);
        
        return convertToReviewResponse(review);
    }
    
    // Update Owner Response
    public ReviewResponse updateOwnerResponse(Long reviewId, OwnerResponseRequest request) {
        User owner = getCurrentUser();
        Review review = getReviewById(reviewId);
        
        validateOwnerCanUpdateResponse(review, owner);
        
        review.updateOwnerResponse(owner, request.getResponse());
        review = reviewRepository.save(review);
        
        return convertToReviewResponse(review);
    }
    
    // Delete Owner Response
    public void deleteOwnerResponse(Long reviewId) {
        User owner = getCurrentUser();
        Review review = getReviewById(reviewId);
        
        validateOwnerCanUpdateResponse(review, owner);
        
        review.removeOwnerResponse(owner);
        reviewRepository.save(review);
    }
    
    // Get Reviews for Restaurant
    @Transactional(readOnly = true)
    public ReviewListResponse getRestaurantReviews(Long restaurantId) {
        List<Review> reviews = reviewRepository.findByTargetIdAndReviewTypeAndIsHiddenFalseOrderByCreatedAtDesc(
            restaurantId, ReviewType.RESTAURANT);
        
        List<ReviewResponse> reviewResponses = reviews.stream()
            .map(this::convertToReviewResponse)
            .collect(Collectors.toList());
        
        // Get statistics
        ReviewStatisticsResponse statistics = getReviewStatistics(restaurantId, ReviewType.RESTAURANT);
        
        return new ReviewListResponse(reviewResponses, 
            statistics.getAverageRating().doubleValue(), 
            statistics.getTotalReviews().intValue());
    }
    
    // Get Reviews for Menu Item
    @Transactional(readOnly = true)
    public ReviewListResponse getMenuItemReviews(Long menuItemId) {
        List<Review> reviews = reviewRepository.findByTargetIdAndReviewTypeAndIsHiddenFalseOrderByCreatedAtDesc(
            menuItemId, ReviewType.MENU_ITEM);
        
        List<ReviewResponse> reviewResponses = reviews.stream()
            .map(this::convertToReviewResponse)
            .collect(Collectors.toList());
        
        // Get statistics
        ReviewStatisticsResponse statistics = getReviewStatistics(menuItemId, ReviewType.MENU_ITEM);
        
        return new ReviewListResponse(reviewResponses,
            statistics.getAverageRating().doubleValue(),
            statistics.getTotalReviews().intValue());
    }
    
    // Get My Reviews
    @Transactional(readOnly = true)
    public ReviewListResponse getMyReviews() {
        User customer = getCurrentUser();
        List<Review> reviews = reviewRepository.findByReviewerAndIsHiddenFalseOrderByCreatedAtDesc(customer);
        
        List<ReviewResponse> reviewResponses = reviews.stream()
            .map(this::convertToReviewResponse)
            .collect(Collectors.toList());
        
        return new ReviewListResponse(reviewResponses, 0.0, reviews.size());
    }
    
    // Get Review Statistics
    @Transactional(readOnly = true)
    public ReviewStatisticsResponse getReviewStatistics(Long targetId, ReviewType reviewType) {
        // Calculate statistics directly from reviews for simplified approach
        List<Review> reviews = reviewRepository.findByTargetIdAndReviewTypeAndIsHiddenFalse(targetId, reviewType);
        
        if (reviews.isEmpty()) {
            // Create empty statistics
            ReviewStatistics newStats = new ReviewStatistics(targetId, reviewType);
            return convertToReviewStatisticsResponse(newStats);
        }
        
        // Calculate average rating
        double averageRating = reviews.stream()
            .mapToInt(Review::getOverallRating)
            .average()
            .orElse(0.0);
        
        // Create simple statistics response
        ReviewStatisticsResponse response = new ReviewStatisticsResponse();
        response.setTargetId(targetId);
        response.setTargetType(reviewType);
        response.setAverageRating(averageRating);
        response.setTotalReviews(reviews.size());
        
        return response;
    }
    
    // Admin: Hide Review
    public void hideReview(Long reviewId, String reason) {
        User admin = getCurrentUser();
        validateAdminRole(admin);
        
        Review review = getReviewById(reviewId);
        review.hide(admin, reason);
        reviewRepository.save(review);
    }
    
    // Admin: Unhide Review
    public void unhideReview(Long reviewId) {
        User admin = getCurrentUser();
        validateAdminRole(admin);
        
        Review review = getReviewById(reviewId);
        review.unhide(admin);
        reviewRepository.save(review);
    }
    
    // Validation Methods
    private Order validateOrderForReview(Long orderId, User customer) {
        Order order = orderRepository.findById(orderId)
            .orElseThrow(() -> new ResourceNotFoundException("Order not found"));
        
        if (!order.getCustomer().getId().equals(customer.getId())) {
            throw new UnauthorizedException("Can only review your own orders");
        }
        
        if (!order.getStatus().equals(Order.OrderStatus.COMPLETED) && 
            !order.getStatus().equals(Order.OrderStatus.PICKED_UP)) {
            throw new BusinessException("Can only review completed orders");
        }
        
        return order;
    }
    
    private void validateRestaurantOrder(Order order, Long restaurantId) {
        if (!order.getRestaurant().getId().equals(restaurantId)) {
            throw new BusinessException("Order is not from this restaurant");
        }
    }
    
    private void validateMenuItemInOrder(Order order, Long requestMenuItemId, Long pathMenuItemId) {
        if (!requestMenuItemId.equals(pathMenuItemId)) {
            throw new BusinessException("Menu item ID in request does not match path parameter");
        }
        
        boolean hasMenuItem = order.getOrderItems().stream()
            .anyMatch(item -> item.getMenuItem().getId().equals(requestMenuItemId));
        
        if (!hasMenuItem) {
            throw new BusinessException("Menu item was not ordered in this order");
        }
    }
    
    private void validateNoExistingRestaurantReview(User customer, Long restaurantId) {
        if (reviewRepository.existsByReviewerAndTargetIdAndReviewType(customer, restaurantId, ReviewType.RESTAURANT)) {
            throw new BusinessException("You have already reviewed this restaurant");
        }
    }
    
    private void validateNoExistingOrderExperienceReview(User customer, Long orderId) {
        if (reviewRepository.existsByReviewerAndTargetIdAndReviewType(customer, orderId, ReviewType.ORDER_EXPERIENCE)) {
            throw new BusinessException("You have already reviewed this order experience");
        }
    }
    
    private void validateCustomerRole(User user) {
        if (!user.getRole().equals(Role.CUSTOMER)) {
            throw new UnauthorizedException("Only customers can create reviews");
        }
    }
    
    private void validateRestaurantOwnerRole(User user) {
        if (!user.getRole().equals(Role.RESTAURANT_OWNER)) {
            throw new UnauthorizedException("Only restaurant owners can respond to reviews");
        }
    }
    
    private void validateAdminRole(User user) {
        if (!user.getRole().equals(Role.ADMIN)) {
            throw new UnauthorizedException("Only admins can perform this action");
        }
    }
    
    private void validateReviewOwner(Review review, User user) {
        if (!review.getReviewer().getId().equals(user.getId())) {
            throw new UnauthorizedException("Can only modify your own reviews");
        }
    }
    
    private void validateReviewCanBeEdited(Review review) {
        if (!review.canBeEdited()) {
            throw new BusinessException("Review cannot be edited after deadline or when hidden");
        }
    }
    
    private void validateReviewCanBeDeleted(Review review) {
        if (!review.canBeDeletedByOwner()) {
            throw new BusinessException("Review cannot be deleted after deadline or when hidden");
        }
    }
    
    private void validateOwnerCanRespond(Review review, User owner) {
        if (review.getReviewType() != ReviewType.RESTAURANT && 
            review.getReviewType() != ReviewType.ORDER_EXPERIENCE) {
            throw new BusinessException("Can only respond to restaurant or order experience reviews");
        }
        
        if (review.getReviewType() == ReviewType.RESTAURANT) {
            Restaurant restaurant = restaurantRepository.findById(review.getTargetId())
                .orElseThrow(() -> new ResourceNotFoundException("Restaurant not found"));
            if (!restaurant.getOwner().getId().equals(owner.getId())) {
                throw new UnauthorizedException("Can only respond to reviews of your restaurant");
            }
        } else if (review.getReviewType() == ReviewType.ORDER_EXPERIENCE) {
            Restaurant restaurant = review.getOrder().getRestaurant();
            if (!restaurant.getOwner().getId().equals(owner.getId())) {
                throw new UnauthorizedException("Can only respond to reviews of your restaurant's orders");
            }
        }
    }
    
    private void validateOwnerCanUpdateResponse(Review review, User owner) {
        validateOwnerCanRespond(review, owner);
        
        if (review.getRespondedBy() == null || !review.getRespondedBy().getId().equals(owner.getId())) {
            throw new UnauthorizedException("Can only update your own responses");
        }
    }
    
    // Utility Methods
    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName();
        return userRepository.findByEmail(email)
            .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }
    
    private Review getReviewById(Long reviewId) {
        return reviewRepository.findById(reviewId)
            .orElseThrow(() -> new ResourceNotFoundException("Review not found"));
    }
    
    // COMMENTED OUT - Currently not used due to simplified reviews
    // private boolean hasDetailedRatings(CreateOrderExperienceReviewRequest request) {
    //     return request.getFoodQualityRating() != null || 
    //            request.getServiceRating() != null ||
    //            request.getDeliveryTimeRating() != null ||
    //            request.getPackagingRating() != null ||
    //            request.getValueForMoneyRating() != null ||
    //            request.getOrderAccuracyRating() != null;
    // }
    
    // Update Restaurant Rating (Simple approach)
    private void updateRestaurantRating(Long restaurantId) {
        List<Review> reviews = reviewRepository.findByTargetIdAndReviewTypeAndIsHiddenFalse(restaurantId, ReviewType.RESTAURANT);
        if (!reviews.isEmpty()) {
            double averageRating = reviews.stream()
                .mapToInt(Review::getOverallRating)
                .average()
                .orElse(0.0);
            
            Restaurant restaurant = restaurantRepository.findById(restaurantId).orElse(null);
            if (restaurant != null) {
                restaurant.setRating(averageRating);
                restaurant.setTotalReviews(reviews.size());
                restaurantRepository.save(restaurant);
            }
        }
    }
    
    // Update Menu Item Rating (Simple approach)  
    private void updateMenuItemRating(Long menuItemId) {
        List<Review> reviews = reviewRepository.findByTargetIdAndReviewTypeAndIsHiddenFalse(menuItemId, ReviewType.MENU_ITEM);
        if (!reviews.isEmpty()) {
            double averageRating = reviews.stream()
                .mapToInt(Review::getOverallRating)
                .average()
                .orElse(0.0);
            
            MenuItem menuItem = menuItemRepository.findById(menuItemId).orElse(null);
            if (menuItem != null) {
                menuItem.setAverageRating(averageRating);
                menuItem.setTotalReviews(reviews.size());
                menuItemRepository.save(menuItem);
            }
        }
    }

    /*
    // COMMENTED OUT - Currently not used due to simplified reviews
    
    private boolean hasDetailedRatingsInUpdate(UpdateReviewRequest request) {
        return request.getFoodQualityRating() != null ||
               request.getServiceRating() != null ||
               request.getDeliveryTimeRating() != null ||
               request.getPackagingRating() != null ||
               request.getValueForMoneyRating() != null ||
               request.getOrderAccuracyRating() != null;
    }
    
    private void updateDetailedRating(Review review, UpdateReviewRequest request) {
        Optional<DetailedRating> existingRating = detailedRatingRepository.findByReview(review);
        
        DetailedRating detailedRating;
        if (existingRating.isPresent()) {
            detailedRating = existingRating.get();
        } else {
            detailedRating = new DetailedRating(review);
        }
        
        if (request.getFoodQualityRating() != null) {
            detailedRating.setFoodQualityRating(request.getFoodQualityRating());
        }
        if (request.getServiceRating() != null) {
            detailedRating.setServiceRating(request.getServiceRating());
        }
        if (request.getDeliveryTimeRating() != null) {
            detailedRating.setDeliveryTimeRating(request.getDeliveryTimeRating());
        }
        if (request.getPackagingRating() != null) {
            detailedRating.setPackagingRating(request.getPackagingRating());
        }
        if (request.getValueForMoneyRating() != null) {
            detailedRating.setValueForMoneyRating(request.getValueForMoneyRating());
        }
        if (request.getOrderAccuracyRating() != null) {
            detailedRating.setOrderAccuracyRating(request.getOrderAccuracyRating());
        }
        
        detailedRatingRepository.save(detailedRating);
    }
    
    // Async Rating Update Methods (will be implemented with @Async in future)
    private void updateRestaurantRatingAsync(Long restaurantId) {
        updateRatingStatisticsForReviewAddition(restaurantId, ReviewType.RESTAURANT, null);
    }
    
    private void updateMenuItemRatingAsync(Long menuItemId) {
        updateRatingStatisticsForReviewAddition(menuItemId, ReviewType.MENU_ITEM, null);
    }
    
    private void updateRestaurantOrderExperienceRatingAsync(Long restaurantId) {
        // This would update detailed statistics for order experience
        // Implementation depends on how we want to aggregate order experience ratings per restaurant
    }
    
    private void updateRatingStatisticsForReviewAddition(Long targetId, ReviewType reviewType, Integer rating) {
        ReviewStatistics stats = reviewStatisticsRepository.findByTargetIdAndTargetType(targetId, reviewType)
            .orElse(new ReviewStatistics(targetId, reviewType));
        
        if (rating != null) {
            stats.addReview(rating);
        }
        
        reviewStatisticsRepository.save(stats);
    }
    
    private void updateRatingStatisticsForReviewDeletion(Long targetId, ReviewType reviewType, Integer rating) {
        ReviewStatistics stats = reviewStatisticsRepository.findByTargetIdAndTargetType(targetId, reviewType)
            .orElse(new ReviewStatistics(targetId, reviewType));
        
        stats.removeReview(rating);
        reviewStatisticsRepository.save(stats);
    }
    
    private void updateRatingStatisticsForReviewUpdate(Review review, Integer oldRating, Integer newRating) {
        ReviewStatistics stats = reviewStatisticsRepository.findByTargetIdAndTargetType(
            review.getTargetId(), review.getReviewType())
            .orElse(new ReviewStatistics(review.getTargetId(), review.getReviewType()));
        
        stats.updateReview(oldRating, newRating);
        reviewStatisticsRepository.save(stats);
    }
    */
    
    // Conversion Methods
    private ReviewResponse convertToReviewResponse(Review review) {
        // Get restaurant info from order
        Long restaurantId = null;
        String restaurantName = null;
        
        if (review.getOrder() != null && review.getOrder().getRestaurant() != null) {
            restaurantId = review.getOrder().getRestaurant().getId();
            restaurantName = review.getOrder().getRestaurant().getName();
        } else if (review.getReviewType() == ReviewType.RESTAURANT) {
            // For restaurant reviews, targetId is restaurantId
            restaurantId = review.getTargetId();
            Restaurant restaurant = restaurantRepository.findById(restaurantId).orElse(null);
            if (restaurant != null) {
                restaurantName = restaurant.getName();
            }
        }
        
        return new ReviewResponse(
            review.getId(),
            review.getReviewer().getFullName(),
            review.getReviewType(),
            review.getOverallRating(),
            review.getComment(),
            review.getOwnerResponse(),
            review.getCreatedAt(),
            restaurantId,
            restaurantName,
            review.getImageUrls()
        );
    }
    
    /*
    // COMMENTED OUT - Currently not used due to simplified reviews
    private DetailedRatingResponse convertToDetailedRatingResponse(DetailedRating detailedRating) {
        DetailedRatingResponse response = new DetailedRatingResponse();
        response.setId(detailedRating.getId());
        response.setReviewId(detailedRating.getReview().getId());
        response.setFoodQualityRating(detailedRating.getFoodQualityRating());
        response.setServiceRating(detailedRating.getServiceRating());
        response.setDeliveryTimeRating(detailedRating.getDeliveryTimeRating());
        response.setPackagingRating(detailedRating.getPackagingRating());
        response.setValueForMoneyRating(detailedRating.getValueForMoneyRating());
        response.setOrderAccuracyRating(detailedRating.getOrderAccuracyRating());
        response.setAverageRating(detailedRating.calculateAverageRating());
        response.setCompletedRatingsCount(detailedRating.getCompletedRatingsCount());
        response.setHasAllRatings(detailedRating.hasAllRatings());
        response.setBestAspect(detailedRating.getBestAspect());
        response.setWorstAspect(detailedRating.getWorstAspect());
        response.setCreatedAt(detailedRating.getCreatedAt());
        response.setUpdatedAt(detailedRating.getUpdatedAt());
        return response;
    }
    */
    
    private ReviewStatisticsResponse convertToReviewStatisticsResponse(ReviewStatistics stats) {
        ReviewStatisticsResponse response = new ReviewStatisticsResponse();
        response.setId(stats.getId());
        response.setTargetId(stats.getTargetId());
        response.setTargetType(stats.getTargetType());
        response.setAverageRating(stats.getAverageRating());
        response.setTotalReviews(stats.getTotalReviews());
        response.setFiveStarCount(stats.getFiveStarCount());
        response.setFourStarCount(stats.getFourStarCount());
        response.setThreeStarCount(stats.getThreeStarCount());
        response.setTwoStarCount(stats.getTwoStarCount());
        response.setOneStarCount(stats.getOneStarCount());
        response.setRatingDistribution(stats.getRatingDistribution());
        response.setRatingDistributionPercentage(stats.getRatingDistributionPercentage());
        response.setMostCommonRating(stats.getMostCommonRating());
        response.setSatisfactionRate(stats.getSatisfactionRate());
        response.setAvgFoodQuality(stats.getAvgFoodQuality());
        response.setAvgService(stats.getAvgService());
        response.setAvgDeliveryTime(stats.getAvgDeliveryTime());
        response.setAvgPackaging(stats.getAvgPackaging());
        response.setAvgValueForMoney(stats.getAvgValueForMoney());
        response.setAvgOrderAccuracy(stats.getAvgOrderAccuracy());
        response.setRatingTrend7Days(stats.getRatingTrend7Days());
        response.setRatingTrend30Days(stats.getRatingTrend30Days());
        response.setReviewsLast7Days(stats.getReviewsLast7Days());
        response.setReviewsLast30Days(stats.getReviewsLast30Days());
        response.setIsPositiveTrend(stats.isPositiveTrend());
        response.setIsNegativeTrend(stats.isNegativeTrend());
        response.setLastUpdated(stats.getLastUpdated());
        response.setCreatedAt(stats.getCreatedAt());
        return response;
    }
}