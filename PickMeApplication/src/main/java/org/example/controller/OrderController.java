package org.example.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.example.dto.mapper.OrderMapper;
import org.example.dto.request.CheckoutCartRequest;
import org.example.dto.response.MessageResponse;
import org.example.dto.response.OrderResponse;
import org.example.entity.Order;
import org.example.entity.User;
import org.example.service.CartService;
import org.example.service.OrderService;
import org.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/orders")
@Tag(name = "Order Management", description = "APIs for managing food orders")
@SecurityRequirement(name = "Bearer Authentication")
public class OrderController {
    
    @Autowired
    private OrderService orderService;
    
    @Autowired
    private CartService cartService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private OrderMapper orderMapper;
    
    // Customer Order Management - Cart-based workflow
    
    @GetMapping("/my-orders")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Get my orders", description = "Get customer's order history")
    public ResponseEntity<Page<OrderResponse>> getMyOrders(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir,
            Authentication authentication) {
        
        User customer = userService.findByEmail(authentication.getName());
        Sort sort = sortDir.equalsIgnoreCase("desc") ? 
            Sort.by(sortBy).descending() : Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);
        
        Page<Order> orders = orderService.getCustomerOrders(customer.getId(), pageable);
        Page<OrderResponse> responses = orders.map(orderMapper::toSummaryResponse);
        
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/my-orders/active")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Get my active orders", description = "Get customer's active orders")
    public ResponseEntity<List<OrderResponse>> getMyActiveOrders(Authentication authentication) {
        User customer = userService.findByEmail(authentication.getName());
        List<Order> orders = orderService.getCustomerActiveOrders(customer.getId());
        List<OrderResponse> responses = orderMapper.toSummaryResponseList(orders);
        
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/{orderId}")
    @Operation(summary = "Get order details", description = "Get detailed order information")
    public ResponseEntity<OrderResponse> getOrderDetails(
            @PathVariable Long orderId,
            Authentication authentication) {
        
        User user = userService.findByEmail(authentication.getName());
        Order order = orderService.getOrderById(orderId, user);
        OrderResponse response = orderMapper.toResponse(order);
        
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/qr/{qrCode}")
    @Operation(summary = "Get order by QR code", description = "Get order information by QR code")
    public ResponseEntity<OrderResponse> getOrderByQrCode(
            @PathVariable String qrCode,
            Authentication authentication) {
        
        User user = userService.findByEmail(authentication.getName());
        Order order = orderService.getOrderByQrCode(qrCode, user);
        OrderResponse response = orderMapper.toResponse(order);
        
        return ResponseEntity.ok(response);
    }
    
    @PutMapping("/{orderId}/cancel")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Cancel order", description = "Cancel an order (Customer only)")
    public ResponseEntity<OrderResponse> cancelOrder(
            @PathVariable Long orderId,
            Authentication authentication) {
        
        User customer = userService.findByEmail(authentication.getName());
        Order order = orderService.cancelOrder(orderId, customer);
        OrderResponse response = orderMapper.toResponse(order);
        
        return ResponseEntity.ok(response);
    }
    
    @PutMapping("/{orderId}/pickup-time")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Update pickup time", description = "Update preferred pickup time")
    public ResponseEntity<OrderResponse> updatePickupTime(
            @PathVariable Long orderId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime pickupTime,
            Authentication authentication) {
        
        User customer = userService.findByEmail(authentication.getName());
        Order order = orderService.updatePickupTime(orderId, pickupTime, customer);
        OrderResponse response = orderMapper.toResponse(order);
        
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/from-cart/{cartId}")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Create order from cart", description = "Create order from cart items (PRIMARY workflow)")
    public ResponseEntity<OrderResponse> createOrderFromCart(
            @PathVariable Long cartId,
            @Valid @RequestBody CheckoutCartRequest request,
            Authentication authentication) {
        
        User customer = userService.findByEmail(authentication.getName());
        // This will use CartService.checkoutCart which creates Order from Cart
        Order order = cartService.checkoutCart(cartId, request, customer);
        OrderResponse response = orderMapper.toResponse(order);
        
        return ResponseEntity.ok(response);
    }
    
    // Restaurant Order Management
    
    @GetMapping("/restaurant/{restaurantId}")
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('RESTAURANT_STAFF') or hasRole('ADMIN')")
    @Operation(summary = "Get restaurant orders", description = "Get orders for a restaurant")
    public ResponseEntity<Page<OrderResponse>> getRestaurantOrders(
            @PathVariable Long restaurantId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir,
            Authentication authentication) {
        
        User user = userService.findByEmail(authentication.getName());
        Sort sort = sortDir.equalsIgnoreCase("desc") ? 
            Sort.by(sortBy).descending() : Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);
        
        Page<Order> orders = orderService.getRestaurantOrders(restaurantId, user, pageable);
        Page<OrderResponse> responses = orders.map(orderMapper::toSummaryResponse);
        
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/restaurant/{restaurantId}/status/{status}")
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('RESTAURANT_STAFF') or hasRole('ADMIN')")
    @Operation(summary = "Get restaurant orders by status", description = "Get restaurant orders filtered by status")
    public ResponseEntity<List<OrderResponse>> getRestaurantOrdersByStatus(
            @PathVariable Long restaurantId,
            @PathVariable Order.OrderStatus status,
            Authentication authentication) {
        
        User user = userService.findByEmail(authentication.getName());
        List<Order> orders = orderService.getRestaurantOrdersByStatus(restaurantId, status, user);
        List<OrderResponse> responses = orderMapper.toSummaryResponseList(orders);
        
        return ResponseEntity.ok(responses);
    }
    
    @PutMapping("/{orderId}/status")
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('RESTAURANT_STAFF')")
    @Operation(summary = "Update order status", description = "Update order status (Restaurant only)")
    public ResponseEntity<OrderResponse> updateOrderStatus(
            @PathVariable Long orderId,
            @RequestParam Order.OrderStatus status,
            Authentication authentication) {
        
        User user = userService.findByEmail(authentication.getName());
        Order order = orderService.updateOrderStatus(orderId, status, user);
        OrderResponse response = orderMapper.toResponse(order);
        
        return ResponseEntity.ok(response);
    }
    
    // Admin & Analytics
    
    @GetMapping("/ready-for-pickup")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get orders ready for pickup", description = "Get all orders ready for pickup (Admin only)")
    public ResponseEntity<List<OrderResponse>> getOrdersReadyForPickup() {
        List<Order> orders = orderService.getOrdersReadyForPickup();
        List<OrderResponse> responses = orderMapper.toSummaryResponseList(orders);
        
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/overdue")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get overdue orders", description = "Get orders that are overdue (Admin only)")
    public ResponseEntity<List<OrderResponse>> getOverdueOrders() {
        List<Order> orders = orderService.getOverdueOrders();
        List<OrderResponse> responses = orderMapper.toSummaryResponseList(orders);
        
        return ResponseEntity.ok(responses);
    }
    
    // Restaurant Statistics
    
    @GetMapping("/restaurant/{restaurantId}/stats/count")
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('RESTAURANT_STAFF') or hasRole('ADMIN')")
    @Operation(summary = "Get restaurant order count", description = "Get total completed orders count")
    public ResponseEntity<Long> getRestaurantOrderCount(
            @PathVariable Long restaurantId,
            Authentication authentication) {
        
        User user = userService.findByEmail(authentication.getName());
        Long count = orderService.getRestaurantOrderCount(restaurantId, user);
        
        return ResponseEntity.ok(count);
    }
    
    @GetMapping("/restaurant/{restaurantId}/stats/revenue")
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('RESTAURANT_STAFF') or hasRole('ADMIN')")
    @Operation(summary = "Get restaurant revenue", description = "Get total revenue from completed orders")
    public ResponseEntity<Double> getRestaurantRevenue(
            @PathVariable Long restaurantId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate,
            Authentication authentication) {
        
        User user = userService.findByEmail(authentication.getName());
        
        Double revenue;
        if (startDate != null && endDate != null) {
            revenue = orderService.getRestaurantRevenueByDateRange(restaurantId, startDate, endDate, user);
        } else {
            revenue = orderService.getRestaurantRevenue(restaurantId, user);
        }
        
        return ResponseEntity.ok(revenue != null ? revenue : 0.0);
    }
    
    // Quick Actions for QR Code Scanning
    
    @PostMapping("/qr/{qrCode}/confirm")
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('RESTAURANT_STAFF')")
    @Operation(summary = "Confirm order by QR", description = "Confirm order using QR code scan")
    public ResponseEntity<MessageResponse> confirmOrderByQr(
            @PathVariable String qrCode,
            Authentication authentication) {
        
        User user = userService.findByEmail(authentication.getName());
        Order order = orderService.getOrderByQrCode(qrCode, user);
        orderService.updateOrderStatus(order.getId(), Order.OrderStatus.CONFIRMED, user);
        
        return ResponseEntity.ok(new MessageResponse("Order confirmed successfully"));
    }
    
    @PostMapping("/qr/{qrCode}/ready")
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('RESTAURANT_STAFF')")
    @Operation(summary = "Mark order ready by QR", description = "Mark order as ready using QR code scan")
    public ResponseEntity<MessageResponse> markOrderReadyByQr(
            @PathVariable String qrCode,
            Authentication authentication) {
        
        User user = userService.findByEmail(authentication.getName());
        Order order = orderService.getOrderByQrCode(qrCode, user);
        orderService.updateOrderStatus(order.getId(), Order.OrderStatus.READY, user);
        
        return ResponseEntity.ok(new MessageResponse("Order marked as ready"));
    }
    
    @PostMapping("/qr/{qrCode}/picked-up")
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('RESTAURANT_STAFF')")
    @Operation(summary = "Mark order picked up by QR", description = "Mark order as picked up using QR code scan")
    public ResponseEntity<MessageResponse> markOrderPickedUpByQr(
            @PathVariable String qrCode,
            Authentication authentication) {
        
        User user = userService.findByEmail(authentication.getName());
        Order order = orderService.getOrderByQrCode(qrCode, user);
        orderService.updateOrderStatus(order.getId(), Order.OrderStatus.PICKED_UP, user);
        
        return ResponseEntity.ok(new MessageResponse("Order marked as picked up"));
    }
}