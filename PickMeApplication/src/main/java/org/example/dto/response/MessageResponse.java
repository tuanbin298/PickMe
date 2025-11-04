package org.example.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Response khi yêu cầu reset mật khẩu thành công")
public class MessageResponse {
    
    @Schema(description = "Thông báo kết quả", example = "Email reset mật khẩu đã được gửi thành công")
    private String message;
    
    @Schema(description = "Trạng thái thành công", example = "true")
    private boolean success;
    
    // Constructors
    public MessageResponse() {}
    
    public MessageResponse(String message) {
        this.message = message;
        this.success = true;
    }
    
    public MessageResponse(String message, boolean success) {
        this.message = message;
        this.success = success;
    }
    
    // Static factory methods
    public static MessageResponse success(String message) {
        return new MessageResponse(message, true);
    }
    
    public static MessageResponse error(String message) {
        return new MessageResponse(message, false);
    }
    
    // Getters and Setters
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public boolean isSuccess() {
        return success;
    }
    
    public void setSuccess(boolean success) {
        this.success = success;
    }
}