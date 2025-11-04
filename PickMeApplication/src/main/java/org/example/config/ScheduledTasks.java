package org.example.config;

import org.example.service.OtpPasswordResetService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class ScheduledTasks {
    
    private static final Logger logger = LoggerFactory.getLogger(ScheduledTasks.class);

    
    @Autowired
    private OtpPasswordResetService otpPasswordResetService;

    // Chạy mỗi 10 phút để dọn dẹp expired OTPs
    @Scheduled(fixedRate = 600000) // 10 minutes = 600000 milliseconds
    public void cleanupExpiredOtps() {
        logger.info("Starting cleanup of expired OTPs");
        otpPasswordResetService.cleanupExpiredOtps();
        logger.info("Completed cleanup of expired OTPs");
    }
}