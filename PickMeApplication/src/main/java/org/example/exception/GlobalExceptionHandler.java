package org.example.exception;

import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> fieldErrors = new HashMap<>();
        Map<String, String> details = new HashMap<>();
        
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            fieldErrors.put(fieldName, errorMessage);
        });
        
        // Thêm thông tin chi tiết về validation
        details.put("errorCount", String.valueOf(fieldErrors.size()));
        details.put("suggestion", "Vui lòng kiểm tra lại các trường thông tin và đảm bảo đúng định dạng");
        details.putAll(fieldErrors);
        
        ErrorResponse errorResponse = new ErrorResponse(
                "Dữ liệu đầu vào không hợp lệ",
                HttpStatus.BAD_REQUEST.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }
    
    @ExceptionHandler(EmailAlreadyExistsException.class)
    public ResponseEntity<ErrorResponse> handleEmailAlreadyExistsException(EmailAlreadyExistsException ex) {
        Map<String, String> details = new HashMap<>();
        details.put("email", ex.getEmail());
        details.put("suggestion", "Vui lòng sử dụng email khác hoặc đăng nhập nếu bạn đã có tài khoản");
        
        ErrorResponse errorResponse = new ErrorResponse(
                "Email đã được sử dụng",
                HttpStatus.CONFLICT.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.CONFLICT);
    }
    
    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleUserNotFoundException(UserNotFoundException ex) {
        Map<String, String> details = new HashMap<>();
        details.put("identifier", ex.getIdentifier());
        details.put("suggestion", "Vui lòng kiểm tra lại thông tin hoặc đăng ký tài khoản mới");
        
        ErrorResponse errorResponse = new ErrorResponse(
                "Không tìm thấy người dùng",
                HttpStatus.NOT_FOUND.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.NOT_FOUND);
    }
    
    @ExceptionHandler(InvalidCredentialsException.class)
    public ResponseEntity<ErrorResponse> handleInvalidCredentialsException(InvalidCredentialsException ex) {
        Map<String, String> details = new HashMap<>();
        details.put("email", ex.getEmail());
        details.put("suggestion", "Vui lòng kiểm tra lại email và mật khẩu");
        
        ErrorResponse errorResponse = new ErrorResponse(
                "Thông tin đăng nhập không hợp lệ",
                HttpStatus.UNAUTHORIZED.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.UNAUTHORIZED);
    }
    
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ErrorResponse> handleAccessDeniedException(AccessDeniedException ex) {
        Map<String, String> details = new HashMap<>();
        if (ex.getAccessType() != null) {
            details.put("requiredAccess", ex.getAccessType());
        }
        if (ex.getResource() != null) {
            details.put("resource", ex.getResource());
        }
        details.put("suggestion", "Vui lòng đăng nhập với tài khoản có quyền phù hợp");
        
        ErrorResponse errorResponse = new ErrorResponse(
                "Không có quyền truy cập",
                HttpStatus.FORBIDDEN.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.FORBIDDEN);
    }
    
    @ExceptionHandler(OtpNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleOtpNotFoundException(OtpNotFoundException ex) {
        Map<String, String> details = new HashMap<>();
        details.put("suggestion", "Vui lòng yêu cầu OTP mới");
        
        ErrorResponse errorResponse = new ErrorResponse(
                ex.getMessage(),
                HttpStatus.NOT_FOUND.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.NOT_FOUND);
    }
    
    @ExceptionHandler(OtpExpiredException.class)
    public ResponseEntity<ErrorResponse> handleOtpExpiredException(OtpExpiredException ex) {
        Map<String, String> details = new HashMap<>();
        details.put("suggestion", "Vui lòng yêu cầu OTP mới");
        
        ErrorResponse errorResponse = new ErrorResponse(
                ex.getMessage(),
                HttpStatus.GONE.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.GONE);
    }
    
    @ExceptionHandler(InvalidOtpException.class)
    public ResponseEntity<ErrorResponse> handleInvalidOtpException(InvalidOtpException ex) {
        Map<String, String> details = new HashMap<>();
        details.put("suggestion", "Vui lòng kiểm tra lại mã OTP hoặc yêu cầu OTP mới");
        
        ErrorResponse errorResponse = new ErrorResponse(
                ex.getMessage(),
                HttpStatus.BAD_REQUEST.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }
    
    @ExceptionHandler(OtpRateLimitExceededException.class)
    public ResponseEntity<ErrorResponse> handleOtpRateLimitExceededException(OtpRateLimitExceededException ex) {
        Map<String, String> details = new HashMap<>();
        details.put("suggestion", "Vui lòng đợi 1 giờ trước khi yêu cầu OTP mới");
        
        ErrorResponse errorResponse = new ErrorResponse(
                ex.getMessage(),
                HttpStatus.TOO_MANY_REQUESTS.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.TOO_MANY_REQUESTS);
    }
    
    @ExceptionHandler(PasswordMismatchException.class)
    public ResponseEntity<ErrorResponse> handlePasswordMismatchException(PasswordMismatchException ex) {
        Map<String, String> details = new HashMap<>();
        details.put("suggestion", "Vui lòng đảm bảo mật khẩu và xác nhận mật khẩu giống nhau");
        
        ErrorResponse errorResponse = new ErrorResponse(
                ex.getMessage(),
                HttpStatus.BAD_REQUEST.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }
    
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ErrorResponse> handleBusinessException(BusinessException ex) {
        Map<String, String> details = new HashMap<>();
        details.put("suggestion", "Vui lòng kiểm tra lại thao tác và thử lại");
        
        ErrorResponse errorResponse = new ErrorResponse(
                ex.getMessage(),
                HttpStatus.BAD_REQUEST.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }
    
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleResourceNotFoundException(ResourceNotFoundException ex) {
        Map<String, String> details = new HashMap<>();
        details.put("suggestion", "Vui lòng kiểm tra lại ID hoặc tham số đầu vào");
        
        ErrorResponse errorResponse = new ErrorResponse(
                ex.getMessage(),
                HttpStatus.NOT_FOUND.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.NOT_FOUND);
    }
    
    @ExceptionHandler(UnauthorizedException.class)
    public ResponseEntity<ErrorResponse> handleUnauthorizedException(UnauthorizedException ex) {
        Map<String, String> details = new HashMap<>();
        details.put("suggestion", "Vui lòng đăng nhập lại hoặc kiểm tra quyền truy cập");
        
        ErrorResponse errorResponse = new ErrorResponse(
                ex.getMessage(),
                HttpStatus.UNAUTHORIZED.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.UNAUTHORIZED);
    }
    
    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ErrorResponse> handleRuntimeException(RuntimeException ex) {
        Map<String, String> details = new HashMap<>();
        details.put("exception", ex.getClass().getSimpleName());
        details.put("suggestion", "Vui lòng thử lại hoặc liên hệ hỗ trợ kỹ thuật");
        
        ErrorResponse errorResponse = new ErrorResponse(
                ex.getMessage() != null ? ex.getMessage() : "Đã xảy ra lỗi không xác định",
                HttpStatus.BAD_REQUEST.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }
    
    @ExceptionHandler(UsernameNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleUsernameNotFoundException(UsernameNotFoundException ex) {
        ErrorResponse errorResponse = new ErrorResponse(
                "User not found",
                HttpStatus.NOT_FOUND.value(),
                LocalDateTime.now(),
                null
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.NOT_FOUND);
    }
    
    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<ErrorResponse> handleBadCredentialsException(BadCredentialsException ex) {
        Map<String, String> details = new HashMap<>();
        details.put("reason", "Email hoặc mật khẩu không chính xác");
        details.put("suggestion", "Vui lòng kiểm tra lại thông tin đăng nhập hoặc reset mật khẩu");
        
        ErrorResponse errorResponse = new ErrorResponse(
                "Thông tin đăng nhập không hợp lệ",
                HttpStatus.UNAUTHORIZED.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.UNAUTHORIZED);
    }
    
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGenericException(Exception ex) {
        Map<String, String> details = new HashMap<>();
        details.put("exception", ex.getClass().getSimpleName());
        details.put("suggestion", "Lỗi hệ thống, vui lòng thử lại sau hoặc liên hệ quản trị viên");
        
        // Trong môi trường dev, có thể hiển thị stack trace
        if (ex.getMessage() != null) {
            details.put("message", ex.getMessage());
        }
        
        ErrorResponse errorResponse = new ErrorResponse(
                "Lỗi hệ thống nội bộ",
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                LocalDateTime.now(),
                details
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    @Schema(description = "Response lỗi chuẩn của hệ thống")
    public static class ErrorResponse {
        
        @Schema(description = "Thông báo lỗi chính", example = "Email đã được sử dụng")
        private String message;
        
        @Schema(description = "Mã lỗi HTTP", example = "409")
        private int status;
        
        @Schema(description = "Thời gian xảy ra lỗi", example = "2025-09-26T10:30:00")
        private LocalDateTime timestamp;
        
        @Schema(description = "Chi tiết lỗi và gợi ý khắc phục")
        private Map<String, String> errors;
        
        public ErrorResponse(String message, int status, LocalDateTime timestamp, Map<String, String> errors) {
            this.message = message;
            this.status = status;
            this.timestamp = timestamp;
            this.errors = errors;
        }
        
        // Getters and Setters
        public String getMessage() {
            return message;
        }
        
        public void setMessage(String message) {
            this.message = message;
        }
        
        public int getStatus() {
            return status;
        }
        
        public void setStatus(int status) {
            this.status = status;
        }
        
        public LocalDateTime getTimestamp() {
            return timestamp;
        }
        
        public void setTimestamp(LocalDateTime timestamp) {
            this.timestamp = timestamp;
        }
        
        public Map<String, String> getErrors() {
            return errors;
        }
        
        public void setErrors(Map<String, String> errors) {
            this.errors = errors;
        }
    }
}