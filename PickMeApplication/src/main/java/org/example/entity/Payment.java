package org.example.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "payments", indexes = {
    @Index(name = "idx_payment_order_id", columnList = "order_id"),
    @Index(name = "idx_payment_status", columnList = "payment_status"),
    @Index(name = "idx_payment_method", columnList = "payment_method"),
    @Index(name = "idx_payment_transaction_id", columnList = "transaction_id", unique = true),
    @Index(name = "idx_payment_created_at", columnList = "created_at")
})
public class Payment {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;
    
    @NotNull
    @Column(name = "amount", precision = 10, scale = 2, nullable = false)
    private BigDecimal amount;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "payment_method", nullable = false)
    private PaymentMethod paymentMethod;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "payment_status", nullable = false)
    private PaymentStatus paymentStatus = PaymentStatus.PENDING;
    
    @Column(name = "transaction_id", unique = true)
    private String transactionId; // ID từ SePay hoặc internal ID cho CASH
    
    @Column(name = "sepay_transaction_id")
    private Long sepayTransactionId; // ID giao dịch từ SePay webhook
    
    @Column(name = "gateway_response", columnDefinition = "TEXT")
    private String gatewayResponse; // JSON response từ payment gateway
    
    @Column(name = "failure_reason")
    private String failureReason; // Lý do thất bại nếu có
    
    @Column(name = "qr_code_url")
    private String qrCodeUrl; // URL QR code cho SePay
    
    @Column(name = "paid_at")
    private LocalDateTime paidAt; // Thời gian thanh toán thành công
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Constructors
    public Payment() {
        this.createdAt = LocalDateTime.now();
    }
    
    public Payment(Order order, BigDecimal amount, PaymentMethod paymentMethod) {
        this();
        this.order = order;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        generateTransactionId();
    }
    
    // Business Logic Methods
    private void generateTransactionId() {
        if (paymentMethod == PaymentMethod.CASH) {
            this.transactionId = "CASH-" + order.getId() + "-" + System.currentTimeMillis();
        } else {
            this.transactionId = "SEPAY-" + order.getId() + "-" + System.currentTimeMillis();
        }
    }
    
    public void markAsPaid() {
        this.paymentStatus = PaymentStatus.PAID;
        this.paidAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        
        // Update order payment status
        if (this.order != null) {
            this.order.setPaymentStatus(Order.PaymentStatus.PAID);
        }
    }
    
    public void markAsFailed(String reason) {
        this.paymentStatus = PaymentStatus.FAILED;
        this.failureReason = reason;
        this.updatedAt = LocalDateTime.now();
        
        // Update order payment status
        if (this.order != null) {
            this.order.setPaymentStatus(Order.PaymentStatus.FAILED);
        }
    }
    
    public void markAsRefunded() {
        this.paymentStatus = PaymentStatus.REFUNDED;
        this.updatedAt = LocalDateTime.now();
        
        // Update order payment status
        if (this.order != null) {
            this.order.setPaymentStatus(Order.PaymentStatus.REFUNDED);
        }
    }
    
    public boolean isPaid() {
        return PaymentStatus.PAID.equals(this.paymentStatus);
    }
    
    public boolean isPending() {
        return PaymentStatus.PENDING.equals(this.paymentStatus);
    }
    
    public boolean isFailed() {
        return PaymentStatus.FAILED.equals(this.paymentStatus);
    }
    
    public boolean isCashPayment() {
        return PaymentMethod.CASH.equals(this.paymentMethod);
    }
    
    public boolean isSePayPayment() {
        return PaymentMethod.SEPAY.equals(this.paymentMethod);
    }
    
    // Enums
    public enum PaymentMethod {
        CASH("Tiền mặt"),
        SEPAY("Cổng thanh toán SePay");
        
        private final String displayName;
        
        PaymentMethod(String displayName) {
            this.displayName = displayName;
        }
        
        public String getDisplayName() {
            return displayName;
        }
    }
    
    public enum PaymentStatus {
        PENDING("Chờ thanh toán"),
        PROCESSING("Đang xử lý"),
        PAID("Đã thanh toán"), 
        FAILED("Thanh toán thất bại"),
        REFUNDED("Đã hoàn tiền"),
        EXPIRED("Hết hạn");
        
        private final String displayName;
        
        PaymentStatus(String displayName) {
            this.displayName = displayName;
        }
        
        public String getDisplayName() {
            return displayName;
        }
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
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public String getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
    
    public Long getSepayTransactionId() {
        return sepayTransactionId;
    }
    
    public void setSepayTransactionId(Long sepayTransactionId) {
        this.sepayTransactionId = sepayTransactionId;
    }
    
    public String getGatewayResponse() {
        return gatewayResponse;
    }
    
    public void setGatewayResponse(String gatewayResponse) {
        this.gatewayResponse = gatewayResponse;
    }
    
    public String getFailureReason() {
        return failureReason;
    }
    
    public void setFailureReason(String failureReason) {
        this.failureReason = failureReason;
    }
    
    public String getQrCodeUrl() {
        return qrCodeUrl;
    }
    
    public void setQrCodeUrl(String qrCodeUrl) {
        this.qrCodeUrl = qrCodeUrl;
    }
    
    public LocalDateTime getPaidAt() {
        return paidAt;
    }
    
    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
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