package org.example.repository;

import org.example.entity.Cart;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface CartRepository extends JpaRepository<Cart, Long> {
    
    // Find active cart by customer (returns first one found)
    @Query("SELECT c FROM Cart c WHERE c.customer.id = :customerId AND c.status = 'ACTIVE'")
    Optional<Cart> findActiveCartByCustomer(@Param("customerId") Long customerId);
    
    // Find all active carts by customer
    @Query("SELECT c FROM Cart c WHERE c.customer.id = :customerId AND c.status = 'ACTIVE' ORDER BY c.updatedAt DESC")
    List<Cart> findAllActiveCartsByCustomer(@Param("customerId") Long customerId);
    
    // Find active cart by customer and restaurant
    @Query("SELECT c FROM Cart c WHERE c.customer.id = :customerId AND c.restaurant.id = :restaurantId AND c.status = 'ACTIVE'")
    Optional<Cart> findActiveCartByCustomerAndRestaurant(@Param("customerId") Long customerId, @Param("restaurantId") Long restaurantId);
    
    // Find all carts by customer
    @Query("SELECT c FROM Cart c WHERE c.customer.id = :customerId ORDER BY c.updatedAt DESC")
    List<Cart> findCartsByCustomer(@Param("customerId") Long customerId);
    
    // Find carts by status
    @Query("SELECT c FROM Cart c WHERE c.status = :status ORDER BY c.updatedAt DESC")
    List<Cart> findCartsByStatus(@Param("status") Cart.CartStatus status);
    
    // Find expired carts (older than 24 hours without activity)
    @Query("SELECT c FROM Cart c WHERE c.status = 'ACTIVE' AND c.updatedAt < :expireTime")
    List<Cart> findExpiredCarts(@Param("expireTime") LocalDateTime expireTime);
    
    // Count active carts by customer
    @Query("SELECT COUNT(c) FROM Cart c WHERE c.customer.id = :customerId AND c.status = 'ACTIVE'")
    Long countActiveCartsByCustomer(@Param("customerId") Long customerId);
    
    // Check if customer has active cart with restaurant
    @Query("SELECT COUNT(c) > 0 FROM Cart c WHERE c.customer.id = :customerId AND c.restaurant.id = :restaurantId AND c.status = 'ACTIVE'")
    boolean hasActiveCartWithRestaurant(@Param("customerId") Long customerId, @Param("restaurantId") Long restaurantId);
    
    // Delete expired carts
    @Query("DELETE FROM Cart c WHERE c.status = 'EXPIRED'")
    void deleteExpiredCarts();
    
    // Find carts with items count
    @Query("SELECT c, SIZE(c.cartItems) FROM Cart c WHERE c.customer.id = :customerId AND c.status = 'ACTIVE'")
    List<Object[]> findCartsWithItemCount(@Param("customerId") Long customerId);
}