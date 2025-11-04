package org.example.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "password_reset_otps")
public class PasswordResetOtp {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 6)
    private String otp;
    
    @Column(nullable = false)
    private String email;
    
    @Column(name = "expires_at", nullable = false)
    private LocalDateTime expiresAt;
    
    @Column(name = "used", nullable = false)
    private Boolean used = false;
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "attempts", nullable = false)
    private Integer attempts = 0;
    
    @Column(name = "max_attempts", nullable = false)
    private Integer maxAttempts = 3;
    
    // Constructors
    public PasswordResetOtp() {
        this.createdAt = LocalDateTime.now();
        this.expiresAt = LocalDateTime.now().plusMinutes(5); // Expire after 5 minutes
    }
    
    public PasswordResetOtp(String otp, String email) {
        this();
        this.otp = otp;
        this.email = email;
    }
    
    public PasswordResetOtp(String otp, String email, int expirationMinutes) {
        this();
        this.otp = otp;
        this.email = email;
        this.expiresAt = LocalDateTime.now().plusMinutes(expirationMinutes);
    }
    
    // Helper methods
    public boolean isExpired() {
        return LocalDateTime.now().isAfter(this.expiresAt);
    }
    
    public boolean isValid() {
        return !this.used && !this.isExpired() && this.attempts < this.maxAttempts;
    }
    
    public void incrementAttempts() {
        this.attempts++;
    }
    
    public boolean hasExceededMaxAttempts() {
        return this.attempts >= this.maxAttempts;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getOtp() {
        return otp;
    }
    
    public void setOtp(String otp) {
        this.otp = otp;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }
    
    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }
    
    public Boolean getUsed() {
        return used;
    }
    
    public void setUsed(Boolean used) {
        this.used = used;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public Integer getAttempts() {
        return attempts;
    }
    
    public void setAttempts(Integer attempts) {
        this.attempts = attempts;
    }
    
    public Integer getMaxAttempts() {
        return maxAttempts;
    }
    
    public void setMaxAttempts(Integer maxAttempts) {
        this.maxAttempts = maxAttempts;
    }
}