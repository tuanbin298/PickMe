package org.example.exception;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Exception khi email đã tồn tại trong hệ thống")
public class EmailAlreadyExistsException extends RuntimeException {
    
    @Schema(description = "Email đã bị trùng", example = "user@example.com")
    private String email;
    
    public EmailAlreadyExistsException(String email) {
        super("Email đã được sử dụng: " + email);
        this.email = email;
    }
    
    public EmailAlreadyExistsException(String email, String message) {
        super(message);
        this.email = email;
    }
    
    public String getEmail() {
        return email;
    }
}