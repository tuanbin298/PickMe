package org.example.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.example.dto.request.*;
import org.example.dto.response.ReviewListResponse;
import org.example.dto.response.ReviewResponse;
import org.example.dto.response.ReviewStatisticsResponse;
import org.example.dto.response.ReviewEligibilityResponse;
import org.example.entity.ReviewType;
import org.example.entity.User;
import org.example.service.ReviewService;
import org.example.service.ReviewValidationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/reviews")
@Tag(name = "Review Management", description = "APIs for managing reviews and ratings")
@SecurityRequirement(name = "Bearer Authentication")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;
    
    @Autowired
    private ReviewValidationService reviewValidationService;

    // ==================== Customer Review APIs ====================

    @Operation(summary = "Create restaurant review", description = "Create a new review for a restaurant based on a completed order")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Review created successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid request data"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - not logged in"),
        @ApiResponse(responseCode = "403", description = "Forbidden - not a customer or already reviewed"),
        @ApiResponse(responseCode = "404", description = "Order or restaurant not found")
    })
    @PostMapping("/restaurant/{restaurantId}")
    @PreAuthorize("hasRole('CUSTOMER')")
    public ResponseEntity<ReviewResponse> createRestaurantReview(
            @Parameter(description = "Restaurant ID") @PathVariable Long restaurantId,
            @Valid @RequestBody CreateRestaurantReviewRequest request) {
        
        ReviewResponse review = reviewService.createRestaurantReview(restaurantId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(review);
    }

    @Operation(summary = "Create menu item review", description = "Create a new review for a specific menu item from a completed order")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Review created successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid request data"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - not logged in"),
        @ApiResponse(responseCode = "403", description = "Forbidden - not a customer"),
        @ApiResponse(responseCode = "404", description = "Order or menu item not found")
    })
    @PostMapping("/menu-item/{menuItemId}")
    @PreAuthorize("hasRole('CUSTOMER')")
    public ResponseEntity<ReviewResponse> createMenuItemReview(
            @Parameter(description = "Menu item ID") @PathVariable Long menuItemId,
            @Valid @RequestBody CreateMenuItemReviewRequest request) {
        
        ReviewResponse review = reviewService.createMenuItemReview(menuItemId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(review);
    }

    @Operation(summary = "Create order experience review", description = "Create a detailed review for the overall order experience")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Review created successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid request data"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - not logged in"),
        @ApiResponse(responseCode = "403", description = "Forbidden - not a customer or already reviewed"),
        @ApiResponse(responseCode = "404", description = "Order not found")
    })
    @PostMapping("/order-experience")
    @PreAuthorize("hasRole('CUSTOMER')")
    public ResponseEntity<ReviewResponse> createOrderExperienceReview(
            @Valid @RequestBody CreateOrderExperienceReviewRequest request) {
        
        ReviewResponse review = reviewService.createOrderExperienceReview(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(review);
    }

    @Operation(summary = "Update review", description = "Update an existing review within the editing deadline")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Review updated successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid request data"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - not logged in"),
        @ApiResponse(responseCode = "403", description = "Forbidden - not the review owner or deadline passed"),
        @ApiResponse(responseCode = "404", description = "Review not found")
    })
    @PutMapping("/{reviewId}")
    @PreAuthorize("hasRole('CUSTOMER')")
    public ResponseEntity<ReviewResponse> updateReview(
            @Parameter(description = "Review ID") @PathVariable Long reviewId,
            @Valid @RequestBody UpdateReviewRequest request) {
        
        ReviewResponse review = reviewService.updateReview(reviewId, request);
        return ResponseEntity.ok(review);
    }

    @Operation(summary = "Delete review", description = "Delete an existing review within the deletion deadline")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "204", description = "Review deleted successfully"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - not logged in"),
        @ApiResponse(responseCode = "403", description = "Forbidden - not the review owner or deadline passed"),
        @ApiResponse(responseCode = "404", description = "Review not found")
    })
    @DeleteMapping("/{reviewId}")
    @PreAuthorize("hasRole('CUSTOMER')")
    public ResponseEntity<Void> deleteReview(
            @Parameter(description = "Review ID") @PathVariable Long reviewId) {
        
        reviewService.deleteReview(reviewId);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Get my reviews", description = "Get all reviews created by the current customer")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Reviews retrieved successfully"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - not logged in")
    })
    @GetMapping("/my-reviews")
    @PreAuthorize("hasRole('CUSTOMER')")
    public ResponseEntity<ReviewListResponse> getMyReviews() {
        ReviewListResponse reviews = reviewService.getMyReviews();
        return ResponseEntity.ok(reviews);
    }

    // ==================== Public Review APIs ====================

    @Operation(summary = "Get restaurant reviews", description = "Get all public reviews for a restaurant")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Reviews retrieved successfully"),
        @ApiResponse(responseCode = "404", description = "Restaurant not found")
    })
    @GetMapping("/restaurant/{restaurantId}")
    public ResponseEntity<ReviewListResponse> getRestaurantReviews(
            @Parameter(description = "Restaurant ID") @PathVariable Long restaurantId) {
        
        ReviewListResponse reviews = reviewService.getRestaurantReviews(restaurantId);
        return ResponseEntity.ok(reviews);
    }

    @Operation(summary = "Get menu item reviews", description = "Get all public reviews for a menu item")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Reviews retrieved successfully"),
        @ApiResponse(responseCode = "404", description = "Menu item not found")
    })
    @GetMapping("/menu-item/{menuItemId}")
    public ResponseEntity<ReviewListResponse> getMenuItemReviews(
            @Parameter(description = "Menu item ID") @PathVariable Long menuItemId) {
        
        ReviewListResponse reviews = reviewService.getMenuItemReviews(menuItemId);
        return ResponseEntity.ok(reviews);
    }

    @Operation(summary = "Get review statistics", description = "Get aggregated rating statistics for a target (restaurant or menu item)")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Statistics retrieved successfully"),
        @ApiResponse(responseCode = "404", description = "Target not found")
    })
    @GetMapping("/statistics/{targetType}/{targetId}")
    public ResponseEntity<ReviewStatisticsResponse> getReviewStatistics(
            @Parameter(description = "Target type (RESTAURANT or MENU_ITEM)") @PathVariable ReviewType targetType,
            @Parameter(description = "Target ID") @PathVariable Long targetId) {
        
        ReviewStatisticsResponse statistics = reviewService.getReviewStatistics(targetId, targetType);
        return ResponseEntity.ok(statistics);
    }

    // ==================== Restaurant Owner APIs ====================

    @Operation(summary = "Add owner response", description = "Add a response to a review (restaurant owners only)")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Response added successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid request data"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - not logged in"),
        @ApiResponse(responseCode = "403", description = "Forbidden - not a restaurant owner or not your restaurant"),
        @ApiResponse(responseCode = "404", description = "Review not found")
    })
    @PostMapping("/{reviewId}/respond")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    public ResponseEntity<ReviewResponse> addOwnerResponse(
            @Parameter(description = "Review ID") @PathVariable Long reviewId,
            @Valid @RequestBody OwnerResponseRequest request) {
        
        ReviewResponse review = reviewService.addOwnerResponse(reviewId, request);
        return ResponseEntity.ok(review);
    }

    @Operation(summary = "Update owner response", description = "Update an existing owner response")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Response updated successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid request data"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - not logged in"),
        @ApiResponse(responseCode = "403", description = "Forbidden - not the original responder"),
        @ApiResponse(responseCode = "404", description = "Review not found")
    })
    @PutMapping("/{reviewId}/respond")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    public ResponseEntity<ReviewResponse> updateOwnerResponse(
            @Parameter(description = "Review ID") @PathVariable Long reviewId,
            @Valid @RequestBody OwnerResponseRequest request) {
        
        ReviewResponse review = reviewService.updateOwnerResponse(reviewId, request);
        return ResponseEntity.ok(review);
    }

    @Operation(summary = "Delete owner response", description = "Delete an existing owner response")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "204", description = "Response deleted successfully"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - not logged in"),
        @ApiResponse(responseCode = "403", description = "Forbidden - not the original responder"),
        @ApiResponse(responseCode = "404", description = "Review not found")
    })
    @DeleteMapping("/{reviewId}/respond")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    public ResponseEntity<Void> deleteOwnerResponse(
            @Parameter(description = "Review ID") @PathVariable Long reviewId) {
        
        reviewService.deleteOwnerResponse(reviewId);
        return ResponseEntity.noContent().build();
    }

    // ==================== Admin APIs ====================

    @Operation(summary = "Hide review", description = "Hide a review for violating policies (admin only)")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "204", description = "Review hidden successfully"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - not logged in"),
        @ApiResponse(responseCode = "403", description = "Forbidden - not an admin"),
        @ApiResponse(responseCode = "404", description = "Review not found")
    })
    @PostMapping("/{reviewId}/hide")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> hideReview(
            @Parameter(description = "Review ID") @PathVariable Long reviewId,
            @Parameter(description = "Reason for hiding") @RequestParam String reason) {
        
        reviewService.hideReview(reviewId, reason);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Unhide review", description = "Unhide a previously hidden review (admin only)")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "204", description = "Review unhidden successfully"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - not logged in"),
        @ApiResponse(responseCode = "403", description = "Forbidden - not an admin"),
        @ApiResponse(responseCode = "404", description = "Review not found")
    })
    @PostMapping("/{reviewId}/unhide")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> unhideReview(
            @Parameter(description = "Review ID") @PathVariable Long reviewId) {
        
        reviewService.unhideReview(reviewId);
        return ResponseEntity.noContent().build();
    }

    // ==================== Utility APIs ====================

    @Operation(summary = "Check review eligibility", description = "Check if current user can review a specific target")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Eligibility checked successfully"),
        @ApiResponse(responseCode = "401", description = "Unauthorized - not logged in")
    })
    @GetMapping("/eligibility/{targetType}/{targetId}")
    @PreAuthorize("hasRole('CUSTOMER')")
    public ResponseEntity<ReviewEligibilityResponse> checkReviewEligibility(
            @Parameter(description = "Target type (RESTAURANT or MENU_ITEM)") @PathVariable ReviewType targetType,
            @Parameter(description = "Target ID") @PathVariable Long targetId,
            @Parameter(description = "Order ID (required for menu item reviews)") @RequestParam(required = false) Long orderId,
            Authentication authentication) {
        
        User user = (User) authentication.getPrincipal();
        ReviewEligibilityResponse response = new ReviewEligibilityResponse();
        
        try {
            if (targetType == ReviewType.RESTAURANT) {
                ReviewValidationService.ReviewEligibilityInfo eligibility = 
                        reviewValidationService.getReviewEligibility(user.getId(), targetId);
                
                response.setEligible(eligibility.isEligible());
                response.setHasCompletedOrders(eligibility.isHasCompletedOrders());
                response.setAlreadyReviewed(eligibility.isAlreadyReviewed());
                response.setWithinReviewWindow(eligibility.isWithinReviewWindow());
                response.setDaysElapsed(eligibility.getDaysElapsed());
                response.setLatestOrderTime(eligibility.getLatestOrderTime());
                response.setExistingReviewId(eligibility.getExistingReviewId());
                response.setError(eligibility.getError());
                
                // Set deprecated fields for backward compatibility
                response.setCanReview(eligibility.isEligible());
                response.setReason(eligibility.isEligible() ? "Có thể đánh giá" : "Không đủ điều kiện đánh giá");
                
            } else if (targetType == ReviewType.MENU_ITEM) {
                boolean eligible = reviewValidationService.isEligibleToReviewMenuItem(user.getId(), targetId);
                response.setEligible(eligible);
                response.setCanReview(eligible);
                response.setReason(eligible ? "Có thể đánh giá món ăn này" : "Chưa từng đặt món ăn này");
                
            } else {
                response.setEligible(false);
                response.setCanReview(false);
                response.setReason("Loại đánh giá không hỗ trợ");
            }
            
        } catch (Exception e) {
            response.setEligible(false);
            response.setCanReview(false);
            response.setError(e.getMessage());
            response.setReason("Lỗi kiểm tra điều kiện đánh giá");
        }
        
        return ResponseEntity.ok(response);
    }
}