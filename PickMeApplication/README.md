# PickMe Application

Ứng dụng đặt trước và đến lấy với 3 roles: Admin, Customer, Restaurant Owner.

## Yêu cầu hệ thống

- Java 17+
- PostgreSQL 12+ (với PostGIS extension)
- Maven 3.6+

## Cài đặt và chạy

### Tùy chọn 1: Sử dụng Neon Database (Cloud PostgreSQL)

**Bước 1**: Tạo database trên Neon

1. Đăng ký tài khoản tại [Neon.tech](https://neon.tech)
2. Tạo project mới
3. Lấy connection string từ dashboard

**Bước 2**: Cấu hình Environment Variables cho Neon
Copy và cập nhật file `.env`:

```bash
copy .env.example .env
```

Cập nhật các biến môi trường Neon:

```properties
NEON_DATABASE_URL=jdbc:postgresql://ep-your-endpoint.us-east-1.aws.neon.tech/neondb?sslmode=require
NEON_DB_USERNAME=your-username
NEON_DB_PASSWORD=your-password
```

**Bước 3**: Chạy ứng dụng

```bash
mvn spring-boot:run
```

Hibernate sẽ tự động tạo các bảng cần thiết với `ddl-auto=update`.

### Tùy chọn 2: Sử dụng PostgreSQL Local

**Bước 1**: Tạo database local

Chạy script SQL để tạo database:

```sql
psql -U postgres -f postgres_setup.sql
psql -U postgres -d pickmeapplication -f enable_postgis.sql
```

**Bước 2**: Cấu hình Environment Variables

Ứng dụng sử dụng **spring.factories** để tự động load file `.env` khi khởi động.

**Bước 1**: Copy file `.env.example` thành `.env`:

```bash
copy .env.example .env
```

**Bước 2**: Cập nhật thông tin trong file `.env`:

```properties
# Database Configuration - PostgreSQL
DB_PASSWORD=your_database_password

# JWT Configuration
JWT_SECRET=your_strong_secret_key_at_least_32_characters
JWT_EXPIRATION=86400000

# Email Configuration (Gmail SMTP)
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-16-digit-app-password
MAIL_FROM=your-email@gmail.com

# Application Configuration
APP_BASE_URL=http://localhost:8080
APP_ENV=development

# Server Configuration
SERVER_PORT=8080
```

**⚠️ Quan trọng**: File `.env` chứa thông tin nhạy cảm và đã được thêm vào `.gitignore`. Không bao giờ commit file này lên Git!

## Tính năng Environment Loading

### Automatic .env Loading với spring.factories

Ứng dụng sử dụng `spring.factories` để tự động load file `.env` khi khởi động:

- **EnvironmentLoader**: Load file `.env` trước khi Spring Boot context khởi tạo
- **EnvironmentValidator**: Validate các environment variables cần thiết
- **EnvUtil**: Utility class để truy cập environment variables dễ dàng

### Thứ tự tìm file .env

1. `.env` (thư mục gốc project)
2. `config/.env` (thư mục config)
3. `{working-directory}/.env`
4. `{user-home}/.env`
5. Classpath resources

### Validation tự động

Application sẽ kiểm tra các environment variables bắt buộc:

- `DB_PASSWORD`: Password database
- `JWT_SECRET`: Phải ít nhất 32 ký tự
- `MAIL_USERNAME`: Phải đúng format email
- `MAIL_PASSWORD`: Password email

Xem chi tiết tại: [`docs/ENVIRONMENT_SETUP.md`](docs/ENVIRONMENT_SETUP.md)

### 3. Cấu hình Email (Gmail)

Để sử dụng tính năng gửi email:

1. **Tạo App Password cho Gmail**:

   - Đăng nhập Gmail → Google Account Settings
   - Security → 2-Step Verification (bật nếu chưa có)
   - App passwords → Generate password for "Mail"
   - Copy app password (16 ký tự)

2. **Cập nhật file `.env`**:

```properties
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-16-digit-app-password
MAIL_FROM=your-email@gmail.com
```

3. **Test Email**: Sau khi cấu hình, test bằng cách đăng ký tài khoản mới hoặc reset password.

### 4. Cấu hình Network Access

Ứng dụng được cấu hình để lắng nghe trên tất cả IP addresses (`0.0.0.0`):

```properties
# Trong file .env
SERVER_ADDRESS=0.0.0.0  # Lắng nghe trên tất cả IP
SERVER_PORT=8080        # Port mặc định
```

**Các tùy chọn SERVER_ADDRESS:**

- `0.0.0.0` - Lắng nghe trên tất cả IP (có thể truy cập từ mạng ngoài)
- `localhost` hoặc `127.0.0.1` - Chỉ truy cập từ máy local
- `192.168.x.x` - IP cụ thể trong mạng LAN

### 5. Chạy ứng dụng

```bash
mvn spring-boot:run
```

Ứng dụng sẽ chạy trên port 8080 và có thể truy cập từ:

- **Local**: http://localhost:8080
- **Network**: http://YOUR_IP_ADDRESS:8080

## Swagger UI

Sau khi chạy ứng dụng, bạn có thể truy cập Swagger UI để xem và test API:

**Local Access:**

- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **API Docs JSON**: http://localhost:8080/v3/api-docs

**Network Access:** (từ máy khác trong cùng mạng)

- **Swagger UI**: http://YOUR_IP_ADDRESS:8080/swagger-ui.html
- **API Docs JSON**: http://YOUR_IP_ADDRESS:8080/v3/api-docs

**Lấy IP address của máy:**

- Windows: `ipconfig`
- Linux/Mac: `ifconfig` hoặc `ip addr`

Swagger UI cung cấp:

- Danh sách tất cả API endpoints
- Mô tả chi tiết cho từng API
- Khả năng test API trực tiếp trong browser
- Schema của request/response
- Authentication với JWT token

### Cách sử dụng JWT trong Swagger:

1. Đăng nhập qua API `/api/auth/login` để lấy token
2. Click nút "Authorize" ở góc trên bên phải Swagger UI
3. Nhập token vào ô "Value" (không cần thêm "Bearer ")
4. Click "Authorize" để áp dụng token cho tất cả API calls

### Error Messages (Thông báo lỗi):

Hệ thống cung cấp các thông báo lỗi chi tiết và thân thiện với người dùng:

#### Các loại lỗi chính:

- **400 - Bad Request**: Dữ liệu đầu vào không hợp lệ
- **401 - Unauthorized**: Thông tin đăng nhập không hợp lệ
- **403 - Forbidden**: Không có quyền truy cập
- **404 - Not Found**: Không tìm thấy resource
- **409 - Conflict**: Dữ liệu bị trung lập (email đã tồn tại)
- **500 - Internal Server Error**: Lỗi hệ thống nội bộ

#### Format Error Response:

```json
{
  "message": "Thông báo lỗi chính",
  "status": 409,
  "timestamp": "2025-09-26T10:30:00",
  "errors": {
    "email": "user@example.com",
    "suggestion": "Vui lòng sử dụng email khác hoặc đăng nhập nếu bạn đã có tài khoản"
  }
}
```

#### Demo Error APIs:

Bạn có thể test các loại error messages qua các endpoints:

- `GET /api/demo/error/email-exists` - Demo lỗi email đã tồn tại
- `GET /api/demo/error/user-not-found` - Demo lỗi user không tìm thấy
- `GET /api/demo/error/access-denied` - Demo lỗi không có quyền
- `GET /api/demo/error/validation` - Demo lỗi validation
- `GET /api/demo/error/internal` - Demo lỗi hệ thống

## API Endpoints

### Authentication

- `POST /api/auth/register` - Đăng ký tài khoản mới
- `POST /api/auth/login` - Đăng nhập

### User Management

- `GET /api/users/me` - Lấy thông tin user hiện tại
- `GET /api/users` - Lấy danh sách tất cả users (Admin only)
- `GET /api/users/{id}` - Lấy thông tin user theo ID
- `PUT /api/users/{id}` - Cập nhật thông tin user
- `DELETE /api/users/{id}` - Xóa user (Admin only)
- `PUT /api/users/{id}/activate` - Kích hoạt user (Admin only)
- `PUT /api/users/{id}/deactivate` - Vô hiệu hóa user (Admin only)

### User Address Management

- `GET /api/addresses` - Lấy tất cả địa chỉ của user
- `GET /api/addresses/default` - Lấy địa chỉ mặc định
- `GET /api/addresses/{addressId}` - Lấy địa chỉ theo ID
- `POST /api/addresses` - Tạo địa chỉ mới
- `PUT /api/addresses/{addressId}` - Cập nhật địa chỉ
- `PUT /api/addresses/{addressId}/set-default` - Đặt làm địa chỉ mặc định
- `DELETE /api/addresses/{addressId}` - Xóa địa chỉ
- `GET /api/addresses/count` - Đếm số lượng địa chỉ
- `GET /api/addresses/nearby` - Tìm địa chỉ gần vị trí (Admin only)

## Roles

### ADMIN

- Quản lý tất cả users
- Quản lý thông tin, chiến dịch, khuyến mãi

### CUSTOMER

- Xem thông tin quán ăn, món ăn
- Xem đường dẫn đến quán ăn
- Nhận gợi ý quán ăn trên tuyến đường
- Order và thanh toán đơn hàng
- Chọn giờ đến lấy món ăn

### RESTAURANT_OWNER

- Cung cấp địa chỉ, thông tin món ăn
- Nhận đơn từ khách hàng

## Ví dụ API

### Đăng ký

```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@example.com",
    "password": "password123",
    "fullName": "Administrator",
    "phoneNumber": "0123456789",
    "role": "ADMIN"
  }'
```

### Đăng nhập

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@example.com",
    "password": "password123"
  }'
```

### Lấy thông tin user hiện tại

```bash
curl -X GET http://localhost:8080/api/users/me \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## JWT Token

Sau khi đăng nhập thành công, bạn sẽ nhận được JWT token. Token này cần được gửi trong header `Authorization` với format `Bearer YOUR_TOKEN` cho các API yêu cầu authentication.

## Cấu trúc dự án

```
src/
├── main/
│   ├── java/
│   │   └── org/
│   │       └── example/
│   │           ├── Main.java
│   │           ├── config/
│   │           │   ├── JwtAuthenticationFilter.java
│   │           │   └── SecurityConfig.java
│   │           ├── controller/
│   │           │   ├── AuthController.java
│   │           │   └── UserController.java
│   │           ├── dto/
│   │           │   ├── AuthResponse.java
│   │           │   ├── LoginRequest.java
│   │           │   ├── RegisterRequest.java
│   │           │   ├── UpdateUserRequest.java
│   │           │   └── UserResponse.java
│   │           ├── entity/
│   │           │   ├── Role.java
│   │           │   └── User.java
│   │           ├── exception/
│   │           │   └── GlobalExceptionHandler.java
│   │           ├── repository/
│   │           │   └── UserRepository.java
│   │           ├── service/
│   │           │   ├── CustomUserDetailsService.java
│   │           │   └── UserService.java
│   │           └── util/
│   │               └── JwtUtil.java
│   └── resources/
│       └── application.properties
└── test/
```
#   U p d a t e d :   1 1 / 0 5 / 2 0 2 5   0 0 : 0 1 : 4 8  
 