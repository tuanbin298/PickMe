package org.example.dto.response;

import org.example.entity.Payment;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class AdminPaymentResponse {
    
    private Long id;
    private Long orderId;
    private BigDecimal amount;
    private Payment.PaymentMethod paymentMethod;
    private String paymentMethodDisplayName;
    private Payment.PaymentStatus paymentStatus;
    private String paymentStatusDisplayName;
    private String transactionId;
    private String customerName;
    private LocalDateTime createdAt;
    
    // Constructors
    public AdminPaymentResponse() {}
    
    public AdminPaymentResponse(Payment payment) {
        this.id = payment.getId();
        this.orderId = payment.getOrder() != null ? payment.getOrder().getId() : null;
        this.amount = payment.getAmount();
        this.paymentMethod = payment.getPaymentMethod();
        this.paymentMethodDisplayName = payment.getPaymentMethod() != null ? 
            payment.getPaymentMethod().getDisplayName() : null;
        this.paymentStatus = payment.getPaymentStatus();
        this.paymentStatusDisplayName = payment.getPaymentStatus() != null ? 
            payment.getPaymentStatus().getDisplayName() : null;
        this.transactionId = payment.getTransactionId();
        this.customerName = payment.getOrder() != null && payment.getOrder().getCustomer() != null ?
            payment.getOrder().getCustomer().getFullName() : null;
        this.createdAt = payment.getCreatedAt();
    }
    
    // Static factory method
    public static AdminPaymentResponse from(Payment payment) {
        return new AdminPaymentResponse(payment);
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
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}