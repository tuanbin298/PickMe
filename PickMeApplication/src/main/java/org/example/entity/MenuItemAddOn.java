package org.example.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "menu_item_add_ons", indexes = {
    @Index(name = "idx_menu_item_addon_menu_item_id", columnList = "menu_item_id"),
    @Index(name = "idx_menu_item_addon_category", columnList = "category"),
    @Index(name = "idx_menu_item_addon_available", columnList = "is_available")
})
public class MenuItemAddOn {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "menu_item_id", nullable = false)
    private MenuItem menuItem;
    
    @NotBlank(message = "Add-on name is required")
    @Column(name = "name", nullable = false)
    private String name; // "Extra cheese", "Thêm trứng", "Size lớn"
    
    @Column(name = "description")
    private String description; // "Add extra cheese (+$2)", "Thêm 1 quả trứng ốp la"
    
    @NotNull(message = "Add-on price is required")
    @DecimalMin(value = "0.0", message = "Add-on price must be non-negative")
    @Column(name = "price", precision = 10, scale = 2, nullable = false)
    private BigDecimal price; // Giá add-on
    
    @Column(name = "category")
    private String category; // "Size", "Topping", "Extra", "Sauce", "Side"
    
    @Column(name = "is_available", nullable = false)
    private Boolean isAvailable = true;
    
    @Column(name = "display_order")
    private Integer displayOrder = 0; // Thứ tự hiển thị trong menu
    
    @Column(name = "max_quantity")
    private Integer maxQuantity; // Số lượng tối đa có thể chọn (null = không giới hạn)
    
    @Column(name = "is_required")
    private Boolean isRequired = false; // Có bắt buộc chọn không (ví dụ: size drink)
    
    // Metadata
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Constructors
    public MenuItemAddOn() {
        this.createdAt = LocalDateTime.now();
    }
    
    public MenuItemAddOn(MenuItem menuItem, String name, BigDecimal price, String category) {
        this();
        this.menuItem = menuItem;
        this.name = name;
        this.price = price;
        this.category = category;
    }
    
    // Business Logic Methods
    public boolean isAvailableForSelection() {
        return this.isAvailable && this.menuItem.getIsAvailable();
    }
    
    public void toggleAvailability() {
        this.isAvailable = !this.isAvailable;
        this.updatedAt = LocalDateTime.now();
    }
    
    public void updatePrice(BigDecimal newPrice) {
        if (newPrice.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Price cannot be negative");
        }
        this.price = newPrice;
        this.updatedAt = LocalDateTime.now();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public MenuItem getMenuItem() {
        return menuItem;
    }
    
    public void setMenuItem(MenuItem menuItem) {
        this.menuItem = menuItem;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public Boolean getIsAvailable() {
        return isAvailable;
    }
    
    public void setIsAvailable(Boolean isAvailable) {
        this.isAvailable = isAvailable;
    }
    
    public Integer getDisplayOrder() {
        return displayOrder;
    }
    
    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }
    
    public Integer getMaxQuantity() {
        return maxQuantity;
    }
    
    public void setMaxQuantity(Integer maxQuantity) {
        this.maxQuantity = maxQuantity;
    }
    
    public Boolean getIsRequired() {
        return isRequired;
    }
    
    public void setIsRequired(Boolean isRequired) {
        this.isRequired = isRequired;
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