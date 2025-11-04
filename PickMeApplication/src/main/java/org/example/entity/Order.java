package org.example.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import org.locationtech.jts.geom.Point;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "orders", indexes = {
    @Index(name = "idx_order_customer_id", columnList = "user_id"),
    @Index(name = "idx_order_restaurant_id", columnList = "restaurant_id"),
    @Index(name = "idx_order_status", columnList = "status"),
    @Index(name = "idx_order_qr_code", columnList = "qr_code", unique = true),
    @Index(name = "idx_order_preferred_pickup_time", columnList = "preferred_pickup_time"),
    @Index(name = "idx_order_created_at", columnList = "created_at")
})
public class Order {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User customer;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "restaurant_id", nullable = false)
    private Restaurant restaurant;
    
    // QR Code for order identification
    @Column(name = "qr_code", unique = true, nullable = false)
    private String qrCode; // UUID-based unique QR code
    
    // Order Items
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    private List<OrderItem> orderItems = new ArrayList<>();
    
    // Location information
    @Column(name = "delivery_address", nullable = false)
    private String deliveryAddress;
    
    @Column(name = "pickup_location", columnDefinition = "POINT")
    private Point pickupLocation; // Vị trí khách hàng muốn lấy hàng
    
    @Column(name = "current_location", columnDefinition = "POINT")
    private Point currentLocation; // Vị trí hiện tại khi đặt hàng
    
    // Time information
    @Column(name = "preferred_pickup_time")
    private LocalDateTime preferredPickupTime; // Thời gian khách hàng muốn đến lấy
    
    @Column(name = "estimated_ready_time")
    private LocalDateTime estimatedReadyTime; // Thời gian dự kiến món ăn sẵn sàng
    
    @Column(name = "actual_ready_time")
    private LocalDateTime actualReadyTime; // Thời gian thực tế món ăn sẵn sàng
    
    @Column(name = "pickup_time")
    private LocalDateTime pickupTime; // Thời gian thực tế khách đến lấy
    
    // Order details
    @NotNull
    @Column(name = "total_amount", precision = 10, scale = 2)
    private BigDecimal totalAmount;
    
    @Column(name = "subtotal", precision = 10, scale = 2)
    private BigDecimal subtotal; // Tổng tiền món ăn (không bao gồm phí)
    
    @Column(name = "delivery_fee", precision = 10, scale = 2)
    private BigDecimal deliveryFee = BigDecimal.ZERO; // Phí giao hàng (nếu có)
    
    @Column(name = "service_fee", precision = 10, scale = 2)
    private BigDecimal serviceFee = BigDecimal.ZERO; // Phí dịch vụ
    
    @Column(name = "discount_amount", precision = 10, scale = 2)
    private BigDecimal discountAmount = BigDecimal.ZERO; // Số tiền giảm giá
    
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private OrderStatus status = OrderStatus.PENDING;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "payment_status", nullable = false)
    private PaymentStatus paymentStatus = PaymentStatus.PENDING;
    
    @Column(name = "special_instructions")
    private String specialInstructions;
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Constructors
    public Order() {
        this.createdAt = LocalDateTime.now();
        this.qrCode = generateQRCode();
        this.totalAmount = BigDecimal.ZERO;
        this.subtotal = BigDecimal.ZERO;
        this.status = OrderStatus.PENDING;
    }
    
    public Order(User customer, Restaurant restaurant, String deliveryAddress) {
        this();
        this.customer = customer;
        this.restaurant = restaurant;
        this.deliveryAddress = deliveryAddress;
    }
    
    // Business Logic Methods
    private String generateQRCode() {
        return "ORDER-" + UUID.randomUUID().toString().replace("-", "").toUpperCase().substring(0, 12);
    }
    
    public void addOrderItem(MenuItem menuItem, Integer quantity, String specialInstructions) {
        OrderItem orderItem = new OrderItem(this, menuItem, quantity, specialInstructions);
        this.orderItems.add(orderItem);
        recalculateTotals();
    }
    
    public void removeOrderItem(Long orderItemId) {
        this.orderItems.removeIf(item -> item.getId().equals(orderItemId));
        recalculateTotals();
    }
    
    public void updateOrderItemQuantity(Long orderItemId, Integer newQuantity) {
        OrderItem orderItem = orderItems.stream()
            .filter(item -> item.getId().equals(orderItemId))
            .findFirst()
            .orElseThrow(() -> new IllegalArgumentException("Order item not found"));
        
        orderItem.updateQuantity(newQuantity);
        recalculateTotals();
    }
    
    public void recalculateTotals() {
        // Handle empty orders
        if (orderItems == null || orderItems.isEmpty()) {
            this.subtotal = BigDecimal.ZERO;
            this.totalAmount = BigDecimal.ZERO;
            this.updatedAt = LocalDateTime.now();
            return;
        }
        
        this.subtotal = orderItems.stream()
            .map(OrderItem::getTotalPrice)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        this.totalAmount = subtotal
            .add(deliveryFee != null ? deliveryFee : BigDecimal.ZERO)
            .add(serviceFee != null ? serviceFee : BigDecimal.ZERO)
            .subtract(discountAmount != null ? discountAmount : BigDecimal.ZERO);
        
        this.updatedAt = LocalDateTime.now();
    }
    
    public void setPreferredPickupTime(LocalDateTime pickupTime) {
        this.preferredPickupTime = pickupTime;
        // Auto-calculate estimated ready time (pickup time - buffer)
        if (pickupTime != null) {
            this.estimatedReadyTime = pickupTime.minusMinutes(15); // 15 minutes buffer
        }
        this.updatedAt = LocalDateTime.now();
    }
    
    public void markAsReady() {
        this.status = OrderStatus.READY;
        this.actualReadyTime = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    public void markAsPickedUp() {
        this.status = OrderStatus.PICKED_UP;
        this.pickupTime = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    public void complete() {
        this.status = OrderStatus.COMPLETED;
        this.updatedAt = LocalDateTime.now();
    }
    
    public void cancel() {
        if (this.status == OrderStatus.PREPARING || this.status == OrderStatus.READY) {
            throw new IllegalStateException("Cannot cancel order that is already being prepared or ready");
        }
        this.status = OrderStatus.CANCELLED;
        this.updatedAt = LocalDateTime.now();
    }
    
    public void confirm() {
        if (this.status != OrderStatus.PENDING) {
            throw new IllegalStateException("Only pending orders can be confirmed");
        }
        
        if (isEmpty()) {
            throw new IllegalStateException("Cannot confirm empty order");
        }
        
        this.status = OrderStatus.CONFIRMED;
        this.updatedAt = LocalDateTime.now();
    }
    
    public void startPreparing() {
        if (this.status != OrderStatus.CONFIRMED) {
            throw new IllegalStateException("Only confirmed orders can start preparing");
        }
        this.status = OrderStatus.PREPARING;
        this.updatedAt = LocalDateTime.now();
    }
    
    public boolean canBeModified() {
        return this.status == OrderStatus.PENDING || this.status == OrderStatus.CONFIRMED;
    }
    
    public boolean isReadyForPickup() {
        return this.status == OrderStatus.READY;
    }
    
    public boolean isCompleted() {
        return this.status == OrderStatus.COMPLETED || this.status == OrderStatus.PICKED_UP;
    }
    
    public int getTotalItems() {
        if (orderItems == null || orderItems.isEmpty()) {
            return 0;
        }
        return orderItems.stream()
            .mapToInt(OrderItem::getQuantity)
            .sum();
    }
    
    public boolean isEmpty() {
        return orderItems == null || orderItems.isEmpty();
    }
    
    // Enums
    public enum OrderStatus {
        PENDING,        // Chờ xác nhận
        CONFIRMED,      // Đã xác nhận
        PREPARING,      // Đang chuẩn bị
        READY,          // Sẵn sàng lấy
        PICKED_UP,      // Đã lấy
        CANCELLED,      // Đã hủy
        COMPLETED       // Hoàn thành
    }
    
    public enum PaymentStatus {
        PENDING,        // Chờ thanh toán
        PAID,           // Đã thanh toán
        FAILED,         // Thanh toán thất bại
        REFUNDED        // Đã hoàn tiền
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public User getCustomer() {
        return customer;
    }
    
    public void setCustomer(User customer) {
        this.customer = customer;
    }
    
    public Restaurant getRestaurant() {
        return restaurant;
    }
    
    public void setRestaurant(Restaurant restaurant) {
        this.restaurant = restaurant;
    }
    
    public String getDeliveryAddress() {
        return deliveryAddress;
    }
    
    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }
    
    public Point getPickupLocation() {
        return pickupLocation;
    }
    
    public void setPickupLocation(Point pickupLocation) {
        this.pickupLocation = pickupLocation;
    }
    
    public Point getCurrentLocation() {
        return currentLocation;
    }
    
    public void setCurrentLocation(Point currentLocation) {
        this.currentLocation = currentLocation;
    }
    
    public LocalDateTime getPreferredPickupTime() {
        return preferredPickupTime;
    }
    
    public LocalDateTime getEstimatedReadyTime() {
        return estimatedReadyTime;
    }
    
    public void setEstimatedReadyTime(LocalDateTime estimatedReadyTime) {
        this.estimatedReadyTime = estimatedReadyTime;
    }
    
    public LocalDateTime getActualReadyTime() {
        return actualReadyTime;
    }
    
    public void setActualReadyTime(LocalDateTime actualReadyTime) {
        this.actualReadyTime = actualReadyTime;
    }
    
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public OrderStatus getStatus() {
        return status;
    }
    
    public void setStatus(OrderStatus status) {
        this.status = status;
    }
    
    public PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public String getSpecialInstructions() {
        return specialInstructions;
    }
    
    public void setSpecialInstructions(String specialInstructions) {
        this.specialInstructions = specialInstructions;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public String getQrCode() {
        return qrCode;
    }
    
    public void setQrCode(String qrCode) {
        this.qrCode = qrCode;
    }
    
    public List<OrderItem> getOrderItems() {
        return orderItems;
    }
    
    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }
    
    public LocalDateTime getPickupTime() {
        return pickupTime;
    }
    
    public void setPickupTime(LocalDateTime pickupTime) {
        this.pickupTime = pickupTime;
    }
    
    public BigDecimal getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
    
    public BigDecimal getDeliveryFee() {
        return deliveryFee;
    }
    
    public void setDeliveryFee(BigDecimal deliveryFee) {
        this.deliveryFee = deliveryFee;
    }
    
    public BigDecimal getServiceFee() {
        return serviceFee;
    }
    
    public void setServiceFee(BigDecimal serviceFee) {
        this.serviceFee = serviceFee;
    }
    
    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }
    
    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}