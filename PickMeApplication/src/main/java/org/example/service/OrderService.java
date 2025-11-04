package org.example.service;

import org.example.entity.*;
import org.example.exception.AccessDeniedException;
import org.example.repository.OrderRepository;
import org.example.repository.RestaurantRepository;
import org.example.repository.RestaurantStaffRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class OrderService {
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private RestaurantRepository restaurantRepository;
    
    @Autowired
    private RestaurantStaffRepository restaurantStaffRepository;

    /**
     * Create order from cart (called by CartService)
     */
    public Order createOrderFromCart(Cart cart, String deliveryAddress, LocalDateTime preferredPickupTime, String specialInstructions) {
        // Create order
        Order order = new Order(cart.getCustomer(), cart.getRestaurant(), deliveryAddress);
        order.setSpecialInstructions(specialInstructions);
        
        // Set pickup time
        if (preferredPickupTime != null) {
            validatePickupTime(preferredPickupTime, cart.getRestaurant());
            order.setPreferredPickupTime(preferredPickupTime);
            // Auto-calculate estimated ready time (15 minutes before preferred time)
            order.setEstimatedReadyTime(preferredPickupTime.minusMinutes(15));
        }
        
        // Save order first to get ID
        order = orderRepository.save(order);
        
        // Convert cart items to order items
        for (CartItem cartItem : cart.getCartItems()) {
            OrderItem orderItem = new OrderItem(
                order, 
                cartItem.getMenuItem(), 
                cartItem.getQuantity(), 
                cartItem.getSpecialInstructions()
            );
            
            // Copy add-ons with quantity
            for (CartItemAddOn cartAddOn : cartItem.getAddOns()) {
                orderItem.addAddOn(
                    cartAddOn.getName(),
                    cartAddOn.getDescription(),
                    cartAddOn.getPrice(),
                    cartAddOn.getQuantity()
                );
            }
            
            order.getOrderItems().add(orderItem);
        }
        
        // Recalculate totals and save
        order.recalculateTotals();
        return orderRepository.save(order);
    }
    
    /**
     * Get order by ID
     */
    public Order getOrderById(Long orderId, User user) {
        Order order = orderRepository.findById(orderId)
            .orElseThrow(() -> new IllegalArgumentException("Order not found"));
        
        validateOrderAccess(order, user);
        return order;
    }
    
    /**
     * Get order by QR code
     */
    public Order getOrderByQrCode(String qrCode, User user) {
        Order order = orderRepository.findByQrCode(qrCode)
            .orElseThrow(() -> new IllegalArgumentException("Order not found"));
        
        validateOrderAccess(order, user);
        return order;
    }
    
    /**
     * Get customer's orders
     */
    public Page<Order> getCustomerOrders(Long customerId, Pageable pageable) {
        return orderRepository.findByCustomerId(customerId, pageable);
    }
    
    /**
     * Get customer's active orders
     */
    public List<Order> getCustomerActiveOrders(Long customerId) {
        return orderRepository.findActiveOrdersByCustomer(customerId);
    }
    
    /**
     * Get restaurant's orders
     */
    public Page<Order> getRestaurantOrders(Long restaurantId, User user, Pageable pageable) {
        validateRestaurantAccess(restaurantId, user);
        return orderRepository.findByRestaurantId(restaurantId, pageable);
    }
    
    /**
     * Get restaurant's orders by status
     */
    public List<Order> getRestaurantOrdersByStatus(Long restaurantId, Order.OrderStatus status, User user) {
        validateRestaurantAccess(restaurantId, user);
        return orderRepository.findByRestaurantIdAndStatus(restaurantId, status);
    }
    
    /**
     * Update order status
     */
    public Order updateOrderStatus(Long orderId, Order.OrderStatus newStatus, User user) {
        Order order = orderRepository.findById(orderId)
            .orElseThrow(() -> new IllegalArgumentException("Order not found"));
        
        validateRestaurantAccess(order.getRestaurant().getId(), user);
        
        switch (newStatus) {
            case CONFIRMED:
                order.confirm();
                break;
            case PREPARING:
                order.startPreparing();
                break;
            case READY:
                order.markAsReady();
                break;
            case PICKED_UP:
                order.markAsPickedUp();
                break;
            case COMPLETED:
                order.complete();
                break;
            case CANCELLED:
                order.cancel();
                break;
            default:
                throw new IllegalArgumentException("Invalid status transition");
        }
        
        return orderRepository.save(order);
    }
    
    /**
     * Cancel order (customer)
     */
    public Order cancelOrder(Long orderId, User customer) {
        Order order = orderRepository.findById(orderId)
            .orElseThrow(() -> new IllegalArgumentException("Order not found"));
        
        if (!order.getCustomer().getId().equals(customer.getId())) {
            throw new AccessDeniedException("You can only cancel your own orders");
        }
        
        order.cancel();
        return orderRepository.save(order);
    }
    
    /**
     * Update pickup time
     */
    public Order updatePickupTime(Long orderId, LocalDateTime newPickupTime, User customer) {
        Order order = orderRepository.findById(orderId)
            .orElseThrow(() -> new IllegalArgumentException("Order not found"));
        
        if (!order.getCustomer().getId().equals(customer.getId())) {
            throw new AccessDeniedException("You can only update your own orders");
        }
        
        if (!order.canBeModified()) {
            throw new IllegalArgumentException("Order cannot be modified in current status");
        }
        
        validatePickupTime(newPickupTime, order.getRestaurant());
        order.setPreferredPickupTime(newPickupTime);
        order.setEstimatedReadyTime(newPickupTime.minusMinutes(15));
        
        return orderRepository.save(order);
    }
    
    /**
     * Get orders ready for pickup
     */
    public List<Order> getOrdersReadyForPickup() {
        return orderRepository.findOrdersReadyForPickup(LocalDateTime.now());
    }
    
    /**
     * Get overdue orders
     */
    public List<Order> getOverdueOrders() {
        return orderRepository.findOverdueOrders(LocalDateTime.now());
    }
    
    /**
     * Get restaurant statistics
     */
    public Long getRestaurantOrderCount(Long restaurantId, User user) {
        validateRestaurantAccess(restaurantId, user);
        return orderRepository.countCompletedOrdersByRestaurant(restaurantId);
    }
    
    public Double getRestaurantRevenue(Long restaurantId, User user) {
        validateRestaurantAccess(restaurantId, user);
        return orderRepository.getTotalRevenueByRestaurant(restaurantId);
    }
    
    public Double getRestaurantRevenueByDateRange(Long restaurantId, LocalDateTime startDate, LocalDateTime endDate, User user) {
        validateRestaurantAccess(restaurantId, user);
        return orderRepository.getTotalRevenueByRestaurantAndDateRange(restaurantId, startDate, endDate);
    }
    
    /**
     * Validate pickup time
     */
    private void validatePickupTime(LocalDateTime pickupTime, Restaurant restaurant) {
        LocalDateTime now = LocalDateTime.now();
        
        // Must be in future (at least 30 minutes from now)
        if (pickupTime.isBefore(now.plusMinutes(30))) {
            throw new IllegalArgumentException("Pickup time must be at least 30 minutes from now");
        }
        
        // Must be within restaurant opening hours
        if (restaurant.getOpeningTime() != null && restaurant.getClosingTime() != null) {
            if (!restaurant.isOpenAt(pickupTime.toLocalTime())) {
                throw new IllegalArgumentException("Pickup time must be within restaurant opening hours");
            }
        }
        
        // Must be within reasonable future (not more than 7 days)
        if (pickupTime.isAfter(now.plusDays(7))) {
            throw new IllegalArgumentException("Pickup time cannot be more than 7 days in advance");
        }
    }
    
    /**
     * Validate order access
     */
    private void validateOrderAccess(Order order, User user) {
        boolean hasAccess = false;
        
        // Customer can access their own orders
        if (order.getCustomer().getId().equals(user.getId())) {
            hasAccess = true;
        }
        
        // Restaurant owner/staff can access their restaurant's orders
        if (user.getRole() == Role.RESTAURANT_OWNER || user.getRole() == Role.RESTAURANT_STAFF) {
            if (order.getRestaurant().getOwner().getId().equals(user.getId())) {
                hasAccess = true; // Owner access
            } else if (user.getRole() == Role.RESTAURANT_STAFF) {
                // Check if staff has access to this restaurant
                Optional<RestaurantStaff> staffAssignment = restaurantStaffRepository
                    .findStaffAssignment(user.getId(), order.getRestaurant().getId());
                if (staffAssignment.isPresent()) {
                    hasAccess = true; // Staff access validated
                }
            }
        }
        
        // Admin can access all orders
        if (user.getRole() == Role.ADMIN) {
            hasAccess = true;
        }
        
        if (!hasAccess) {
            throw new AccessDeniedException("You don't have access to this order");
        }
    }
    
    /**
     * Validate restaurant access
     */
    private void validateRestaurantAccess(Long restaurantId, User user) {
        if (user.getRole() == Role.ADMIN) {
            return; // Admin has access to all restaurants
        }
        
        if (user.getRole() == Role.RESTAURANT_OWNER) {
            Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new IllegalArgumentException("Restaurant not found"));
            
            if (!restaurant.getOwner().getId().equals(user.getId())) {
                throw new AccessDeniedException("You don't have access to this restaurant");
            }
        } else if (user.getRole() == Role.RESTAURANT_STAFF) {
            // Check if staff has access to this restaurant
            Optional<RestaurantStaff> staffAssignment = restaurantStaffRepository
                .findStaffAssignment(user.getId(), restaurantId);
            if (!staffAssignment.isPresent()) {
                throw new AccessDeniedException("You don't have access to this restaurant");
            }
        } else {
            throw new AccessDeniedException("You don't have access to restaurant orders");
        }
    }
}