package org.example.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Schema(description = "Request để đăng nhập")
public class LoginRequest {
    
    @Schema(description = "Email của user", example = "user@example.com")
    @NotBlank(message = "Email is required")
    @Email(message = "Email should be valid")
    private String email;
    
    @Schema(description = "Mật khẩu (tối thiểu 6 ký tự)", example = "password123")
    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password should have at least 6 characters")
    private String password;
    
    // Constructors
    public LoginRequest() {}
    
    public LoginRequest(String email, String password) {
        this.email = email;
        this.password = password;
    }
    
    // Getters and Setters
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
}