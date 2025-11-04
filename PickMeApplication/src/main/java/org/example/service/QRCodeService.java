package org.example.service;

import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class QRCodeService {
    
    /**
     * Generate unique QR code string for order
     */
    public String generateOrderQRCode() {
        return "ORDER-" + UUID.randomUUID().toString().replace("-", "").toUpperCase().substring(0, 12);
    }
    
    /**
     * Validate QR code format
     */
    public boolean isValidOrderQRCode(String qrCode) {
        if (qrCode == null || qrCode.length() != 18) {
            return false;
        }
        
        return qrCode.startsWith("ORDER-") && qrCode.substring(6).matches("[A-Z0-9]{12}");
    }
    
    /**
     * Extract order identifier from QR code
     */
    public String extractOrderIdentifier(String qrCode) {
        if (!isValidOrderQRCode(qrCode)) {
            throw new IllegalArgumentException("Invalid QR code format");
        }
        
        return qrCode.substring(6); // Remove "ORDER-" prefix
    }
    
    /**
     * Generate QR code URL for frontend to render
     * This would typically integrate with a QR code library like ZXing
     */
    public String generateQRCodeUrl(String qrCode, String baseUrl) {
        // Example: Generate URL that frontend can use to create QR code image
        return baseUrl + "/api/orders/qr/" + qrCode;
    }
    
    /**
     * Create display text for QR code
     */
    public String createQRDisplayText(String qrCode, String restaurantName) {
        return String.format("Order: %s\nRestaurant: %s\nScan to verify pickup", 
                            qrCode, restaurantName);
    }
    
    // Future: Add actual QR code image generation using libraries like ZXing
    // This would require additional dependencies in pom.xml:
    // <dependency>
    //     <groupId>com.google.zxing</groupId>
    //     <artifactId>core</artifactId>
    //     <version>3.5.1</version>
    // </dependency>
    // <dependency>
    //     <groupId>com.google.zxing</groupId>
    //     <artifactId>javase</artifactId>
    //     <version>3.5.1</version>
    // </dependency>
    
    /*
    public BufferedImage generateQRCodeImage(String qrCode) throws Exception {
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(qrCode, BarcodeFormat.QR_CODE, 300, 300);
        
        BufferedImage image = new BufferedImage(300, 300, BufferedImage.TYPE_INT_RGB);
        image.createGraphics();
        
        Graphics2D graphics = (Graphics2D) image.getGraphics();
        graphics.setColor(Color.WHITE);
        graphics.fillRect(0, 0, 300, 300);
        graphics.setColor(Color.BLACK);
        
        for (int i = 0; i < 300; i++) {
            for (int j = 0; j < 300; j++) {
                if (bitMatrix.get(i, j)) {
                    graphics.fillRect(i, j, 1, 1);
                }
            }
        }
        
        return image;
    }
    */
}