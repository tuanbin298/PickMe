package org.example.service;

import org.example.dto.mapper.MenuItemMapper;
import org.example.dto.request.CreateMenuItemRequest;
import org.example.dto.request.UpdateMenuItemRequest;
import org.example.entity.MenuItem;
import org.example.entity.Restaurant;
import org.example.entity.User;
import org.example.exception.AccessDeniedException;
import org.example.repository.MenuItemRepository;
import org.example.repository.RestaurantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
public class MenuItemService {
    
    @Autowired
    private MenuItemRepository menuItemRepository;
    
    @Autowired
    private RestaurantRepository restaurantRepository;
    
    @Autowired
    private RestaurantService restaurantService;
    
    @Autowired
    private MenuItemMapper menuItemMapper;
    
    /**
     * Tạo menu item mới
     */
    public MenuItem createMenuItem(Long restaurantId, MenuItem menuItem, User user) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
            .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        validateMenuAccess(user, restaurant);
        
        menuItem.setRestaurant(restaurant);
        menuItem.setCreatedAt(LocalDateTime.now());
        
        return menuItemRepository.save(menuItem);
    }
    
    /**
     * Tạo menu item mới từ CreateMenuItemRequest
     */
    public MenuItem createMenuItem(Long restaurantId, CreateMenuItemRequest request, User user) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
            .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        validateMenuAccess(user, restaurant);
        
        MenuItem menuItem = menuItemMapper.toEntity(request, restaurant);
        menuItem.setCreatedAt(LocalDateTime.now());
        
        return menuItemRepository.save(menuItem);
    }
    
    /**
     * Lấy tất cả menu items của restaurant (available only)
     */
    public List<MenuItem> getAvailableMenuItems(Long restaurantId) {
        return menuItemRepository.findByRestaurantIdAndIsAvailableTrue(restaurantId);
    }
    
    /**
     * Lấy tất cả menu items của restaurant (bao gồm unavailable) - for management
     */
    public List<MenuItem> getAllMenuItems(Long restaurantId, User user) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
            .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        validateMenuAccess(user, restaurant);
        
        return menuItemRepository.findByRestaurantId(restaurantId);
    }
    
    /**
     * Lấy menu items theo category
     */
    public List<MenuItem> getMenuItemsByCategory(Long restaurantId, String category) {
        return menuItemRepository.findByRestaurantIdAndCategoryAndIsAvailableTrue(restaurantId, category);
    }
    
    /**
     * Lấy menu items theo tag
     */
    public List<MenuItem> getMenuItemsByTag(Long restaurantId, String tag) {
        return menuItemRepository.findByRestaurantIdAndTag(restaurantId, tag);
    }
    
    /**
     * Tìm kiếm menu items
     */
    public List<MenuItem> searchMenuItems(Long restaurantId, String searchTerm) {
        return menuItemRepository.searchMenuItems(restaurantId, searchTerm);
    }
    
    /**
     * Lấy tất cả categories của restaurant
     */
    public List<String> getMenuCategories(Long restaurantId) {
        return menuItemRepository.findDistinctCategoriesByRestaurantId(restaurantId);
    }
    
    /**
     * Cập nhật menu item
     */
    public MenuItem updateMenuItem(Long menuItemId, MenuItem updatedMenuItem, User user) {
        MenuItem menuItem = menuItemRepository.findById(menuItemId)
            .orElseThrow(() -> new RuntimeException("Menu item not found"));
        
        validateMenuAccess(user, menuItem.getRestaurant());
        
        // Update fields
        menuItem.setName(updatedMenuItem.getName());
        menuItem.setDescription(updatedMenuItem.getDescription());
        menuItem.setPrice(updatedMenuItem.getPrice());
        menuItem.setCategory(updatedMenuItem.getCategory());
        menuItem.setImageUrl(updatedMenuItem.getImageUrl());
        menuItem.setIsAvailable(updatedMenuItem.getIsAvailable());
        menuItem.setPreparationTimeMinutes(updatedMenuItem.getPreparationTimeMinutes());
        menuItem.setTags(updatedMenuItem.getTags());
        menuItem.setUpdatedAt(LocalDateTime.now());
        
        return menuItemRepository.save(menuItem);
    }
    
    /**
     * Toggle availability của menu item
     */
    public MenuItem toggleAvailability(Long menuItemId, User user) {
        MenuItem menuItem = menuItemRepository.findById(menuItemId)
            .orElseThrow(() -> new RuntimeException("Menu item not found"));
        
        validateMenuAccess(user, menuItem.getRestaurant());
        
        menuItem.setIsAvailable(!menuItem.getIsAvailable());
        menuItem.setUpdatedAt(LocalDateTime.now());
        
        return menuItemRepository.save(menuItem);
    }
    
    /**
     * Xóa menu item
     */
    public void deleteMenuItem(Long menuItemId, User user) {
        MenuItem menuItem = menuItemRepository.findById(menuItemId)
            .orElseThrow(() -> new RuntimeException("Menu item not found"));
        
        validateMenuAccess(user, menuItem.getRestaurant());
        
        menuItemRepository.delete(menuItem);
    }
    
    /**
     * Cập nhật menu item từ UpdateMenuItemRequest
     */
    public MenuItem updateMenuItem(Long menuItemId, UpdateMenuItemRequest request, User user) {
        MenuItem menuItem = menuItemRepository.findById(menuItemId)
            .orElseThrow(() -> new RuntimeException("Menu item not found"));
        
        validateMenuAccess(user, menuItem.getRestaurant());
        
        // Use mapper to update only non-null fields
        menuItemMapper.updateEntity(menuItem, request);
        menuItem.setUpdatedAt(LocalDateTime.now());
        
        return menuItemRepository.save(menuItem);
    }
    
    /**
     * Lấy menu item theo ID
     */
    public MenuItem getMenuItemById(Long menuItemId) {
        return menuItemRepository.findById(menuItemId)
            .orElseThrow(() -> new RuntimeException("Menu item not found"));
    }
    

    
    /**
     * Kiểm tra user có quyền quản lý menu không
     */
    private void validateMenuAccess(User user, Restaurant restaurant) {
        if (!restaurantService.hasRestaurantAccess(user, restaurant.getId())) {
            throw new AccessDeniedException("You don't have access to manage this restaurant's menu");
        }
    }
}