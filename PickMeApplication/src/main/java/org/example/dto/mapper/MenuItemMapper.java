package org.example.dto.mapper;

import org.example.dto.request.CreateMenuItemRequest;
import org.example.dto.request.UpdateMenuItemRequest;
import org.example.dto.response.MenuItemResponse;
import org.example.dto.response.MenuItemSummaryResponse;
import org.example.entity.MenuItem;
import org.example.entity.Restaurant;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Mapper để chuyển đổi giữa MenuItem Entity và DTOs
 */
@Component
public class MenuItemMapper {
    
    /**
     * Chuyển đổi từ MenuItem Entity sang MenuItemResponse
     */
    public MenuItemResponse toResponse(MenuItem menuItem) {
        if (menuItem == null) {
            return null;
        }
        
        MenuItemResponse response = new MenuItemResponse();
        response.setId(menuItem.getId());
        response.setName(menuItem.getName());
        response.setDescription(menuItem.getDescription());
        response.setPrice(menuItem.getPrice());
        response.setCategory(menuItem.getCategory());
        response.setImageUrl(menuItem.getImageUrl());
        response.setIsAvailable(menuItem.getIsAvailable());
        response.setPreparationTimeMinutes(menuItem.getPreparationTimeMinutes());
        response.setTags(menuItem.getTags());
        response.setCreatedAt(menuItem.getCreatedAt());
        response.setUpdatedAt(menuItem.getUpdatedAt());
        
        // Set restaurant info if available
        if (menuItem.getRestaurant() != null) {
            response.setRestaurantId(menuItem.getRestaurant().getId());
            response.setRestaurantName(menuItem.getRestaurant().getName());
        }
        
        return response;
    }
    
    /**
     * Chuyển đổi từ MenuItem Entity sang MenuItemSummaryResponse
     */
    public MenuItemSummaryResponse toSummaryResponse(MenuItem menuItem) {
        if (menuItem == null) {
            return null;
        }
        
        MenuItemSummaryResponse response = new MenuItemSummaryResponse();
        response.setId(menuItem.getId());
        response.setName(menuItem.getName());
        response.setDescription(menuItem.getDescription());
        response.setPrice(menuItem.getPrice());
        response.setCategory(menuItem.getCategory());
        response.setImageUrl(menuItem.getImageUrl());
        response.setIsAvailable(menuItem.getIsAvailable());
        response.setPreparationTimeMinutes(menuItem.getPreparationTimeMinutes());
        response.setTags(menuItem.getTags());
        
        return response;
    }
    
    /**
     * Chuyển đổi từ CreateMenuItemRequest sang MenuItem Entity
     */
    public MenuItem toEntity(CreateMenuItemRequest request, Restaurant restaurant) {
        if (request == null) {
            return null;
        }
        
        MenuItem menuItem = new MenuItem();
        menuItem.setRestaurant(restaurant);
        menuItem.setName(request.getName());
        menuItem.setDescription(request.getDescription());
        menuItem.setPrice(request.getPrice());
        menuItem.setCategory(request.getCategory());
        menuItem.setImageUrl(request.getImageUrl());
        menuItem.setIsAvailable(request.getIsAvailable());
        menuItem.setPreparationTimeMinutes(request.getPreparationTimeMinutes());
        menuItem.setTags(request.getTags());
        
        return menuItem;
    }
    
    /**
     * Cập nhật MenuItem Entity từ UpdateMenuItemRequest
     * Chỉ cập nhật các field không null
     */
    public void updateEntity(MenuItem menuItem, UpdateMenuItemRequest request) {
        if (menuItem == null || request == null) {
            return;
        }
        
        if (request.hasName()) {
            menuItem.setName(request.getName());
        }
        
        if (request.hasDescription()) {
            menuItem.setDescription(request.getDescription());
        }
        
        if (request.hasPrice()) {
            menuItem.setPrice(request.getPrice());
        }
        
        if (request.hasCategory()) {
            menuItem.setCategory(request.getCategory());
        }
        
        if (request.hasImageUrl()) {
            menuItem.setImageUrl(request.getImageUrl());
        }
        
        if (request.hasIsAvailable()) {
            menuItem.setIsAvailable(request.getIsAvailable());
        }
        
        if (request.hasPreparationTime()) {
            menuItem.setPreparationTimeMinutes(request.getPreparationTimeMinutes());
        }
        
        if (request.hasTags()) {
            menuItem.setTags(request.getTags());
        }
    }
    
    /**
     * Chuyển đổi List<MenuItem> sang List<MenuItemResponse>
     */
    public List<MenuItemResponse> toResponseList(List<MenuItem> menuItems) {
        if (menuItems == null) {
            return null;
        }
        
        return menuItems.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }
    
    /**
     * Chuyển đổi List<MenuItem> sang List<MenuItemSummaryResponse>
     */
    public List<MenuItemSummaryResponse> toSummaryResponseList(List<MenuItem> menuItems) {
        if (menuItems == null) {
            return null;
        }
        
        return menuItems.stream()
                .map(this::toSummaryResponse)
                .collect(Collectors.toList());
    }
}