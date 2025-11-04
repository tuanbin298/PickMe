package org.example.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import org.example.entity.ApprovalStatus;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

public class RestaurantResponse {
    
    private Long id;
    
    private String name;
    
    private String description;
    
    private String address;
    
    private String phoneNumber;
    
    private String email;
    
    private String imageUrl;
    
    // Location information
    private Double latitude;
    
    private Double longitude;
    
    // Business hours
    @Schema(type = "string", example = "08:00:00", description = "Opening time in HH:mm:ss format")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm:ss")
    private LocalTime openingTime;
    
    @Schema(type = "string", example = "22:00:00", description = "Closing time in HH:mm:ss format")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm:ss")
    private LocalTime closingTime;
    
    private Boolean isActive;
    
    private Double rating;
    
    private Integer totalReviews;
    
    // Owner information (basic info only for security)
    private Long ownerId;
    
    private String ownerName;
    
    // Approval status
    private ApprovalStatus approvalStatus;
    
    private Long approvedBy;
    
    private String approvedByName;
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime approvedAt;
    
    private String rejectionReason;
    
    // Categories
    private List<String> categories;
    
    // Timestamps
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updatedAt;
    
    // Business logic helpers (computed fields)
    private Boolean isOpen;
    
    private Boolean isApproved;
    
    // Constructors
    public RestaurantResponse() {}
    
    public RestaurantResponse(Long id, String name, String address, Double latitude, Double longitude) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
    }
    
    // Getters and Setters
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
    
    public Double getLatitude() {
        return latitude;
    }
    
    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }
    
    public Double getLongitude() {
        return longitude;
    }
    
    public void setLongitude(Double longitude) {
        this.longitude = longitude;
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
    
    public Long getOwnerId() {
        return ownerId;
    }
    
    public void setOwnerId(Long ownerId) {
        this.ownerId = ownerId;
    }
    
    public String getOwnerName() {
        return ownerName;
    }
    
    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }
    
    public ApprovalStatus getApprovalStatus() {
        return approvalStatus;
    }
    
    public void setApprovalStatus(ApprovalStatus approvalStatus) {
        this.approvalStatus = approvalStatus;
    }
    
    public Long getApprovedBy() {
        return approvedBy;
    }
    
    public void setApprovedBy(Long approvedBy) {
        this.approvedBy = approvedBy;
    }
    
    public String getApprovedByName() {
        return approvedByName;
    }
    
    public void setApprovedByName(String approvedByName) {
        this.approvedByName = approvedByName;
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
    
    public Boolean getIsOpen() {
        return isOpen;
    }
    
    public void setIsOpen(Boolean isOpen) {
        this.isOpen = isOpen;
    }
    
    public Boolean getIsApproved() {
        return isApproved;
    }
    
    public void setIsApproved(Boolean isApproved) {
        this.isApproved = isApproved;
    }
}