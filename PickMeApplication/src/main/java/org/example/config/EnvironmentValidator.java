package org.example.config;

import org.example.util.EnvUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

/**
 * Configuration validator để kiểm tra các environment variables cần thiết
 */
@Component
public class EnvironmentValidator {

    private static final Logger logger = LoggerFactory.getLogger(EnvironmentValidator.class);

    @Autowired
    private EnvUtil envUtil;

    @EventListener(ApplicationReadyEvent.class)
    public void validateEnvironmentVariables() {
        logger.info("Validating environment variables...");

        boolean isValid = true;

        // Kiểm tra các biến môi trường bắt buộc
        isValid &= validateRequired("DB_PASSWORD", "Database password");
        isValid &= validateRequired("JWT_SECRET", "JWT secret key");
        isValid &= validateRequired("MAIL_USERNAME", "Email username");
        isValid &= validateRequired("MAIL_PASSWORD", "Email password");

        // Kiểm tra JWT secret length (phải ít nhất 32 ký tự)
        String jwtSecret = envUtil.getJwtSecret();
        if (jwtSecret != null && jwtSecret.length() < 32) {
            logger.error("JWT_SECRET must be at least 32 characters long. Current length: {}", jwtSecret.length());
            isValid = false;
        }

        // Kiểm tra email format
        String mailUsername = envUtil.getMailUsername();
        if (mailUsername != null && !isValidEmail(mailUsername)) {
            logger.error("MAIL_USERNAME is not a valid email format: {}", mailUsername);
            isValid = false;
        }

        // Kiểm tra port number
        Integer serverPort = envUtil.getServerPort();
        if (serverPort != null && (serverPort < 1 || serverPort > 65535)) {
            logger.error("SERVER_PORT must be between 1 and 65535. Current value: {}", serverPort);
            isValid = false;
        }

        // Log thông tin môi trường
        logEnvironmentInfo();

        if (isValid) {
            logger.info("✅ All environment variables are valid!");
        } else {
            logger.error("❌ Some environment variables are missing or invalid. Please check your .env file.");
            // Không throw exception để không crash ứng dụng, chỉ log warning
        }
    }

    private boolean validateRequired(String key, String description) {
        if (!envUtil.hasEnv(key) || envUtil.getEnv(key) == null || envUtil.getEnv(key).trim().isEmpty()) {
            logger.error("Missing required environment variable: {} ({})", key, description);
            return false;
        }
        logger.debug("✅ {} is configured", key);
        return true;
    }

    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    private void logEnvironmentInfo() {
        logger.info("=== Environment Information ===");
        logger.info("App Environment: {}", envUtil.getAppEnvironment());
        logger.info("Server Port: {}", envUtil.getServerPort());
        logger.info("App Base URL: {}", envUtil.getAppBaseUrl());
        logger.info("JWT Expiration: {} ms", envUtil.getJwtExpiration());
        logger.info("Mail From: {}", envUtil.getMailFrom());
        logger.info("Development Mode: {}", envUtil.isDevelopment());
        logger.info("===============================");
    }
}