package org.example.repository;

import org.example.entity.UserAddress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserAddressRepository extends JpaRepository<UserAddress, Long> {
    
    /**
     * Tìm tất cả địa chỉ của user theo ID
     */
    @Query("SELECT ua FROM UserAddress ua WHERE ua.user.id = :userId ORDER BY ua.isDefault DESC, ua.createdAt DESC")
    List<UserAddress> findByUserIdOrderByDefaultFirst(@Param("userId") Long userId);
    
    /**
     * Tìm địa chỉ mặc định của user
     */
    @Query("SELECT ua FROM UserAddress ua WHERE ua.user.id = :userId AND ua.isDefault = true")
    Optional<UserAddress> findDefaultByUserId(@Param("userId") Long userId);
    
    /**
     * Tìm địa chỉ theo ID và user ID (security check)
     */
    @Query("SELECT ua FROM UserAddress ua WHERE ua.id = :addressId AND ua.user.id = :userId")
    Optional<UserAddress> findByIdAndUserId(@Param("addressId") Long addressId, @Param("userId") Long userId);
    
    /**
     * Kiểm tra user có địa chỉ nào không
     */
    @Query("SELECT COUNT(ua) > 0 FROM UserAddress ua WHERE ua.user.id = :userId")
    boolean existsByUserId(@Param("userId") Long userId);
    
    /**
     * Đếm số lượng địa chỉ của user
     */
    @Query("SELECT COUNT(ua) FROM UserAddress ua WHERE ua.user.id = :userId")
    int countByUserId(@Param("userId") Long userId);
    
    /**
     * Kiểm tra user đã có địa chỉ mặc định chưa
     */
    @Query("SELECT COUNT(ua) > 0 FROM UserAddress ua WHERE ua.user.id = :userId AND ua.isDefault = true")
    boolean hasDefaultAddress(@Param("userId") Long userId);
    
    /**
     * Đặt tất cả địa chỉ của user thành không mặc định
     */
    @Modifying
    @Query("UPDATE UserAddress ua SET ua.isDefault = false WHERE ua.user.id = :userId")
    void clearDefaultForUser(@Param("userId") Long userId);
    
    /**
     * Tìm địa chỉ trong khu vực gần (có thể dùng cho location-based features)
     */
    @Query(value = "SELECT * FROM user_addresses ua " +
           "WHERE ST_DWithin(ua.location, ST_GeomFromText(:point, 4326), :radiusMeters) " +
           "ORDER BY ST_Distance(ua.location, ST_GeomFromText(:point, 4326))",
           nativeQuery = true)
    List<UserAddress> findAddressesWithinRadius(@Param("point") String point, 
                                               @Param("radiusMeters") double radiusMeters);
    
    /**
     * Xóa tất cả địa chỉ của user (khi xóa user)
     */
    @Modifying
    @Query("DELETE FROM UserAddress ua WHERE ua.user.id = :userId")
    void deleteByUserId(@Param("userId") Long userId);
}