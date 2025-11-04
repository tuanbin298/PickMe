package org.example.repository;

import org.example.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    
    /**
     * Tìm payment theo order ID
     */
    @Query("SELECT p FROM Payment p WHERE p.order.id = :orderId")
    Optional<Payment> findByOrderId(@Param("orderId") Long orderId);
    
    /**
     * Tìm payment theo transaction ID
     */
    Optional<Payment> findByTransactionId(String transactionId);
    
    /**
     * Tìm payment theo SePay transaction ID
     */
    Optional<Payment> findBySepayTransactionId(Long sepayTransactionId);
    
    /**
     * Lấy danh sách payments của user
     */
    @Query("SELECT p FROM Payment p WHERE p.order.customer.id = :userId ORDER BY p.createdAt DESC")
    List<Payment> findByUserId(@Param("userId") Long userId);
    
    /**
     * Lấy danh sách payments theo status
     */
    List<Payment> findByPaymentStatus(Payment.PaymentStatus status);
    
    /**
     * Lấy danh sách payments theo payment method
     */
    List<Payment> findByPaymentMethod(Payment.PaymentMethod method);
    
    /**
     * Đếm số lượng payments theo status của user
     */
    @Query("SELECT COUNT(p) FROM Payment p WHERE p.order.customer.id = :userId AND p.paymentStatus = :status")
    long countByUserIdAndStatus(@Param("userId") Long userId, @Param("status") Payment.PaymentStatus status);
    
    /**
     * Lấy payments pending quá lâu (có thể expired)
     */
    @Query("SELECT p FROM Payment p WHERE p.paymentStatus = 'PENDING' AND p.createdAt < :expiredBefore")
    List<Payment> findExpiredPendingPayments(@Param("expiredBefore") java.time.LocalDateTime expiredBefore);
    
    /**
     * Kiểm tra payment có tồn tại với order và amount không
     */
    @Query("SELECT COUNT(p) > 0 FROM Payment p WHERE p.order.id = :orderId AND p.amount = :amount")
    boolean existsByOrderIdAndAmount(@Param("orderId") Long orderId, @Param("amount") java.math.BigDecimal amount);
    
    /**
     * Statistics - Tổng tiền đã thanh toán của restaurant
     */
    @Query("SELECT COALESCE(SUM(p.amount), 0) FROM Payment p " +
           "WHERE p.order.restaurant.id = :restaurantId AND p.paymentStatus = 'PAID'")
    java.math.BigDecimal getTotalPaidByRestaurant(@Param("restaurantId") Long restaurantId);
    
    /**
     * Statistics - Tổng tiền đã thanh toán theo method
     */
    @Query("SELECT COALESCE(SUM(p.amount), 0) FROM Payment p " +
           "WHERE p.paymentMethod = :method AND p.paymentStatus = 'PAID'")
    java.math.BigDecimal getTotalPaidByMethod(@Param("method") Payment.PaymentMethod method);
}