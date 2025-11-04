package org.example.dto.mapper;

import org.example.dto.response.RestaurantStaffResponse;
import org.example.entity.RestaurantStaff;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class RestaurantStaffMapper {
    
    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private RestaurantMapper restaurantMapper;
    
    /**
     * Convert RestaurantStaff entity to RestaurantStaffResponse DTO
     * @param restaurantStaff RestaurantStaff entity
     * @return RestaurantStaffResponse DTO
     */
    public RestaurantStaffResponse toResponse(RestaurantStaff restaurantStaff) {
        if (restaurantStaff == null) {
            return null;
        }
        
        return new RestaurantStaffResponse(
            restaurantStaff.getId(),
            userMapper.toBasicResponse(restaurantStaff.getStaffUser()),
            restaurantMapper.toBasicResponse(restaurantStaff.getRestaurant()),
            userMapper.toBasicResponse(restaurantStaff.getOwner()),
            restaurantStaff.getPosition(),
            restaurantStaff.getIsActive(),
            restaurantStaff.getCreatedAt(),
            restaurantStaff.getUpdatedAt()
        );
    }
    
    /**
     * Convert list of RestaurantStaff entities to list of RestaurantStaffResponse DTOs
     * @param restaurantStaffs List of RestaurantStaff entities
     * @return List of RestaurantStaffResponse DTOs
     */
    public List<RestaurantStaffResponse> toResponseList(List<RestaurantStaff> restaurantStaffs) {
        if (restaurantStaffs == null) {
            return null;
        }
        
        return restaurantStaffs.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }
    
    /**
     * Convert RestaurantStaff entity to basic RestaurantStaffResponse (limited info)
     * @param restaurantStaff RestaurantStaff entity
     * @return RestaurantStaffResponse DTO with limited information
     */
    public RestaurantStaffResponse toBasicResponse(RestaurantStaff restaurantStaff) {
        if (restaurantStaff == null) {
            return null;
        }
        
        RestaurantStaffResponse response = new RestaurantStaffResponse();
        response.setId(restaurantStaff.getId());
        response.setStaffUser(userMapper.toBasicResponse(restaurantStaff.getStaffUser()));
        response.setPosition(restaurantStaff.getPosition());
        response.setIsActive(restaurantStaff.getIsActive());
        response.setCreatedAt(restaurantStaff.getCreatedAt());
        
        return response;
    }
}