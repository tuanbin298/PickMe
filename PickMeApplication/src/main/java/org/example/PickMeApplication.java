package org.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class PickMeApplication {
    public static void main(String[] args) {
        // Set default timezone to Vietnam
        System.setProperty("user.timezone", "Asia/Ho_Chi_Minh");
        java.util.TimeZone.setDefault(java.util.TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        
        SpringApplication.run(PickMeApplication.class, args);
    }
}