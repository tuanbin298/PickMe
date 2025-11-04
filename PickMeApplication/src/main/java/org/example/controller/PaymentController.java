package org.example.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.example.dto.request.CreatePaymentRequest;
import org.example.dto.request.SepayWebhookRequest;
import org.example.dto.response.MessageResponse;
import org.example.dto.response.PaymentResponse;
import org.example.entity.Payment;
import org.example.entity.SepayTransaction;
import org.example.exception.GlobalExceptionHandler;
import org.example.service.PaymentService;
import org.example.service.SepayService;
import org.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/payments")
@Tag(name = "Payment Management", description = "API quản lý thanh toán - SePay và tiền mặt")
public class PaymentController {
    
    @Autowired
    private PaymentService paymentService;
    
    @Autowired
    private SepayService sepayService;
    
    @Autowired
    private UserService userService;
    
    /**
     * Helper method để lấy user ID từ SecurityContext
     */
    private Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        
        return userService.getUserByEmail(username)
                .orElseThrow(() -> new IllegalStateException("Current user not found"))
                .getId();
    }
    
    @PostMapping
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('RESTAURANT_OWNER')")
    @SecurityRequirement(name = "Bearer Authentication")
    @Operation(summary = "Tạo payment cho order", 
               description = "Tạo thanh toán cho đơn hàng với phương thức SePay hoặc tiền mặt")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Tạo payment thành công",
                    content = @Content(schema = @Schema(implementation = PaymentResponse.class))),
        @ApiResponse(responseCode = "400", description = "Dữ liệu đầu vào không hợp lệ",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class))),
        @ApiResponse(responseCode = "404", description = "Không tìm thấy order",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<PaymentResponse> createPayment(@Valid @RequestBody CreatePaymentRequest request) {
        PaymentResponse payment = paymentService.createPayment(request);
        return ResponseEntity.ok(payment);
    }
    
    @GetMapping("/order/{orderId}")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('RESTAURANT_OWNER') or hasRole('ADMIN')")
    @SecurityRequirement(name = "Bearer Authentication")
    @Operation(summary = "Lấy payment theo order ID", 
               description = "Lấy thông tin thanh toán của đơn hàng")
    public ResponseEntity<PaymentResponse> getPaymentByOrderId(
            @Parameter(description = "ID của order", required = true)
            @PathVariable Long orderId) {
        
        PaymentResponse payment = paymentService.getPaymentByOrderId(orderId);
        return ResponseEntity.ok(payment);
    }
    
    @GetMapping("/{paymentId}")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('RESTAURANT_OWNER') or hasRole('ADMIN')")
    @SecurityRequirement(name = "Bearer Authentication")
    @Operation(summary = "Lấy payment theo ID", 
               description = "Lấy thông tin chi tiết của payment")
    public ResponseEntity<PaymentResponse> getPaymentById(
            @Parameter(description = "ID của payment", required = true)
            @PathVariable Long paymentId) {
        
        PaymentResponse payment = paymentService.getPaymentById(paymentId);
        return ResponseEntity.ok(payment);
    }
    
    @GetMapping("/my-payments")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('RESTAURANT_OWNER')")
    @SecurityRequirement(name = "Bearer Authentication")
    @Operation(summary = "Lấy danh sách payments của user", 
               description = "Lấy lịch sử thanh toán của user hiện tại")
    public ResponseEntity<List<PaymentResponse>> getMyPayments() {
        Long userId = getCurrentUserId();
        List<PaymentResponse> payments = paymentService.getUserPayments(userId);
        return ResponseEntity.ok(payments);
    }
    
    @PostMapping("/{paymentId}/cash-confirm")
    @PreAuthorize("hasRole('RESTAURANT_OWNER') or hasRole('ADMIN')")
    @SecurityRequirement(name = "Bearer Authentication")
    @Operation(summary = "Xác nhận thanh toán tiền mặt", 
               description = "Restaurant owner xác nhận đã nhận tiền mặt từ customer")
    public ResponseEntity<PaymentResponse> confirmCashPayment(
            @Parameter(description = "ID của payment", required = true)
            @PathVariable Long paymentId) {
        
        PaymentResponse payment = paymentService.processCashPayment(paymentId);
        return ResponseEntity.ok(payment);
    }
    
    @PostMapping("/{paymentId}/cancel")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('RESTAURANT_OWNER') or hasRole('ADMIN')")
    @SecurityRequirement(name = "Bearer Authentication")
    @Operation(summary = "Hủy thanh toán", 
               description = "Hủy thanh toán đang pending")
    public ResponseEntity<PaymentResponse> cancelPayment(
            @Parameter(description = "ID của payment", required = true)
            @PathVariable Long paymentId,
            @RequestParam(required = false) String reason) {
        
        PaymentResponse payment = paymentService.cancelPayment(paymentId, reason);
        return ResponseEntity.ok(payment);
    }
    
    @PostMapping("/{paymentId}/refund")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "Bearer Authentication")
    @Operation(summary = "Hoàn tiền", 
               description = "Admin hoàn tiền cho customer (chỉ Admin)")
    public ResponseEntity<PaymentResponse> refundPayment(
            @Parameter(description = "ID của payment", required = true)
            @PathVariable Long paymentId) {
        
        PaymentResponse payment = paymentService.refundPayment(paymentId);
        return ResponseEntity.ok(payment);
    }
    
    @GetMapping("/order/{orderId}/status")
    @SecurityRequirement(name = "Bearer Authentication")
    @Operation(summary = "Kiểm tra trạng thái thanh toán", 
               description = "API cho AJAX polling để kiểm tra trạng thái thanh toán")
    public ResponseEntity<Map<String, Object>> checkPaymentStatus(
            @Parameter(description = "ID của order", required = true)
            @PathVariable Long orderId) {
        
        Payment.PaymentStatus status = paymentService.checkPaymentStatus(orderId);
        
        return ResponseEntity.ok(Map.of(
            "payment_status", status.name(),
            "payment_status_display", status.getDisplayName()
        ));
    }
    
    @GetMapping("/sepay/info")
    @SecurityRequirement(name = "Bearer Authentication")
    @Operation(summary = "Lấy thông tin thanh toán SePay", 
               description = "Lấy thông tin ngân hàng để hiển thị cho customer")
    public ResponseEntity<SepayService.PaymentInfo> getSepayInfo() {
        SepayService.PaymentInfo info = paymentService.getSepayPaymentInfo();
        return ResponseEntity.ok(info);
    }
    
    // ========== SePay Webhook Endpoint ==========
    
    @PostMapping("/sepay/webhook")

    public ResponseEntity<Map<String, Object>> sepayWebhook(@RequestBody SepayWebhookRequest request) {
        try {
            // Validate webhook
            if (!sepayService.isValidWebhook(request)) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Invalid webhook data"
                ));
            }
            
            // Process webhook - lưu transaction
            SepayTransaction transaction = sepayService.processWebhook(request);
            
            // Nếu tìm được order ID, xử lý payment
            if (transaction.getOrderId() != null) {
                try {
                    PaymentResponse payment = paymentService.processSepayWebhook(transaction);
                    
                    return ResponseEntity.ok(Map.of(
                        "success", true,
                        "message", "Payment processed successfully",
                        "order_id", transaction.getOrderId(),
                        "payment_id", payment.getId()
                    ));
                } catch (Exception e) {
                    // Log error nhưng vẫn return success để SePay không retry
                    return ResponseEntity.ok(Map.of(
                        "success", false,
                        "message", "Payment processing failed: " + e.getMessage(),
                        "transaction_id", transaction.getId()
                    ));
                }
            } else {
                // Không tìm thấy order ID trong content
                return ResponseEntity.ok(Map.of(
                    "success", false,
                    "message", "Order ID not found in transaction content",
                    "transaction_id", transaction.getId()
                ));
            }
            
        } catch (IllegalArgumentException e) {
            // Transaction đã tồn tại hoặc lỗi khác
            return ResponseEntity.ok(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        } catch (Exception e) {
            // Lỗi không mong đợi
            return ResponseEntity.status(500).body(Map.of(
                "success", false,
                "message", "Internal server error: " + e.getMessage()
            ));
        }
    }
    
    @GetMapping("/admin/statistics")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "Bearer Authentication")
    @Operation(summary = "Thống kê thanh toán", 
               description = "Admin xem thống kê thanh toán theo phương thức")
    public ResponseEntity<Map<String, Object>> getPaymentStatistics() {
        java.math.BigDecimal totalSepay = paymentService.getTotalPaidByMethod(Payment.PaymentMethod.SEPAY);
        java.math.BigDecimal totalCash = paymentService.getTotalPaidByMethod(Payment.PaymentMethod.CASH);
        long unprocessedTransactions = sepayService.countUnprocessedTransactions();
        
        return ResponseEntity.ok(Map.of(
            "total_sepay", totalSepay,
            "total_cash", totalCash,
            "total_all", totalSepay.add(totalCash),
            "unprocessed_transactions", unprocessedTransactions
        ));
    }
    
    @PostMapping("/admin/expire-pending")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "Bearer Authentication")
    @Operation(summary = "Expire pending payments", 
               description = "Admin manually expire các payments pending quá lâu")
    public ResponseEntity<MessageResponse> expirePendingPayments() {
        paymentService.expirePendingPayments();
        return ResponseEntity.ok(new MessageResponse("Pending payments expired successfully"));
    }
}