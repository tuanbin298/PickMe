package org.example.exception;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Exception khi không có quyền truy cập")
public class AccessDeniedException extends RuntimeException {
    
    @Schema(description = "Loại quyền bị từ chối", example = "ADMIN_ONLY")
    private String accessType;
    
    @Schema(description = "Resource đang cố gắng truy cập", example = "USER_MANAGEMENT")
    private String resource;
    
    public AccessDeniedException(String message) {
        super(message);
    }
    
    public AccessDeniedException(String accessType, String resource) {
        super("Không có quyền truy cập " + accessType + " cho resource: " + resource);
        this.accessType = accessType;
        this.resource = resource;
    }
    
    public AccessDeniedException(String accessType, String resource, String message) {
        super(message);
        this.accessType = accessType;
        this.resource = resource;
    }
    
    public String getAccessType() {
        return accessType;
    }
    
    public String getResource() {
        return resource;
    }
}