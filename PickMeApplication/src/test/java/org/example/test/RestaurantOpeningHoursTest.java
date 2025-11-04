package org.example.test;

import org.example.entity.Restaurant;
import org.example.entity.ApprovalStatus;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalTime;

/**
 * Test cases for Restaurant opening hours validation
 * Especially for overnight operations (e.g., 22:00 - 04:00)
 */
public class RestaurantOpeningHoursTest {
    
    private Restaurant restaurant;
    
    @BeforeEach
    void setUp() {
        restaurant = new Restaurant();
        restaurant.setIsActive(true);
        restaurant.setApprovalStatus(ApprovalStatus.APPROVED);
    }
    
    @Test
    void testNormalHours_08_22() {
        // Normal hours: 08:00 - 22:00
        restaurant.setOpeningTime(LocalTime.of(8, 0));
        restaurant.setClosingTime(LocalTime.of(22, 0));
        
        // Should be open
        assertTrue(restaurant.isOpenAt(LocalTime.of(8, 0)));   // Exactly opening time
        assertTrue(restaurant.isOpenAt(LocalTime.of(12, 0)));  // Mid day
        assertTrue(restaurant.isOpenAt(LocalTime.of(22, 0)));  // Exactly closing time
        
        // Should be closed
        assertFalse(restaurant.isOpenAt(LocalTime.of(7, 59))); // Before opening
        assertFalse(restaurant.isOpenAt(LocalTime.of(22, 1))); // After closing
        assertFalse(restaurant.isOpenAt(LocalTime.of(2, 0)));  // Late night
    }
    
    @Test
    void testOvernightHours_22_04() {
        // Overnight hours: 22:00 - 04:00
        restaurant.setOpeningTime(LocalTime.of(22, 0));
        restaurant.setClosingTime(LocalTime.of(4, 0));
        
        // Should be open
        assertTrue(restaurant.isOpenAt(LocalTime.of(22, 0)));  // Exactly opening time
        assertTrue(restaurant.isOpenAt(LocalTime.of(23, 0)));  // Late night
        assertTrue(restaurant.isOpenAt(LocalTime.of(0, 0)));   // Midnight
        assertTrue(restaurant.isOpenAt(LocalTime.of(2, 0)));   // Early morning
        assertTrue(restaurant.isOpenAt(LocalTime.of(4, 0)));   // Exactly closing time
        
        // Should be closed
        assertFalse(restaurant.isOpenAt(LocalTime.of(21, 59))); // Before opening
        assertFalse(restaurant.isOpenAt(LocalTime.of(4, 1)));   // After closing
        assertFalse(restaurant.isOpenAt(LocalTime.of(10, 0)));  // Mid day
        assertFalse(restaurant.isOpenAt(LocalTime.of(15, 0)));  // Afternoon
    }
    
    @Test
    void testOvernightHours_20_06() {
        // Longer overnight hours: 20:00 - 06:00
        restaurant.setOpeningTime(LocalTime.of(20, 0));
        restaurant.setClosingTime(LocalTime.of(6, 0));
        
        // Should be open
        assertTrue(restaurant.isOpenAt(LocalTime.of(20, 0)));  // Exactly opening time
        assertTrue(restaurant.isOpenAt(LocalTime.of(21, 0)));  // Evening
        assertTrue(restaurant.isOpenAt(LocalTime.of(23, 30))); // Late night
        assertTrue(restaurant.isOpenAt(LocalTime.of(1, 0)));   // After midnight
        assertTrue(restaurant.isOpenAt(LocalTime.of(5, 30))); // Early morning
        assertTrue(restaurant.isOpenAt(LocalTime.of(6, 0)));   // Exactly closing time
        
        // Should be closed
        assertFalse(restaurant.isOpenAt(LocalTime.of(19, 59))); // Before opening
        assertFalse(restaurant.isOpenAt(LocalTime.of(6, 1)));   // After closing
        assertFalse(restaurant.isOpenAt(LocalTime.of(12, 0)));  // Mid day
    }
    
    @Test
    void testEdgeCases() {
        // Same opening and closing time (24 hours)
        restaurant.setOpeningTime(LocalTime.of(0, 0));
        restaurant.setClosingTime(LocalTime.of(0, 0));
        
        // This should be treated as overnight (always open)
        assertTrue(restaurant.isOpenAt(LocalTime.of(12, 0)));
        assertTrue(restaurant.isOpenAt(LocalTime.of(0, 0)));
        
        // Inactive restaurant should always be closed
        restaurant.setIsActive(false);
        assertFalse(restaurant.isOpenAt(LocalTime.of(12, 0)));
        
        // Unapproved restaurant should always be closed
        restaurant.setIsActive(true);
        restaurant.setApprovalStatus(ApprovalStatus.PENDING);
        assertFalse(restaurant.isOpenAt(LocalTime.of(12, 0)));
    }
    
    @Test
    void testSpecificBugCase_22_04_at_23() {
        // The exact case from user's question:
        // Restaurant: 22:00 - 04:00, Check time: 23:00
        restaurant.setOpeningTime(LocalTime.of(22, 0));
        restaurant.setClosingTime(LocalTime.of(4, 0));
        
        // This should return TRUE (restaurant is open at 23:00)
        assertTrue(restaurant.isOpenAt(LocalTime.of(23, 0)), 
                  "Restaurant with hours 22:00-04:00 should be open at 23:00");
    }
}