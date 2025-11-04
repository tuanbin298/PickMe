package org.example.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

@Schema(description = "Request để reset mật khẩu với OTP")
public class ResetPasswordWithOtpRequest {
    
    @Schema(description = "Email của user", example = "user@example.com")
    @NotBlank(message = "Email là bắt buộc")
    @Email(message = "Email phải có định dạng hợp lệ")
    private String email;
    
    @Schema(description = "Mã OTP (6 chữ số)", example = "123456")
    @NotBlank(message = "OTP là bắt buộc")
    @Pattern(regexp = "^\\d{6}$", message = "OTP phải là 6 chữ số")
    private String otp;
    
    @Schema(description = "Mật khẩu mới (tối thiểu 6 ký tự)", example = "newpassword123")
    @NotBlank(message = "Mật khẩu mới là bắt buộc")
    @Size(min = 6, message = "Mật khẩu phải có ít nhất 6 ký tự")
    private String newPassword;
    
    @Schema(description = "Xác nhận mật khẩu mới", example = "newpassword123")
    @NotBlank(message = "Xác nhận mật khẩu là bắt buộc")
    private String confirmPassword;
    
    // Constructors
    public ResetPasswordWithOtpRequest() {}
    
    public ResetPasswordWithOtpRequest(String email, String otp, String newPassword, String confirmPassword) {
        this.email = email;
        this.otp = otp;
        this.newPassword = newPassword;
        this.confirmPassword = confirmPassword;
    }
    
    // Validation method
    public boolean isPasswordsMatch() {
        return newPassword != null && newPassword.equals(confirmPassword);
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
    
    public String getNewPassword() {
        return newPassword;
    }
    
    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }
    
    public String getConfirmPassword() {
        return confirmPassword;
    }
    
    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }
}