package org.example.exception;

public class OtpNotFoundException extends RuntimeException {
    
    public OtpNotFoundException(String email) {
        super("Không tìm thấy OTP hợp lệ cho email: " + email);
    }
    
    public OtpNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }
}