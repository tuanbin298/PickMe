package org.example.service;

import org.example.dto.request.CreateAddressRequest;
import org.example.dto.request.UpdateAddressRequest;
import org.example.dto.response.UserAddressResponse;
import org.example.entity.User;
import org.example.entity.UserAddress;
import org.example.repository.UserAddressRepository;
import org.example.repository.UserRepository;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class UserAddressService {
    
    @Autowired
    private UserAddressRepository userAddressRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    private final GeometryFactory geometryFactory = new GeometryFactory();
    
    /**
     * Lấy tất cả địa chỉ của user (default address first)
     */
    @Transactional(readOnly = true)
    public List<UserAddressResponse> getUserAddresses(Long userId) {
        // Kiểm tra user tồn tại
        if (!userRepository.existsById(userId)) {
            throw new IllegalArgumentException("User not found");
        }
        
        List<UserAddress> addresses = userAddressRepository.findByUserIdOrderByDefaultFirst(userId);
        return addresses.stream()
                .map(UserAddressResponse::from)
                .collect(Collectors.toList());
    }
    
    /**
     * Lấy địa chỉ mặc định của user
     */
    @Transactional(readOnly = true)
    public UserAddressResponse getDefaultAddress(Long userId) {
        UserAddress defaultAddress = userAddressRepository.findDefaultByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("No default address found"));
        
        return UserAddressResponse.from(defaultAddress);
    }
    
    /**
     * Lấy địa chỉ theo ID (với security check)
     */
    @Transactional(readOnly = true)
    public UserAddressResponse getAddress(Long userId, Long addressId) {
        UserAddress address = userAddressRepository.findByIdAndUserId(addressId, userId)
                .orElseThrow(() -> new IllegalArgumentException("Address not found or access denied"));
        
        return UserAddressResponse.from(address);
    }
    
    /**
     * Tạo địa chỉ mới
     */
    public UserAddressResponse createAddress(Long userId, CreateAddressRequest request) {
        // Validate user exists
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        
        // Tạo UserAddress entity
        UserAddress address = new UserAddress();
        address.setUser(user);
        address.setAddressName(request.getAddressName());
        address.setFullAddress(request.getFullAddress());
        
        // Set coordinates nếu có
        if (request.hasValidCoordinates()) {
            Point location = geometryFactory.createPoint(
                new Coordinate(request.getLongitude(), request.getLatitude())
            );
            address.setLocation(location);
        }
        
        // Handle default address logic
        boolean hasExistingDefault = userAddressRepository.hasDefaultAddress(userId);
        
        if (request.getIsDefault() || !hasExistingDefault) {
            // Nếu request yêu cầu default hoặc chưa có default address
            if (hasExistingDefault) {
                userAddressRepository.clearDefaultForUser(userId);
            }
            address.setIsDefault(true);
        } else {
            address.setIsDefault(false);
        }
        
        UserAddress savedAddress = userAddressRepository.save(address);
        return UserAddressResponse.from(savedAddress);
    }
    
    /**
     * Cập nhật địa chỉ
     */
    public UserAddressResponse updateAddress(Long userId, Long addressId, UpdateAddressRequest request) {
        if (!request.hasUpdates()) {
            throw new IllegalArgumentException("No updates provided");
        }
        
        UserAddress address = userAddressRepository.findByIdAndUserId(addressId, userId)
                .orElseThrow(() -> new IllegalArgumentException("Address not found or access denied"));
        
        // Update fields if provided
        if (request.getAddressName() != null) {
            address.setAddressName(request.getAddressName());
        }
        
        if (request.getFullAddress() != null) {
            address.setFullAddress(request.getFullAddress());
        }
        
        // Update coordinates if provided
        if (request.hasValidCoordinates()) {
            Point location = geometryFactory.createPoint(
                new Coordinate(request.getLongitude(), request.getLatitude())
            );
            address.setLocation(location);
        }
        
        // Handle default address change
        if (request.getIsDefault() != null) {
            if (request.getIsDefault() && !address.getIsDefault()) {
                // Setting this address as default
                userAddressRepository.clearDefaultForUser(userId);
                address.setIsDefault(true);
            } else if (!request.getIsDefault() && address.getIsDefault()) {
                // Removing default from this address
                address.setIsDefault(false);
                // Note: This might leave user without default address
            }
        }
        
        UserAddress savedAddress = userAddressRepository.save(address);
        return UserAddressResponse.from(savedAddress);
    }
    
    /**
     * Đặt địa chỉ làm mặc định
     */
    public UserAddressResponse setAsDefault(Long userId, Long addressId) {
        UserAddress address = userAddressRepository.findByIdAndUserId(addressId, userId)
                .orElseThrow(() -> new IllegalArgumentException("Address not found or access denied"));
        
        if (!address.getIsDefault()) {
            // Clear current default and set this as default
            userAddressRepository.clearDefaultForUser(userId);
            address.setIsDefault(true);
            UserAddress savedAddress = userAddressRepository.save(address);
            return UserAddressResponse.from(savedAddress);
        }
        
        // Already default, return as-is
        return UserAddressResponse.from(address);
    }
    
    /**
     * Xóa địa chỉ
     */
    public void deleteAddress(Long userId, Long addressId) {
        UserAddress address = userAddressRepository.findByIdAndUserId(addressId, userId)
                .orElseThrow(() -> new IllegalArgumentException("Address not found or access denied"));
        
        boolean wasDefault = address.getIsDefault();
        userAddressRepository.delete(address);
        
        // Nếu xóa default address, tự động set address đầu tiên làm default
        if (wasDefault) {
            List<UserAddress> remainingAddresses = userAddressRepository.findByUserIdOrderByDefaultFirst(userId);
            if (!remainingAddresses.isEmpty()) {
                UserAddress firstAddress = remainingAddresses.get(0);
                firstAddress.setIsDefault(true);
                userAddressRepository.save(firstAddress);
            }
        }
    }
    
    /**
     * Kiểm tra user có địa chỉ nào không
     */
    @Transactional(readOnly = true)
    public boolean userHasAddresses(Long userId) {
        return userAddressRepository.existsByUserId(userId);
    }
    
    /**
     * Đếm số lượng địa chỉ của user
     */
    @Transactional(readOnly = true)
    public int countUserAddresses(Long userId) {
        return userAddressRepository.countByUserId(userId);
    }
    
    /**
     * Tìm địa chỉ gần điểm cho trước (có thể dùng để suggest addresses)
     */
    @Transactional(readOnly = true)
    public List<UserAddressResponse> findAddressesNearLocation(double latitude, double longitude, double radiusMeters) {
        String point = String.format("POINT(%f %f)", longitude, latitude);
        List<UserAddress> addresses = userAddressRepository.findAddressesWithinRadius(point, radiusMeters);
        
        return addresses.stream()
                .map(UserAddressResponse::from)
                .collect(Collectors.toList());
    }
}