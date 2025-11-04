package org.example.service;

import org.example.dto.request.ResetPasswordWithOtpRequest;
import org.example.dto.request.SendOtpRequest;
import org.example.dto.request.VerifyOtpRequest;
import org.example.dto.response.MessageResponse;
import org.example.entity.PasswordResetOtp;
import org.example.entity.User;
import org.example.exception.*;
import org.example.repository.PasswordResetOtpRepository;
import org.example.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Optional;

@Service
@Transactional
public class OtpPasswordResetService {
    
    private static final Logger logger = LoggerFactory.getLogger(OtpPasswordResetService.class);
    private static final int MAX_OTP_REQUESTS_PER_HOUR = 5;
    private static final int OTP_EXPIRATION_MINUTES = 5;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordResetOtpRepository otpRepository;
    
    @Autowired
    private EmailService emailService;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    private final SecureRandom secureRandom = new SecureRandom();
    
    /**
     * Gửi OTP reset password qua email
     */
    public MessageResponse sendOtp(SendOtpRequest request) {
        // Kiểm tra user có tồn tại không
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new UserNotFoundException(request.getEmail()));
        
        // Kiểm tra rate limiting
        if (isRateLimited(request.getEmail())) {
            throw new OtpRateLimitExceededException();
        }
        
        try {
            // Vô hiệu hóa tất cả OTP cũ của email này
            otpRepository.markAllEmailOtpsAsUsed(request.getEmail());
            
            // Tạo OTP mới
            String otp = generateOtp();
            PasswordResetOtp resetOtp = new PasswordResetOtp(otp, request.getEmail(), OTP_EXPIRATION_MINUTES);
            otpRepository.save(resetOtp);
            
            // Gửi email chứa OTP
            emailService.sendOtpEmail(user.getEmail(), user.getFullName(), otp);
            
            logger.info("OTP reset password sent for user: {}", user.getEmail());
            
            return MessageResponse.success("Mã OTP đã được gửi đến email " + user.getEmail() + ". Mã có hiệu lực trong " + OTP_EXPIRATION_MINUTES + " phút.");
            
        } catch (Exception e) {
            logger.error("Error sending OTP for email: {}", request.getEmail(), e);
            throw new RuntimeException("Đã xảy ra lỗi khi gửi OTP. Vui lòng thử lại sau.", e);
        }
    }
    
    /**
     * Xác minh OTP
     */
    public MessageResponse verifyOtp(VerifyOtpRequest request) {
        try {
            // Tìm OTP mới nhất chưa được sử dụng
            Optional<PasswordResetOtp> otpOptional = otpRepository.findLatestByEmailAndUsedFalse(request.getEmail());
            
            if (otpOptional.isEmpty()) {
                throw new OtpNotFoundException(request.getEmail());
            }
            
            PasswordResetOtp resetOtp = otpOptional.get();
            
            // Kiểm tra OTP đã hết hạn chưa
            if (resetOtp.isExpired()) {
                throw new OtpExpiredException();
            }
            
            // Kiểm tra đã vượt quá số lần thử tối đa chưa
            if (resetOtp.hasExceededMaxAttempts()) {
                throw new InvalidOtpException("OTP đã bị khóa do nhập sai quá nhiều lần. Vui lòng yêu cầu OTP mới.");
            }
            
            // Kiểm tra OTP có đúng không
            if (!resetOtp.getOtp().equals(request.getOtp())) {
                resetOtp.incrementAttempts();
                otpRepository.save(resetOtp);
                
                int remainingAttempts = resetOtp.getMaxAttempts() - resetOtp.getAttempts();
                if (remainingAttempts > 0) {
                    throw new InvalidOtpException("OTP không đúng. Bạn còn " + remainingAttempts + " lần thử.");
                } else {
                    throw new InvalidOtpException("OTP không đúng. Bạn đã hết lượt thử. Vui lòng yêu cầu OTP mới.");
                }
            }
            
            logger.info("OTP verified successfully for email: {}", request.getEmail());
            
            return MessageResponse.success("OTP xác minh thành công. Bạn có thể tiến hành đổi mật khẩu.");
            
        } catch (OtpNotFoundException | OtpExpiredException | InvalidOtpException e) {
            throw e;
        } catch (Exception e) {
            logger.error("Error verifying OTP for email: {}", request.getEmail(), e);
            throw new RuntimeException("Đã xảy ra lỗi khi xác minh OTP. Vui lòng thử lại.", e);
        }
    }
    
    /**
     * Reset password với OTP
     */
    public MessageResponse resetPasswordWithOtp(ResetPasswordWithOtpRequest request) {
        // Kiểm tra mật khẩu xác nhận có khớp không
        if (!request.isPasswordsMatch()) {
            throw new PasswordMismatchException();
        }
        
        // Tìm user
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new UserNotFoundException(request.getEmail()));
        
        // Tìm OTP mới nhất chưa được sử dụng
        Optional<PasswordResetOtp> otpOptional = otpRepository.findByEmailAndOtpAndUsedFalse(request.getEmail(), request.getOtp());
        
        if (otpOptional.isEmpty()) {
            throw new OtpNotFoundException(request.getEmail());
        }
        
        PasswordResetOtp resetOtp = otpOptional.get();
        
        // Kiểm tra OTP có hợp lệ không
        if (!resetOtp.isValid()) {
            throw new OtpExpiredException("OTP đã hết hạn hoặc không hợp lệ. Vui lòng yêu cầu OTP mới.");
        }
        
        try {
            // Cập nhật mật khẩu
            user.setPassword(passwordEncoder.encode(request.getNewPassword()));
            userRepository.save(user);
            
            // Đánh dấu OTP đã được sử dụng
            resetOtp.setUsed(true);
            otpRepository.save(resetOtp);
            
            // Vô hiệu hóa tất cả OTP khác của email này
            otpRepository.markAllEmailOtpsAsUsed(request.getEmail());
            
            // Gửi email thông báo đổi mật khẩu thành công
            emailService.sendPasswordChangeNotification(user.getEmail(), user.getFullName());
            
            logger.info("Password reset successfully with OTP for user: {}", user.getEmail());
            
            return MessageResponse.success("Mật khẩu đã được thay đổi thành công.");
            
        } catch (Exception e) {
            logger.error("Error resetting password with OTP for email: {}", request.getEmail(), e);
            throw new RuntimeException("Đã xảy ra lỗi khi reset mật khẩu. Vui lòng thử lại.", e);
        }
    }
    
    /**
     * Dọn dẹp các OTP đã hết hạn và đã sử dụng
     */
    @Transactional
    public void cleanupExpiredOtps() {
        try {
            otpRepository.deleteExpiredAndUsedOtps(LocalDateTime.now());
            logger.info("Cleaned up expired and used OTPs");
        } catch (Exception e) {
            logger.error("Error cleaning up expired OTPs", e);
        }
    }
    
    /**
     * Kiểm tra rate limiting
     */
    private boolean isRateLimited(String email) {
        LocalDateTime oneHourAgo = LocalDateTime.now().minusHours(1);
        long recentAttempts = otpRepository.countByEmailAndCreatedAtAfter(email, oneHourAgo);
        return recentAttempts >= MAX_OTP_REQUESTS_PER_HOUR;
    }
    
    /**
     * Tạo OTP 6 chữ số
     */
    private String generateOtp() {
        int otp = secureRandom.nextInt(900000) + 100000; // Tạo số từ 100000 đến 999999
        return String.valueOf(otp);
    }
}