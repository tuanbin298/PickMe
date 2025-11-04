package org.example.repository;

import org.example.entity.Order;
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
public interface OrderRepository extends JpaRepository<Order, Long> {
    
    // Find by QR Code
    Optional<Order> findByQrCode(String qrCode);
    
    // Find orders by customer
    @Query("SELECT o FROM Order o WHERE o.customer.id = :customerId ORDER BY o.createdAt DESC")
    Page<Order> findByCustomerId(@Param("customerId") Long customerId, Pageable pageable);
    
    @Query("SELECT o FROM Order o WHERE o.customer.id = :customerId ORDER BY o.createdAt DESC")
    List<Order> findByCustomerId(@Param("customerId") Long customerId);
    
    // Find orders by restaurant
    @Query("SELECT o FROM Order o WHERE o.restaurant.id = :restaurantId ORDER BY o.createdAt DESC")
    Page<Order> findByRestaurantId(@Param("restaurantId") Long restaurantId, Pageable pageable);
    
    @Query("SELECT o FROM Order o WHERE o.restaurant.id = :restaurantId ORDER BY o.createdAt DESC")
    List<Order> findByRestaurantId(@Param("restaurantId") Long restaurantId);
    
    // Find orders by status
    @Query("SELECT o FROM Order o WHERE o.status = :status ORDER BY o.createdAt DESC")
    List<Order> findByStatus(@Param("status") Order.OrderStatus status);
    
    // Find orders by restaurant and status
    @Query("SELECT o FROM Order o WHERE o.restaurant.id = :restaurantId AND o.status = :status ORDER BY o.createdAt DESC")
    List<Order> findByRestaurantIdAndStatus(@Param("restaurantId") Long restaurantId, @Param("status") Order.OrderStatus status);
    
    // Find orders by customer and status
    @Query("SELECT o FROM Order o WHERE o.customer.id = :customerId AND o.status = :status ORDER BY o.createdAt DESC")
    List<Order> findByCustomerIdAndStatus(@Param("customerId") Long customerId, @Param("status") Order.OrderStatus status);
    
    // Find orders by date range
    @Query("SELECT o FROM Order o WHERE o.createdAt BETWEEN :startDate AND :endDate ORDER BY o.createdAt DESC")
    List<Order> findByDateRange(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    // Find orders by restaurant and date range
    @Query("SELECT o FROM Order o WHERE o.restaurant.id = :restaurantId AND o.createdAt BETWEEN :startDate AND :endDate ORDER BY o.createdAt DESC")
    List<Order> findByRestaurantIdAndDateRange(
        @Param("restaurantId") Long restaurantId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );
    
    // Find orders ready for pickup (status = READY and preferred_pickup_time <= now)
    @Query("SELECT o FROM Order o WHERE o.status = 'READY' AND o.preferredPickupTime <= :now ORDER BY o.preferredPickupTime ASC")
    List<Order> findOrdersReadyForPickup(@Param("now") LocalDateTime now);
    
    // Find overdue orders (estimated_ready_time < now and status not in READY, PICKED_UP, COMPLETED, CANCELLED)
    @Query("SELECT o FROM Order o WHERE o.estimatedReadyTime < :now AND o.status NOT IN ('READY', 'PICKED_UP', 'COMPLETED', 'CANCELLED') ORDER BY o.estimatedReadyTime ASC")
    List<Order> findOverdueOrders(@Param("now") LocalDateTime now);
    
    // Statistics queries
    @Query("SELECT COUNT(o) FROM Order o WHERE o.restaurant.id = :restaurantId AND o.status IN ('COMPLETED', 'PICKED_UP')")
    Long countCompletedOrdersByRestaurant(@Param("restaurantId") Long restaurantId);
    
    @Query("SELECT SUM(o.totalAmount) FROM Order o WHERE o.restaurant.id = :restaurantId AND o.status IN ('COMPLETED', 'PICKED_UP')")
    Double getTotalRevenueByRestaurant(@Param("restaurantId") Long restaurantId);
    
    @Query("SELECT SUM(o.totalAmount) FROM Order o WHERE o.restaurant.id = :restaurantId AND o.status IN ('COMPLETED', 'PICKED_UP') AND o.createdAt BETWEEN :startDate AND :endDate")
    Double getTotalRevenueByRestaurantAndDateRange(
        @Param("restaurantId") Long restaurantId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );
    
    // Check if customer has active order with restaurant
    @Query("SELECT COUNT(o) > 0 FROM Order o WHERE o.customer.id = :customerId AND o.restaurant.id = :restaurantId AND o.status IN ('PENDING', 'CONFIRMED', 'PREPARING')")
    boolean hasActiveOrderWithRestaurant(@Param("customerId") Long customerId, @Param("restaurantId") Long restaurantId);
    
    // Find orders by customer with status not in completed/cancelled (active orders)
    @Query("SELECT o FROM Order o WHERE o.customer.id = :customerId AND o.status NOT IN ('COMPLETED', 'CANCELLED', 'PICKED_UP') ORDER BY o.createdAt DESC")
    List<Order> findActiveOrdersByCustomer(@Param("customerId") Long customerId);
    
    // Find orders by restaurant owner
    @Query("SELECT o FROM Order o WHERE o.restaurant.owner.id = :ownerId ORDER BY o.createdAt DESC")
    List<Order> findByRestaurantOwnerId(@Param("ownerId") Long ownerId);
    
    // Find orders by user, restaurant and status (for review validation)
    @Query("SELECT o FROM Order o WHERE o.customer.id = :userId AND o.restaurant.id = :restaurantId AND o.status = :status ORDER BY o.createdAt DESC")
    List<Order> findByUserIdAndRestaurantIdAndStatus(@Param("userId") Long userId, @Param("restaurantId") Long restaurantId, @Param("status") Order.OrderStatus status);
    
    // Find order by id and user id (for review validation)
    @Query("SELECT o FROM Order o WHERE o.id = :orderId AND o.customer.id = :userId")
    Optional<Order> findByIdAndUserId(@Param("orderId") Long orderId, @Param("userId") Long userId);
    
    // Find orders containing specific menu item (for review validation)
    @Query("SELECT DISTINCT o FROM Order o JOIN o.orderItems oi WHERE o.customer.id = :userId AND oi.menuItem.id = :menuItemId AND o.status = :status ORDER BY o.createdAt DESC")
    List<Order> findOrdersWithMenuItem(@Param("userId") Long userId, @Param("menuItemId") Long menuItemId, @Param("status") Order.OrderStatus status);
}