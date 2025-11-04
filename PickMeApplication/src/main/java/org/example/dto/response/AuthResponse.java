package org.example.dto.response;

import org.example.entity.Role;

import java.time.LocalDateTime;

public class AuthResponse {
    
    private String token;
    private String type = "Bearer";
    private Long id;
    private String email;
    private String fullName;
    private String phoneNumber;
    private String imageUrl;
    private Role role;
    private LocalDateTime createdAt;
    
    // Constructors
    public AuthResponse() {}
    
    public AuthResponse(String token, Long id, String email, String fullName, 
                       String phoneNumber, String imageUrl, Role role, LocalDateTime createdAt) {
        this.token = token;
        this.id = id;
        this.email = email;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.imageUrl = imageUrl;
        this.role = role;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public String getToken() {
        return token;
    }
    
    public void setToken(String token) {
        this.token = token;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getPhoneNumber() {
        return phoneNumber;
    }
    
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public Role getRole() {
        return role;
    }
    
    public void setRole(Role role) {
        this.role = role;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}