package org.example.exception;

public class OtpExpiredException extends RuntimeException {
    
    public OtpExpiredException() {
        super("OTP đã hết hạn. Vui lòng yêu cầu OTP mới.");
    }
    
    public OtpExpiredException(String message) {
        super(message);
    }
}