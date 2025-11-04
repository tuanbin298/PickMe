package org.example.dto.response;

import java.time.LocalTime;

public class RestaurantStatusResponse {
    
    private Long id;
    private String name;
    private String status; // OPEN, CLOSED, INACTIVE, PENDING_APPROVAL, NO_HOURS_SET
    private Boolean isOpen;
    private LocalTime openingTime;
    private LocalTime closingTime;
    private Long minutesUntilStatusChange; // Minutes until open/close, -1 if unknown
    private String statusMessage;
    
    // Constructors
    public RestaurantStatusResponse() {}
    
    public RestaurantStatusResponse(Long id, String name, String status, Boolean isOpen) {
        this.id = id;
        this.name = name;
        this.status = status;
        this.isOpen = isOpen;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Boolean getIsOpen() {
        return isOpen;
    }
    
    public void setIsOpen(Boolean isOpen) {
        this.isOpen = isOpen;
    }
    
    public LocalTime getOpeningTime() {
        return openingTime;
    }
    
    public void setOpeningTime(LocalTime openingTime) {
        this.openingTime = openingTime;
    }
    
    public LocalTime getClosingTime() {
        return closingTime;
    }
    
    public void setClosingTime(LocalTime closingTime) {
        this.closingTime = closingTime;
    }
    
    public Long getMinutesUntilStatusChange() {
        return minutesUntilStatusChange;
    }
    
    public void setMinutesUntilStatusChange(Long minutesUntilStatusChange) {
        this.minutesUntilStatusChange = minutesUntilStatusChange;
    }
    
    public String getStatusMessage() {
        return statusMessage;
    }
    
    public void setStatusMessage(String statusMessage) {
        this.statusMessage = statusMessage;
    }
}