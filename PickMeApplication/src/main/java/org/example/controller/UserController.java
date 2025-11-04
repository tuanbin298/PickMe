package org.example.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.example.dto.request.UpdateUserRequest;
import org.example.dto.response.UserResponse;
import org.example.entity.Role;
import org.example.exception.GlobalExceptionHandler;
import org.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*", maxAge = 3600)
@Tag(name = "User Management", description = "API for user management - Quản lý người dùng")
@SecurityRequirement(name = "Bearer Authentication")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/me")
    @Operation(summary = "Lấy thông tin user hiện tại", 
               description = "Lấy thông tin của user đang đăng nhập dựa trên JWT token")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Lấy thông tin thành công",
                    content = @Content(schema = @Schema(implementation = UserResponse.class))),
        @ApiResponse(responseCode = "404", description = "User không tồn tại",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<UserResponse> getCurrentUser() {
        try {
            UserResponse response = userService.getCurrentUser();
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Lấy danh sách tất cả users", 
               description = "Chỉ Admin mới có quyền truy cập. Lấy danh sách tất cả users trong hệ thống")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Lấy danh sách thành công"),
        @ApiResponse(responseCode = "403", description = "Không có quyền truy cập (chỉ Admin)",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<List<UserResponse>> getAllUsers() {
        List<UserResponse> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }
    
    @GetMapping("/paginated")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Lấy danh sách users có phân trang", 
               description = "Chỉ Admin mới có quyền truy cập. Lấy danh sách users với phân trang và sắp xếp")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Lấy danh sách thành công"),
        @ApiResponse(responseCode = "403", description = "Không có quyền truy cập (chỉ Admin)",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<Page<UserResponse>> getAllUsers(
            @Parameter(description = "Số trang (bắt đầu từ 0)") @RequestParam(defaultValue = "0") int page,
            @Parameter(description = "Số lượng items trên 1 trang") @RequestParam(defaultValue = "10") int size,
            @Parameter(description = "Trường dùng để sắp xếp") @RequestParam(defaultValue = "id") String sortBy,
            @Parameter(description = "Hướng sắp xếp (asc/desc)") @RequestParam(defaultValue = "asc") String sortDir) {
        
        Sort sort = sortDir.equalsIgnoreCase("desc") ? 
                Sort.by(sortBy).descending() : 
                Sort.by(sortBy).ascending();
        
        Pageable pageable = PageRequest.of(page, size, sort);
        Page<UserResponse> users = userService.getAllUsers(pageable);
        return ResponseEntity.ok(users);
    }
    
    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or (hasRole('CUSTOMER') and #id == authentication.principal.id) or (hasRole('RESTAURANT_OWNER') and #id == authentication.principal.id)")
    public ResponseEntity<UserResponse> getUserById(@PathVariable Long id) {
        Optional<UserResponse> user = userService.getUserById(id);
        return user.map(ResponseEntity::ok)
                  .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/email/{email}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UserResponse> getUserByEmail(@PathVariable String email) {
        Optional<UserResponse> user = userService.getUserByEmail(email);
        return user.map(ResponseEntity::ok)
                  .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/role/{role}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<UserResponse>> getUsersByRole(@PathVariable Role role) {
        List<UserResponse> users = userService.getUsersByRole(role);
        return ResponseEntity.ok(users);
    }
    
    @GetMapping("/search")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<UserResponse>> searchUsersByName(@RequestParam String name) {
        List<UserResponse> users = userService.searchUsersByName(name);
        return ResponseEntity.ok(users);
    }
    
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or (hasRole('CUSTOMER') and #id == authentication.principal.id) or (hasRole('RESTAURANT_OWNER') and #id == authentication.principal.id)")
    @Operation(summary = "Cập nhật thông tin user", 
               description = "Admin có thể cập nhật bất kỳ user nào. User thường chỉ có thể cập nhật thông tin của chính mình")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Cập nhật thành công",
                    content = @Content(schema = @Schema(implementation = UserResponse.class))),
        @ApiResponse(responseCode = "400", description = "Dữ liệu không hợp lệ",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class))),
        @ApiResponse(responseCode = "403", description = "Không có quyền truy cập"),
        @ApiResponse(responseCode = "404", description = "User không tồn tại")
    })
    public ResponseEntity<UserResponse> updateUser(
            @Parameter(description = "ID của user cần cập nhật") @PathVariable Long id, 
            @Valid @RequestBody UpdateUserRequest request) {
        try {
            UserResponse updatedUser = userService.updateUser(id, request);
            return ResponseEntity.ok(updatedUser);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Xóa user", 
               description = "Chỉ Admin mới có quyền xóa user. Thao tác này sẽ xóa vĩnh viễn user khỏi hệ thống")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "204", description = "Xóa thành công"),
        @ApiResponse(responseCode = "403", description = "Không có quyền truy cập"),
        @ApiResponse(responseCode = "404", description = "User không tồn tại")
    })
    public ResponseEntity<Void> deleteUser(
            @Parameter(description = "ID của user cần xóa") @PathVariable Long id) {
        try {
            userService.deleteUser(id);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    @PutMapping("/{id}/deactivate")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UserResponse> deactivateUser(@PathVariable Long id) {
        try {
            UserResponse user = userService.deactivateUser(id);
            return ResponseEntity.ok(user);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    @PutMapping("/{id}/activate")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UserResponse> activateUser(@PathVariable Long id) {
        try {
            UserResponse user = userService.activateUser(id);
            return ResponseEntity.ok(user);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
}