package org.example.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "order_items", indexes = {
    @Index(name = "idx_orderitem_order_id", columnList = "order_id"),
    @Index(name = "idx_orderitem_menu_item_id", columnList = "menu_item_id"),
    @Index(name = "idx_orderitem_created_at", columnList = "created_at")
})
public class OrderItem {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // Relationships
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "menu_item_id", nullable = false)
    private MenuItem menuItem;
    
    // Order details
    @NotNull(message = "Quantity is required")
    @Min(value = 1, message = "Quantity must be at least 1")
    @Column(name = "quantity", nullable = false)
    private Integer quantity;
    
    // Pricing (snapshot tại thời điểm đặt hàng)
    @NotNull(message = "Unit price is required")
    @DecimalMin(value = "0.0", inclusive = false, message = "Unit price must be greater than 0")
    @Column(name = "unit_price", precision = 10, scale = 2, nullable = false)
    private BigDecimal unitPrice; // Giá tại thời điểm đặt (từ MenuItem)
    
    @NotNull(message = "Subtotal is required")
    @Column(name = "subtotal", precision = 10, scale = 2, nullable = false)
    private BigDecimal subtotal; // quantity * unitPrice
    
    @NotNull(message = "Total price is required")
    @Column(name = "total_price", precision = 10, scale = 2, nullable = false)
    private BigDecimal totalPrice; // subtotal + sum(addOns.price)
    
    // Customization
    @Column(name = "special_instructions", length = 500)
    private String specialInstructions; // "Không cay", "Ít đá", "Nướng vừa"
    
    // Add-ons relationship
    @OneToMany(mappedBy = "orderItem", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    private List<OrderAddOn> addOns = new ArrayList<>();
    
    // Snapshot của MenuItem info (để tránh mất dữ liệu khi MenuItem bị xóa/sửa)
    @Column(name = "menu_item_name", nullable = false)
    private String menuItemName;
    
    @Column(name = "menu_item_description")
    private String menuItemDescription;
    
    @Column(name = "menu_item_category")
    private String menuItemCategory;
    
    @Column(name = "menu_item_image_url")
    private String menuItemImageUrl;
    
    // Timestamps
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Constructors
    public OrderItem() {
        this.createdAt = LocalDateTime.now();
    }
    
    public OrderItem(Order order, MenuItem menuItem, Integer quantity, String specialInstructions) {
        this();
        this.order = order;
        this.menuItem = menuItem;
        this.quantity = quantity;
        this.specialInstructions = specialInstructions;
        
        // Snapshot pricing and info
        this.unitPrice = menuItem.getPrice();
        this.menuItemName = menuItem.getName();
        this.menuItemDescription = menuItem.getDescription();
        this.menuItemCategory = menuItem.getCategory();
        this.menuItemImageUrl = menuItem.getImageUrl();
        
        this.subtotal = calculateSubtotal();
        this.totalPrice = calculateTotalPrice();
    }
    
    // Business Logic Methods
    private BigDecimal calculateSubtotal() {
        return unitPrice.multiply(BigDecimal.valueOf(quantity));
    }
    
    private BigDecimal calculateTotalPrice() {
        BigDecimal addOnsTotal = addOns.stream()
            .map(OrderAddOn::getTotalPrice)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        return subtotal.add(addOnsTotal);
    }
    
    public void updateQuantity(Integer newQuantity) {
        if (newQuantity < 1) {
            throw new IllegalArgumentException("Quantity must be at least 1");
        }
        this.quantity = newQuantity;
        this.subtotal = calculateSubtotal();
        this.totalPrice = calculateTotalPrice();
        this.updatedAt = LocalDateTime.now();
    }
    
    public void addAddOn(String name, String description, BigDecimal price) {
        addAddOn(name, description, price, 1);
    }
    
    public void addAddOn(String name, String description, BigDecimal price, Integer quantity) {
        OrderAddOn addOn = new OrderAddOn(this, name, description, price, quantity);
        this.addOns.add(addOn);
        this.totalPrice = calculateTotalPrice();
        this.updatedAt = LocalDateTime.now();
    }
    
    public void removeAddOn(Long addOnId) {
        this.addOns.removeIf(addOn -> addOn.getId().equals(addOnId));
        this.totalPrice = calculateTotalPrice();
        this.updatedAt = LocalDateTime.now();
    }
    
    public void updateSpecialInstructions(String instructions) {
        this.specialInstructions = instructions;
        this.updatedAt = LocalDateTime.now();
    }
    
    // Recalculate prices (useful when add-ons change)
    public void recalculatePrices() {
        this.subtotal = calculateSubtotal();
        this.totalPrice = calculateTotalPrice();
        this.updatedAt = LocalDateTime.now();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Order getOrder() {
        return order;
    }
    
    public void setOrder(Order order) {
        this.order = order;
    }
    
    public MenuItem getMenuItem() {
        return menuItem;
    }
    
    public void setMenuItem(MenuItem menuItem) {
        this.menuItem = menuItem;
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
    
    public BigDecimal getUnitPrice() {
        return unitPrice;
    }
    
    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }
    
    public BigDecimal getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
    
    public BigDecimal getTotalPrice() {
        return totalPrice;
    }
    
    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
    
    public String getSpecialInstructions() {
        return specialInstructions;
    }
    
    public void setSpecialInstructions(String specialInstructions) {
        this.specialInstructions = specialInstructions;
    }
    
    public List<OrderAddOn> getAddOns() {
        return addOns;
    }
    
    public void setAddOns(List<OrderAddOn> addOns) {
        this.addOns = addOns;
    }
    
    public String getMenuItemName() {
        return menuItemName;
    }
    
    public void setMenuItemName(String menuItemName) {
        this.menuItemName = menuItemName;
    }
    
    public String getMenuItemDescription() {
        return menuItemDescription;
    }
    
    public void setMenuItemDescription(String menuItemDescription) {
        this.menuItemDescription = menuItemDescription;
    }
    
    public String getMenuItemCategory() {
        return menuItemCategory;
    }
    
    public void setMenuItemCategory(String menuItemCategory) {
        this.menuItemCategory = menuItemCategory;
    }
    
    public String getMenuItemImageUrl() {
        return menuItemImageUrl;
    }
    
    public void setMenuItemImageUrl(String menuItemImageUrl) {
        this.menuItemImageUrl = menuItemImageUrl;
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
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}