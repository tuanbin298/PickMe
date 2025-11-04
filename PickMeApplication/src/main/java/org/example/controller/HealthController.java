package org.example.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;

@RestController
@CrossOrigin(origins = "*")
public class HealthController {
    
    @GetMapping("/")
    public String home() {
        return "PickMe Backend is running successfully! 🚀";
    }
    
    @GetMapping("/health")
    public String health() {
        return "OK - PickMe API is healthy! ✅";
    }
    
    @GetMapping("/api/health")
    public String apiHealth() {
        return "API endpoints are working! 📡";
    }
}