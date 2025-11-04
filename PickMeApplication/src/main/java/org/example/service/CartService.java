package org.example.service;

import org.example.dto.request.AddToCartRequest;
import org.example.dto.request.CheckoutCartRequest;
import org.example.dto.request.AddOnRequest;
import org.example.entity.*;
import org.example.exception.AccessDeniedException;
import org.example.repository.CartRepository;
import org.example.repository.MenuItemAddOnRepository;
import org.example.repository.MenuItemRepository;
import org.example.repository.RestaurantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CartService {
    
    @Autowired
    private CartRepository cartRepository;
    
    @Autowired
    private RestaurantRepository restaurantRepository;
    
    @Autowired
    private MenuItemRepository menuItemRepository;
    
    @Autowired
    private MenuItemAddOnRepository menuItemAddOnRepository;
    
    @Autowired
    private OrderService orderService;
    
    /**
     * Get or create active cart for customer and restaurant
     */
    public Cart getOrCreateCart(Long customerId, Long restaurantId) {
        // Check if customer has active cart with this restaurant
        Optional<Cart> existingCart = cartRepository.findActiveCartByCustomerAndRestaurant(customerId, restaurantId);
        
        if (existingCart.isPresent()) {
            return existingCart.get();
        }
        
        // Validate restaurant
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
            .orElseThrow(() -> new IllegalArgumentException("Restaurant not found"));
        
        if (!restaurant.isApproved() || !restaurant.getIsActive()) {
            throw new IllegalArgumentException("Restaurant is not available");
        }
        
        // Create new cart for this restaurant
        // Note: Customer can now have multiple active carts, one per restaurant
        User customer = new User();
        customer.setId(customerId);
        
        Cart cart = new Cart(customer, restaurant);
        return cartRepository.save(cart);
    }
    
    /**
     * Add item to cart
     */
    public Cart addToCart(AddToCartRequest request, User customer) {
        Cart cart = getOrCreateCart(customer.getId(), request.getRestaurantId());
        
        // Validate menu item
        MenuItem menuItem = menuItemRepository.findById(request.getMenuItemId())
            .orElseThrow(() -> new IllegalArgumentException("Menu item not found"));
        
        if (!menuItem.getRestaurant().getId().equals(request.getRestaurantId())) {
            throw new IllegalArgumentException("Menu item does not belong to this restaurant");
        }
        
        if (!menuItem.getIsAvailable()) {
            throw new IllegalArgumentException("Menu item is not available: " + menuItem.getName());
        }
        
        // Add item to cart
        cart.addCartItem(menuItem, request.getQuantity(), request.getSpecialInstructions());
        
        // Add add-ons if any
        if (request.getAddOns() != null && !request.getAddOns().isEmpty()) {
            CartItem lastCartItem = cart.getCartItems().get(cart.getCartItems().size() - 1);
            for (AddOnRequest addOnRequest : request.getAddOns()) {
                // Validate and get MenuItemAddOn
                MenuItemAddOn menuItemAddOn = menuItemAddOnRepository.findById(addOnRequest.getMenuItemAddOnId())
                    .orElseThrow(() -> new IllegalArgumentException("Add-on not found: " + addOnRequest.getMenuItemAddOnId()));
                
                // Security check: Ensure add-on belongs to the menu item
                if (!menuItemAddOn.getMenuItem().getId().equals(request.getMenuItemId())) {
                    throw new IllegalArgumentException("Add-on doesn't belong to this menu item");
                }
                
                // Availability check
                if (!menuItemAddOn.isAvailableForSelection()) {
                    throw new IllegalArgumentException("Add-on is not available: " + menuItemAddOn.getName());
                }
                
                // Quantity validation
                if (menuItemAddOn.getMaxQuantity() != null && 
                    addOnRequest.getQuantity() > menuItemAddOn.getMaxQuantity()) {
                    throw new IllegalArgumentException("Exceeded maximum quantity for add-on: " + menuItemAddOn.getName());
                }
                
                // Add the validated add-on
                lastCartItem.addAddOn(
                    menuItemAddOn.getName(),
                    menuItemAddOn.getDescription(),
                    menuItemAddOn.getPrice(),
                    addOnRequest.getQuantity()
                );
            }
            lastCartItem.recalculatePrices();
        }
        
        return cartRepository.save(cart);
    }
    
    /**
     * Get customer's active cart for specific restaurant
     */
    public Optional<Cart> getActiveCart(Long customerId, Long restaurantId) {
        return cartRepository.findActiveCartByCustomerAndRestaurant(customerId, restaurantId);
    }
    
    /**
     * Get customer's active cart (backwards compatibility - returns first active cart if any)
     */
    public Optional<Cart> getActiveCart(Long customerId) {
        List<Cart> activeCarts = getAllActiveCarts(customerId);
        return activeCarts.isEmpty() ? Optional.empty() : Optional.of(activeCarts.get(0));
    }
    
    /**
     * Get all active carts for customer (one per restaurant)
     */
    public List<Cart> getAllActiveCarts(Long customerId) {
        return cartRepository.findAllActiveCartsByCustomer(customerId);
    }
    
    /**
     * Update cart item quantity
     */
    public Cart updateCartItemQuantity(Long cartId, Long cartItemId, Integer newQuantity, User customer) {
        Cart cart = getCartById(cartId, customer);
        
        if (newQuantity <= 0) {
            cart.removeCartItem(cartItemId);
        } else {
            cart.updateCartItemQuantity(cartItemId, newQuantity);
        }
        
        return cartRepository.save(cart);
    }
    
    /**
     * Remove item from cart
     */
    public Cart removeFromCart(Long cartId, Long cartItemId, User customer) {
        Cart cart = getCartById(cartId, customer);
        cart.removeCartItem(cartItemId);
        return cartRepository.save(cart);
    }
    
    /**
     * Clear cart
     */
    public Cart clearCart(Long cartId, User customer) {
        Cart cart = getCartById(cartId, customer);
        cart.clearCart();
        return cartRepository.save(cart);
    }
    
    /**
     * Checkout cart - convert to order
     */
    public Order checkoutCart(Long cartId, CheckoutCartRequest request, User customer) {
        Cart cart = getCartById(cartId, customer);
        
        if (cart.isEmpty()) {
            throw new IllegalArgumentException("Cart is empty");
        }
        
        if (!cart.isActive()) {
            throw new IllegalArgumentException("Cart is not active");
        }
        
        // Create order using new method
        Order order = orderService.createOrderFromCart(
            cart, 
            request.getDeliveryAddress(), 
            request.getPreferredPickupTime(), 
            request.getSpecialInstructions()
        );
        
        // Mark cart as converted
        cart.convertToOrder();
        cartRepository.save(cart);
        
        return order;
    }
    
    /**
     * Get cart by ID with access validation
     */
    public Cart getCartById(Long cartId, User customer) {
        Cart cart = cartRepository.findById(cartId)
            .orElseThrow(() -> new IllegalArgumentException("Cart not found"));
        
        if (!cart.getCustomer().getId().equals(customer.getId())) {
            throw new AccessDeniedException("You can only access your own cart");
        }
        
        return cart;
    }
    
    /**
     * Get customer's cart history
     */
    public List<Cart> getCartHistory(Long customerId) {
        return cartRepository.findCartsByCustomer(customerId);
    }
    
    /**
     * Clean up expired carts (run periodically)
     */
    @Transactional
    public void cleanupExpiredCarts() {
        LocalDateTime expireTime = LocalDateTime.now().minusHours(24); // 24 hours
        List<Cart> expiredCarts = cartRepository.findExpiredCarts(expireTime);
        
        for (Cart cart : expiredCarts) {
            cart.expire();
        }
        
        cartRepository.saveAll(expiredCarts);
        
        // Optionally delete very old expired carts
        cartRepository.deleteExpiredCarts();
    }
    
}