package org.example.repository;

import org.example.entity.RestaurantStaff;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RestaurantStaffRepository extends JpaRepository<RestaurantStaff, Long> {
    
    // Find staff by owner (all staff created by this owner)
    List<RestaurantStaff> findByOwnerIdAndIsActiveTrue(Long ownerId);
    
    // Find staff by restaurant (all staff working in this restaurant)
    List<RestaurantStaff> findByRestaurantIdAndIsActiveTrue(Long restaurantId);
    
    // Find staff assignment for a specific user
    Optional<RestaurantStaff> findByStaffUserIdAndIsActiveTrue(Long staffUserId);
    
    // Check if user is staff of a specific restaurant
    @Query("SELECT rs FROM RestaurantStaff rs WHERE rs.staffUser.id = :staffUserId " +
           "AND rs.restaurant.id = :restaurantId AND rs.isActive = true")
    Optional<RestaurantStaff> findStaffAssignment(@Param("staffUserId") Long staffUserId, 
                                                 @Param("restaurantId") Long restaurantId);
    
    // Find all restaurants that a staff user has access to
    @Query("SELECT rs.restaurant FROM RestaurantStaff rs WHERE rs.staffUser.id = :staffUserId " +
           "AND rs.isActive = true")
    List<Long> findRestaurantIdsByStaffUserId(@Param("staffUserId") Long staffUserId);
}