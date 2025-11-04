package org.example.service;

import org.example.dto.request.SepayWebhookRequest;
import org.example.entity.SepayTransaction;
import org.example.repository.SepayTransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
@Transactional
public class SepayService {
    
    @Autowired
    private SepayTransactionRepository sepayTransactionRepository;
    
    // SePay configuration từ environment variables
    @Value("${sepay.bank.name:VPBank}")
    private String bankName;
    
    @Value("${sepay.account.number:0868767029}")
    private String accountNumber;
    
    @Value("${sepay.account.holder:PICK ME APPLICATION}")
    private String accountHolder;
    
    @Value("${sepay.qr.base.url:https://qr.sepay.vn}")
    private String qrBaseUrl;
    
    /**
     * Tạo QR code URL cho thanh toán SePay
     * Format: https://qr.sepay.vn/img?bank=MBBank&acc=0903252427&template=compact&amount=100000&des=DH123
     */
    public String generateQrCodeUrl(Long orderId, BigDecimal amount) {
        StringBuilder url = new StringBuilder();
        url.append(qrBaseUrl).append("/img?");
        url.append("bank=").append(bankName);
        url.append("&acc=").append(accountNumber);
        url.append("&template=compact");
        url.append("&amount=").append(amount.intValue());
        url.append("&des=DH").append(orderId);
        
        return url.toString();
    }
    
    /**
     * Tạo nội dung thanh toán cho order
     */
    public String generatePaymentContent(Long orderId) {
        return "DH" + orderId;
    }
    
    /**
     * Xử lý webhook từ SePay
     * Lưu transaction và trả về order ID nếu tìm thấy
     */
    public SepayTransaction processWebhook(SepayWebhookRequest request) {
        // Kiểm tra transaction đã tồn tại chưa
        if (sepayTransactionRepository.existsBySepayTransactionId(request.getId())) {
            throw new IllegalArgumentException("Transaction already exists: " + request.getId());
        }
        
        // Tạo SepayTransaction entity
        SepayTransaction transaction = new SepayTransaction();
        transaction.setSepayTransactionId(request.getId());
        transaction.setGateway(request.getGateway());
        transaction.setTransactionDate(request.getParsedTransactionDate());
        transaction.setAccountNumber(request.getAccountNumber());
        transaction.setSubAccount(request.getSubAccount());
        transaction.setTransferType(request.getTransferType());
        transaction.setTransferAmount(request.getTransferAmount());
        transaction.setAccumulated(request.getAccumulated());
        transaction.setCode(request.getCode());
        transaction.setTransactionContent(request.getContent());
        transaction.setReferenceCode(request.getReferenceCode());
        transaction.setDescription(request.getDescription());
        
        // Tách order ID từ nội dung
        Long orderId = transaction.extractOrderId();
        transaction.setOrderId(orderId);
        
        // Lưu transaction
        return sepayTransactionRepository.save(transaction);
    }
    
    /**
     * Lấy transactions chưa được process
     */
    @Transactional(readOnly = true)
    public List<SepayTransaction> getUnprocessedTransactions() {
        return sepayTransactionRepository.findByProcessedFalse();
    }
    
    /**
     * Đánh dấu transaction đã được process
     */
    public void markTransactionAsProcessed(Long transactionId) {
        SepayTransaction transaction = sepayTransactionRepository.findById(transactionId)
                .orElseThrow(() -> new IllegalArgumentException("Transaction not found: " + transactionId));
        
        transaction.markAsProcessed();
        sepayTransactionRepository.save(transaction);
    }
    
    /**
     * Lấy transaction theo SePay ID
     */
    @Transactional(readOnly = true)
    public SepayTransaction getTransactionBySepayId(Long sepayTransactionId) {
        return sepayTransactionRepository.findBySepayTransactionId(sepayTransactionId)
                .orElseThrow(() -> new IllegalArgumentException("Transaction not found: " + sepayTransactionId));
    }
    
    /**
     * Lấy transactions của order
     */
    @Transactional(readOnly = true)
    public List<SepayTransaction> getTransactionsByOrderId(Long orderId) {
        return sepayTransactionRepository.findByOrderId(orderId);
    }
    
    /**
     * Statistics - Tổng tiền vào hôm nay
     */
    @Transactional(readOnly = true)
    public BigDecimal getTotalMoneyInToday() {
        return sepayTransactionRepository.getTotalMoneyInByDate(java.time.LocalDateTime.now());
    }
    
    /**
     * Statistics - Số transactions chưa process
     */
    @Transactional(readOnly = true)
    public long countUnprocessedTransactions() {
        return sepayTransactionRepository.countUnprocessedTransactions();
    }
    
    /**
     * Validate webhook data
     */
    public boolean isValidWebhook(SepayWebhookRequest request) {
        // Basic validation
        if (request.getId() == null || request.getTransferAmount() == null) {
            return false;
        }
        
        // Chỉ process money-in transactions
        if (!"in".equals(request.getTransferType())) {
            return false;
        }
        
        // Kiểm tra account number (nếu cần)
        if (request.getAccountNumber() != null && !accountNumber.equals(request.getAccountNumber())) {
            // Log warning nhưng vẫn process (có thể có nhiều account)
        }
        
        return true;
    }
    
    /**
     * Get payment info cho frontend
     */
    public PaymentInfo getPaymentInfo() {
        return new PaymentInfo(bankName, accountNumber, accountHolder);
    }
    
    // Inner class cho payment info
    public static class PaymentInfo {
        private String bankName;
        private String accountNumber;
        private String accountHolder;
        
        public PaymentInfo(String bankName, String accountNumber, String accountHolder) {
            this.bankName = bankName;
            this.accountNumber = accountNumber;
            this.accountHolder = accountHolder;
        }
        
        // Getters
        public String getBankName() { return bankName; }
        public String getAccountNumber() { return accountNumber; }
        public String getAccountHolder() { return accountHolder; }
    }
}