package org.example.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

    @Value("${CLOUDFLARED_URL:}")
    private String cloudflaredUrl;
    
    @Value("${APP_BASE_URL:http://localhost:8080}")
    private String appBaseUrl;

    @Bean
    public OpenAPI customOpenAPI() {
        // ✅ Cloudflare Tunnel URL
        String actualCloudflaredUrl = "https://shops-miss-joshua-warm.trycloudflare.com";
        
        // 🔍 DEBUG: Log giá trị environment variables
        System.out.println("🔍 SwaggerConfig DEBUG:");
        System.out.println("   CLOUDFLARED_URL (from env) = '" + cloudflaredUrl + "'");
        System.out.println("   CLOUDFLARED_URL (forced) = '" + actualCloudflaredUrl + "'");
        System.out.println("   APP_BASE_URL = '" + appBaseUrl + "'");
        
        OpenAPI openAPI = new OpenAPI()
                .info(new Info()
                        .title("PickMe Application API")
                        .version("1.0.0")
                        .description("API documentation for PickMe Application - Ứng dụng đặt trước và đến lấy với 3 roles: Admin, Customer, Restaurant Owner")
                        .contact(new Contact()
                                .name("PickMe Team")
                                .email("support@pickmeapp.com")
                                .url("https://pickmeapp.com"))
                        .license(new License()
                                .name("MIT License")
                                .url("https://opensource.org/licenses/MIT")));
        
        // ✅ Thêm Cloudflare Tunnel server TRƯỚC (làm default)
        System.out.println("✅ Adding Cloudflare Tunnel server: " + actualCloudflaredUrl);
        openAPI.addServersItem(new Server()
                .url(actualCloudflaredUrl)
                .description("Cloudflare Tunnel HTTPS Server (Default)"));
        
        // ✅ Add localhost server sau
        System.out.println("✅ Adding localhost server: " + appBaseUrl);
        openAPI.addServersItem(new Server()
                        .url(appBaseUrl)
                        .description("Local Development Server"));
        
        return openAPI
                .addSecurityItem(new SecurityRequirement().addList("Bearer Authentication"))
                .components(new Components()
                        .addSecuritySchemes("Bearer Authentication", 
                                new SecurityScheme()
                                        .type(SecurityScheme.Type.HTTP)
                                        .scheme("bearer")
                                        .bearerFormat("JWT")
                                        .description("Enter JWT token (without 'Bearer ' prefix)")
                        )
                );
    }
}