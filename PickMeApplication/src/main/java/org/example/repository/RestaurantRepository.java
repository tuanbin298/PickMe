package org.example.repository;

import org.example.entity.ApprovalStatus;
import org.example.entity.Restaurant;
import org.locationtech.jts.geom.Point;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RestaurantRepository extends JpaRepository<Restaurant, Long> {
    
    // Find active restaurants
    List<Restaurant> findByIsActiveTrue();
    
    // Find restaurants by owner
    List<Restaurant> findByOwnerIdAndIsActiveTrue(Long ownerId);
    
    // Find approved restaurants by owner
    @Query("SELECT r FROM Restaurant r WHERE r.owner.id = :ownerId AND r.isActive = true " +
           "AND r.approvalStatus = org.example.entity.ApprovalStatus.APPROVED")
    List<Restaurant> findApprovedRestaurantsByOwnerId(@Param("ownerId") Long ownerId);
    
    // Find all active and approved restaurants
    @Query("SELECT r FROM Restaurant r WHERE r.isActive = true " +
           "AND r.approvalStatus = org.example.entity.ApprovalStatus.APPROVED " +
           "ORDER BY r.name ASC")
    List<Restaurant> findAllActiveAndApproved();
    
    // Admin functions - find restaurants by approval status
    @Query("SELECT r FROM Restaurant r WHERE r.approvalStatus = :status ORDER BY r.createdAt DESC")
    List<Restaurant> findByApprovalStatus(@Param("status") ApprovalStatus status);

    Optional<Restaurant> findByIdAndApprovalStatus(Long id, ApprovalStatus approvalStatus);
    
    // Find pending restaurants for admin approval
    @Query("SELECT r FROM Restaurant r WHERE r.approvalStatus = org.example.entity.ApprovalStatus.PENDING " +
           "ORDER BY r.createdAt ASC")
    List<Restaurant> findPendingApprovalRestaurants();
    
    // Find restaurants by category
    @Query("SELECT r FROM Restaurant r JOIN r.categories c WHERE c = :category AND r.isActive = true")
    List<Restaurant> findByCategory(@Param("category") String category);
    
    // Spatial Queries using PostGIS functions
    
    // Find restaurants within a certain distance (meters) from a point
    @Query(value = "SELECT *, ST_Distance_Sphere(location, ST_MakePoint(:longitude, :latitude)) as distance " +
                   "FROM restaurants " +
                   "WHERE is_active = true " +
                   "AND ST_DWithin(location::geography, ST_MakePoint(:longitude, :latitude)::geography, :radiusMeters) " +
                   "ORDER BY distance", 
           nativeQuery = true)
    List<Restaurant> findRestaurantsWithinRadius(
        @Param("latitude") double latitude, 
        @Param("longitude") double longitude, 
        @Param("radiusMeters") double radiusMeters
    );
    
    // Find restaurants on a route (within distance from a line between two points)
    @Query(value = "SELECT *, ST_Distance_Sphere(location, ST_ClosestPoint(" +
                   "ST_MakeLine(ST_MakePoint(:startLng, :startLat), ST_MakePoint(:endLng, :endLat)), location)) as distance_to_route " +
                   "FROM restaurants " +
                   "WHERE is_active = true " +
                   "AND ST_DWithin(" +
                   "    location::geography, " +
                   "    ST_MakeLine(ST_MakePoint(:startLng, :startLat), ST_MakePoint(:endLng, :endLat))::geography, " +
                   "    :maxDetourMeters" +
                   ") " +
                   "ORDER BY distance_to_route", 
           nativeQuery = true)
    List<Restaurant> findRestaurantsOnRoute(
        @Param("startLat") double startLat,
        @Param("startLng") double startLng,
        @Param("endLat") double endLat,
        @Param("endLng") double endLng,
        @Param("maxDetourMeters") double maxDetourMeters
    );
    
    // Find nearest restaurants (top N closest)
    @Query(value = "SELECT *, ST_Distance_Sphere(location, ST_MakePoint(:longitude, :latitude)) as distance " +
                   "FROM restaurants " +
                   "WHERE is_active = true " +
                   "ORDER BY distance " +
                   "LIMIT :limit", 
           nativeQuery = true)
    List<Restaurant> findNearestRestaurants(
        @Param("latitude") double latitude,
        @Param("longitude") double longitude,
        @Param("limit") int limit
    );
    
    // Calculate distance to a specific restaurant
    @Query(value = "SELECT ST_Distance_Sphere(location, ST_MakePoint(:longitude, :latitude)) " +
                   "FROM restaurants " +
                   "WHERE id = :restaurantId", 
           nativeQuery = true)
    Double calculateDistanceToRestaurant(
        @Param("restaurantId") Long restaurantId,
        @Param("latitude") double latitude,
        @Param("longitude") double longitude
    );
    
    // Find restaurants within delivery area (if polygon is defined)
    @Query(value = "SELECT * FROM restaurants " +
                   "WHERE is_active = true " +
                   "AND delivery_area IS NOT NULL " +
                   "AND ST_Contains(delivery_area, ST_MakePoint(:longitude, :latitude))", 
           nativeQuery = true)
    List<Restaurant> findRestaurantsWithDeliveryToPoint(
        @Param("latitude") double latitude,
        @Param("longitude") double longitude
    );
}