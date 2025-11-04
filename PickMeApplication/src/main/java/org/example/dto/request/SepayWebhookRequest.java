package org.example.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * DTO cho SePay Webhook Request
 * Mapping theo format của SePay webhook
 */
public class SepayWebhookRequest {
    
    @JsonProperty("id")
    @NotNull
    private Long id; // ID giao dịch trên SePay
    
    @JsonProperty("gateway")
    private String gateway; // Brand name của ngân hàng
    
    @JsonProperty("transactionDate")
    private String transactionDate; // Format: "2024-07-25 14:02:37"
    
    @JsonProperty("accountNumber")
    private String accountNumber; // Số tài khoản ngân hàng
    
    @JsonProperty("subAccount")
    private String subAccount; // Tài khoản ngân hàng phụ
    
    @JsonProperty("transferType")
    private String transferType; // "in" hoặc "out"
    
    @JsonProperty("transferAmount")
    private BigDecimal transferAmount; // Số tiền giao dịch
    
    @JsonProperty("accumulated")
    private BigDecimal accumulated; // Số dư tài khoản
    
    @JsonProperty("code")
    private String code; // Mã code thanh toán
    
    @JsonProperty("content")
    private String content; // Nội dung chuyển khoản
    
    @JsonProperty("referenceCode")
    private String referenceCode; // Mã tham chiếu
    
    @JsonProperty("description")
    private String description; // Toàn bộ nội dung tin notify ngân hàng
    
    // Constructors
    public SepayWebhookRequest() {}
    
    // Helper methods
    public LocalDateTime getParsedTransactionDate() {
        if (transactionDate == null || transactionDate.isEmpty()) {
            return LocalDateTime.now();
        }
        
        try {
            // Parse format: "2024-07-25 14:02:37"
            return LocalDateTime.parse(transactionDate.replace(" ", "T"));
        } catch (Exception e) {
            return LocalDateTime.now();
        }
    }
    
    public boolean isMoneyIn() {
        return "in".equals(transferType);
    }
    
    public boolean isMoneyOut() {
        return "out".equals(transferType);
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getGateway() {
        return gateway;
    }
    
    public void setGateway(String gateway) {
        this.gateway = gateway;
    }
    
    public String getTransactionDate() {
        return transactionDate;
    }
    
    public void setTransactionDate(String transactionDate) {
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
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
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
}