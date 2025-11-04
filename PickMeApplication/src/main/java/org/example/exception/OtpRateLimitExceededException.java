package org.example.exception;

public class OtpRateLimitExceededException extends RuntimeException {
    
    public OtpRateLimitExceededException() {
        super("Bạn đã yêu cầu OTP quá nhiều lần. Vui lòng thử lại sau 1 giờ.");
    }
    
    public OtpRateLimitExceededException(String message) {
        super(message);
    }
}