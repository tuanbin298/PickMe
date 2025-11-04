package org.example.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

@Schema(description = "Request để yêu cầu gửi OTP reset mật khẩu")
public class SendOtpRequest {
    
    @Schema(description = "Email của user cần reset mật khẩu", example = "user@example.com")
    @NotBlank(message = "Email là bắt buộc")
    @Email(message = "Email phải có định dạng hợp lệ")
    private String email;
    
    // Constructors
    public SendOtpRequest() {}
    
    public SendOtpRequest(String email) {
        this.email = email;
    }
    
    // Getters and Setters
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
}