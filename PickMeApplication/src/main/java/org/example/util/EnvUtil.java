package org.example.util;

import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

/**
 * Utility class để truy cập environment variables một cách dễ dàng
 */
@Component
public class EnvUtil {

    private final Environment environment;

    public EnvUtil(Environment environment) {
        this.environment = environment;
    }

    /**
     * Lấy giá trị environment variable
     * @param key tên của environment variable
     * @return giá trị của environment variable hoặc null nếu không tồn tại
     */
    public String getEnv(String key) {
        return environment.getProperty(key);
    }

    /**
     * Lấy giá trị environment variable với default value
     * @param key tên của environment variable
     * @param defaultValue giá trị mặc định nếu không tìm thấy
     * @return giá trị của environment variable hoặc defaultValue
     */
    public String getEnv(String key, String defaultValue) {
        return environment.getProperty(key, defaultValue);
    }

    /**
     * Lấy giá trị environment variable dạng Integer
     * @param key tên của environment variable
     * @param defaultValue giá trị mặc định nếu không tìm thấy
     * @return giá trị Integer hoặc defaultValue
     */
    public Integer getEnvAsInt(String key, Integer defaultValue) {
        String value = environment.getProperty(key);
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.valueOf(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Lấy giá trị environment variable dạng Long
     * @param key tên của environment variable
     * @param defaultValue giá trị mặc định nếu không tìm thấy
     * @return giá trị Long hoặc defaultValue
     */
    public Long getEnvAsLong(String key, Long defaultValue) {
        String value = environment.getProperty(key);
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Long.valueOf(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Lấy giá trị environment variable dạng Boolean
     * @param key tên của environment variable
     * @param defaultValue giá trị mặc định nếu không tìm thấy
     * @return giá trị Boolean hoặc defaultValue
     */
    public Boolean getEnvAsBoolean(String key, Boolean defaultValue) {
        String value = environment.getProperty(key);
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        return Boolean.valueOf(value.trim());
    }

    /**
     * Kiểm tra xem environment variable có tồn tại không
     * @param key tên của environment variable
     * @return true nếu tồn tại, false nếu không
     */
    public boolean hasEnv(String key) {
        return environment.containsProperty(key);
    }

    // Các method tiện ích cho các environment variables thường dùng

    public String getDatabasePassword() {
        return getEnv("DB_PASSWORD");
    }

    public String getJwtSecret() {
        return getEnv("JWT_SECRET");
    }

    public Long getJwtExpiration() {
        return getEnvAsLong("JWT_EXPIRATION", 86400000L);
    }

    public String getMailUsername() {
        return getEnv("MAIL_USERNAME");
    }

    public String getMailPassword() {
        return getEnv("MAIL_PASSWORD");
    }

    public String getMailFrom() {
        return getEnv("MAIL_FROM");
    }

    public String getAppBaseUrl() {
        return getEnv("APP_BASE_URL", "http://localhost:8080");
    }

    public Integer getServerPort() {
        return getEnvAsInt("SERVER_PORT", 8080);
    }

    public String getAppEnvironment() {
        return getEnv("APP_ENV", "development");
    }

    public boolean isDevelopment() {
        return "development".equalsIgnoreCase(getAppEnvironment());
    }

    public boolean isProduction() {
        return "production".equalsIgnoreCase(getAppEnvironment());
    }
}