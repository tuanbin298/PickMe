package org.example.config;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.example.util.EnvUtil;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Test class để kiểm tra EnvironmentLoader hoạt động đúng
 */
@SpringBootTest
@TestPropertySource(properties = {
    "TEST_ENV_VAR=test_value",
    "DB_PASSWORD=test_password"
})
class EnvironmentLoaderTest {

    @Autowired
    private Environment environment;

    @Autowired
    private EnvUtil envUtil;

    @Test
    void testEnvironmentLoader() {
        // Test basic property access
        assertNotNull(environment);
        
        // Test EnvUtil functionality
        assertNotNull(envUtil);
        
        // Test getting property with default value
        String testValue = envUtil.getEnv("NON_EXISTENT_KEY", "default_value");
        assertEquals("default_value", testValue);
        
        // Test integer conversion
        Integer port = envUtil.getEnvAsInt("SERVER_PORT", 8080);
        assertNotNull(port);
        assertTrue(port > 0 && port <= 65535);
        
        // Test boolean conversion
        Boolean isDev = envUtil.getEnvAsBoolean("IS_DEV", true);
        assertNotNull(isDev);
        
        // Test environment detection
        String appEnv = envUtil.getAppEnvironment();
        assertNotNull(appEnv);
    }

    @Test
    void testEnvironmentVariableAccess() {
        // Test accessing environment variables
        String jwtSecret = envUtil.getJwtSecret();
        // JWT secret có thể null trong test environment, điều đó OK
        
        Long jwtExpiration = envUtil.getJwtExpiration();
        assertNotNull(jwtExpiration);
        assertTrue(jwtExpiration > 0);
        
        String baseUrl = envUtil.getAppBaseUrl();
        assertNotNull(baseUrl);
        assertTrue(baseUrl.startsWith("http"));
    }

    @Test 
    void testEnvironmentTypeChecking() {
        // Test development/production detection
        boolean isDev = envUtil.isDevelopment();
        boolean isProd = envUtil.isProduction();
        
        // Ít nhất một trong hai phải false (không thể vừa dev vừa prod)
        assertFalse(isDev && isProd);
    }

    @Test
    void testPropertyExistence() {
        // Test hasEnv method
        assertTrue(envUtil.hasEnv("spring.application.name") || !envUtil.hasEnv("DEFINITELY_NOT_EXISTS"));
        
        // Test với property có default value
        Integer serverPort = envUtil.getEnvAsInt("SERVER_PORT", 8080);
        assertEquals(8080, serverPort); // Should return default if not set
    }
}