package org.example.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.example.dto.request.LoginRequest;
import org.example.dto.request.RegisterRequest;
import org.example.dto.request.SendOtpRequest;
import org.example.dto.request.VerifyOtpRequest;
import org.example.dto.request.ResetPasswordWithOtpRequest;
import org.example.dto.response.AuthResponse;
import org.example.dto.response.MessageResponse;
import org.example.exception.GlobalExceptionHandler;
import org.example.service.OtpPasswordResetService;
import org.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*", maxAge = 3600)
@Tag(name = "Authentication", description = "API for user authentication - Đăng ký và đăng nhập")
public class AuthController {
    
    @Autowired
    private UserService userService;
    

    @Autowired
    private OtpPasswordResetService otpPasswordResetService;
    
    @PostMapping("/register")
    @Operation(summary = "Đăng ký tài khoản mới", 
               description = "Tạo tài khoản mới với email, password và role (ADMIN, CUSTOMER, RESTAURANT_OWNER)")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Đăng ký thành công", 
                    content = @Content(schema = @Schema(implementation = AuthResponse.class))),
        @ApiResponse(responseCode = "400", description = "Dữ liệu đầu vào không hợp lệ",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class))),
        @ApiResponse(responseCode = "409", description = "Email đã được sử dụng",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        try {
            AuthResponse response = userService.register(request);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @PostMapping("/login")
    @Operation(summary = "Đăng nhập", 
               description = "Đăng nhập bằng email và password để nhận JWT token")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Đăng nhập thành công",
                    content = @Content(schema = @Schema(implementation = AuthResponse.class))),
        @ApiResponse(responseCode = "400", description = "Dữ liệu đầu vào không hợp lệ",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class))),
        @ApiResponse(responseCode = "401", description = "Thông tin đăng nhập không hợp lệ",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class))),
        @ApiResponse(responseCode = "404", description = "Người dùng không tồn tại",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        try {
            AuthResponse response = userService.login(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    
    @PostMapping("/send-otp")
    @Operation(summary = "Gửi mã OTP", 
               description = "Gửi mã OTP 6 số để reset mật khẩu qua email")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OTP đã được gửi thành công",
                    content = @Content(schema = @Schema(implementation = MessageResponse.class))),
        @ApiResponse(responseCode = "400", description = "Dữ liệu đầu vào không hợp lệ",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class))),
        @ApiResponse(responseCode = "404", description = "Email không tồn tại",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class))),
        @ApiResponse(responseCode = "429", description = "Yêu cầu OTP quá nhiều lần",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<MessageResponse> sendOtp(@Valid @RequestBody SendOtpRequest request) {
        MessageResponse response = otpPasswordResetService.sendOtp(request);
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/verify-otp")
    @Operation(summary = "Xác minh mã OTP", 
               description = "Xác minh mã OTP trước khi cho phép đổi mật khẩu")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OTP xác minh thành công",
                    content = @Content(schema = @Schema(implementation = MessageResponse.class))),
        @ApiResponse(responseCode = "400", description = "OTP không hợp lệ",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class))),
        @ApiResponse(responseCode = "404", description = "Không tìm thấy OTP",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class))),
        @ApiResponse(responseCode = "410", description = "OTP đã hết hạn",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<MessageResponse> verifyOtp(@Valid @RequestBody VerifyOtpRequest request) {
        MessageResponse response = otpPasswordResetService.verifyOtp(request);
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/reset-password-with-otp")
    @Operation(summary = "Reset mật khẩu với OTP", 
               description = "Reset mật khẩu sử dụng mã OTP đã được xác minh")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Mật khẩu đã được reset thành công",
                    content = @Content(schema = @Schema(implementation = MessageResponse.class))),
        @ApiResponse(responseCode = "400", description = "OTP không hợp lệ hoặc mật khẩu không đúng format",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class))),
        @ApiResponse(responseCode = "404", description = "Không tìm thấy OTP hoặc user",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class))),
        @ApiResponse(responseCode = "410", description = "OTP đã hết hạn",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<MessageResponse> resetPasswordWithOtp(@Valid @RequestBody ResetPasswordWithOtpRequest request) {
        MessageResponse response = otpPasswordResetService.resetPasswordWithOtp(request);
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/cors-test")
    @Operation(summary = "Test CORS configuration", description = "Debug endpoint to test CORS")
    public ResponseEntity<java.util.Map<String, Object>> corsTest() {
        return ResponseEntity.ok(java.util.Map.of(
            "message", "CORS is working!",
            "timestamp", java.time.LocalDateTime.now(),
            "server", "PickMe Application"
        ));
    }
}