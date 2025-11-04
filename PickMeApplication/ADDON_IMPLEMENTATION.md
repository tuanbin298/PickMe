# Menu Item Add-Ons Implementation

## 📋 Overview

Đã implement hệ thống Add-Ons hoàn chỉnh và an toàn cho PickMe Application với các tính năng:

- **Master Data Management**: MenuItemAddOn entity để quản lý add-ons của từng menu item
- **Security Validation**: Validate add-on thuộc menu item và không cho phép user tự set giá
- **Quantity Support**: Hỗ trợ quantity cho add-ons
- **Category Management**: Phân loại add-ons theo category (Size, Topping, Extra, etc.)

## 🏗️ Architecture

### Entities Structure
```
MenuItem
├── MenuItemAddOn (Master data)
│   ├── name, description, price
│   ├── category, displayOrder
│   ├── maxQuantity, isRequired
│   └── isAvailable
│
Cart/Order Flow:
├── CartItem → CartItemAddOn (với quantity)
└── OrderItem → OrderAddOn (snapshot với quantity)
```

## 🔧 Implementation Details

### 1. MenuItemAddOn Entity
```java
@Entity
@Table(name = "menu_item_add_ons")
public class MenuItemAddOn {
    private String name;        // "Extra cheese"
    private String description; // "Add extra cheese (+$2)" 
    private BigDecimal price;   // $2.00
    private String category;    // "Topping", "Size", "Extra"
    private Boolean isRequired; // Bắt buộc chọn (ví dụ: size)
    private Integer maxQuantity; // Giới hạn số lượng
    private Integer displayOrder; // Thứ tự hiển thị
}
```

### 2. Secure Add-On Request
```java
public class AddOnRequest {
    @NotNull
    private Long menuItemAddOnId; // ✅ Reference to master data
    
    @NotNull
    private Integer quantity = 1;
    
    // ❌ Removed: name, description, price (security risk)
}
```

### 3. Validation trong CartService
```java
// Validate add-on belongs to menu item
MenuItemAddOn menuItemAddOn = menuItemAddOnRepository.findById(addOnRequest.getMenuItemAddOnId())
    .orElseThrow(() -> new IllegalArgumentException("Add-on not found"));

// Security check
if (!menuItemAddOn.getMenuItem().getId().equals(request.getMenuItemId())) {
    throw new IllegalArgumentException("Add-on doesn't belong to this menu item");
}

// Availability check  
if (!menuItemAddOn.isAvailableForSelection()) {
    throw new IllegalArgumentException("Add-on is not available");
}

// Quantity validation
if (menuItemAddOn.getMaxQuantity() != null && 
    addOnRequest.getQuantity() > menuItemAddOn.getMaxQuantity()) {
    throw new IllegalArgumentException("Exceeded maximum quantity");
}
```

## 🔌 API Endpoints

### Public APIs (Customer)
```bash
# Get all add-ons for menu item
GET /api/menu-items/{menuItemId}/add-ons

# Get add-ons by category
GET /api/menu-items/{menuItemId}/add-ons/category/{category}

# Get add-on categories
GET /api/menu-items/{menuItemId}/add-ons/categories
```

### Restaurant Owner APIs
```bash
# Create add-on
POST /api/menu-items/{menuItemId}/add-ons

# Update add-on
PUT /api/menu-items/{menuItemId}/add-ons/{addOnId}

# Delete add-on
DELETE /api/menu-items/{menuItemId}/add-ons/{addOnId}

# Toggle availability
PUT /api/menu-items/{menuItemId}/add-ons/{addOnId}/toggle-availability

# Update display order
PUT /api/menu-items/{menuItemId}/add-ons/{addOnId}/display-order?displayOrder=1
```

### Add to Cart với Add-ons
```bash
POST /api/cart/add
{
  "restaurantId": 1,
  "menuItemId": 5,
  "quantity": 2,
  "specialInstructions": "Không cay",
  "addOns": [
    {
      "menuItemAddOnId": 10,  // ✅ Reference to MenuItemAddOn
      "quantity": 2           // ✅ Quantity for add-on
    }
  ]
}
```

## 📊 Database Schema

### New Tables
```sql
-- Master add-ons data
CREATE TABLE menu_item_add_ons (
    id BIGINT PRIMARY KEY,
    menu_item_id BIGINT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(100),
    is_available BOOLEAN DEFAULT true,
    display_order INT DEFAULT 0,
    max_quantity INT,
    is_required BOOLEAN DEFAULT false,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Updated cart_item_add_ons
ALTER TABLE cart_item_add_ons ADD COLUMN quantity INT NOT NULL DEFAULT 1;

-- Updated order_add_ons  
ALTER TABLE order_add_ons ADD COLUMN quantity INT NOT NULL DEFAULT 1;
```

## 🎯 Use Cases

### Typical Add-On Categories
- **Size**: "Small", "Medium", "Large" (usually required)
- **Topping**: "Extra cheese", "Pepperoni", "Mushroom"
- **Extra**: "Extra sauce", "Side salad"
- **Temperature**: "Hot", "Iced" (for drinks)
- **Spice Level**: "Mild", "Medium", "Spicy"

### Example Add-On Setup
```java
// Pizza menu item
MenuItem pizza = ...;

// Size category (required)
pizza.addAddOn("Small (9inch)", "Personal size pizza", new BigDecimal("0.00"), "Size");
pizza.addAddOn("Medium (12inch)", "Medium size pizza", new BigDecimal("3.00"), "Size");
pizza.addAddOn("Large (15inch)", "Large size pizza", new BigDecimal("6.00"), "Size");

// Toppings (optional, max 5)
pizza.addAddOn("Extra cheese", "Double cheese", new BigDecimal("2.00"), "Topping");
pizza.addAddOn("Pepperoni", "Spicy pepperoni", new BigDecimal("2.50"), "Topping");
```

## ✅ Security Benefits

1. **Price Integrity**: User không thể manipulate giá add-on
2. **Data Validation**: Chỉ cho phép add-on thuộc menu item đó
3. **Availability Control**: Kiểm tra add-on có available không
4. **Quantity Limits**: Enforce max quantity nếu có
5. **Business Rules**: Support required add-ons

## 🚀 Next Steps

1. **Frontend Integration**: Update UI để sử dụng menuItemAddOnId
2. **Migration Script**: Migrate existing add-on data (nếu có)  
3. **Testing**: Thêm unit tests cho validation logic
4. **Admin Panel**: UI để restaurant owners quản lý add-ons
5. **Analytics**: Track add-on popularity và revenue