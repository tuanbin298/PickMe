package org.example.dto.mapper;

import org.example.dto.response.*;
import org.example.entity.*;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class OrderMapper {
    
    public OrderResponse toResponse(Order order) {
        if (order == null) {
            return null;
        }
        
        OrderResponse response = new OrderResponse();
        response.setId(order.getId());
        response.setQrCode(order.getQrCode());
        
        // Customer info
        if (order.getCustomer() != null) {
            UserResponse customerResponse = new UserResponse();
            customerResponse.setId(order.getCustomer().getId());
            customerResponse.setEmail(order.getCustomer().getEmail());
            customerResponse.setFullName(order.getCustomer().getFullName());
            customerResponse.setPhoneNumber(order.getCustomer().getPhoneNumber());
            response.setCustomer(customerResponse);
        }
        
        // Restaurant info
        if (order.getRestaurant() != null) {
            RestaurantSummaryResponse restaurantResponse = new RestaurantSummaryResponse();
            restaurantResponse.setId(order.getRestaurant().getId());
            restaurantResponse.setName(order.getRestaurant().getName());
            restaurantResponse.setAddress(order.getRestaurant().getAddress());
            restaurantResponse.setImageUrl(order.getRestaurant().getImageUrl());
            restaurantResponse.setOpeningTime(order.getRestaurant().getOpeningTime());
            restaurantResponse.setClosingTime(order.getRestaurant().getClosingTime());
            restaurantResponse.setRating(order.getRestaurant().getRating());
            restaurantResponse.setIsOpen(order.getRestaurant().isOpen());
            
            // Location
            if (order.getRestaurant().getLocation() != null) {
                restaurantResponse.setLatitude(order.getRestaurant().getLocation().getY());
                restaurantResponse.setLongitude(order.getRestaurant().getLocation().getX());
            }
            
            response.setRestaurant(restaurantResponse);
        }
        
        // Location info
        response.setDeliveryAddress(order.getDeliveryAddress());
        if (order.getPickupLocation() != null) {
            response.setPickupLatitude(order.getPickupLocation().getY());
            response.setPickupLongitude(order.getPickupLocation().getX());
        }
        if (order.getCurrentLocation() != null) {
            response.setCurrentLatitude(order.getCurrentLocation().getY());
            response.setCurrentLongitude(order.getCurrentLocation().getX());
        }
        
        // Time info
        response.setPreferredPickupTime(order.getPreferredPickupTime());
        response.setEstimatedReadyTime(order.getEstimatedReadyTime());
        response.setActualReadyTime(order.getActualReadyTime());
        response.setPickupTime(order.getPickupTime());
        
        // Pricing info
        response.setSubtotal(order.getSubtotal());
        response.setDeliveryFee(order.getDeliveryFee());
        response.setServiceFee(order.getServiceFee());
        response.setDiscountAmount(order.getDiscountAmount());
        response.setTotalAmount(order.getTotalAmount());
        
        // Status info
        response.setStatus(order.getStatus());
        response.setPaymentStatus(order.getPaymentStatus());
        response.setSpecialInstructions(order.getSpecialInstructions());
        
        // Order items
        if (order.getOrderItems() != null) {
            List<OrderItemResponse> orderItemResponses = order.getOrderItems().stream()
                .map(this::toOrderItemResponse)
                .collect(Collectors.toList());
            response.setOrderItems(orderItemResponses);
        }
        
        response.setTotalItems(order.getTotalItems());
        response.setCreatedAt(order.getCreatedAt());
        response.setUpdatedAt(order.getUpdatedAt());
        
        return response;
    }
    
    public OrderItemResponse toOrderItemResponse(OrderItem orderItem) {
        if (orderItem == null) {
            return null;
        }
        
        OrderItemResponse response = new OrderItemResponse();
        response.setId(orderItem.getId());
        
        // Menu item info (from snapshot)
        response.setMenuItemId(orderItem.getMenuItem() != null ? orderItem.getMenuItem().getId() : null);
        response.setMenuItemName(orderItem.getMenuItemName());
        response.setMenuItemDescription(orderItem.getMenuItemDescription());
        response.setMenuItemCategory(orderItem.getMenuItemCategory());
        response.setMenuItemImageUrl(orderItem.getMenuItemImageUrl());
        
        // Order item details
        response.setQuantity(orderItem.getQuantity());
        response.setUnitPrice(orderItem.getUnitPrice());
        response.setSubtotal(orderItem.getSubtotal());
        response.setTotalPrice(orderItem.getTotalPrice());
        response.setSpecialInstructions(orderItem.getSpecialInstructions());
        
        // Add-ons
        if (orderItem.getAddOns() != null) {
            List<OrderAddOnResponse> addOnResponses = orderItem.getAddOns().stream()
                .map(this::toOrderAddOnResponse)
                .collect(Collectors.toList());
            response.setAddOns(addOnResponses);
        }
        
        response.setCreatedAt(orderItem.getCreatedAt());
        
        return response;
    }
    
    public OrderAddOnResponse toOrderAddOnResponse(OrderAddOn addOn) {
        if (addOn == null) {
            return null;
        }
        
        OrderAddOnResponse response = new OrderAddOnResponse();
        response.setId(addOn.getId());
        response.setName(addOn.getName());
        response.setDescription(addOn.getDescription());
        response.setPrice(addOn.getPrice());
        
        return response;
    }
    
    public List<OrderResponse> toResponseList(List<Order> orders) {
        if (orders == null) {
            return null;
        }
        
        return orders.stream()
            .map(this::toResponse)
            .collect(Collectors.toList());
    }
    
    // Summary response for lists (lighter version)
    public OrderResponse toSummaryResponse(Order order) {
        if (order == null) {
            return null;
        }
        
        OrderResponse response = new OrderResponse();
        response.setId(order.getId());
        response.setQrCode(order.getQrCode());
        
        // Basic restaurant info only
        if (order.getRestaurant() != null) {
            RestaurantSummaryResponse restaurantResponse = new RestaurantSummaryResponse();
            restaurantResponse.setId(order.getRestaurant().getId());
            restaurantResponse.setName(order.getRestaurant().getName());
            restaurantResponse.setImageUrl(order.getRestaurant().getImageUrl());
            response.setRestaurant(restaurantResponse);
        }
        
        // Time and status info
        response.setPreferredPickupTime(order.getPreferredPickupTime());
        response.setEstimatedReadyTime(order.getEstimatedReadyTime());
        response.setStatus(order.getStatus());
        response.setPaymentStatus(order.getPaymentStatus());
        response.setTotalAmount(order.getTotalAmount());
        response.setTotalItems(order.getTotalItems());
        response.setCreatedAt(order.getCreatedAt());
        
        return response;
    }
    
    public List<OrderResponse> toSummaryResponseList(List<Order> orders) {
        if (orders == null) {
            return null;
        }
        
        return orders.stream()
            .map(this::toSummaryResponse)
            .collect(Collectors.toList());
    }
}