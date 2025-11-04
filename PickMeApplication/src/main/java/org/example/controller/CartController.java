package org.example.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.example.dto.mapper.CartMapper;
import org.example.dto.mapper.OrderMapper;
import org.example.dto.request.AddToCartRequest;
import org.example.dto.request.CheckoutCartRequest;
import org.example.dto.response.CartResponse;
import org.example.dto.response.MessageResponse;
import org.example.dto.response.OrderResponse;
import org.example.entity.Cart;
import org.example.entity.Order;
import org.example.entity.User;
import org.example.service.CartService;
import org.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/cart")
@Tag(name = "Cart Management", description = "APIs for shopping cart management")
@SecurityRequirement(name = "Bearer Authentication")
@PreAuthorize("hasRole('CUSTOMER')")
public class CartController {
    
    @Autowired
    private CartService cartService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private CartMapper cartMapper;
    
    @Autowired
    private OrderMapper orderMapper;
    
    @PostMapping("/add")
    @Operation(summary = "Add item to cart", description = "Add a menu item to shopping cart")
    public ResponseEntity<CartResponse> addToCart(
            @Valid @RequestBody AddToCartRequest request,
            Authentication authentication) {
        
        User customer = userService.findByEmail(authentication.getName());
        Cart cart = cartService.addToCart(request, customer);
        CartResponse response = cartMapper.toResponse(cart);
        
        return ResponseEntity.ok(response);
    }
    
    @GetMapping
    @Operation(summary = "Get active carts", description = "Get customer's active shopping carts")
    public ResponseEntity<List<CartResponse>> getActiveCarts(Authentication authentication) {
        User customer = userService.findByEmail(authentication.getName());
        List<Cart> carts = cartService.getAllActiveCarts(customer.getId());
        
        if (carts.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        
        List<CartResponse> responses = cartMapper.toResponseList(carts);
        return ResponseEntity.ok(responses);
    }
    
    @GetMapping("/restaurant/{restaurantId}")
    @Operation(summary = "Get active cart for restaurant", description = "Get customer's active cart for specific restaurant")
    public ResponseEntity<CartResponse> getActiveCartForRestaurant(
            @PathVariable Long restaurantId,
            Authentication authentication) {
        User customer = userService.findByEmail(authentication.getName());
        Optional<Cart> cart = cartService.getActiveCart(customer.getId(), restaurantId);
        
        if (cart.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        
        CartResponse response = cartMapper.toResponse(cart.get());
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/{cartId}")
    @Operation(summary = "Get cart by ID", description = "Get specific cart by ID")
    public ResponseEntity<CartResponse> getCartById(
            @PathVariable Long cartId,
            Authentication authentication) {
        
        User customer = userService.findByEmail(authentication.getName());
        Cart cart = cartService.getCartById(cartId, customer);
        CartResponse response = cartMapper.toResponse(cart);
        
        return ResponseEntity.ok(response);
    }
    
    @PutMapping("/{cartId}/items/{cartItemId}/quantity")
    @Operation(summary = "Update item quantity", description = "Update quantity of item in cart")
    public ResponseEntity<CartResponse> updateCartItemQuantity(
            @PathVariable Long cartId,
            @PathVariable Long cartItemId,
            @RequestParam Integer quantity,
            Authentication authentication) {
        
        User customer = userService.findByEmail(authentication.getName());
        Cart cart = cartService.updateCartItemQuantity(cartId, cartItemId, quantity, customer);
        CartResponse response = cartMapper.toResponse(cart);
        
        return ResponseEntity.ok(response);
    }
    
    @DeleteMapping("/{cartId}/items/{cartItemId}")
    @Operation(summary = "Remove item from cart", description = "Remove a specific item from cart")
    public ResponseEntity<CartResponse> removeFromCart(
            @PathVariable Long cartId,
            @PathVariable Long cartItemId,
            Authentication authentication) {
        
        User customer = userService.findByEmail(authentication.getName());
        Cart cart = cartService.removeFromCart(cartId, cartItemId, customer);
        CartResponse response = cartMapper.toResponse(cart);
        
        return ResponseEntity.ok(response);
    }
    
    @DeleteMapping("/{cartId}/clear")
    @Operation(summary = "Clear cart", description = "Remove all items from cart")
    public ResponseEntity<MessageResponse> clearCart(
            @PathVariable Long cartId,
            Authentication authentication) {
        
        User customer = userService.findByEmail(authentication.getName());
        cartService.clearCart(cartId, customer);
        
        return ResponseEntity.ok(new MessageResponse("Cart cleared successfully"));
    }
    
    @PostMapping("/{cartId}/checkout")
    @Operation(summary = "Checkout cart", description = "Convert cart to order and proceed to checkout")
    public ResponseEntity<OrderResponse> checkoutCart(
            @PathVariable Long cartId,
            @Valid @RequestBody CheckoutCartRequest request,
            Authentication authentication) {
        
        User customer = userService.findByEmail(authentication.getName());
        Order order = cartService.checkoutCart(cartId, request, customer);
        OrderResponse response = orderMapper.toResponse(order);
        
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/history")
    @Operation(summary = "Get cart history", description = "Get customer's cart history")
    public ResponseEntity<List<CartResponse>> getCartHistory(Authentication authentication) {
        User customer = userService.findByEmail(authentication.getName());
        List<Cart> carts = cartService.getCartHistory(customer.getId());
        List<CartResponse> responses = cartMapper.toSummaryResponseList(carts);
        
        return ResponseEntity.ok(responses);
    }
    
    // Quick actions for better UX
    
    @PostMapping("/quick-add")
    @Operation(summary = "Quick add item", description = "Quickly add single item to cart with default quantity")
    public ResponseEntity<CartResponse> quickAddToCart(
            @RequestParam Long restaurantId,
            @RequestParam Long menuItemId,
            @RequestParam(defaultValue = "1") Integer quantity,
            Authentication authentication) {
        
        AddToCartRequest request = new AddToCartRequest();
        request.setRestaurantId(restaurantId);
        request.setMenuItemId(menuItemId);
        request.setQuantity(quantity);
        
        User customer = userService.findByEmail(authentication.getName());
        Cart cart = cartService.addToCart(request, customer);
        CartResponse response = cartMapper.toResponse(cart);
        
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/count")
    @Operation(summary = "Get total cart item count", description = "Get total number of items across all active carts")
    public ResponseEntity<Integer> getTotalCartItemCount(Authentication authentication) {
        User customer = userService.findByEmail(authentication.getName());
        List<Cart> carts = cartService.getAllActiveCarts(customer.getId());
        
        Integer totalCount = carts.stream()
            .mapToInt(Cart::getTotalItems)
            .sum();
        
        return ResponseEntity.ok(totalCount);
    }
    
    @GetMapping("/count/restaurant/{restaurantId}")
    @Operation(summary = "Get cart item count for restaurant", description = "Get number of items in cart for specific restaurant")
    public ResponseEntity<Integer> getCartItemCountForRestaurant(
            @PathVariable Long restaurantId,
            Authentication authentication) {
        User customer = userService.findByEmail(authentication.getName());
        Optional<Cart> cart = cartService.getActiveCart(customer.getId(), restaurantId);
        
        Integer count = cart.map(Cart::getTotalItems).orElse(0);
        return ResponseEntity.ok(count);
    }
    
    @GetMapping("/total")
    @Operation(summary = "Get total cart amount", description = "Get total amount across all active carts")
    public ResponseEntity<Double> getTotalCartAmount(Authentication authentication) {
        User customer = userService.findByEmail(authentication.getName());
        List<Cart> carts = cartService.getAllActiveCarts(customer.getId());
        
        Double totalAmount = carts.stream()
            .mapToDouble(c -> c.getTotalAmount().doubleValue())
            .sum();
        
        return ResponseEntity.ok(totalAmount);
    }
    
    @GetMapping("/total/restaurant/{restaurantId}")
    @Operation(summary = "Get cart total for restaurant", description = "Get total amount of cart for specific restaurant")
    public ResponseEntity<Double> getCartTotalForRestaurant(
            @PathVariable Long restaurantId,
            Authentication authentication) {
        User customer = userService.findByEmail(authentication.getName());
        Optional<Cart> cart = cartService.getActiveCart(customer.getId(), restaurantId);
        
        Double total = cart.map(c -> c.getTotalAmount().doubleValue()).orElse(0.0);
        return ResponseEntity.ok(total);
    }
}