package org.example.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.*;

import java.time.LocalTime;
import java.util.List;

/**
 * Test request class để debug PostGIS issue
 */
public class TestCreateRestaurantRequest {
    
    @NotBlank(message = "Restaurant name is required")
    private String name;
    
    private String description;
    
    @NotBlank(message = "Address is required")
    private String address;
    
    @Pattern(regexp = "^[+]?[0-9]{10,15}$", message = "Invalid phone number format")
    private String phoneNumber;
    
    @Email(message = "Invalid email format")
    private String email;
    
    private String imageUrl;
    
    @NotNull(message = "Latitude is required")
    @DecimalMin(value = "-90.0", message = "Latitude must be between -90 and 90")
    @DecimalMax(value = "90.0", message = "Latitude must be between -90 and 90")
    @JsonProperty("latitude")
    private Double latitude;
    
    @NotNull(message = "Longitude is required")
    @DecimalMin(value = "-180.0", message = "Longitude must be between -180 and 180")
    @DecimalMax(value = "180.0", message = "Longitude must be between -180 and 180")
    @JsonProperty("longitude")
    private Double longitude;
    
    private LocalTime openingTime;
    
    private LocalTime closingTime;
    
    private List<String> categories;
    
    // Constructors
    public TestCreateRestaurantRequest() {}
    
    // Static factory method for testing
    public static TestCreateRestaurantRequest createTestRequest() {
        TestCreateRestaurantRequest request = new TestCreateRestaurantRequest();
        request.setName("Test Restaurant");
        request.setDescription("Test Description");
        request.setAddress("123 Test Street, Test City");
        request.setPhoneNumber("1234567890");
        request.setEmail("test@restaurant.com");
        request.setImageUrl("https://example.com/image.jpg");
        request.setLatitude(10.762622); // Valid Ho Chi Minh City latitude
        request.setLongitude(106.660172); // Valid Ho Chi Minh City longitude
        request.setOpeningTime(LocalTime.of(8, 0));
        request.setClosingTime(LocalTime.of(22, 0));
        request.setCategories(List.of("Vietnamese", "Fast Food"));
        return request;
    }
    
    // Getters and setters
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }
    
    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }
    
    public LocalTime getOpeningTime() { return openingTime; }
    public void setOpeningTime(LocalTime openingTime) { this.openingTime = openingTime; }
    
    public LocalTime getClosingTime() { return closingTime; }
    public void setClosingTime(LocalTime closingTime) { this.closingTime = closingTime; }
    
    public List<String> getCategories() { return categories; }
    public void setCategories(List<String> categories) { this.categories = categories; }
}