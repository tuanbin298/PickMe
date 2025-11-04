package org.example.config;

import org.example.service.CustomUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;
    
    @Value("${CLOUDFLARED_URL:}")
    private String cloudflaredUrl;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // ✅ Bật CORS với cấu hình custom
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                // ✅ Tắt CSRF (vì API REST không cần)
                .csrf(AbstractHttpConfigurer::disable)
                // ✅ Cấu hình quyền truy cập
                .authorizeHttpRequests(authz -> authz
                        // ✅ WEBHOOK - MUST BE FIRST (highest priority)
                        .requestMatchers("/api/payments/sepay/webhook").permitAll()
                        .requestMatchers("/api/payments/order/*/status").permitAll()
                        // Other public endpoints
                        .requestMatchers("/api/auth/**").permitAll()
                        .requestMatchers("/swagger-ui/**", "/v3/api-docs/**", "/swagger-ui.html").permitAll()
                        .requestMatchers("/api/demo/**").permitAll()
                        // Public endpoints for customers (no authentication required)
                        .requestMatchers("/api/restaurants/public/**").permitAll()
                        .requestMatchers("/api/restaurants/*/menu/public").permitAll()
                        .requestMatchers("/api/restaurants/*/menu/categories").permitAll()
                        .requestMatchers("/api/restaurants/*/menu/category/**").permitAll()
                        .requestMatchers("/api/restaurants/*/menu/search").permitAll()
                        // Method-level security will handle detailed authorization
                        .anyRequest().authenticated()
                )
                // ✅ Stateless session (vì dùng JWT)
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                // ✅ Thêm authentication provider và JWT filter
                .authenticationProvider(authenticationProvider())
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    // 🔥 CORS configuration - Cấu hình chính xác và bảo mật
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        
        // ✅ Danh sách origins được phép (localhost + cloudflare tunnel)
        List<String> allowedOrigins = List.of(
            "http://localhost:3000",
            "http://localhost:5173", 
            "http://localhost:8080"
        );
        
        // ✅ Thêm Cloudflare Tunnel URL nếu có
        if (cloudflaredUrl != null && !cloudflaredUrl.trim().isEmpty()) {
            allowedOrigins = new java.util.ArrayList<>(allowedOrigins);
            allowedOrigins.add(cloudflaredUrl.trim());
        }
        
        configuration.setAllowedOrigins(allowedOrigins);
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"));
        configuration.setAllowedHeaders(List.of(
            "Authorization", 
            "Content-Type", 
            "Accept", 
            "X-Requested-With", 
            "Cache-Control"
        ));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L); // Cache preflight for 1 hour

        // Đăng ký cấu hình CORS cho toàn bộ API
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}