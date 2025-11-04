package org.example.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.event.ApplicationEnvironmentPreparedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.PropertiesPropertySource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Properties;

/**
 * Environment Loader để load file .env khi application khởi động
 * Sử dụng spring.factories để tự động register
 */
public class EnvironmentLoader implements ApplicationListener<ApplicationEnvironmentPreparedEvent> {

    private static final Logger logger = LoggerFactory.getLogger(EnvironmentLoader.class);
    private static final String ENV_FILE_NAME = ".env";
    private static final String ENV_PROPERTY_SOURCE_NAME = "envFile";

    @Override
    public void onApplicationEvent(ApplicationEnvironmentPreparedEvent event) {
        ConfigurableEnvironment environment = event.getEnvironment();
        loadEnvFile(environment);
    }

    private void loadEnvFile(ConfigurableEnvironment environment) {
        Properties envProperties = new Properties();
        
        // Thử load file .env từ nhiều vị trí khác nhau
        String[] envFilePaths = {
            ENV_FILE_NAME,  // Thư mục gốc của project
            "config/" + ENV_FILE_NAME,  // Thư mục config
            System.getProperty("user.dir") + "/" + ENV_FILE_NAME,  // Working directory
            System.getProperty("user.home") + "/" + ENV_FILE_NAME   // Home directory
        };

        boolean loaded = false;
        
        for (String envFilePath : envFilePaths) {
            try {
                // Thử load từ file system trước
                Path path = Paths.get(envFilePath);
                if (Files.exists(path)) {
                    logger.info("Loading .env file from: {}", path.toAbsolutePath());
                    try (InputStream inputStream = Files.newInputStream(path)) {
                        envProperties.load(inputStream);
                        loaded = true;
                        break;
                    }
                }
                
                // Nếu không tìm thấy trong file system, thử load từ classpath
                Resource resource = new ClassPathResource(envFilePath);
                if (resource.exists()) {
                    logger.info("Loading .env file from classpath: {}", envFilePath);
                    try (InputStream inputStream = resource.getInputStream()) {
                        envProperties.load(inputStream);
                        loaded = true;
                        break;
                    }
                }
            } catch (IOException e) {
                logger.debug("Could not load .env file from: {} - {}", envFilePath, e.getMessage());
            }
        }

        if (loaded) {
            // Parse và add các environment variables
            Properties parsedProperties = parseEnvProperties(envProperties);
            
            // Add property source với priority cao (trước các property source khác)
            environment.getPropertySources().addFirst(
                new PropertiesPropertySource(ENV_PROPERTY_SOURCE_NAME, parsedProperties)
            );
            
            logger.info("Successfully loaded {} environment variables from .env file", parsedProperties.size());
            
            // Log các biến đã load (không log giá trị để bảo mật)
            parsedProperties.keySet().forEach(key -> 
                logger.debug("Loaded environment variable: {}", key)
            );
        } else {
            logger.warn("No .env file found in any of the expected locations: {}", String.join(", ", envFilePaths));
        }
    }

    /**
     * Parse các properties từ file .env
     * Hỗ trợ comment (#), empty lines, và format KEY=VALUE
     */
    private Properties parseEnvProperties(Properties rawProperties) {
        Properties parsedProperties = new Properties();
        
        rawProperties.forEach((key, value) -> {
            String keyStr = key.toString().trim();
            String valueStr = value.toString().trim();
            
            // Bỏ qua comment và empty lines
            if (keyStr.isEmpty() || keyStr.startsWith("#")) {
                return;
            }
            
            // Remove quotes nếu có
            if (valueStr.startsWith("\"") && valueStr.endsWith("\"")) {
                valueStr = valueStr.substring(1, valueStr.length() - 1);
            } else if (valueStr.startsWith("'") && valueStr.endsWith("'")) {
                valueStr = valueStr.substring(1, valueStr.length() - 1);
            }
            
            // Set cả property và system property
            parsedProperties.setProperty(keyStr, valueStr);
            System.setProperty(keyStr, valueStr);
        });
        
        return parsedProperties;
    }
}