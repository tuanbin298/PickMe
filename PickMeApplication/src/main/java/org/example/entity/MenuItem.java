package org.example.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "menu_items")
public class MenuItem {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "restaurant_id", nullable = false)
    private Restaurant restaurant;
    
    @NotBlank(message = "Item name is required")
    @Column(name = "name", nullable = false)
    private String name;
    
    @Column(name = "description")
    private String description;
    
    @NotNull(message = "Price is required")
    @DecimalMin(value = "0.0", inclusive = false, message = "Price must be greater than 0")
    @Column(name = "price", precision = 10, scale = 2, nullable = false)
    private BigDecimal price;
    
    @Column(name = "category")
    private String category; // "Drinks", "Main Course", "Dessert", etc.
    
    @Column(name = "image_url")
    private String imageUrl;
    
    @Column(name = "is_available", nullable = false)
    private Boolean isAvailable = true;
    
    @Column(name = "preparation_time_minutes")
    private Integer preparationTimeMinutes;
    
    // Rating and review statistics
    @Column(name = "average_rating")
    private Double averageRating = 0.0;
    
    @Column(name = "total_reviews")
    private Integer totalReviews = 0;
    
    // Tags for filtering
    @ElementCollection
    @CollectionTable(name = "menu_item_tags", joinColumns = @JoinColumn(name = "menu_item_id"))
    @Column(name = "tag")
    private List<String> tags; // "Spicy", "Vegetarian", "Gluten-Free", etc.
    
    // Available add-ons for this menu item
    @OneToMany(mappedBy = "menuItem", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    @OrderBy("category ASC, displayOrder ASC, name ASC")
    private List<MenuItemAddOn> availableAddOns = new ArrayList<>();
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Constructors
    public MenuItem() {
        this.createdAt = LocalDateTime.now();
    }
    
    public MenuItem(Restaurant restaurant, String name, BigDecimal price, String category) {
        this();
        this.restaurant = restaurant;
        this.name = name;
        this.price = price;
        this.category = category;
    }
    
    // Business Logic Methods for Add-ons
    public void addAddOn(String name, BigDecimal price, String category, String description) {
        MenuItemAddOn addOn = new MenuItemAddOn(this, name, price, category);
        addOn.setDescription(description);
        this.availableAddOns.add(addOn);
    }
    
    public void removeAddOn(Long addOnId) {
        this.availableAddOns.removeIf(addOn -> addOn.getId().equals(addOnId));
    }
    
    public List<MenuItemAddOn> getAvailableAddOns() {
        return availableAddOns.stream()
            .filter(MenuItemAddOn::isAvailableForSelection)
            .toList();
    }
    
    public List<MenuItemAddOn> getAddOnsByCategory(String category) {
        return availableAddOns.stream()
            .filter(addOn -> addOn.isAvailableForSelection() && 
                           category.equals(addOn.getCategory()))
            .toList();
    }
    
    public List<MenuItemAddOn> getRequiredAddOns() {
        return availableAddOns.stream()
            .filter(addOn -> addOn.isAvailableForSelection() && 
                           Boolean.TRUE.equals(addOn.getIsRequired()))
            .toList();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Restaurant getRestaurant() {
        return restaurant;
    }
    
    public void setRestaurant(Restaurant restaurant) {
        this.restaurant = restaurant;
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
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public Boolean getIsAvailable() {
        return isAvailable;
    }
    
    public void setIsAvailable(Boolean isAvailable) {
        this.isAvailable = isAvailable;
    }
    
    public Integer getPreparationTimeMinutes() {
        return preparationTimeMinutes;
    }
    
    public void setPreparationTimeMinutes(Integer preparationTimeMinutes) {
        this.preparationTimeMinutes = preparationTimeMinutes;
    }
    
    public Double getAverageRating() {
        return averageRating;
    }
    
    public void setAverageRating(Double averageRating) {
        this.averageRating = averageRating;
    }
    
    public Integer getTotalReviews() {
        return totalReviews;
    }
    
    public void setTotalReviews(Integer totalReviews) {
        this.totalReviews = totalReviews;
    }
    
    public List<String> getTags() {
        return tags;
    }
    
    public void setTags(List<String> tags) {
        this.tags = tags;
    }
    
    public List<MenuItemAddOn> getAllAddOns() {
        return availableAddOns;
    }
    
    public void setAvailableAddOns(List<MenuItemAddOn> availableAddOns) {
        this.availableAddOns = availableAddOns;
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