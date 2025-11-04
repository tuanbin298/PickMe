package org.example.service;

import org.example.entity.MenuItem;
import org.example.entity.MenuItemAddOn;
import org.example.entity.User;
import org.example.exception.AccessDeniedException;
import org.example.repository.MenuItemAddOnRepository;
import org.example.repository.MenuItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
@Transactional
public class MenuItemAddOnService {
    
    @Autowired
    private MenuItemAddOnRepository menuItemAddOnRepository;
    
    @Autowired
    private MenuItemRepository menuItemRepository;
    
    /**
     * Create new add-on for menu item
     */
    public MenuItemAddOn createAddOn(Long menuItemId, String name, String description, 
                                   BigDecimal price, String category, User user) {
        
        MenuItem menuItem = menuItemRepository.findById(menuItemId)
            .orElseThrow(() -> new IllegalArgumentException("Menu item not found"));
        
        validateRestaurantOwnership(menuItem, user);
        
        MenuItemAddOn addOn = new MenuItemAddOn(menuItem, name, price, category);
        addOn.setDescription(description);
        
        return menuItemAddOnRepository.save(addOn);
    }
    
    /**
     * Update add-on
     */
    public MenuItemAddOn updateAddOn(Long addOnId, String name, String description,
                                   BigDecimal price, String category, Boolean isAvailable, User user) {
        
        MenuItemAddOn addOn = menuItemAddOnRepository.findById(addOnId)
            .orElseThrow(() -> new IllegalArgumentException("Add-on not found"));
        
        validateRestaurantOwnership(addOn.getMenuItem(), user);
        
        if (name != null) addOn.setName(name);
        if (description != null) addOn.setDescription(description);
        if (price != null) addOn.updatePrice(price);
        if (category != null) addOn.setCategory(category);
        if (isAvailable != null) addOn.setIsAvailable(isAvailable);
        
        return menuItemAddOnRepository.save(addOn);
    }
    
    /**
     * Delete add-on
     */
    public void deleteAddOn(Long addOnId, User user) {
        MenuItemAddOn addOn = menuItemAddOnRepository.findById(addOnId)
            .orElseThrow(() -> new IllegalArgumentException("Add-on not found"));
        
        validateRestaurantOwnership(addOn.getMenuItem(), user);
        
        menuItemAddOnRepository.delete(addOn);
    }
    
    /**
     * Get add-ons by menu item
     */
    public List<MenuItemAddOn> getAddOnsByMenuItem(Long menuItemId) {
        return menuItemAddOnRepository.findAvailableByMenuItemId(menuItemId);
    }
    
    /**
     * Get add-ons by category
     */
    public List<MenuItemAddOn> getAddOnsByCategory(Long menuItemId, String category) {
        return menuItemAddOnRepository.findByMenuItemIdAndCategory(menuItemId, category);
    }
    
    /**
     * Get all categories for menu item
     */
    public List<String> getCategories(Long menuItemId) {
        return menuItemAddOnRepository.findCategoriesByMenuItemId(menuItemId);
    }
    
    /**
     * Toggle add-on availability
     */
    public MenuItemAddOn toggleAvailability(Long addOnId, User user) {
        MenuItemAddOn addOn = menuItemAddOnRepository.findById(addOnId)
            .orElseThrow(() -> new IllegalArgumentException("Add-on not found"));
        
        validateRestaurantOwnership(addOn.getMenuItem(), user);
        
        addOn.toggleAvailability();
        return menuItemAddOnRepository.save(addOn);
    }
    
    /**
     * Update display order
     */
    public MenuItemAddOn updateDisplayOrder(Long addOnId, Integer displayOrder, User user) {
        MenuItemAddOn addOn = menuItemAddOnRepository.findById(addOnId)
            .orElseThrow(() -> new IllegalArgumentException("Add-on not found"));
        
        validateRestaurantOwnership(addOn.getMenuItem(), user);
        
        addOn.setDisplayOrder(displayOrder);
        return menuItemAddOnRepository.save(addOn);
    }
    
    /**
     * Bulk update add-ons for menu item
     */
    public void bulkUpdateAddOns(Long menuItemId, List<MenuItemAddOn> addOns, User user) {
        MenuItem menuItem = menuItemRepository.findById(menuItemId)
            .orElseThrow(() -> new IllegalArgumentException("Menu item not found"));
        
        validateRestaurantOwnership(menuItem, user);
        
        // Clear existing add-ons
        List<MenuItemAddOn> existing = menuItemAddOnRepository.findByMenuItemId(menuItemId);
        menuItemAddOnRepository.deleteAll(existing);
        
        // Add new add-ons
        for (MenuItemAddOn addOn : addOns) {
            addOn.setMenuItem(menuItem);
            menuItemAddOnRepository.save(addOn);
        }
    }
    
    /**
     * Validate restaurant ownership
     */
    private void validateRestaurantOwnership(MenuItem menuItem, User user) {
        if (!menuItem.getRestaurant().getOwner().getId().equals(user.getId())) {
            throw new AccessDeniedException("You can only manage add-ons for your own restaurant");
        }
    }
}