package org.example.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "sepay_transactions", indexes = {
    @Index(name = "idx_sepay_transaction_sepay_id", columnList = "sepay_transaction_id", unique = true),
    @Index(name = "idx_sepay_transaction_date", columnList = "transaction_date"),
    @Index(name = "idx_sepay_transaction_account", columnList = "account_number"),
    @Index(name = "idx_sepay_transaction_content", columnList = "transaction_content"),
    @Index(name = "idx_sepay_transaction_reference", columnList = "reference_code")
})
public class SepayTransaction {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "sepay_transaction_id", nullable = false, unique = true)
    private Long sepayTransactionId; // ID giao dịch từ SePay
    
    @Column(name = "gateway", nullable = false)
    private String gateway; // Brand name của ngân hàng (VD: Vietcombank)
    
    @Column(name = "transaction_date", nullable = false)
    private LocalDateTime transactionDate; // Thời gian giao dịch phía ngân hàng
    
    @Column(name = "account_number")
    private String accountNumber; // Số tài khoản ngân hàng
    
    @Column(name = "sub_account")
    private String subAccount; // Tài khoản ngân hàng phụ
    
    @Column(name = "transfer_type", nullable = false)
    private String transferType; // "in" hoặc "out"
    
    @Column(name = "transfer_amount", precision = 15, scale = 2, nullable = false)
    private BigDecimal transferAmount; // Số tiền giao dịch
    
    @Column(name = "accumulated", precision = 15, scale = 2)
    private BigDecimal accumulated; // Số dư tài khoản
    
    @Column(name = "code")
    private String code; // Mã code thanh toán
    
    @Column(name = "transaction_content", columnDefinition = "TEXT")
    private String transactionContent; // Nội dung chuyển khoản
    
    @Column(name = "reference_code")
    private String referenceCode; // Mã tham chiếu (VD: MBVCB.3278907687)
    
    @Column(name = "description", columnDefinition = "TEXT")
    private String description; // Toàn bộ nội dung tin notify ngân hàng
    
    @Column(name = "processed", nullable = false)
    private Boolean processed = false; // Đã xử lý chưa
    
    @Column(name = "order_id")
    private Long orderId; // ID đơn hàng được tách từ transaction_content
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Constructors
    public SepayTransaction() {
        this.createdAt = LocalDateTime.now();
    }
    
    // Business methods
    public boolean isMoneyIn() {
        return "in".equals(transferType);
    }
    
    public boolean isMoneyOut() {
        return "out".equals(transferType);
    }
    
    public void markAsProcessed() {
        this.processed = true;
        this.updatedAt = LocalDateTime.now();
    }
    
    /**
     * Tách order ID từ transaction content
     * Format: DH{orderId} hoặc ORDER{orderId}
     */
    public Long extractOrderId() {
        if (transactionContent == null) {
            return null;
        }
        
        // Regex để tìm DH{số} hoặc ORDER{số}
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("(?:DH|ORDER)(\\d+)", java.util.regex.Pattern.CASE_INSENSITIVE);
        java.util.regex.Matcher matcher = pattern.matcher(transactionContent);
        
        if (matcher.find()) {
            try {
                return Long.parseLong(matcher.group(1));
            } catch (NumberFormatException e) {
                return null;
            }
        }
        
        return null;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getSepayTransactionId() {
        return sepayTransactionId;
    }
    
    public void setSepayTransactionId(Long sepayTransactionId) {
        this.sepayTransactionId = sepayTransactionId;
    }
    
    public String getGateway() {
        return gateway;
    }
    
    public void setGateway(String gateway) {
        this.gateway = gateway;
    }
    
    public LocalDateTime getTransactionDate() {
        return transactionDate;
    }
    
    public void setTransactionDate(LocalDateTime transactionDate) {
        this.transactionDate = transactionDate;
    }
    
    public String getAccountNumber() {
        return accountNumber;
    }
    
    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }
    
    public String getSubAccount() {
        return subAccount;
    }
    
    public void setSubAccount(String subAccount) {
        this.subAccount = subAccount;
    }
    
    public String getTransferType() {
        return transferType;
    }
    
    public void setTransferType(String transferType) {
        this.transferType = transferType;
    }
    
    public BigDecimal getTransferAmount() {
        return transferAmount;
    }
    
    public void setTransferAmount(BigDecimal transferAmount) {
        this.transferAmount = transferAmount;
    }
    
    public BigDecimal getAccumulated() {
        return accumulated;
    }
    
    public void setAccumulated(BigDecimal accumulated) {
        this.accumulated = accumulated;
    }
    
    public String getCode() {
        return code;
    }
    
    public void setCode(String code) {
        this.code = code;
    }
    
    public String getTransactionContent() {
        return transactionContent;
    }
    
    public void setTransactionContent(String transactionContent) {
        this.transactionContent = transactionContent;
    }
    
    public String getReferenceCode() {
        return referenceCode;
    }
    
    public void setReferenceCode(String referenceCode) {
        this.referenceCode = referenceCode;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Boolean getProcessed() {
        return processed;
    }
    
    public void setProcessed(Boolean processed) {
        this.processed = processed;
    }
    
    public Long getOrderId() {
        return orderId;
    }
    
    public void setOrderId(Long orderId) {
        this.orderId = orderId;
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