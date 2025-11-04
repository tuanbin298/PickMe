package org.example.repository;

import org.example.entity.OrderItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {
    
    // Find order items by order ID
    @Query("SELECT oi FROM OrderItem oi WHERE oi.order.id = :orderId ORDER BY oi.createdAt ASC")
    List<OrderItem> findByOrderId(@Param("orderId") Long orderId);
    
    // Find order items by menu item ID (for analytics)
    @Query("SELECT oi FROM OrderItem oi WHERE oi.menuItem.id = :menuItemId ORDER BY oi.createdAt DESC")
    List<OrderItem> findByMenuItemId(@Param("menuItemId") Long menuItemId);
    
    // Count total quantity sold for a menu item
    @Query("SELECT SUM(oi.quantity) FROM OrderItem oi WHERE oi.menuItem.id = :menuItemId AND oi.order.status IN ('COMPLETED', 'PICKED_UP')")
    Long getTotalQuantitySoldByMenuItem(@Param("menuItemId") Long menuItemId);
    
    // Get best selling menu items by restaurant
    @Query("SELECT oi.menuItem.id, oi.menuItem.name, SUM(oi.quantity) as totalSold " +
           "FROM OrderItem oi " +
           "WHERE oi.menuItem.restaurant.id = :restaurantId " +
           "AND oi.order.status IN ('COMPLETED', 'PICKED_UP') " +
           "GROUP BY oi.menuItem.id, oi.menuItem.name " +
           "ORDER BY totalSold DESC")
    List<Object[]> getBestSellingItemsByRestaurant(@Param("restaurantId") Long restaurantId);
    
    // Get revenue by menu item
    @Query("SELECT SUM(oi.totalPrice) FROM OrderItem oi WHERE oi.menuItem.id = :menuItemId AND oi.order.status IN ('COMPLETED', 'PICKED_UP')")
    Double getTotalRevenueByMenuItem(@Param("menuItemId") Long menuItemId);
    
    // Delete orphaned order items (if needed for cleanup)
    @Query("DELETE FROM OrderItem oi WHERE oi.order IS NULL")
    void deleteOrphanedOrderItems();
}