package org.example.repository;

import org.example.entity.PasswordResetOtp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Optional;

@Repository
public interface PasswordResetOtpRepository extends JpaRepository<PasswordResetOtp, Long> {
    
    /**
     * Tìm OTP theo email và chưa được sử dụng, sắp xếp theo thời gian tạo mới nhất
     */
    @Query("SELECT o FROM PasswordResetOtp o WHERE o.email = :email AND o.used = false ORDER BY o.createdAt DESC")
    Optional<PasswordResetOtp> findLatestByEmailAndUsedFalse(@Param("email") String email);
    
    /**
     * Tìm OTP theo email, OTP code và chưa được sử dụng
     */
    Optional<PasswordResetOtp> findByEmailAndOtpAndUsedFalse(String email, String otp);
    
    /**
     * Đếm số lượng OTP được tạo trong khoảng thời gian gần đây cho một email
     */
    @Query("SELECT COUNT(o) FROM PasswordResetOtp o WHERE o.email = :email AND o.createdAt > :since")
    long countByEmailAndCreatedAtAfter(@Param("email") String email, @Param("since") LocalDateTime since);
    
    /**
     * Đánh dấu tất cả OTP của một email là đã sử dụng
     */
    @Modifying
    @Query("UPDATE PasswordResetOtp o SET o.used = true WHERE o.email = :email AND o.used = false")
    void markAllEmailOtpsAsUsed(@Param("email") String email);
    
    /**
     * Xóa các OTP đã hết hạn và đã được sử dụng
     */
    @Modifying
    @Query("DELETE FROM PasswordResetOtp o WHERE (o.expiresAt < :now) OR (o.used = true)")
    void deleteExpiredAndUsedOtps(@Param("now") LocalDateTime now);
    
    /**
     * Xóa tất cả OTP của một email
     */
    void deleteByEmail(String email);
}