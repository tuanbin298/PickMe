package org.example.repository;

import org.example.entity.SepayTransaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface SepayTransactionRepository extends JpaRepository<SepayTransaction, Long> {
    
    /**
     * Tìm transaction theo SePay transaction ID
     */
    Optional<SepayTransaction> findBySepayTransactionId(Long sepayTransactionId);
    
    /**
     * Kiểm tra transaction đã tồn tại chưa (để tránh duplicate)
     */
    boolean existsBySepayTransactionId(Long sepayTransactionId);
    
    /**
     * Lấy transactions chưa được process
     */
    List<SepayTransaction> findByProcessedFalse();
    
    /**
     * Lấy transactions theo reference code
     */
    Optional<SepayTransaction> findByReferenceCode(String referenceCode);
    
    /**
     * Lấy transactions theo order ID
     */
    List<SepayTransaction> findByOrderId(Long orderId);
    
    /**
     * Lấy transactions theo account number
     */
    List<SepayTransaction> findByAccountNumber(String accountNumber);
    
    /**
     * Lấy money-in transactions trong khoảng thời gian
     */
    @Query("SELECT st FROM SepayTransaction st WHERE st.transferType = 'in' " +
           "AND st.transactionDate BETWEEN :startDate AND :endDate " +
           "ORDER BY st.transactionDate DESC")
    List<SepayTransaction> findMoneyInTransactionsBetween(@Param("startDate") LocalDateTime startDate,
                                                          @Param("endDate") LocalDateTime endDate);
    
    /**
     * Tìm transactions theo nội dung (cho việc debug)
     */
    @Query("SELECT st FROM SepayTransaction st WHERE st.transactionContent LIKE %:content%")
    List<SepayTransaction> findByTransactionContentContaining(@Param("content") String content);
    
    /**
     * Statistics - Tổng tiền vào theo ngày
     */
    @Query("SELECT COALESCE(SUM(st.transferAmount), 0) FROM SepayTransaction st " +
           "WHERE st.transferType = 'in' AND DATE(st.transactionDate) = DATE(:date)")
    java.math.BigDecimal getTotalMoneyInByDate(@Param("date") LocalDateTime date);
    
    /**
     * Statistics - Đếm transactions chưa process
     */
    @Query("SELECT COUNT(st) FROM SepayTransaction st WHERE st.processed = false")
    long countUnprocessedTransactions();
}