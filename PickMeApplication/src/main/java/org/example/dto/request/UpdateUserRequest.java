package org.example.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import org.example.entity.Role;

public class UpdateUserRequest {
    
    @Email(message = "Email should be valid")
    private String email;
    
    @NotBlank(message = "Full name is required")
    private String fullName;
    
    private String phoneNumber;
    
    private String imageUrl;
    
    private Role role;
    
    private Boolean isActive;
    
    // Constructors
    public UpdateUserRequest() {}
    
    public UpdateUserRequest(String email, String fullName, String phoneNumber, 
                           String imageUrl, Role role, Boolean isActive) {
        this.email = email;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.imageUrl = imageUrl;
        this.role = role;
        this.isActive = isActive;
    }
    
    // Getters and Setters
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
    
    public Boolean getIsActive() {
        return isActive;
    }
    
    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
}