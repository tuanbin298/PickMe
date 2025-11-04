package org.example.dto.mapper;

import org.example.dto.response.*;
import org.example.entity.*;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class CartMapper {
    
    public CartResponse toResponse(Cart cart) {
        if (cart == null) {
            return null;
        }
        
        CartResponse response = new CartResponse();
        response.setId(cart.getId());
        
        // Restaurant info
        if (cart.getRestaurant() != null) {
            RestaurantSummaryResponse restaurantResponse = new RestaurantSummaryResponse();
            restaurantResponse.setId(cart.getRestaurant().getId());
            restaurantResponse.setName(cart.getRestaurant().getName());
            restaurantResponse.setAddress(cart.getRestaurant().getAddress());
            restaurantResponse.setImageUrl(cart.getRestaurant().getImageUrl());
            restaurantResponse.setOpeningTime(cart.getRestaurant().getOpeningTime());
            restaurantResponse.setClosingTime(cart.getRestaurant().getClosingTime());
            restaurantResponse.setRating(cart.getRestaurant().getRating());
            restaurantResponse.setIsOpen(cart.getRestaurant().isOpen());
            
            // Location
            if (cart.getRestaurant().getLocation() != null) {
                restaurantResponse.setLatitude(cart.getRestaurant().getLocation().getY());
                restaurantResponse.setLongitude(cart.getRestaurant().getLocation().getX());
            }
            
            response.setRestaurant(restaurantResponse);
        }
        
        // Cart items
        if (cart.getCartItems() != null) {
            List<CartItemResponse> cartItemResponses = cart.getCartItems().stream()
                .map(this::toCartItemResponse)
                .collect(Collectors.toList());
            response.setCartItems(cartItemResponses);
        }
        
        // Pricing info
        response.setSubtotal(cart.getSubtotal());
        response.setTotalAmount(cart.getTotalAmount());
        response.setTotalItems(cart.getTotalItems());
        
        // Status and timestamps
        response.setStatus(cart.getStatus());
        response.setCreatedAt(cart.getCreatedAt());
        response.setUpdatedAt(cart.getUpdatedAt());
        
        return response;
    }
    
    public CartItemResponse toCartItemResponse(CartItem cartItem) {
        if (cartItem == null) {
            return null;
        }
        
        CartItemResponse response = new CartItemResponse();
        response.setId(cartItem.getId());
        
        // Menu item info (from snapshot)
        response.setMenuItemId(cartItem.getMenuItem() != null ? cartItem.getMenuItem().getId() : null);
        response.setMenuItemName(cartItem.getMenuItemName());
        response.setMenuItemDescription(cartItem.getMenuItemDescription());
        response.setMenuItemCategory(cartItem.getMenuItemCategory());
        response.setMenuItemImageUrl(cartItem.getMenuItemImageUrl());
        
        // Cart item details
        response.setQuantity(cartItem.getQuantity());
        response.setUnitPrice(cartItem.getUnitPrice());
        response.setSubtotal(cartItem.getSubtotal());
        response.setTotalPrice(cartItem.getTotalPrice());
        response.setSpecialInstructions(cartItem.getSpecialInstructions());
        
        // Add-ons
        if (cartItem.getAddOns() != null) {
            List<CartItemAddOnResponse> addOnResponses = cartItem.getAddOns().stream()
                .map(this::toCartItemAddOnResponse)
                .collect(Collectors.toList());
            response.setAddOns(addOnResponses);
        }
        
        response.setCreatedAt(cartItem.getCreatedAt());
        
        return response;
    }
    
    public CartItemAddOnResponse toCartItemAddOnResponse(CartItemAddOn addOn) {
        if (addOn == null) {
            return null;
        }
        
        CartItemAddOnResponse response = new CartItemAddOnResponse();
        response.setId(addOn.getId());
        response.setName(addOn.getName());
        response.setDescription(addOn.getDescription());
        response.setPrice(addOn.getPrice());
        
        return response;
    }
    
    public List<CartResponse> toResponseList(List<Cart> carts) {
        if (carts == null) {
            return null;
        }
        
        return carts.stream()
            .map(this::toResponse)
            .collect(Collectors.toList());
    }
    
    // Summary response for cart list (lighter version)
    public CartResponse toSummaryResponse(Cart cart) {
        if (cart == null) {
            return null;
        }
        
        CartResponse response = new CartResponse();
        response.setId(cart.getId());
        
        // Basic restaurant info only
        if (cart.getRestaurant() != null) {
            RestaurantSummaryResponse restaurantResponse = new RestaurantSummaryResponse();
            restaurantResponse.setId(cart.getRestaurant().getId());
            restaurantResponse.setName(cart.getRestaurant().getName());
            restaurantResponse.setImageUrl(cart.getRestaurant().getImageUrl());
            response.setRestaurant(restaurantResponse);
        }
        
        // Basic info
        response.setSubtotal(cart.getSubtotal());
        response.setTotalAmount(cart.getTotalAmount());
        response.setTotalItems(cart.getTotalItems());
        response.setStatus(cart.getStatus());
        response.setCreatedAt(cart.getCreatedAt());
        response.setUpdatedAt(cart.getUpdatedAt());
        
        return response;
    }
    
    public List<CartResponse> toSummaryResponseList(List<Cart> carts) {
        if (carts == null) {
            return null;
        }
        
        return carts.stream()
            .map(this::toSummaryResponse)
            .collect(Collectors.toList());
    }
}