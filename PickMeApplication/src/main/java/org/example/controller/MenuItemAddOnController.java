package org.example.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.example.dto.request.CreateMenuItemAddOnRequest;
import org.example.dto.request.UpdateMenuItemAddOnRequest;
import org.example.dto.response.MenuItemAddOnResponse;
import org.example.dto.response.MessageResponse;
import org.example.entity.MenuItemAddOn;
import org.example.entity.User;
import org.example.service.MenuItemAddOnService;
import org.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/menu-items/{menuItemId}/add-ons")
@Tag(name = "Menu Item Add-ons", description = "APIs for managing menu item add-ons")
@SecurityRequirement(name = "Bearer Authentication")
public class MenuItemAddOnController {
    
    @Autowired
    private MenuItemAddOnService menuItemAddOnService;
    
    @Autowired
    private UserService userService;
    
    // Public endpoints for customers
    
    @GetMapping
    @Operation(summary = "Get menu item add-ons", description = "Get all available add-ons for a menu item")
    public ResponseEntity<List<MenuItemAddOnResponse>> getMenuItemAddOns(@PathVariable Long menuItemId) {
        List<MenuItemAddOn> addOns = menuItemAddOnService.getAddOnsByMenuItem(menuItemId);
        List<MenuItemAddOnResponse> responses = addOns.stream()
            .map(this::toResponse)
            .toList();
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/categories")
    @Operation(summary = "Get add-on categories", description = "Get all add-on categories for a menu item")
    public ResponseEntity<List<String>> getAddOnCategories(@PathVariable Long menuItemId) {
        List<String> categories = menuItemAddOnService.getCategories(menuItemId);
        return ResponseEntity.ok(categories);
    }
    
    @GetMapping("/category/{category}")
    @Operation(summary = "Get add-ons by category", description = "Get add-ons filtered by category")
    public ResponseEntity<List<MenuItemAddOnResponse>> getAddOnsByCategory(
            @PathVariable Long menuItemId,
            @PathVariable String category) {
        
        List<MenuItemAddOn> addOns = menuItemAddOnService.getAddOnsByCategory(menuItemId, category);
        List<MenuItemAddOnResponse> responses = addOns.stream()
            .map(this::toResponse)
            .toList();
        return ResponseEntity.ok(responses);
    }
    
    // Restaurant owner/staff endpoints
    
    @PostMapping
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    @Operation(summary = "Create add-on", description = "Create new add-on for menu item")
    public ResponseEntity<MenuItemAddOnResponse> createAddOn(
            @PathVariable Long menuItemId,
            @Valid @RequestBody CreateMenuItemAddOnRequest request,
            Authentication authentication) {
        
        User user = userService.findByEmail(authentication.getName());
        
        MenuItemAddOn addOn = menuItemAddOnService.createAddOn(
            menuItemId,
            request.getName(),
            request.getDescription(),
            request.getPrice(),
            request.getCategory(),
            user
        );
        
        return ResponseEntity.ok(toResponse(addOn));
    }
    
    @PutMapping("/{addOnId}")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    @Operation(summary = "Update add-on", description = "Update existing add-on")
    public ResponseEntity<MenuItemAddOnResponse> updateAddOn(
            @PathVariable Long menuItemId,
            @PathVariable Long addOnId,
            @Valid @RequestBody UpdateMenuItemAddOnRequest request,
            Authentication authentication) {
        
        User user = userService.findByEmail(authentication.getName());
        
        MenuItemAddOn addOn = menuItemAddOnService.updateAddOn(
            addOnId,
            request.getName(),
            request.getDescription(),
            request.getPrice(),
            request.getCategory(),
            request.getIsAvailable(),
            user
        );
        
        return ResponseEntity.ok(toResponse(addOn));
    }
    
    @DeleteMapping("/{addOnId}")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    @Operation(summary = "Delete add-on", description = "Delete add-on from menu item")
    public ResponseEntity<MessageResponse> deleteAddOn(
            @PathVariable Long menuItemId,
            @PathVariable Long addOnId,
            Authentication authentication) {
        
        User user = userService.findByEmail(authentication.getName());
        menuItemAddOnService.deleteAddOn(addOnId, user);
        
        return ResponseEntity.ok(new MessageResponse("Add-on deleted successfully"));
    }
    
    @PutMapping("/{addOnId}/toggle-availability")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    @Operation(summary = "Toggle add-on availability", description = "Toggle add-on availability status")
    public ResponseEntity<MenuItemAddOnResponse> toggleAvailability(
            @PathVariable Long menuItemId,
            @PathVariable Long addOnId,
            Authentication authentication) {
        
        User user = userService.findByEmail(authentication.getName());
        MenuItemAddOn addOn = menuItemAddOnService.toggleAvailability(addOnId, user);
        
        return ResponseEntity.ok(toResponse(addOn));
    }
    
    @PutMapping("/{addOnId}/display-order")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    @Operation(summary = "Update display order", description = "Update add-on display order")
    public ResponseEntity<MenuItemAddOnResponse> updateDisplayOrder(
            @PathVariable Long menuItemId,
            @PathVariable Long addOnId,
            @RequestParam Integer displayOrder,
            Authentication authentication) {
        
        User user = userService.findByEmail(authentication.getName());
        MenuItemAddOn addOn = menuItemAddOnService.updateDisplayOrder(addOnId, displayOrder, user);
        
        return ResponseEntity.ok(toResponse(addOn));
    }
    
    // Helper method
    private MenuItemAddOnResponse toResponse(MenuItemAddOn addOn) {
        MenuItemAddOnResponse response = new MenuItemAddOnResponse();
        response.setId(addOn.getId());
        response.setName(addOn.getName());
        response.setDescription(addOn.getDescription());
        response.setPrice(addOn.getPrice());
        response.setCategory(addOn.getCategory());
        response.setIsAvailable(addOn.getIsAvailable());
        response.setDisplayOrder(addOn.getDisplayOrder());
        response.setMaxQuantity(addOn.getMaxQuantity());
        response.setIsRequired(addOn.getIsRequired());
        return response;
    }
}