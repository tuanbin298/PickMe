package org.example.exception;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Exception khi không tìm thấy user")
public class UserNotFoundException extends RuntimeException {
    
    @Schema(description = "ID hoặc email của user không tìm thấy")
    private String identifier;
    
    public UserNotFoundException(String identifier) {
        super("Không tìm thấy user với thông tin: " + identifier);
        this.identifier = identifier;
    }
    
    public UserNotFoundException(Long id) {
        super("Không tìm thấy user với ID: " + id);
        this.identifier = id.toString();
    }
    
    public UserNotFoundException(String identifier, String message) {
        super(message);
        this.identifier = identifier;
    }
    
    public String getIdentifier() {
        return identifier;
    }
}