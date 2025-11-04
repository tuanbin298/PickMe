package org.example.exception;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Exception khi thông tin đăng nhập không hợp lệ")
public class InvalidCredentialsException extends RuntimeException {
    
    @Schema(description = "Email được sử dụng để đăng nhập", example = "user@example.com")
    private String email;
    
    public InvalidCredentialsException(String email) {
        super("Thông tin đăng nhập không hợp lệ cho email: " + email);
        this.email = email;
    }
    
    public InvalidCredentialsException(String email, String message) {
        super(message);
        this.email = email;
    }
    
    public String getEmail() {
        return email;
    }
}