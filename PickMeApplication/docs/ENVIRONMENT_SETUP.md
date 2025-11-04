# Environment Variables Setup

Dự án này sử dụng `spring.factories` để tự động load file `.env` khi application khởi động.

## Cách hoạt động

1. **EnvironmentLoader**: Class này implement `ApplicationListener<ApplicationEnvironmentPreparedEvent>` để load file `.env` trước khi Spring Boot khởi tạo context.

2. **spring.factories**: File này register `EnvironmentLoader` để Spring Boot tự động load khi application start.

3. **EnvUtil**: Utility class cung cấp các method tiện ích để truy cập environment variables.

4. **EnvironmentValidator**: Class để validate các environment variables cần thiết khi application ready.

## Cấu trúc files

```
src/main/
├── java/org/example/
│   ├── config/
│   │   ├── EnvironmentLoader.java      # Load .env file
│   │   └── EnvironmentValidator.java   # Validate env variables
│   └── util/
│       └── EnvUtil.java               # Utility để access env variables
└── resources/
    └── META-INF/
        └── spring.factories           # Register EnvironmentLoader
.env                                   # Environment variables (KHÔNG commit)
.env.example                          # Template file (có thể commit)
```

## Cách sử dụng

### 1. Tạo file .env

Copy từ `.env.example` và cập nhật các giá trị:

```bash
cp .env.example .env
```

### 2. Cập nhật giá trị trong .env

```properties
# Database Configuration
DB_PASSWORD=your_real_password

# JWT Configuration
JWT_SECRET=your_32_character_secret_key_here
JWT_EXPIRATION=86400000

# Email Configuration
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_FROM=your-email@gmail.com

# Application Configuration
APP_BASE_URL=http://localhost:8080
APP_ENV=development

# Server Configuration
SERVER_PORT=8080
```

### 3. Sử dụng trong code

#### Cách 1: Sử dụng EnvUtil (Khuyến nghị)

```java
@Autowired
private EnvUtil envUtil;

public void someMethod() {
    String dbPassword = envUtil.getDatabasePassword();
    String jwtSecret = envUtil.getJwtSecret();
    Long jwtExpiration = envUtil.getJwtExpiration();
    boolean isDev = envUtil.isDevelopment();
}
```

#### Cách 2: Sử dụng @Value annotation

```java
@Value("${DB_PASSWORD}")
private String dbPassword;

@Value("${JWT_SECRET}")
private String jwtSecret;

@Value("${JWT_EXPIRATION:86400000}")
private Long jwtExpiration;
```

#### Cách 3: Sử dụng Environment

```java
@Autowired
private Environment environment;

public void someMethod() {
    String dbPassword = environment.getProperty("DB_PASSWORD");
    String jwtSecret = environment.getProperty("JWT_SECRET");
}
```

## Thứ tự load

EnvironmentLoader sẽ tìm file `.env` theo thứ tự:

1. `.env` (thư mục gốc project)
2. `config/.env` (thư mục config)
3. `{working-directory}/.env`
4. `{user-home}/.env`
5. Classpath resources

## Validation

Application sẽ tự động validate các environment variables khi khởi động:

- **DB_PASSWORD**: Bắt buộc phải có
- **JWT_SECRET**: Bắt buộc, ít nhất 32 ký tự
- **MAIL_USERNAME**: Bắt buộc, phải đúng format email
- **MAIL_PASSWORD**: Bắt buộc phải có
- **SERVER_PORT**: Phải trong khoảng 1-65535

## Lưu ý bảo mật

1. **KHÔNG BAO GIỜ** commit file `.env` vào git
2. File `.env.example` chỉ chứa template, không chứa giá trị thật
3. Sử dụng strong JWT secret (ít nhất 32 ký tự)
4. Sử dụng App Password cho Gmail, không dùng password thường

## Troubleshooting

### Lỗi: Environment variable not found

```
Missing required environment variable: DB_PASSWORD
```

**Giải pháp**: Kiểm tra file `.env` có tồn tại và chứa biến đó không.

### Lỗi: JWT secret too short

```
JWT_SECRET must be at least 32 characters long
```

**Giải pháp**: Tăng độ dài của JWT_SECRET trong file `.env`.

### Lỗi: Invalid email format

```
MAIL_USERNAME is not a valid email format
```

**Giải pháp**: Kiểm tra format email trong MAIL_USERNAME.

## Environment cho các môi trường khác nhau

### Development

```properties
APP_ENV=development
APP_BASE_URL=http://localhost:8080
```

### Production

```properties
APP_ENV=production
APP_BASE_URL=https://your-domain.com
```

### Testing

```properties
APP_ENV=testing
APP_BASE_URL=http://localhost:8080
```
