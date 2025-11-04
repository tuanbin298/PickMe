package org.example.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.example.entity.Role;

@Schema(description = "Request để đăng ký tài khoản mới")
public class RegisterRequest {
    
    @Schema(description = "Email của user", example = "user@example.com")
    @NotBlank(message = "Email is required")
    @Email(message = "Email should be valid")
    private String email;
    
    @Schema(description = "Mật khẩu (tối thiểu 6 ký tự)", example = "password123")
    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password should have at least 6 characters")
    private String password;
    
    @Schema(description = "Họ và tên đầy đủ", example = "Nguyễn Văn A")
    @NotBlank(message = "Full name is required")
    private String fullName;
    
    @Schema(description = "Số điện thoại", example = "0123456789")
    private String phoneNumber;
    
    @Schema(description = "URL ảnh đại diện", example = "https://example.com/avatar.jpg")
    private String imageUrl;
    
    @Schema(description = "Vai trò của user", example = "CUSTOMER", allowableValues = {"ADMIN", "CUSTOMER", "RESTAURANT_OWNER"})
    @NotNull(message = "Role is required")
    private Role role;
    
    // Constructors
    public RegisterRequest() {}
    
    public RegisterRequest(String email, String password, String fullName, Role role) {
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.role = role;
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
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getPhoneNumber() {
        return phoneNumber;
    }
    
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public Role getRole() {
        return role;
    }
    
    public void setRole(Role role) {
        this.role = role;
    }
}