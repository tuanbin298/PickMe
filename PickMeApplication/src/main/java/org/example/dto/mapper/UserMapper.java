package org.example.dto.mapper;

import org.example.dto.response.UserResponse;
import org.example.entity.User;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class UserMapper {
    
    /**
     * Convert User entity to UserResponse DTO
     * @param user User entity
     * @return UserResponse DTO
     */
    public UserResponse toResponse(User user) {
        if (user == null) {
            return null;
        }
        
        return new UserResponse(
            user.getId(),
            user.getEmail(),
            user.getFullName(),
            user.getPhoneNumber(),
            user.getImageUrl(),
            user.getRole(),
            user.getIsActive(),
            user.getCreatedAt(),
            user.getUpdatedAt()
        );
    }
    
    /**
     * Convert list of User entities to list of UserResponse DTOs
     * @param users List of User entities
     * @return List of UserResponse DTOs
     */
    public List<UserResponse> toResponseList(List<User> users) {
        if (users == null) {
            return null;
        }
        
        return users.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }
    
    /**
     * Convert User entity to basic UserResponse (limited info for security)
     * @param user User entity
     * @return UserResponse DTO with limited information
     */
    public UserResponse toBasicResponse(User user) {
        if (user == null) {
            return null;
        }
        
        UserResponse response = new UserResponse();
        response.setId(user.getId());
        response.setFullName(user.getFullName());
        response.setEmail(user.getEmail());
        response.setRole(user.getRole());
        response.setIsActive(user.getIsActive());
        
        return response;
    }
}