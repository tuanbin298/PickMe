package org.example.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.dto.mapper.RestaurantMapper;
import org.example.dto.response.AdminFeedbackResponse;
import org.example.dto.response.AdminPaymentResponse;
import org.example.dto.response.AdminUserResponse;
import org.example.dto.response.RestaurantResponse;
import org.example.dto.response.OrderResponse;
import org.example.dto.response.MenuItemResponse;
import org.example.entity.Payment;
import org.example.entity.Restaurant;
import org.example.entity.Review;
import org.example.entity.User;
import org.example.entity.Order;
import org.example.entity.MenuItem;
import org.example.repository.PaymentRepository;
import org.example.repository.RestaurantRepository;
import org.example.repository.ReviewRepository;
import org.example.repository.UserRepository;
import org.example.repository.OrderRepository;
import org.example.repository.MenuItemRepository;
import org.example.service.RestaurantService;
import org.example.service.UserService;
import org.example.dto.mapper.OrderMapper;
import org.example.dto.mapper.MenuItemMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@CrossOrigin(origins = "http://localhost:5173", allowedHeaders = "*", allowCredentials = "true")
@RequestMapping("/api/admin")
@Tag(name = "Admin Management", description = "APIs for admin operations")
@SecurityRequirement(name = "Bearer Authentication")
public class AdminController {
    
    @Autowired
    private RestaurantService restaurantService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private RestaurantMapper restaurantMapper;
    
    @Autowired
    private PaymentRepository paymentRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private ReviewRepository reviewRepository;
    
    @Autowired
    private RestaurantRepository restaurantRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private MenuItemRepository menuItemRepository;

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private MenuItemMapper menuItemMapper;

    @GetMapping("/restaurants")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all restaurants", description = "Get all restaurants (Admin only)")
    public ResponseEntity<List<RestaurantResponse>> getAllRestaurants(Authentication authentication) {
        User currentUser = userService.findByEmail(authentication.getName());
        List<Restaurant> allRestaurants = restaurantService.getAllRestaurants(currentUser);
        List<RestaurantResponse> responses = restaurantMapper.toResponseList(allRestaurants);
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/restaurants/pending")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get pending restaurants", description = "Get all restaurants waiting for approval (Admin only)")
    public ResponseEntity<List<RestaurantResponse>> getPendingRestaurants(Authentication authentication) {
        User currentUser = userService.findByEmail(authentication.getName());
        List<Restaurant> pendingRestaurants = restaurantService.getPendingApprovalRestaurants(currentUser);
        List<RestaurantResponse> responses = restaurantMapper.toResponseList(pendingRestaurants);
        return ResponseEntity.ok(responses);
    }
    
    @PostMapping("/restaurants/{restaurantId}/approve")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Approve restaurant", description = "Approve a restaurant (Admin only)")
    public ResponseEntity<RestaurantResponse> approveRestaurant(
            @PathVariable Long restaurantId,
            Authentication authentication) {
        
        User currentUser = userService.findByEmail(authentication.getName());
        Restaurant approvedRestaurant = restaurantService.approveRestaurant(restaurantId, currentUser);
        RestaurantResponse response = restaurantMapper.toResponse(approvedRestaurant);
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/restaurants/{restaurantId}/reject")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Reject restaurant", description = "Reject a restaurant with reason (Admin only)")
    public ResponseEntity<RestaurantResponse> rejectRestaurant(
            @PathVariable Long restaurantId,
            @RequestParam String reason,
            Authentication authentication) {
        
        User currentUser = userService.findByEmail(authentication.getName());
        Restaurant rejectedRestaurant = restaurantService.rejectRestaurant(restaurantId, currentUser, reason);
        RestaurantResponse response = restaurantMapper.toResponse(rejectedRestaurant);
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/payments")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all payments", description = "Get all payments in the system (Admin only)")
    public ResponseEntity<List<AdminPaymentResponse>> getAllPayments(Authentication authentication) {
        List<Payment> payments = paymentRepository.findAll();
        List<AdminPaymentResponse> responses = payments.stream()
                .map(AdminPaymentResponse::from)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/users")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all users", description = "Get all users in the system (Admin only)")
    public ResponseEntity<List<AdminUserResponse>> getAllUsers(Authentication authentication) {
        List<User> users = userRepository.findAll();
        List<AdminUserResponse> responses = users.stream()
                .map(AdminUserResponse::from)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/feedbacks")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all feedbacks", description = "Get all feedbacks/reviews in the system (Admin only)")
    public ResponseEntity<List<AdminFeedbackResponse>> getAllFeedbacks(Authentication authentication) {
        List<Review> reviews = reviewRepository.findAll();
        List<AdminFeedbackResponse> responses = reviews.stream()
                .map(review -> {
                    AdminFeedbackResponse response = AdminFeedbackResponse.from(review);
                    
                    // Set restaurant name for restaurant reviews
                    if (review.getReviewType() == org.example.entity.ReviewType.RESTAURANT) {
                        restaurantRepository.findById(review.getTargetId())
                                .ifPresent(restaurant -> response.setRestaurantName(restaurant.getName()));
                    }
                    
                    return response;
                })
                .collect(Collectors.toList());
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/orders")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all orders", description = "Get all orders in the system (Admin only)")
    public ResponseEntity<List<OrderResponse>> getAllOrders(Authentication authentication) {
        List<Order> orders = orderRepository.findAll();
        List<OrderResponse> responses = orderMapper.toSummaryResponseList(orders);
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/menu-items")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all menu items", description = "Get all menu items across restaurants (Admin only)")
    public ResponseEntity<List<MenuItemResponse>> getAllMenuItems(Authentication authentication) {
        List<MenuItem> items = menuItemRepository.findAll();
        List<MenuItemResponse> responses = menuItemMapper.toResponseList(items);
        return ResponseEntity.ok(responses);
    }
}