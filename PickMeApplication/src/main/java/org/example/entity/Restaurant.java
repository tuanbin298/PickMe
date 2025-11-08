package org.example.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.Polygon;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Entity
@Table(name = "restaurants")
public class Restaurant {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "Restaurant name is required")
    @Column(name = "name", nullable = false)
    private String name;
    
    @Column(name = "description")
    private String description;
    
    @NotBlank(message = "Address is required")
    @Column(name = "address", nullable = false)
    private String address;
    
    @Column(name = "phone_number")
    private String phoneNumber;
    
    @Column(name = "email")
    private String email;
    
    @Column(name = "image_url")
    private String imageUrl;
    
    @NotNull(message = "Location is required")
    @Column(name = "location", columnDefinition = "geometry(Point,4326)", nullable = false)
    private Point location; // Vị trí chính xác của quán
    
    @Column(name = "delivery_area", columnDefinition = "geometry(Polygon,4326)")
    private Polygon deliveryArea; // Khu vực giao hàng (nếu có)

    @Column(name = "opening_time")
    private LocalTime openingTime;
    
    @Column(name = "closing_time")
    private LocalTime closingTime;
    
    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;
    
    @Column(name = "rating")
    private Double rating = 0.0;
    
    @Column(name = "total_reviews")
    private Integer totalReviews = 0;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id", nullable = false)
    private User owner;

    @Enumerated(EnumType.STRING)
    @Column(name = "approval_status", nullable = false)
    private ApprovalStatus approvalStatus = ApprovalStatus.PENDING;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "approved_by")
    private User approvedBy;
    
    @Column(name = "approved_at")
    private LocalDateTime approvedAt;
    
    @Column(name = "rejection_reason")
    private String rejectionReason;

    @ElementCollection
    @CollectionTable(name = "restaurant_categories", joinColumns = @JoinColumn(name = "restaurant_id"))
    @Column(name = "category")
    private List<String> categories;
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    public Restaurant() {
        this.createdAt = LocalDateTime.now();
    }
    
    public Restaurant(String name, String address, Point location, User owner) {
        this();
        this.name = name;
        this.address = address;
        this.location = location;
        this.owner = owner;
    }

    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
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
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getPhoneNumber() {
        return phoneNumber;
    }
    
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public Point getLocation() {
        return location;
    }
    
    public void setLocation(Point location) {
        this.location = location;
    }
    
    public Polygon getDeliveryArea() {
        return deliveryArea;
    }
    
    public void setDeliveryArea(Polygon deliveryArea) {
        this.deliveryArea = deliveryArea;
    }
    
    public LocalTime getOpeningTime() {
        return openingTime;
    }
    
    public void setOpeningTime(LocalTime openingTime) {
        this.openingTime = openingTime;
    }
    
    public LocalTime getClosingTime() {
        return closingTime;
    }
    
    public void setClosingTime(LocalTime closingTime) {
        this.closingTime = closingTime;
    }
    
    public Boolean getIsActive() {
        return isActive;
    }
    
    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
    
    public Double getRating() {
        return rating;
    }
    
    public void setRating(Double rating) {
        this.rating = rating;
    }
    
    public Integer getTotalReviews() {
        return totalReviews;
    }
    
    public void setTotalReviews(Integer totalReviews) {
        this.totalReviews = totalReviews;
    }
    
    public User getOwner() {
        return owner;
    }
    
    public void setOwner(User owner) {
        this.owner = owner;
    }
    
    public List<String> getCategories() {
        return categories;
    }
    
    public void setCategories(List<String> categories) {
        this.categories = categories;
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

    public ApprovalStatus getApprovalStatus() {
        return approvalStatus;
    }
    
    public void setApprovalStatus(ApprovalStatus approvalStatus) {
        this.approvalStatus = approvalStatus;
    }
    
    public User getApprovedBy() {
        return approvedBy;
    }
    
    public void setApprovedBy(User approvedBy) {
        this.approvedBy = approvedBy;
    }
    
    public LocalDateTime getApprovedAt() {
        return approvedAt;
    }
    
    public void setApprovedAt(LocalDateTime approvedAt) {
        this.approvedAt = approvedAt;
    }
    
    public String getRejectionReason() {
        return rejectionReason;
    }
    
    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public boolean isOpen() {
        // Must be active and approved
        if (!isActive || !isApproved()) {
            return false;
        }
        
        // Must have opening hours set
        if (openingTime == null || closingTime == null) {
            return false;
        }
        
        // Use Vietnam timezone (UTC+7)
        LocalTime now = LocalTime.now(java.time.ZoneId.of("Asia/Ho_Chi_Minh"));
        
        // Handle normal hours (e.g., 08:00 - 22:00)
        if (closingTime.isAfter(openingTime)) {
            return !now.isBefore(openingTime) && now.isBefore(closingTime);
        } 
        // Handle overnight hours (e.g., 22:00 - 06:00)
        else {
            return !now.isBefore(openingTime) || now.isBefore(closingTime);
        }
    }
    
    public boolean isOpenAt(LocalTime time) {
        // Must be active and approved
        if (!isActive || !isApproved()) {
            return false;
        }
        
        // Must have opening hours set
        if (openingTime == null || closingTime == null) {
            return false;
        }
        
        // Handle normal hours (e.g., 08:00 - 22:00)
        if (closingTime.isAfter(openingTime)) {
            return !time.isBefore(openingTime) && time.isBefore(closingTime);
        } 
        // Handle overnight hours (e.g., 22:00 - 06:00)
        else {
            return !time.isBefore(openingTime) || time.isBefore(closingTime);
        }
    }
    
    public String getOpenStatus() {
        if (!isActive) {
            return "INACTIVE";
        }
        if (!isApproved()) {
            return "PENDING_APPROVAL";
        }
        if (openingTime == null || closingTime == null) {
            return "NO_HOURS_SET";
        }
        return isOpen() ? "OPEN" : "CLOSED";
    }
    
    /**
     * Get open status at a specific time (for testing)
     */
    public String getOpenStatusAt(LocalTime time) {
        if (!isActive) {
            return "INACTIVE";
        }
        if (!isApproved()) {
            return "PENDING_APPROVAL";
        }
        if (openingTime == null || closingTime == null) {
            return "NO_HOURS_SET";
        }
        return isOpenAt(time) ? "OPEN" : "CLOSED";
    }
    
    public long getMinutesUntilStatusChange() {
        // Use Vietnam timezone (UTC+7)
        LocalTime now = LocalTime.now(java.time.ZoneId.of("Asia/Ho_Chi_Minh"));
        return getMinutesUntilStatusChangeAt(now);
    }
    
    /**
     * Calculate minutes until status change at a specific time (for testing)
     */
    public long getMinutesUntilStatusChangeAt(LocalTime currentTime) {
        if (!isActive || !isApproved() || openingTime == null || closingTime == null) {
            return -1; // Unknown
        }
        
        boolean isCurrentlyOpen = isOpenAt(currentTime);
        
        if (isCurrentlyOpen) {
            // Calculate minutes until closing
            if (closingTime.isAfter(openingTime)) {
                // Normal hours (e.g., 08:00 - 22:00)
                return java.time.Duration.between(currentTime, closingTime).toMinutes();
            } else {
                // Overnight hours (e.g., 22:00 - 06:00)
                if (currentTime.isBefore(closingTime)) {
                    // We're past midnight, calculate to closing time
                    return java.time.Duration.between(currentTime, closingTime).toMinutes();
                } else {
                    // We're before midnight, calculate to closing time next day
                    long minutesToMidnight = java.time.Duration.between(currentTime, LocalTime.MAX).toMinutes() + 1;
                    long minutesFromMidnightToClose = java.time.Duration.between(LocalTime.MIDNIGHT, closingTime).toMinutes();
                    return minutesToMidnight + minutesFromMidnightToClose;
                }
            }
        } else {
            // Calculate minutes until opening
            if (closingTime.isAfter(openingTime)) {
                // Normal hours (e.g., 08:00 - 22:00)
                if (currentTime.isBefore(openingTime)) {
                    // Before opening time today
                    return java.time.Duration.between(currentTime, openingTime).toMinutes();
                } else {
                    // After closing time, calculate to opening time next day
                    long minutesToMidnight = java.time.Duration.between(currentTime, LocalTime.MAX).toMinutes() + 1;
                    long minutesFromMidnightToOpen = java.time.Duration.between(LocalTime.MIDNIGHT, openingTime).toMinutes();
                    return minutesToMidnight + minutesFromMidnightToOpen;
                }
            } else {
                // Overnight hours (e.g., 22:00 - 06:00)
                if (currentTime.isAfter(closingTime) && currentTime.isBefore(openingTime)) {
                    // Between closing and opening (closed period)
                    return java.time.Duration.between(currentTime, openingTime).toMinutes();
                } else {
                    // Should be open, this shouldn't happen
                    return -1;
                }
            }
        }
    }
    
    public boolean isApproved() {
        return ApprovalStatus.APPROVED.equals(this.approvalStatus);
    }
    
    public void approve(User admin) {
        this.approvalStatus = ApprovalStatus.APPROVED;
        this.approvedBy = admin;
        this.approvedAt = LocalDateTime.now();
        this.rejectionReason = null;
    }
    
    public void reject(User admin, String reason) {
        this.approvalStatus = ApprovalStatus.REJECTED;
        this.approvedBy = admin;
        this.approvedAt = LocalDateTime.now();
        this.rejectionReason = reason;
    }
}