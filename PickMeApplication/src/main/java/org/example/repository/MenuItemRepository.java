package org.example.repository;

import org.example.entity.MenuItem;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MenuItemRepository extends JpaRepository<MenuItem, Long> {
    
    // Find menu items by restaurant
    List<MenuItem> findByRestaurantIdAndIsAvailableTrue(Long restaurantId);
    
    // Find all menu items by restaurant (including unavailable)
    List<MenuItem> findByRestaurantId(Long restaurantId);
    
    // Find menu items by category
    List<MenuItem> findByRestaurantIdAndCategoryAndIsAvailableTrue(Long restaurantId, String category);
    
    // Find menu items by tags
    @Query("SELECT mi FROM MenuItem mi JOIN mi.tags t WHERE mi.restaurant.id = :restaurantId " +
           "AND t = :tag AND mi.isAvailable = true")
    List<MenuItem> findByRestaurantIdAndTag(@Param("restaurantId") Long restaurantId, 
                                           @Param("tag") String tag);
    
    // Search menu items by name or description
    @Query("SELECT mi FROM MenuItem mi WHERE mi.restaurant.id = :restaurantId " +
           "AND (LOWER(mi.name) LIKE LOWER(CONCAT('%', :searchTerm, '%')) " +
           "OR LOWER(mi.description) LIKE LOWER(CONCAT('%', :searchTerm, '%'))) " +
           "AND mi.isAvailable = true")
    List<MenuItem> searchMenuItems(@Param("restaurantId") Long restaurantId, 
                                  @Param("searchTerm") String searchTerm);
    
    // Find distinct categories for a restaurant
    @Query("SELECT DISTINCT mi.category FROM MenuItem mi WHERE mi.restaurant.id = :restaurantId " +
           "AND mi.isAvailable = true ORDER BY mi.category")
    List<String> findDistinctCategoriesByRestaurantId(@Param("restaurantId") Long restaurantId);
}