package org.example.entity;

/**
 * Enum định nghĩa các loại review trong hệ thống
 */
public enum ReviewType {
    /**
     * Đánh giá quán ăn tổng thể
     */
    RESTAURANT("Restaurant Review"),
    
    /**
     * Đánh giá món ăn cụ thể
     */
    MENU_ITEM("Menu Item Review"),
    
    /**
     * Đánh giá trải nghiệm đơn hàng (service, timing, packaging)
     */
    ORDER_EXPERIENCE("Order Experience Review");
    
    private final String displayName;
    
    ReviewType(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    @Override
    public String toString() {
        return displayName;
    }
}