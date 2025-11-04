package org.example.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;

@Entity
@Table(name = "user_addresses")
public class UserAddress {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @NotBlank(message = "Address name is required")
    @Column(name = "address_name", nullable = false)
    private String addressName; // "Nhà", "Công ty", "Trường học"
    
    @NotBlank(message = "Full address is required")
    @Column(name = "full_address", nullable = false)
    private String fullAddress;
    
    @Column(name = "location", columnDefinition = "POINT")
    private Point location; // Tọa độ GPS
    
    @Column(name = "is_default", nullable = false)
    private Boolean isDefault = false;
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Constructors
    public UserAddress() {
        this.createdAt = LocalDateTime.now();
    }
    
    public UserAddress(User user, String addressName, String fullAddress) {
        this();
        this.user = user;
        this.addressName = addressName;
        this.fullAddress = fullAddress;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public String getAddressName() {
        return addressName;
    }
    
    public void setAddressName(String addressName) {
        this.addressName = addressName;
    }
    
    public String getFullAddress() {
        return fullAddress;
    }
    
    public void setFullAddress(String fullAddress) {
        this.fullAddress = fullAddress;
    }
    
    public Point getLocation() {
        return location;
    }
    
    public void setLocation(Point location) {
        this.location = location;
    }
    
    public Boolean getIsDefault() {
        return isDefault;
    }
    
    public void setIsDefault(Boolean isDefault) {
        this.isDefault = isDefault;
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