package org.example.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.example.dto.mapper.MenuItemMapper;
import org.example.dto.request.CreateMenuItemRequest;
import org.example.dto.request.UpdateMenuItemRequest;
import org.example.dto.response.MenuItemResponse;
import org.example.dto.response.MenuItemSummaryResponse;
import org.example.dto.response.MessageResponse;
import org.example.entity.MenuItem;
import org.example.entity.User;
import org.example.service.MenuItemService;
import org.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/restaurants/{restaurantId}/menu")
@Tag(name = "Menu Management", description = "APIs for managing restaurant menus")
@SecurityRequirement(name = "Bearer Authentication")
public class MenuController {
    
    @Autowired
    private MenuItemService menuItemService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private MenuItemMapper menuItemMapper;
    
    @PostMapping
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('RESTAURANT_STAFF')")
    @Operation(summary = "Create menu item", description = "Add new item to restaurant menu (Owner/Staff only)")
    public ResponseEntity<MenuItemResponse> createMenuItem(
            @PathVariable Long restaurantId,
            @Valid @RequestBody CreateMenuItemRequest request,
            Authentication authentication) {
        
        User currentUser = userService.findByEmail(authentication.getName());
        
        MenuItem createdMenuItem = menuItemService.createMenuItem(restaurantId, request, currentUser);
        MenuItemResponse response = menuItemMapper.toResponse(createdMenuItem);
        return ResponseEntity.ok(response);
    }
    
    @GetMapping
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('RESTAURANT_STAFF')")
    @Operation(summary = "Get menu items", description = "Get all menu items for management (Owner/Staff only)")
    public ResponseEntity<List<MenuItemResponse>> getAllMenuItems(
            @PathVariable Long restaurantId,
            Authentication authentication) {
        
        User currentUser = userService.findByEmail(authentication.getName());
        List<MenuItem> menuItems = menuItemService.getAllMenuItems(restaurantId, currentUser);
        List<MenuItemResponse> responses = menuItemMapper.toResponseList(menuItems);
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/public")
    @Operation(summary = "Get available menu items", description = "Get available menu items for customers")
    public ResponseEntity<List<MenuItemSummaryResponse>> getAvailableMenuItems(@PathVariable Long restaurantId) {
        List<MenuItem> menuItems = menuItemService.getAvailableMenuItems(restaurantId);
        List<MenuItemSummaryResponse> responses = menuItemMapper.toSummaryResponseList(menuItems);
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/categories")
    @Operation(summary = "Get menu categories", description = "Get all menu categories")
    public ResponseEntity<List<String>> getMenuCategories(@PathVariable Long restaurantId) {
        List<String> categories = menuItemService.getMenuCategories(restaurantId);
        return ResponseEntity.ok(categories);
    }
    
    @GetMapping("/category/{category}")
    @Operation(summary = "Get items by category", description = "Get menu items by category")
    public ResponseEntity<List<MenuItemSummaryResponse>> getMenuItemsByCategory(
            @PathVariable Long restaurantId,
            @PathVariable String category) {
        
        List<MenuItem> menuItems = menuItemService.getMenuItemsByCategory(restaurantId, category);
        List<MenuItemSummaryResponse> responses = menuItemMapper.toSummaryResponseList(menuItems);
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/search")
    @Operation(summary = "Search menu items", description = "Search menu items by name or description")
    public ResponseEntity<List<MenuItemSummaryResponse>> searchMenuItems(
            @PathVariable Long restaurantId,
            @RequestParam String q) {
        
        List<MenuItem> menuItems = menuItemService.searchMenuItems(restaurantId, q);
        List<MenuItemSummaryResponse> responses = menuItemMapper.toSummaryResponseList(menuItems);
        return ResponseEntity.ok(responses);
    }
    
    @PutMapping("/{menuItemId}")
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('RESTAURANT_STAFF')")
    @Operation(summary = "Update menu item", description = "Update menu item (Owner/Staff only)")
    public ResponseEntity<MenuItemResponse> updateMenuItem(
            @PathVariable Long restaurantId,
            @PathVariable Long menuItemId,
            @Valid @RequestBody UpdateMenuItemRequest request,
            Authentication authentication) {
        
        User currentUser = userService.findByEmail(authentication.getName());
        
        MenuItem menuItem = menuItemService.updateMenuItem(menuItemId, request, currentUser);
        MenuItemResponse response = menuItemMapper.toResponse(menuItem);
        return ResponseEntity.ok(response);
    }
    
    @PutMapping("/{menuItemId}/toggle-availability")
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('RESTAURANT_STAFF')")
    @Operation(summary = "Toggle availability", description = "Toggle menu item availability (Owner/Staff only)")
    public ResponseEntity<MenuItemResponse> toggleAvailability(
            @PathVariable Long restaurantId,
            @PathVariable Long menuItemId,
            Authentication authentication) {
        
        User currentUser = userService.findByEmail(authentication.getName());
        MenuItem menuItem = menuItemService.toggleAvailability(menuItemId, currentUser);
        MenuItemResponse response = menuItemMapper.toResponse(menuItem);
        return ResponseEntity.ok(response);
    }
    
    @DeleteMapping("/{menuItemId}")
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('RESTAURANT_STAFF')")
    @Operation(summary = "Delete menu item", description = "Delete menu item (Owner/Staff only)")
    public ResponseEntity<MessageResponse> deleteMenuItem(
            @PathVariable Long restaurantId,
            @PathVariable Long menuItemId,
            Authentication authentication) {
        
        User currentUser = userService.findByEmail(authentication.getName());
        menuItemService.deleteMenuItem(menuItemId, currentUser);
        return ResponseEntity.ok(new MessageResponse("Menu item deleted successfully"));
    }
    
    @GetMapping("/{menuItemId}")
    @Operation(summary = "Get menu item by ID", description = "Get detailed information of a menu item")
    public ResponseEntity<MenuItemResponse> getMenuItemById(
            @PathVariable Long restaurantId,
            @PathVariable Long menuItemId) {
        
        MenuItem menuItem = menuItemService.getMenuItemById(menuItemId);
        MenuItemResponse response = menuItemMapper.toResponse(menuItem);
        return ResponseEntity.ok(response);
    }
    
}