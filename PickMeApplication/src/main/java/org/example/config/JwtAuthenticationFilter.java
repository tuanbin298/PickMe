package org.example.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.service.CustomUserDetailsService;
import org.example.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    
    @Autowired
    private JwtUtil jwtUtil;
    
    @Autowired
    private CustomUserDetailsService userDetailsService;
    
    @Override
    protected void doFilterInternal(HttpServletRequest request, 
                                  HttpServletResponse response, 
                                  FilterChain filterChain) throws ServletException, IOException {
        
        // ✅ Skip JWT processing for public endpoints (webhooks, auth, etc.)
        String requestPath = request.getRequestURI();
        if (isPublicEndpoint(requestPath)) {
            filterChain.doFilter(request, response);
            return;
        }
        
        final String authorizationHeader = request.getHeader("Authorization");
        
        String username = null;
        String jwt = null;
        
        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            jwt = authorizationHeader.substring(7);
            try {
                username = jwtUtil.extractUsername(jwt);
            } catch (Exception e) {
                logger.error("Cannot get JWT Username from Bearer Token");
            }
        }
        
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            UserDetails userDetails = this.userDetailsService.loadUserByUsername(username);
            
            if (jwtUtil.validateToken(jwt, userDetails)) {
                UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken = 
                    new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                usernamePasswordAuthenticationToken
                    .setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);
            }
        }
        filterChain.doFilter(request, response);
    }
    
    /**
     * Kiểm tra xem endpoint có phải là public không (không cần JWT)
     */
    private boolean isPublicEndpoint(String requestPath) {
        // ✅ Webhook endpoints - KHÔNG cần JWT
        if (requestPath.equals("/api/payments/sepay/webhook")) {
            return true;
        }
        if (requestPath.matches("/api/payments/order/\\d+/status")) {
            return true;
        }
        
        // ✅ Auth endpoints
        if (requestPath.startsWith("/api/auth/")) {
            return true;
        }
        
        // ✅ Swagger UI endpoints
        if (requestPath.startsWith("/swagger-ui/") || 
            requestPath.startsWith("/v3/api-docs/") || 
            requestPath.equals("/swagger-ui.html")) {
            return true;
        }
        
        // ✅ Public restaurant endpoints
        if (requestPath.startsWith("/api/restaurants/public/") ||
            requestPath.matches("/api/restaurants/\\d+/menu/public") ||
            requestPath.startsWith("/api/restaurants/") && requestPath.contains("/menu/categories") ||
            requestPath.startsWith("/api/restaurants/") && requestPath.contains("/menu/category/") ||
            requestPath.startsWith("/api/restaurants/") && requestPath.contains("/menu/search")) {
            return true;
        }
        
        // ✅ Demo endpoints
        if (requestPath.startsWith("/api/demo/")) {
            return true;
        }
        
        return false;
    }
}