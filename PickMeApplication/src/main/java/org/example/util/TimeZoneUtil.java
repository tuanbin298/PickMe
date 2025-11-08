package org.example.util;

import org.springframework.stereotype.Component;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;

/**
 * Utility class để debug timezone issues
 */
@Component
public class TimeZoneUtil {
    
    /**
     * Log current time in different timezones for debugging
     */
    public void logCurrentTimes() {
        System.out.println("=== TIMEZONE DEBUG INFO ===");
        
        // System timezone
        System.out.println("System Timezone: " + java.util.TimeZone.getDefault().getID());
        
        // Current times in different zones
        ZonedDateTime nowUTC = ZonedDateTime.now(ZoneId.of("UTC"));
        ZonedDateTime nowVietnam = ZonedDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh"));
        ZonedDateTime nowSystem = ZonedDateTime.now();
        
        System.out.println("UTC Time: " + nowUTC);
        System.out.println("Vietnam Time (UTC+7): " + nowVietnam);  
        System.out.println("System Time: " + nowSystem);
        
        // LocalTime comparisons
        LocalTime localTimeSystem = LocalTime.now();
        LocalTime localTimeVietnam = LocalTime.now(ZoneId.of("Asia/Ho_Chi_Minh"));
        
        System.out.println("LocalTime (System): " + localTimeSystem);
        System.out.println("LocalTime (Vietnam): " + localTimeVietnam);
        System.out.println("============================");
    }
    
    /**
     * Get current Vietnam time
     */
    public LocalTime getCurrentVietnamTime() {
        return LocalTime.now(ZoneId.of("Asia/Ho_Chi_Minh"));
    }
}