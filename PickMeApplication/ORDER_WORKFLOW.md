# PickMe Application - Order Workflow

## 🛒 **RECOMMENDED WORKFLOW: Cart-Based Order Creation**

### **New Flow (Khuyến khích sử dụng)**

```
1. Customer thêm items vào Cart (cùng restaurant)
   POST /api/cart/add

2. Customer xem và chỉnh sửa Cart
   GET /api/cart
   PUT /api/cart/{cartId}/items/{itemId}/quantity
   DELETE /api/cart/{cartId}/items/{itemId}

3. Customer checkout Cart thành Order
   POST /api/orders/from-cart/{cartId}

4. Restaurant xử lý Order
   PUT /api/orders/{orderId}/status
```

### **Old Flow (Deprecated - Không khuyến khích)**

```
1. Customer tạo empty order
   POST /api/orders (DEPRECATED)

2. Customer thêm từng item vào order
   POST /api/orders/{orderId}/items (DEPRECATED)

3. Restaurant xử lý Order
   PUT /api/orders/{orderId}/status
```

---

## 🔄 **Cart Workflow Chi Tiết**

### **1. Thêm Items Vào Cart**

**Endpoint**: `POST /api/cart/add`

**Request Body**:

```json
{
  "restaurantId": 1,
  "menuItemId": 5,
  "quantity": 2,
  "specialInstructions": "Không cay",
  "addOns": [
    {
      "menuItemAddOnId": 3,
      "quantity": 1
    }
  ]
}
```

**Business Rules**:

- Chỉ cho phép items từ cùng 1 restaurant
- Nếu thêm item từ restaurant khác → Clear cart cũ
- Validate restaurant phải ACTIVE và APPROVED
- Validate menu item phải thuộc restaurant đó

### **2. Quản Lý Cart**

**Xem Cart**: `GET /api/cart`

**Cập nhật số lượng**: `PUT /api/cart/{cartId}/items/{itemId}/quantity?quantity=3`

**Xóa item**: `DELETE /api/cart/{cartId}/items/{itemId}`

**Clear cart**: `DELETE /api/cart/{cartId}/clear`

**Quick actions**:

- `GET /api/cart/count` - Số lượng items
- `GET /api/cart/total` - Tổng tiền
- `POST /api/cart/quick-add?restaurantId=1&menuItemId=5&quantity=2`

### **3. Checkout Cart Thành Order**

**Endpoint**: `POST /api/orders/from-cart/{cartId}`

**Request Body**:

```json
{
  "deliveryAddressId": 2,
  "preferredPickupTime": "2025-10-24T18:30:00",
  "specialInstructions": "Gọi trước khi đến 15 phút",
  "paymentMethod": "CASH"
}
```

**Kết quả**:

- Cart status: ACTIVE → CHECKED_OUT
- Tạo Order mới với status: PENDING
- Order có QR code để track
- Copy tất cả items từ Cart sang Order với snapshot pricing

---

## 📱 **API Endpoints Tổng Hợp**

### **Cart Management**

- `POST /api/cart/add` - Thêm item vào cart
- `GET /api/cart` - Xem active cart
- `PUT /api/cart/{cartId}/items/{itemId}/quantity` - Cập nhật số lượng
- `DELETE /api/cart/{cartId}/items/{itemId}` - Xóa item
- `DELETE /api/cart/{cartId}/clear` - Clear cart
- `POST /api/orders/from-cart/{cartId}` - **Checkout cart thành order**

### **Order Management**

- `GET /api/orders/my-orders` - Lịch sử orders
- `GET /api/orders/my-orders/active` - Active orders
- `GET /api/orders/{orderId}` - Chi tiết order
- `GET /api/orders/qr/{qrCode}` - Order theo QR code
- `PUT /api/orders/{orderId}/cancel` - Hủy order
- `PUT /api/orders/{orderId}/pickup-time` - Cập nhật thời gian lấy

### **Restaurant Order Processing**

- `GET /api/orders/restaurant/{restaurantId}` - Orders của restaurant
- `GET /api/orders/restaurant/{restaurantId}/status/{status}` - Filter theo status
- `PUT /api/orders/{orderId}/status` - Cập nhật status
- `POST /api/orders/qr/{qrCode}/confirm` - Xác nhận order bằng QR
- `POST /api/orders/qr/{qrCode}/ready` - Đánh dấu sẵn sàng bằng QR
- `POST /api/orders/qr/{qrCode}/picked-up` - Đánh dấu đã lấy bằng QR

---

## ✅ **Lợi Ích Của Cart Workflow**

1. **UX tốt hơn**: Customer có thể thêm/bớt items dễ dàng
2. **Single restaurant rule**: Tránh nhầm lẫn khi order từ nhiều restaurants
3. **Snapshot pricing**: Giá được fix tại thời điểm checkout
4. **Better validation**: Validate toàn bộ cart trước khi tạo order
5. **Cleaner code**: Separation of concerns rõ ràng

---

## 🔒 **Security & Permissions**

- **CUSTOMER**: Có thể manage cart và orders của mình
- **RESTAURANT_STAFF/OWNER**: Có thể xử lý orders của restaurant mình
- **ADMIN**: Có thể xem tất cả orders và analytics

---

## 📊 **Order Status Lifecycle**

```
PENDING → CONFIRMED → PREPARING → READY → PICKED_UP → COMPLETED
                ↓
            CANCELLED (chỉ khi PENDING)
```

**QR Code Format**: `ORDER-{randomString}` (ví dụ: `ORDER-ABC123DEF456`)
