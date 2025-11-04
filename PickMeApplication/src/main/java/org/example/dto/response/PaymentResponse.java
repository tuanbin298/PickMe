package org.example.dto.response;

import org.example.entity.Payment;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class PaymentResponse {
    
    private Long id;
    private Long orderId;
    private String orderQrCode;
    private BigDecimal amount;
    private Payment.PaymentMethod paymentMethod;
    private String paymentMethodDisplayName;
    private Payment.PaymentStatus paymentStatus;
    private String paymentStatusDisplayName;
    private String transactionId;
    private String qrCodeUrl; // QR code cho SePay
    private String failureReason;
    private LocalDateTime paidAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Constructors
    public PaymentResponse() {}
    
    public PaymentResponse(Payment payment) {
        this.id = payment.getId();
        this.orderId = payment.getOrder() != null ? payment.getOrder().getId() : null;
        this.orderQrCode = payment.getOrder() != null ? payment.getOrder().getQrCode() : null;
        this.amount = payment.getAmount();
        this.paymentMethod = payment.getPaymentMethod();
        this.paymentMethodDisplayName = payment.getPaymentMethod() != null ? 
            payment.getPaymentMethod().getDisplayName() : null;
        this.paymentStatus = payment.getPaymentStatus();
        this.paymentStatusDisplayName = payment.getPaymentStatus() != null ? 
            payment.getPaymentStatus().getDisplayName() : null;
        this.transactionId = payment.getTransactionId();
        this.qrCodeUrl = payment.getQrCodeUrl();
        this.failureReason = payment.getFailureReason();
        this.paidAt = payment.getPaidAt();
        this.createdAt = payment.getCreatedAt();
        this.updatedAt = payment.getUpdatedAt();
    }
    
    // Static factory method
    public static PaymentResponse from(Payment payment) {
        return new PaymentResponse(payment);
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getOrderId() {
        return orderId;
    }
    
    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }
    
    public String getOrderQrCode() {
        return orderQrCode;
    }
    
    public void setOrderQrCode(String orderQrCode) {
        this.orderQrCode = orderQrCode;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public Payment.PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(Payment.PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public String getPaymentMethodDisplayName() {
        return paymentMethodDisplayName;
    }
    
    public void setPaymentMethodDisplayName(String paymentMethodDisplayName) {
        this.paymentMethodDisplayName = paymentMethodDisplayName;
    }
    
    public Payment.PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(Payment.PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public String getPaymentStatusDisplayName() {
        return paymentStatusDisplayName;
    }
    
    public void setPaymentStatusDisplayName(String paymentStatusDisplayName) {
        this.paymentStatusDisplayName = paymentStatusDisplayName;
    }
    
    public String getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
    
    public String getQrCodeUrl() {
        return qrCodeUrl;
    }
    
    public void setQrCodeUrl(String qrCodeUrl) {
        this.qrCodeUrl = qrCodeUrl;
    }
    
    public String getFailureReason() {
        return failureReason;
    }
    
    public void setFailureReason(String failureReason) {
        this.failureReason = failureReason;
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
}