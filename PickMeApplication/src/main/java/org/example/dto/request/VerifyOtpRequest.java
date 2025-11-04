package org.example.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

@Schema(description = "Request để xác minh OTP")
public class VerifyOtpRequest {
    
    @Schema(description = "Email của user", example = "user@example.com")
    @NotBlank(message = "Email là bắt buộc")
    @Email(message = "Email phải có định dạng hợp lệ")
    private String email;
    
    @Schema(description = "Mã OTP (6 chữ số)", example = "123456")
    @NotBlank(message = "OTP là bắt buộc")
    @Pattern(regexp = "^\\d{6}$", message = "OTP phải là 6 chữ số")
    private String otp;
    
    // Constructors
    public VerifyOtpRequest() {}
    
    public VerifyOtpRequest(String email, String otp) {
        this.email = email;
        this.otp = otp;
    }
    
    // Getters and Setters
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getOtp() {
        return otp;
    }
    
    public void setOtp(String otp) {
        this.otp = otp;
    }
}