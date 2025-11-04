package org.example.service;

import org.example.entity.Restaurant;
import org.example.repository.RestaurantRepository;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LocationService {
    
    @Autowired
    private RestaurantRepository restaurantRepository;
    
    private final GeometryFactory geometryFactory = new GeometryFactory();
    
    /**
     * Tìm quán ăn trong bán kính xác định
     */
    public List<Restaurant> findRestaurantsNearby(double latitude, double longitude, double radiusMeters) {
        return restaurantRepository.findRestaurantsWithinRadius(latitude, longitude, radiusMeters);
    }
    
    /**
     * Tìm quán ăn trên tuyến đường từ điểm A đến điểm B
     * @param startLat Vĩ độ điểm xuất phát
     * @param startLng Kinh độ điểm xuất phát  
     * @param endLat Vĩ độ điểm đến
     * @param endLng Kinh độ điểm đến
     * @param maxDetourMeters Khoảng cách tối đa lệch khỏi tuyến đường (meters)
     * @return Danh sách quán ăn trên tuyến đường
     */
    public List<Restaurant> findRestaurantsOnRoute(
            double startLat, double startLng, 
            double endLat, double endLng, 
            double maxDetourMeters) {
        
        return restaurantRepository.findRestaurantsOnRoute(
            startLat, startLng, endLat, endLng, maxDetourMeters
        );
    }
    
    /**
     * Tìm N quán ăn gần nhất
     */
    public List<Restaurant> findNearestRestaurants(double latitude, double longitude, int limit) {
        return restaurantRepository.findNearestRestaurants(latitude, longitude, limit);
    }
    
    /**
     * Tính khoảng cách đến một quán ăn cụ thể
     */
    public Double calculateDistanceToRestaurant(Long restaurantId, double latitude, double longitude) {
        return restaurantRepository.calculateDistanceToRestaurant(restaurantId, latitude, longitude);
    }
    
    /**
     * Tìm quán ăn có thể giao hàng đến điểm cụ thể
     */
    public List<Restaurant> findRestaurantsWithDelivery(double latitude, double longitude) {
        return restaurantRepository.findRestaurantsWithDeliveryToPoint(latitude, longitude);
    }
    
    /**
     * Tạo Point object từ latitude và longitude
     */
    public Point createPoint(double latitude, double longitude) {
        return geometryFactory.createPoint(new Coordinate(longitude, latitude));
    }
    
    /**
     * Gợi ý quán ăn dựa trên route và preferences
     * @param currentLat Vĩ độ hiện tại
     * @param currentLng Kinh độ hiện tại
     * @param destinationLat Vĩ độ đích đến
     * @param destinationLng Kinh độ đích đến
     * @param maxDetourMeters Khoảng cách lệch tối đa
     * @param preferredCategories Danh mục món ăn ưa thích
     * @return Danh sách quán ăn được gợi ý
     */
    public List<Restaurant> getRouteBasedRecommendations(
            double currentLat, double currentLng,
            double destinationLat, double destinationLng,
            double maxDetourMeters,
            List<String> preferredCategories) {
        
        // Bước 1: Tìm quán ăn trên tuyến đường
        List<Restaurant> restaurantsOnRoute = findRestaurantsOnRoute(
            currentLat, currentLng, 
            destinationLat, destinationLng, 
            maxDetourMeters
        );
        
        // Bước 2: Filter theo categories nếu có
        if (preferredCategories != null && !preferredCategories.isEmpty()) {
            return restaurantsOnRoute.stream()
                .filter(restaurant -> restaurant.getCategories() != null && 
                       restaurant.getCategories().stream()
                           .anyMatch(preferredCategories::contains))
                .toList();
        }
        
        return restaurantsOnRoute;
    }
    
    /**
     * Estimate pickup time dựa trên khoảng cách và tốc độ di chuyển
     * @param restaurantLat Vĩ độ quán ăn
     * @param restaurantLng Kinh độ quán ăn
     * @param pickupLat Vĩ độ điểm lấy hàng
     * @param pickupLng Kinh độ điểm lấy hàng
     * @param averageSpeedKmh Tốc độ di chuyển trung bình (km/h)
     * @return Thời gian di chuyển ước tính (phút)
     */
    public int estimatePickupTime(
            double restaurantLat, double restaurantLng,
            double pickupLat, double pickupLng,
            double averageSpeedKmh) {
        
        // Sử dụng haversine formula để tính khoảng cách
        double distance = calculateHaversineDistance(
            restaurantLat, restaurantLng, 
            pickupLat, pickupLng
        );
        
        // Convert distance to time
        double timeHours = distance / averageSpeedKmh;
        return (int) Math.ceil(timeHours * 60); // Convert to minutes
    }
    
    /**
     * Tính khoảng cách Haversine giữa 2 điểm (km)
     */
    private double calculateHaversineDistance(double lat1, double lng1, double lat2, double lng2) {
        final double R = 6371; // Earth's radius in km
        
        double latDistance = Math.toRadians(lat2 - lat1);
        double lngDistance = Math.toRadians(lng2 - lng1);
        
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lngDistance / 2) * Math.sin(lngDistance / 2);
        
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        
        return R * c;
    }
}