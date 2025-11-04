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
import org.example.dto.request.CreateAddressRequest;
import org.example.dto.request.UpdateAddressRequest;
import org.example.dto.response.MessageResponse;
import org.example.dto.response.UserAddressResponse;
import org.example.exception.GlobalExceptionHandler;
import org.example.service.UserAddressService;
import org.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/addresses")
@CrossOrigin(origins = "*", maxAge = 3600)
@SecurityRequirement(name = "Bearer Authentication")
@Tag(name = "User Addresses", description = "API quản lý địa chỉ của người dùng")
public class UserAddressController {
    
    @Autowired
    private UserAddressService userAddressService;
    
    @Autowired
    private UserService userService;
    
    /**
     * Helper method để lấy user ID từ SecurityContext
     */
    private Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        
        // Get user by email/username
        return userService.getUserByEmail(username)
                .orElseThrow(() -> new IllegalStateException("Current user not found"))
                .getId();
    }
    
    @GetMapping
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('RESTAURANT_OWNER') or hasRole('ADMIN')")
    @Operation(summary = "Lấy danh sách địa chỉ", 
               description = "Lấy tất cả địa chỉ của user hiện tại (địa chỉ mặc định sẽ ở đầu)")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Lấy danh sách thành công",
                    content = @Content(schema = @Schema(implementation = UserAddressResponse.class))),
        @ApiResponse(responseCode = "401", description = "Chưa đăng nhập",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<List<UserAddressResponse>> getUserAddresses() {
        Long userId = getCurrentUserId();
        List<UserAddressResponse> addresses = userAddressService.getUserAddresses(userId);
        return ResponseEntity.ok(addresses);
    }
    
    @GetMapping("/default")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('RESTAURANT_OWNER') or hasRole('ADMIN')")
    @Operation(summary = "Lấy địa chỉ mặc định", 
               description = "Lấy địa chỉ mặc định của user hiện tại")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Lấy địa chỉ mặc định thành công",
                    content = @Content(schema = @Schema(implementation = UserAddressResponse.class))),
        @ApiResponse(responseCode = "404", description = "Không tìm thấy địa chỉ mặc định",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class))),
        @ApiResponse(responseCode = "401", description = "Chưa đăng nhập",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<UserAddressResponse> getDefaultAddress() {
        Long userId = getCurrentUserId();
        UserAddressResponse address = userAddressService.getDefaultAddress(userId);
        return ResponseEntity.ok(address);
    }
    
    @GetMapping("/{addressId}")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('RESTAURANT_OWNER') or hasRole('ADMIN')")
    @Operation(summary = "Lấy địa chỉ theo ID", 
               description = "Lấy thông tin chi tiết của một địa chỉ")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Lấy địa chỉ thành công",
                    content = @Content(schema = @Schema(implementation = UserAddressResponse.class))),
        @ApiResponse(responseCode = "404", description = "Không tìm thấy địa chỉ",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class))),
        @ApiResponse(responseCode = "403", description = "Không có quyền truy cập địa chỉ này",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<UserAddressResponse> getAddress(
            @Parameter(description = "ID của địa chỉ", required = true)
            @PathVariable Long addressId) {
        
        Long userId = getCurrentUserId();
        UserAddressResponse address = userAddressService.getAddress(userId, addressId);
        return ResponseEntity.ok(address);
    }
    
    @PostMapping
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('RESTAURANT_OWNER') or hasRole('ADMIN')")
    @Operation(summary = "Tạo địa chỉ mới", 
               description = "Thêm địa chỉ mới cho user. Nếu chưa có địa chỉ nào thì sẽ tự động đặt làm mặc định.")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Tạo địa chỉ thành công",
                    content = @Content(schema = @Schema(implementation = UserAddressResponse.class))),
        @ApiResponse(responseCode = "400", description = "Dữ liệu đầu vào không hợp lệ",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<UserAddressResponse> createAddress(
            @Valid @RequestBody CreateAddressRequest request) {
        
        Long userId = getCurrentUserId();
        UserAddressResponse address = userAddressService.createAddress(userId, request);
        return ResponseEntity.ok(address);
    }
    
    @PutMapping("/{addressId}")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('RESTAURANT_OWNER') or hasRole('ADMIN')")
    @Operation(summary = "Cập nhật địa chỉ", 
               description = "Cập nhật thông tin địa chỉ. Chỉ cần truyền các field muốn cập nhật.")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Cập nhật thành công",
                    content = @Content(schema = @Schema(implementation = UserAddressResponse.class))),
        @ApiResponse(responseCode = "404", description = "Không tìm thấy địa chỉ",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class))),
        @ApiResponse(responseCode = "400", description = "Dữ liệu đầu vào không hợp lệ",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<UserAddressResponse> updateAddress(
            @Parameter(description = "ID của địa chỉ", required = true)
            @PathVariable Long addressId,
            @Valid @RequestBody UpdateAddressRequest request) {
        
        Long userId = getCurrentUserId();
        UserAddressResponse address = userAddressService.updateAddress(userId, addressId, request);
        return ResponseEntity.ok(address);
    }
    
    @PutMapping("/{addressId}/set-default")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('RESTAURANT_OWNER') or hasRole('ADMIN')")
    @Operation(summary = "Đặt làm địa chỉ mặc định", 
               description = "Đặt một địa chỉ làm mặc định. Địa chỉ mặc định cũ sẽ bị bỏ.")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Đặt mặc định thành công",
                    content = @Content(schema = @Schema(implementation = UserAddressResponse.class))),
        @ApiResponse(responseCode = "404", description = "Không tìm thấy địa chỉ",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<UserAddressResponse> setAsDefault(
            @Parameter(description = "ID của địa chỉ", required = true)
            @PathVariable Long addressId) {
        
        Long userId = getCurrentUserId();
        UserAddressResponse address = userAddressService.setAsDefault(userId, addressId);
        return ResponseEntity.ok(address);
    }
    
    @DeleteMapping("/{addressId}")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('RESTAURANT_OWNER') or hasRole('ADMIN')")
    @Operation(summary = "Xóa địa chỉ", 
               description = "Xóa một địa chỉ. Nếu xóa địa chỉ mặc định thì địa chỉ đầu tiên sẽ được đặt làm mặc định.")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Xóa thành công",
                    content = @Content(schema = @Schema(implementation = MessageResponse.class))),
        @ApiResponse(responseCode = "404", description = "Không tìm thấy địa chỉ",
                    content = @Content(schema = @Schema(implementation = GlobalExceptionHandler.ErrorResponse.class)))
    })
    public ResponseEntity<MessageResponse> deleteAddress(
            @Parameter(description = "ID của địa chỉ", required = true)
            @PathVariable Long addressId) {
        
        Long userId = getCurrentUserId();
        userAddressService.deleteAddress(userId, addressId);
        
        return ResponseEntity.ok(new MessageResponse("Address deleted successfully"));
    }
    
    @GetMapping("/count")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('RESTAURANT_OWNER') or hasRole('ADMIN')")
    @Operation(summary = "Đếm số lượng địa chỉ", 
               description = "Lấy số lượng địa chỉ của user hiện tại")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Đếm thành công")
    })
    public ResponseEntity<Integer> countAddresses() {
        Long userId = getCurrentUserId();
        int count = userAddressService.countUserAddresses(userId);
        return ResponseEntity.ok(count);
    }
    
    @GetMapping("/nearby")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Tìm địa chỉ gần điểm cho trước", 
               description = "API dành cho admin để tìm các địa chỉ user trong khu vực (có thể dùng cho analytics)")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Tìm kiếm thành công",
                    content = @Content(schema = @Schema(implementation = UserAddressResponse.class)))
    })
    public ResponseEntity<List<UserAddressResponse>> findAddressesNearby(
            @Parameter(description = "Vĩ độ", required = true)
            @RequestParam double latitude,
            @Parameter(description = "Kinh độ", required = true)
            @RequestParam double longitude,
            @Parameter(description = "Bán kính tìm kiếm (mét)", required = true)
            @RequestParam(defaultValue = "1000") double radiusMeters) {
        
        List<UserAddressResponse> addresses = userAddressService.findAddressesNearLocation(
            latitude, longitude, radiusMeters);
        return ResponseEntity.ok(addresses);
    }
}