package org.example.dto.request;

import jakarta.validation.constraints.NotNull;
import org.example.entity.Payment;

public class CreatePaymentRequest {
    
    @NotNull(message = "Order ID is required")
    private Long orderId;
    
    @NotNull(message = "Payment method is required")
    private Payment.PaymentMethod paymentMethod;
    
    // Constructors
    public CreatePaymentRequest() {}
    
    public CreatePaymentRequest(Long orderId, Payment.PaymentMethod paymentMethod) {
        this.orderId = orderId;
        this.paymentMethod = paymentMethod;
    }
    
    // Getters and Setters
    public Long getOrderId() {
        return orderId;
    }
    
    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }
    
    public Payment.PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(Payment.PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
}