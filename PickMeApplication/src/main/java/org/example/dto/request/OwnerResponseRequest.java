package org.example.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * DTO cho request phản hồi từ restaurant owner
 */
public class OwnerResponseRequest {
    
    @NotBlank(message = "Response is required")
    @Size(min = 10, max = 500, message = "Response must be between 10 and 500 characters")
    private String response;
    
    // Constructors
    public OwnerResponseRequest() {}
    
    public OwnerResponseRequest(String response) {
        this.response = response;
    }
    
    // Getters and Setters
    public String getResponse() {
        return response;
    }
    
    public void setResponse(String response) {
        this.response = response;
    }
}