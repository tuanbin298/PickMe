package org.example.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "reviews", indexes = {
    @Index(name = "idx_review_reviewer_id", columnList = "reviewer_id"),
    @Index(name = "idx_review_order_id", columnList = "order_id"),
    @Index(name = "idx_review_target", columnList = "review_type, target_id"),
    @Index(name = "idx_review_created_at", columnList = "created_at"),
    @Index(name = "idx_review_rating", columnList = "overall_rating")
})
public class Review {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // Người đánh giá (chỉ CUSTOMER)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reviewer_id", nullable = false)
    private User reviewer;
    
    // Đơn hàng liên quan (bắt buộc - phải là COMPLETED)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;
    
    // Loại review
    @Enumerated(EnumType.STRING)
    @Column(name = "review_type", nullable = false)
    private ReviewType reviewType;
    
    // ID của đối tượng được review (Restaurant ID, MenuItem ID, Order ID)
    @Column(name = "target_id", nullable = false)
    private Long targetId;
    
    // Đánh giá tổng thể (1-5 sao)
    @Min(value = 1, message = "Rating must be at least 1")
    @Max(value = 5, message = "Rating must be at most 5")
    @Column(name = "overall_rating", nullable = false)
    private Integer overallRating;
    
    // Bình luận
    @Size(min = 10, max = 1000, message = "Comment must be between 10 and 1000 characters")
    @Column(name = "comment", columnDefinition = "TEXT")
    private String comment;
    
    // Hình ảnh đính kèm (tối đa 5 ảnh)
    @ElementCollection
    @CollectionTable(name = "review_images", joinColumns = @JoinColumn(name = "review_id"))
    @Column(name = "image_url")
    @Size(max = 5, message = "Maximum 5 images allowed")
    private List<String> imageUrls = new ArrayList<>();
    
    // Thông tin chỉnh sửa
    @Column(name = "is_edited", nullable = false)
    private Boolean isEdited = false;
    
    @Column(name = "edit_deadline", nullable = false)
    private LocalDateTime editDeadline; // 7 ngày từ khi tạo
    
    // Thông tin ẩn/hiện (Admin moderation)
    @Column(name = "is_hidden", nullable = false)
    private Boolean isHidden = false;
    
    @Column(name = "hidden_reason")
    private String hiddenReason;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hidden_by")
    private User hiddenBy;
    
    @Column(name = "hidden_at")
    private LocalDateTime hiddenAt;
    
    // Phản hồi từ Restaurant Owner
    @Column(name = "owner_response", columnDefinition = "TEXT")
    private String ownerResponse;
    
    @Column(name = "response_date")
    private LocalDateTime responseDate;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "responded_by")
    private User respondedBy;
    
    // Timestamps
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Constructors
    public Review() {
        this.createdAt = LocalDateTime.now();
        this.editDeadline = this.createdAt.plusDays(7); // 7 ngày để chỉnh sửa
        this.isEdited = false;
        this.isHidden = false;
    }
    
    public Review(User reviewer, Order order, ReviewType reviewType, Long targetId, 
                  Integer overallRating, String comment) {
        this();
        this.reviewer = reviewer;
        this.order = order;
        this.reviewType = reviewType;
        this.targetId = targetId;
        this.overallRating = overallRating;
        this.comment = comment;
    }
    
    // Business Logic Methods
    public boolean canBeEdited() {
        return LocalDateTime.now().isBefore(this.editDeadline) && !this.isHidden;
    }
    
    public boolean canBeDeletedByOwner() {
        return LocalDateTime.now().isBefore(this.editDeadline) && !this.isHidden;
    }
    
    public void updateContent(Integer rating, String comment, List<String> imageUrls) {
        if (!canBeEdited()) {
            throw new IllegalStateException("Review cannot be edited after deadline or when hidden");
        }
        
        this.overallRating = rating;
        this.comment = comment;
        this.imageUrls = imageUrls != null ? new ArrayList<>(imageUrls) : new ArrayList<>();
        this.isEdited = true;
        this.updatedAt = LocalDateTime.now();
    }
    
    public void addOwnerResponse(User restaurantOwner, String response) {
        this.ownerResponse = response;
        this.respondedBy = restaurantOwner;
        this.responseDate = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    public void updateOwnerResponse(User restaurantOwner, String response) {
        if (this.respondedBy == null || !this.respondedBy.getId().equals(restaurantOwner.getId())) {
            throw new IllegalStateException("Only the original responder can update the response");
        }
        
        this.ownerResponse = response;
        this.responseDate = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    public void removeOwnerResponse(User restaurantOwner) {
        if (this.respondedBy == null || !this.respondedBy.getId().equals(restaurantOwner.getId())) {
            throw new IllegalStateException("Only the original responder can remove the response");
        }
        
        this.ownerResponse = null;
        this.respondedBy = null;
        this.responseDate = null;
        this.updatedAt = LocalDateTime.now();
    }
    
    public void hide(User admin, String reason) {
        this.isHidden = true;
        this.hiddenReason = reason;
        this.hiddenBy = admin;
        this.hiddenAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    public void unhide(User admin) {
        this.isHidden = false;
        this.hiddenReason = null;
        this.hiddenBy = admin;
        this.hiddenAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    public boolean isVisibleToPublic() {
        return !this.isHidden;
    }
    
    public boolean hasOwnerResponse() {
        return this.ownerResponse != null && !this.ownerResponse.trim().isEmpty();
    }
    
    public long getDaysUntilEditDeadline() {
        if (LocalDateTime.now().isAfter(this.editDeadline)) {
            return 0;
        }
        return java.time.Duration.between(LocalDateTime.now(), this.editDeadline).toDays();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public User getReviewer() {
        return reviewer;
    }
    
    public void setReviewer(User reviewer) {
        this.reviewer = reviewer;
    }
    
    public Order getOrder() {
        return order;
    }
    
    public void setOrder(Order order) {
        this.order = order;
    }
    
    public ReviewType getReviewType() {
        return reviewType;
    }
    
    public void setReviewType(ReviewType reviewType) {
        this.reviewType = reviewType;
    }
    
    public Long getTargetId() {
        return targetId;
    }
    
    public void setTargetId(Long targetId) {
        this.targetId = targetId;
    }
    
    public Integer getOverallRating() {
        return overallRating;
    }
    
    public void setOverallRating(Integer overallRating) {
        this.overallRating = overallRating;
    }
    
    public String getComment() {
        return comment;
    }
    
    public void setComment(String comment) {
        this.comment = comment;
    }
    
    public List<String> getImageUrls() {
        return imageUrls;
    }
    
    public void setImageUrls(List<String> imageUrls) {
        this.imageUrls = imageUrls;
    }
    
    public Boolean getIsEdited() {
        return isEdited;
    }
    
    public void setIsEdited(Boolean isEdited) {
        this.isEdited = isEdited;
    }
    
    public LocalDateTime getEditDeadline() {
        return editDeadline;
    }
    
    public void setEditDeadline(LocalDateTime editDeadline) {
        this.editDeadline = editDeadline;
    }
    
    public Boolean getIsHidden() {
        return isHidden;
    }
    
    public void setIsHidden(Boolean isHidden) {
        this.isHidden = isHidden;
    }
    
    public String getHiddenReason() {
        return hiddenReason;
    }
    
    public void setHiddenReason(String hiddenReason) {
        this.hiddenReason = hiddenReason;
    }
    
    public User getHiddenBy() {
        return hiddenBy;
    }
    
    public void setHiddenBy(User hiddenBy) {
        this.hiddenBy = hiddenBy;
    }
    
    public LocalDateTime getHiddenAt() {
        return hiddenAt;
    }
    
    public void setHiddenAt(LocalDateTime hiddenAt) {
        this.hiddenAt = hiddenAt;
    }
    
    public String getOwnerResponse() {
        return ownerResponse;
    }
    
    public void setOwnerResponse(String ownerResponse) {
        this.ownerResponse = ownerResponse;
    }
    
    public LocalDateTime getResponseDate() {
        return responseDate;
    }
    
    public void setResponseDate(LocalDateTime responseDate) {
        this.responseDate = responseDate;
    }
    
    public User getRespondedBy() {
        return respondedBy;
    }
    
    public void setRespondedBy(User respondedBy) {
        this.respondedBy = respondedBy;
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