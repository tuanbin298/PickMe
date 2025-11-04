package org.example.config;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.context.annotation.Configuration;
import jakarta.annotation.PostConstruct;

@Configuration
public class EnvironmentConfig {

    @PostConstruct
    public void loadEnvironmentVariables() {
        try {
            // Load .env file if it exists
            Dotenv dotenv = Dotenv.configure()
                    .ignoreIfMissing() // Don't fail if .env file doesn't exist
                    .load();

            // Set system properties from .env file
            dotenv.entries().forEach(entry -> {
                String key = entry.getKey();
                String value = entry.getValue();
                
                // Only set if not already set as system property or environment variable
                if (System.getProperty(key) == null && System.getenv(key) == null) {
                    System.setProperty(key, value);
                }
            });
            
            System.out.println("Environment variables loaded successfully from .env file");
        } catch (Exception e) {
            System.out.println("Could not load .env file: " + e.getMessage());
            System.out.println("Using system environment variables or default values");
        }
    }
}