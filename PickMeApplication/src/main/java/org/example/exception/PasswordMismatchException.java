package org.example.exception;

public class PasswordMismatchException extends RuntimeException {
    
    public PasswordMismatchException() {
        super("Mật khẩu xác nhận không khớp.");
    }
    
    public PasswordMismatchException(String message) {
        super(message);
    }
}