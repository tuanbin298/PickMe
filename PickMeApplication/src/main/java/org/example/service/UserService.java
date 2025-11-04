package org.example.service;

import org.example.dto.request.LoginRequest;
import org.example.dto.request.RegisterRequest;
import org.example.dto.request.UpdateUserRequest;
import org.example.dto.response.AuthResponse;
import org.example.dto.response.UserResponse;
import org.example.entity.Role;
import org.example.entity.User;
import org.example.exception.EmailAlreadyExistsException;
import org.example.exception.UserNotFoundException;
import org.example.repository.UserRepository;
import org.example.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private AuthenticationManager authenticationManager;
    
    @Autowired
    private JwtUtil jwtUtil;
    
    @Autowired
    private EmailService emailService;
    
    public AuthResponse register(RegisterRequest request) {
        // Check if user already exists
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new EmailAlreadyExistsException(request.getEmail());
        }
        
        // Create new user
        User user = new User();
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setFullName(request.getFullName());
        user.setPhoneNumber(request.getPhoneNumber());
        user.setImageUrl(request.getImageUrl());
        user.setRole(request.getRole());
        user.setIsActive(true);
        
        User savedUser = userRepository.save(user);
        
        // Send welcome email
        try {
            emailService.sendWelcomeEmail(savedUser.getEmail(), savedUser.getFullName());
        } catch (Exception e) {
            // Log error but don't fail registration
            System.err.println("Failed to send welcome email: " + e.getMessage());
        }
        
        // Generate JWT token
        Map<String, Object> extraClaims = new HashMap<>();
        extraClaims.put("role", savedUser.getRole().name());
        extraClaims.put("userId", savedUser.getId());
        
        String jwt = jwtUtil.generateToken(savedUser, extraClaims);
        
        return new AuthResponse(jwt, savedUser.getId(), savedUser.getEmail(),
                savedUser.getFullName(), savedUser.getPhoneNumber(),
                savedUser.getImageUrl(), savedUser.getRole(), savedUser.getCreatedAt());
    }
    
    public AuthResponse login(LoginRequest request) {
        // Authenticate user
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );
        
        User user = (User) authentication.getPrincipal();
        
        // Generate JWT token
        Map<String, Object> extraClaims = new HashMap<>();
        extraClaims.put("role", user.getRole().name());
        extraClaims.put("userId", user.getId());
        
        String jwt = jwtUtil.generateToken(user, extraClaims);
        
        return new AuthResponse(jwt, user.getId(), user.getEmail(),
                user.getFullName(), user.getPhoneNumber(),
                user.getImageUrl(), user.getRole(), user.getCreatedAt());
    }
    
    public List<UserResponse> getAllUsers() {
        return userRepository.findAll().stream()
                .map(this::convertToUserResponse)
                .collect(Collectors.toList());
    }
    
    public Page<UserResponse> getAllUsers(Pageable pageable) {
        return userRepository.findAll(pageable)
                .map(this::convertToUserResponse);
    }
    
    public Optional<UserResponse> getUserById(Long id) {
        return userRepository.findById(id)
                .map(this::convertToUserResponse);
    }
    
    public Optional<UserResponse> getUserByEmail(String email) {
        return userRepository.findByEmail(email)
                .map(this::convertToUserResponse);
    }
    
    public List<UserResponse> getUsersByRole(Role role) {
        return userRepository.findByRole(role).stream()
                .map(this::convertToUserResponse)
                .collect(Collectors.toList());
    }
    
    public List<UserResponse> searchUsersByName(String name) {
        return userRepository.findByFullNameContaining(name).stream()
                .map(this::convertToUserResponse)
                .collect(Collectors.toList());
    }
    
    public UserResponse updateUser(Long id, UpdateUserRequest request) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException(id));
        
        // Check if email is being changed and if it's already taken
        if (!user.getEmail().equals(request.getEmail()) && 
            userRepository.existsByEmail(request.getEmail())) {
            throw new EmailAlreadyExistsException(request.getEmail());
        }
        
        user.setEmail(request.getEmail());
        user.setFullName(request.getFullName());
        user.setPhoneNumber(request.getPhoneNumber());
        user.setImageUrl(request.getImageUrl());
        if (request.getRole() != null) {
            user.setRole(request.getRole());
        }
        if (request.getIsActive() != null) {
            user.setIsActive(request.getIsActive());
        }
        
        User updatedUser = userRepository.save(user);
        return convertToUserResponse(updatedUser);
    }
    
    public void deleteUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException(id));
        userRepository.delete(user);
    }
    
    public UserResponse deactivateUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException(id));
        user.setIsActive(false);
        User updatedUser = userRepository.save(user);
        return convertToUserResponse(updatedUser);
    }
    
    public UserResponse activateUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException(id));
        user.setIsActive(true);
        User updatedUser = userRepository.save(user);
        return convertToUserResponse(updatedUser);
    }
    
    public UserResponse getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException(email));
        return convertToUserResponse(user);
    }
    
    public User findByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException(email));
    }
    
    public User createUser(User user) {
        // Check if email already exists
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new EmailAlreadyExistsException(user.getEmail());
        }
        
        user.setIsActive(true);
        return userRepository.save(user);
    }
    
    private UserResponse convertToUserResponse(User user) {
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
}