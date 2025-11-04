package org.example.repository;

import org.example.entity.MenuItemAddOn;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MenuItemAddOnRepository extends JpaRepository<MenuItemAddOn, Long> {
    
    // Find add-ons by menu item
    @Query("SELECT ma FROM MenuItemAddOn ma WHERE ma.menuItem.id = :menuItemId ORDER BY ma.category ASC, ma.displayOrder ASC, ma.name ASC")
    List<MenuItemAddOn> findByMenuItemId(@Param("menuItemId") Long menuItemId);
    
    // Find available add-ons by menu item
    @Query("SELECT ma FROM MenuItemAddOn ma WHERE ma.menuItem.id = :menuItemId AND ma.isAvailable = true ORDER BY ma.category ASC, ma.displayOrder ASC, ma.name ASC")
    List<MenuItemAddOn> findAvailableByMenuItemId(@Param("menuItemId") Long menuItemId);
    
    // Find add-ons by category
    @Query("SELECT ma FROM MenuItemAddOn ma WHERE ma.menuItem.id = :menuItemId AND ma.category = :category AND ma.isAvailable = true ORDER BY ma.displayOrder ASC, ma.name ASC")
    List<MenuItemAddOn> findByMenuItemIdAndCategory(@Param("menuItemId") Long menuItemId, @Param("category") String category);
    
    // Find required add-ons for a menu item
    @Query("SELECT ma FROM MenuItemAddOn ma WHERE ma.menuItem.id = :menuItemId AND ma.isRequired = true AND ma.isAvailable = true ORDER BY ma.category ASC, ma.displayOrder ASC")
    List<MenuItemAddOn> findRequiredByMenuItemId(@Param("menuItemId") Long menuItemId);
    
    // Find add-ons by restaurant
    @Query("SELECT ma FROM MenuItemAddOn ma WHERE ma.menuItem.restaurant.id = :restaurantId ORDER BY ma.menuItem.name ASC, ma.category ASC, ma.displayOrder ASC")
    List<MenuItemAddOn> findByRestaurantId(@Param("restaurantId") Long restaurantId);
    
    // Find all categories for a menu item
    @Query("SELECT DISTINCT ma.category FROM MenuItemAddOn ma WHERE ma.menuItem.id = :menuItemId AND ma.isAvailable = true ORDER BY ma.category ASC")
    List<String> findCategoriesByMenuItemId(@Param("menuItemId") Long menuItemId);
    
    // Check if add-on belongs to menu item (for security validation)
    @Query("SELECT COUNT(ma) > 0 FROM MenuItemAddOn ma WHERE ma.id = :addOnId AND ma.menuItem.id = :menuItemId")
    boolean existsByIdAndMenuItemId(@Param("addOnId") Long addOnId, @Param("menuItemId") Long menuItemId);
    
    // Find add-ons by name (for search)
    @Query("SELECT ma FROM MenuItemAddOn ma WHERE ma.menuItem.restaurant.id = :restaurantId AND LOWER(ma.name) LIKE LOWER(CONCAT('%', :name, '%')) ORDER BY ma.name ASC")
    List<MenuItemAddOn> findByRestaurantIdAndNameContaining(@Param("restaurantId") Long restaurantId, @Param("name") String name);
}