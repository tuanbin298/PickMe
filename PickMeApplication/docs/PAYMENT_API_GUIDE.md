# � Payment API - Hướng dẫn sử dụng

## 🎯 Mục đích

Hệ thống thanh toán cho PickMe Application hỗ trợ 2 phương thức:

- **SePay**: Thanh toán QR code ngân hàng tự động
- **Cash**: Thanh toán tiền mặt (xác nhận thủ công)

## 🔄 Cách hoạt động

### SePay Payment Flow:

1. Customer tạo payment → Backend tạo QR code
2. Customer quét QR → Chuyển khoản với nội dung "DH{orderId}"
3. SePay webhook → Backend tự động xác nhận thanh toán
4. Frontend polling status → Chuyển trang thành công

### Cash Payment Flow:

1. Customer chọn thanh toán tiền mặt → Payment status = PENDING
2. Restaurant Owner nhận tiền → Xác nhận qua API
3. Payment status = COMPLETED → Order được xử lý

## 📋 Danh sách API

### 🔐 Customer/Restaurant APIs

- `POST /api/payments` - Tạo payment cho order
- `GET /api/payments/order/{orderId}` - Xem payment của order
- `GET /api/payments/{paymentId}` - Chi tiết payment
- `GET /api/payments/my-payments` - Lịch sử thanh toán
- `POST /api/payments/{paymentId}/cash-confirm` - Xác nhận tiền mặt (Restaurant)
- `POST /api/payments/{paymentId}/cancel` - Hủy thanh toán

### � Admin APIs

- `POST /api/payments/{paymentId}/refund` - Hoàn tiền
- `GET /api/payments/admin/statistics` - Thống kê doanh thu
- `POST /api/payments/admin/expire-pending` - Expire payments thủ công

### 🌐 Public APIs

- `GET /api/payments/order/{orderId}/status` - Check status (cho polling)
- `GET /api/payments/sepay/info` - Thông tin ngân hàng
- `POST /api/payments/sepay/webhook` - SePay webhook endpoint

## 🏗️ Kiến trúc

```
[Customer] → [Order] → [Payment] → [SepayTransaction] → [Success]
                  ↓         ↓             ↓
               [PENDING] [PROCESSING] [COMPLETED]
```

## 📊 Payment Status

- **PENDING** → Chờ thanh toán
- **PROCESSING** → Đang xử lý (SePay)
- **COMPLETED** → Thành công
- **CANCELLED/EXPIRED/FAILED** → Thất bại
- **REFUNDED** → Đã hoàn tiền

## 🔑 Authentication

- Tất cả API cần JWT: `Authorization: Bearer <token>`
- Trừ: webhook, status polling, sepay info

## 💡 Sử dụng cơ bản

### Tạo SePay Payment:

```json
POST /api/payments
{
  "orderId": 123,
  "paymentMethod": "SEPAY"
}
```

### Polling trạng thái (Frontend):

```javascript
setInterval(async () => {
  const response = await fetch("/api/payments/order/123/status");
  const data = await response.json();
  if (data.payment_status === "COMPLETED") {
    window.location.href = "/success";
  }
}, 3000);
```

### SePay Webhook URL (cấu hình tại SePay):

```
https://yourdomain.com/api/payments/sepay/webhook
```

## 📱 Frontend Integration

1. Tạo payment → Hiển thị QR code (SePay) hoặc hướng dẫn (Cash)
2. Start polling → Check status mỗi 3 giây
3. Status = COMPLETED → Redirect success page
4. Restaurant xác nhận cash → Call cash-confirm API

## 🔧 Testing

- **Swagger UI**: `/swagger-ui.html`
- **Mock webhook**: POST to webhook endpoint với sample data
- **ngrok**: Expose localhost cho SePay webhook test  
  **Auth:** `CUSTOMER`, `RESTAURANT_OWNER`

#### Request Body:

```json
{
  "orderId": 123,
  "paymentMethod": "SEPAY", // "SEPAY" hoặc "CASH"
  "note": "Thanh toán đơn hàng #123"
}
```

#### Response - SePay:

```json
{
  "id": 456,
  "orderId": 123,
  "paymentMethod": "SEPAY",
  "paymentStatus": "PENDING",
  "amount": 150000.0,
  "qrCodeUrl": "https://qr.sepay.vn/img?bank=MBBank&acc=0903252427&template=compact&amount=150000&des=DH123",
  "paymentContent": "DH123",
  "bankInfo": {
    "bankName": "MBBank",
    "accountNumber": "0903252427",
    "accountHolder": "PICK ME APPLICATION"
  },
  "note": "Thanh toán đơn hàng #123",
  "createdAt": "2025-10-29T10:30:00"
}
```

#### Response - Cash:

```json
{
  "id": 457,
  "orderId": 123,
  "paymentMethod": "CASH",
  "paymentStatus": "PENDING",
  "amount": 150000.0,
  "note": "Thanh toán đơn hàng #123",
  "createdAt": "2025-10-29T10:30:00"
}
```

---

### 2. 📄 Lấy Payment theo Order ID

**Endpoint:** `GET /api/payments/order/{orderId}`  
**Auth:** `CUSTOMER`, `RESTAURANT_OWNER`, `ADMIN`

#### Example:

```bash
GET /api/payments/order/123
```

#### Response:

```json
{
  "id": 456,
  "orderId": 123,
  "paymentMethod": "SEPAY",
  "paymentStatus": "COMPLETED",
  "amount": 150000.0,
  "qrCodeUrl": "https://qr.sepay.vn/img?bank=MBBank&acc=0903252427&template=compact&amount=150000&des=DH123",
  "sepayTransactionId": 987654321,
  "completedAt": "2025-10-29T10:35:00",
  "createdAt": "2025-10-29T10:30:00"
}
```

---

### 3. 🔍 Lấy Payment theo Payment ID

**Endpoint:** `GET /api/payments/{paymentId}`  
**Auth:** `CUSTOMER`, `RESTAURANT_OWNER`, `ADMIN`

#### Example:

```bash
GET /api/payments/456
```

---

### 4. 📋 Lấy danh sách Payments của User

**Endpoint:** `GET /api/payments/my-payments`  
**Auth:** `CUSTOMER`, `RESTAURANT_OWNER`

#### Response:

```json
[
  {
    "id": 456,
    "orderId": 123,
    "paymentMethod": "SEPAY",
    "paymentStatus": "COMPLETED",
    "amount": 150000.0,
    "completedAt": "2025-10-29T10:35:00",
    "createdAt": "2025-10-29T10:30:00"
  },
  {
    "id": 457,
    "orderId": 124,
    "paymentMethod": "CASH",
    "paymentStatus": "PENDING",
    "amount": 200000.0,
    "createdAt": "2025-10-29T11:00:00"
  }
]
```

---

### 5. ✅ Xác nhận thanh toán tiền mặt

**Endpoint:** `POST /api/payments/{paymentId}/cash-confirm`  
**Auth:** `RESTAURANT_OWNER`, `ADMIN`

#### Example:

```bash
POST /api/payments/457/cash-confirm
```

#### Response:

```json
{
  "id": 457,
  "orderId": 124,
  "paymentMethod": "CASH",
  "paymentStatus": "COMPLETED",
  "amount": 200000.0,
  "completedAt": "2025-10-29T11:30:00",
  "createdAt": "2025-10-29T11:00:00"
}
```

---

### 6. ❌ Hủy thanh toán

**Endpoint:** `POST /api/payments/{paymentId}/cancel?reason=Customer%20request`  
**Auth:** `CUSTOMER`, `RESTAURANT_OWNER`, `ADMIN`

#### Response:

```json
{
  "id": 458,
  "paymentStatus": "CANCELLED",
  "cancelReason": "Customer request",
  "cancelledAt": "2025-10-29T12:00:00"
}
```

---

### 7. 💰 Hoàn tiền (Admin only)

**Endpoint:** `POST /api/payments/{paymentId}/refund`  
**Auth:** `ADMIN`

#### Response:

```json
{
  "id": 456,
  "paymentStatus": "REFUNDED",
  "refundedAt": "2025-10-29T12:30:00"
}
```

---

### 8. ⏱️ Kiểm tra trạng thái thanh toán (AJAX Polling)

**Endpoint:** `GET /api/payments/order/{orderId}/status`  
**Auth:** Không cần (Public)

#### Response:

```json
{
  "payment_status": "COMPLETED",
  "payment_status_display": "Đã thanh toán"
}
```

#### Usage (Frontend JavaScript):

```javascript
// Polling mỗi 3 giây để check trạng thái
setInterval(async () => {
  const response = await fetch("/api/payments/order/123/status");
  const data = await response.json();

  if (data.payment_status === "COMPLETED") {
    alert("Thanh toán thành công!");
    window.location.href = "/order-success";
  }
}, 3000);
```

---

### 9. 🏦 Lấy thông tin ngân hàng SePay

**Endpoint:** `GET /api/payments/sepay/info`  
**Auth:** Không cần (Public)

#### Response:

```json
{
  "bankName": "MBBank",
  "accountNumber": "0903252427",
  "accountHolder": "PICK ME APPLICATION"
}
```

---

### 10. 🔗 SePay Webhook (Internal)

**Endpoint:** `POST /api/payments/sepay/webhook`  
**Auth:** Không cần (Chỉ SePay gọi)

#### SePay Request Body:

```json
{
  "id": 987654321,
  "gateway": "MBBank",
  "transactionDate": "2025-10-29 10:35:00",
  "accountNumber": "0903252427",
  "transferType": "in",
  "transferAmount": 150000,
  "content": "DH123",
  "referenceCode": "MBVCB.987654321"
}
```

#### Response:

```json
{
  "success": true,
  "message": "Payment processed successfully",
  "order_id": 123,
  "payment_id": 456
}
```

---

## 🔧 Admin APIs

### 11. 📊 Thống kê thanh toán

**Endpoint:** `GET /api/payments/admin/statistics`  
**Auth:** `ADMIN`

#### Response:

```json
{
  "total_sepay": 5000000.0,
  "total_cash": 2000000.0,
  "total_all": 7000000.0,
  "unprocessed_transactions": 3
}
```

### 12. ⏰ Expire pending payments thủ công

**Endpoint:** `POST /api/payments/admin/expire-pending`  
**Auth:** `ADMIN`

#### Response:

```json
{
  "message": "Pending payments expired successfully"
}
```

---

## 🔄 Payment Status Flow

```
PENDING → PROCESSING → COMPLETED
   ↓
CANCELLED / EXPIRED / FAILED
   ↓
REFUNDED (chỉ từ COMPLETED)
```

### Payment Status:

- **PENDING**: Đang chờ thanh toán
- **PROCESSING**: Đang xử lý (SePay webhook nhận được)
- **COMPLETED**: Đã thanh toán thành công
- **CANCELLED**: Đã hủy
- **EXPIRED**: Hết hạn (15 phút)
- **FAILED**: Thanh toán thất bại
- **REFUNDED**: Đã hoàn tiền

---

## 🛠️ Frontend Integration Examples

### 1. Tạo Payment SePay

```javascript
async function createSepayPayment(orderId) {
  const response = await fetch("/api/payments", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: "Bearer " + localStorage.getItem("jwt_token"),
    },
    body: JSON.stringify({
      orderId: orderId,
      paymentMethod: "SEPAY",
      note: `Thanh toán đơn hàng #${orderId}`,
    }),
  });

  const payment = await response.json();

  // Hiển thị QR code
  document.getElementById("qr-image").src = payment.qrCodeUrl;
  document.getElementById("payment-content").textContent = payment.paymentContent;

  // Bắt đầu polling trạng thái
  startPaymentStatusPolling(orderId);
}
```

### 2. Polling trạng thái thanh toán

```javascript
function startPaymentStatusPolling(orderId) {
  const pollInterval = setInterval(async () => {
    try {
      const response = await fetch(`/api/payments/order/${orderId}/status`);
      const data = await response.json();

      if (data.payment_status === "COMPLETED") {
        clearInterval(pollInterval);
        showSuccessMessage("Thanh toán thành công!");
        redirectToSuccessPage();
      } else if (data.payment_status === "EXPIRED") {
        clearInterval(pollInterval);
        showErrorMessage("Thanh toán đã hết hạn");
      }
    } catch (error) {
      console.error("Error polling payment status:", error);
    }
  }, 3000); // Poll mỗi 3 giây

  // Dừng polling sau 15 phút
  setTimeout(() => {
    clearInterval(pollInterval);
  }, 15 * 60 * 1000);
}
```

### 3. Xác nhận thanh toán tiền mặt (Restaurant Owner)

```javascript
async function confirmCashPayment(paymentId) {
  const response = await fetch(`/api/payments/${paymentId}/cash-confirm`, {
    method: "POST",
    headers: {
      Authorization: "Bearer " + localStorage.getItem("jwt_token"),
    },
  });

  if (response.ok) {
    const payment = await response.json();
    alert("Đã xác nhận thanh toán tiền mặt");
    location.reload();
  }
}
```

---

## 🧪 Testing với Postman

### 1. Setup Environment

```
Base URL: http://localhost:8080
JWT Token: {{jwt_token}}
```

### 2. Test Flow:

1. **Login** → Lấy JWT token
2. **Create Order** → Lấy orderId
3. **Create Payment** → Test SePay/Cash
4. **Mock Webhook** → Test SePay webhook (nếu cần)
5. **Check Status** → Verify payment status

### 3. Mock SePay Webhook:

```bash
curl -X POST http://localhost:8080/api/payments/sepay/webhook \
-H "Content-Type: application/json" \
-d '{
  "id": 987654321,
  "gateway": "MBBank",
  "transactionDate": "2025-10-29 10:35:00",
  "accountNumber": "0903252427",
  "transferType": "in",
  "transferAmount": 150000,
  "content": "DH123",
  "referenceCode": "MBVCB.987654321"
}'
```

---

## ⚠️ Error Handling

### Common HTTP Status Codes:

- **200**: Success
- **400**: Bad Request (validation errors)
- **401**: Unauthorized (missing/invalid JWT)
- **403**: Forbidden (insufficient permissions)
- **404**: Not Found (payment/order not found)
- **500**: Internal Server Error

### Error Response Format:

```json
{
  "timestamp": "2025-10-29T10:30:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Order not found",
  "path": "/api/payments"
}
```

---

## 🔒 Security Notes

1. **Webhook Security**: SePay webhook không cần auth nhưng nên validate transaction data
2. **Role-based Access**: Mỗi API có role riêng (CUSTOMER/RESTAURANT_OWNER/ADMIN)
3. **Input Validation**: Tất cả input được validate với Bean Validation
4. **SQL Injection Prevention**: Sử dụng JPA Repository với parameterized queries

---

## 📞 Support & Contact

- **API Documentation**: `/swagger-ui.html`
- **Backend Developer**: PickMe Team
- **SePay Integration**: Xem tài liệu SePay webhook
