package org.example.service;

import org.example.dto.request.CreatePaymentRequest;
import org.example.dto.response.PaymentResponse;
import org.example.entity.Order;
import org.example.entity.Payment;
import org.example.entity.Role;
import org.example.entity.SepayTransaction;
import org.example.entity.User;
import org.example.repository.OrderRepository;
import org.example.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class PaymentService {
    
    @Autowired
    private PaymentRepository paymentRepository;
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private SepayService sepayService;
    
    @Autowired
    private UserService userService;
    
    /**
     * Tạo payment cho order
     */
    public PaymentResponse createPayment(CreatePaymentRequest request) {
        // Validate order exists và chưa có payment
        Order order = orderRepository.findById(request.getOrderId())
                .orElseThrow(() -> new IllegalArgumentException("Order not found"));
        
        if (paymentRepository.findByOrderId(request.getOrderId()).isPresent()) {
            throw new IllegalStateException("Payment already exists for this order");
        }
        
        // Validate order status
        if (!order.canBeModified()) {
            throw new IllegalStateException("Cannot create payment for order in status: " + order.getStatus());
        }
        
        // Tạo Payment entity
        Payment payment = new Payment(order, order.getTotalAmount(), request.getPaymentMethod());
        
        // Xử lý theo payment method
        if (request.getPaymentMethod() == Payment.PaymentMethod.SEPAY) {
            // Generate QR code URL cho SePay
            String qrCodeUrl = sepayService.generateQrCodeUrl(order.getId(), order.getTotalAmount());
            payment.setQrCodeUrl(qrCodeUrl);
        } else if (request.getPaymentMethod() == Payment.PaymentMethod.CASH) {
            // Cash payment - có thể mark as paid ngay hoặc để pending
            // Tuỳ business logic của bạn
        }
        
        Payment savedPayment = paymentRepository.save(payment);
        return PaymentResponse.from(savedPayment);
    }
    
    /**
     * Lấy payment theo order ID
     */
    @Transactional(readOnly = true)
    public PaymentResponse getPaymentByOrderId(Long orderId) {
        Payment payment = paymentRepository.findByOrderId(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Payment not found for order: " + orderId));
        
        return PaymentResponse.from(payment);
    }
    
    /**
     * Lấy payment theo ID
     */
    @Transactional(readOnly = true)
    public PaymentResponse getPaymentById(Long paymentId) {
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new IllegalArgumentException("Payment not found: " + paymentId));
        
        return PaymentResponse.from(payment);
    }
    
    /**
     * Lấy payments của user
     */
    @Transactional(readOnly = true)
    public List<PaymentResponse> getUserPayments(Long userId) {
        List<Payment> payments = paymentRepository.findByUserId(userId);
        return payments.stream()
                .map(PaymentResponse::from)
                .collect(Collectors.toList());
    }
    
    /**
     * Xử lý thanh toán tiền mặt
     * Khi restaurant owner xác nhận thanh toán tiền mặt, cả payment và order sẽ được cập nhật
     */
    public PaymentResponse processCashPayment(Long paymentId) {
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new IllegalArgumentException("Payment not found: " + paymentId));
        
        if (payment.getPaymentMethod() != Payment.PaymentMethod.CASH) {
            throw new IllegalArgumentException("Payment is not cash payment");
        }
        
        if (!payment.isPending()) {
            throw new IllegalStateException("Payment is not pending");
        }
        
        // Validate restaurant owner permissions
        String currentUsername = SecurityContextHolder.getContext().getAuthentication().getName();
        User currentUser = userService.findByEmail(currentUsername);
        
        // Kiểm tra xem restaurant owner có quyền xác nhận payment của restaurant này không
        if (currentUser.getRole() == Role.RESTAURANT_OWNER) {
            Order order = payment.getOrder();
            if (order == null || !order.getRestaurant().getOwner().getId().equals(currentUser.getId())) {
                throw new IllegalArgumentException("You can only confirm payments for your own restaurant");
            }
        }
        
        // Mark payment as paid
        payment.markAsPaid();
        Payment savedPayment = paymentRepository.save(payment);
        
        // Cập nhật order status thành COMPLETED khi thanh toán tiền mặt được xác nhận
        Order order = payment.getOrder();
        if (order != null) {
            order.setStatus(Order.OrderStatus.COMPLETED);
            order.setUpdatedAt(LocalDateTime.now());
            orderRepository.save(order);
        }
        
        return PaymentResponse.from(savedPayment);
    }
    
    /**
     * Xử lý SePay webhook - cập nhật payment status
     */
    public PaymentResponse processSepayWebhook(SepayTransaction sepayTransaction) {
        if (!sepayTransaction.isMoneyIn()) {
            throw new IllegalArgumentException("Only money-in transactions are supported");
        }
        
        Long orderId = sepayTransaction.getOrderId();
        if (orderId == null) {
            throw new IllegalArgumentException("Order ID not found in transaction content");
        }
        
        // Tìm payment của order này
        Payment payment = paymentRepository.findByOrderId(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Payment not found for order: " + orderId));
        
        // Validate payment
        if (payment.getPaymentMethod() != Payment.PaymentMethod.SEPAY) {
            throw new IllegalArgumentException("Payment method is not SePay");
        }
        
        if (!payment.isPending()) {
            throw new IllegalStateException("Payment is not pending");
        }
        
        // Validate amount
        if (payment.getAmount().compareTo(sepayTransaction.getTransferAmount()) != 0) {
            throw new IllegalArgumentException("Payment amount mismatch. Expected: " + 
                payment.getAmount() + ", Got: " + sepayTransaction.getTransferAmount());
        }
        
        // Update payment
        payment.setSepayTransactionId(sepayTransaction.getSepayTransactionId());
        payment.setGatewayResponse(sepayTransaction.getDescription());
        payment.markAsPaid();
        
        Payment savedPayment = paymentRepository.save(payment);
        
        // Mark SePay transaction as processed
        sepayService.markTransactionAsProcessed(sepayTransaction.getId());
        
        return PaymentResponse.from(savedPayment);
    }
    
    /**
     * Cancel payment
     */
    public PaymentResponse cancelPayment(Long paymentId, String reason) {
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new IllegalArgumentException("Payment not found: " + paymentId));
        
        if (!payment.isPending()) {
            throw new IllegalStateException("Cannot cancel non-pending payment");
        }
        
        payment.markAsFailed(reason != null ? reason : "Cancelled by user");
        Payment savedPayment = paymentRepository.save(payment);
        
        return PaymentResponse.from(savedPayment);
    }
    
    /**
     * Refund payment
     */
    public PaymentResponse refundPayment(Long paymentId) {
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new IllegalArgumentException("Payment not found: " + paymentId));
        
        if (!payment.isPaid()) {
            throw new IllegalStateException("Cannot refund non-paid payment");
        }
        
        payment.markAsRefunded();
        Payment savedPayment = paymentRepository.save(payment);
        
        return PaymentResponse.from(savedPayment);
    }
    
    /**
     * Kiểm tra payment status cho AJAX polling
     */
    @Transactional(readOnly = true)
    public Payment.PaymentStatus checkPaymentStatus(Long orderId) {
        Payment payment = paymentRepository.findByOrderId(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Payment not found for order: " + orderId));
        
        return payment.getPaymentStatus();
    }
    
    /**
     * Get SePay payment info
     */
    @Transactional(readOnly = true)
    public SepayService.PaymentInfo getSepayPaymentInfo() {
        return sepayService.getPaymentInfo();
    }
    
    /**
     * Auto-expire pending payments
     * Nên được gọi bởi scheduled task
     */
    public void expirePendingPayments() {
        LocalDateTime expiredBefore = LocalDateTime.now().minusHours(24); // 24 hours timeout
        List<Payment> expiredPayments = paymentRepository.findExpiredPendingPayments(expiredBefore);
        
        for (Payment payment : expiredPayments) {
            payment.setPaymentStatus(Payment.PaymentStatus.EXPIRED);
            paymentRepository.save(payment);
        }
    }
    
    /**
     * Statistics methods
     */
    @Transactional(readOnly = true)
    public java.math.BigDecimal getTotalPaidByRestaurant(Long restaurantId) {
        return paymentRepository.getTotalPaidByRestaurant(restaurantId);
    }
    
    @Transactional(readOnly = true)
    public java.math.BigDecimal getTotalPaidByMethod(Payment.PaymentMethod method) {
        return paymentRepository.getTotalPaidByMethod(method);
    }
}