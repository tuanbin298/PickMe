# Hướng dẫn Bảo mật - PickMe Application

## 🔐 Environment Variables Security

### Files và Variables cần bảo vệ:

**❌ KHÔNG BAO GIỜ COMMIT:**
- `.env` - Chứa thông tin production
- `.env.local` - Thông tin local development
- `.env.production` - Thông tin production
- `application-prod.properties` - Config production
- Bất kỳ file nào chứa passwords, API keys, secrets

**✅ AN TOÀN ĐỂ COMMIT:**
- `.env.example` - Template không chứa dữ liệu thật
- `application.properties` - Chỉ chứa placeholders với default values

### Cấu hình Variables:

#### 1. Database Credentials
```properties
# ✅ GOOD - Sử dụng environment variables
DB_USERNAME=${DB_USERNAME:root}
DB_PASSWORD=${DB_PASSWORD:default_password}

# ❌ BAD - Hard-coded credentials
DB_USERNAME=root
DB_PASSWORD=my_secret_password
```

#### 2. JWT Secret
```properties
# ✅ GOOD - Strong, unique secret from environment
JWT_SECRET=${JWT_SECRET:fallback-key-only-for-dev}

# ❌ BAD - Weak or exposed secret
JWT_SECRET=secret123
```

#### 3. Email Credentials
```properties
# ✅ GOOD - App-specific password từ environment
MAIL_PASSWORD=${MAIL_PASSWORD:app-specific-password}

# ❌ BAD - Gmail password trực tiếp
MAIL_PASSWORD=my_gmail_password
```

## 🚀 Deployment Security

### Development Environment:
1. Sử dụng file `.env` cho local development
2. Không commit `.env` file
3. Sử dụng weak credentials cho development database

### Production Environment:
1. **Server Environment Variables**: Set trực tiếp trên server
```bash
export DB_PASSWORD="strong_production_password"
export JWT_SECRET="very-strong-jwt-secret-64-characters-minimum-for-production"
export MAIL_PASSWORD="production-app-password"
```

2. **Docker**: Sử dụng secrets hoặc environment files
```dockerfile
# docker-compose.yml
environment:
  - DB_PASSWORD_FILE=/run/secrets/db_password
  - JWT_SECRET_FILE=/run/secrets/jwt_secret
```

3. **Cloud Platforms**:
   - **AWS**: SSM Parameter Store, Secrets Manager
   - **Azure**: Key Vault
   - **Google Cloud**: Secret Manager
   - **Heroku**: Config Vars

## 🔑 JWT Security Best Practices

### 1. Secret Key Requirements:
- **Minimum 32 characters** (256 bits)
- **Random generation** using cryptographically secure methods
- **Unique per environment** (dev, staging, prod)

### 2. Generate Strong JWT Secret:
```bash
# Linux/Mac
openssl rand -base64 32

# Windows PowerShell
[System.Web.Security.Membership]::GeneratePassword(32, 4)

# Online (development only)
# https://generate-secret.vercel.app/32
```

### 3. Token Expiration:
```properties
# Short-lived tokens for production
JWT_EXPIRATION=3600000  # 1 hour

# Longer for development
JWT_EXPIRATION=86400000  # 24 hours
```

## 📧 Email Security

### 1. Gmail App Passwords:
- **Never use main Gmail password**
- **Enable 2FA** trước khi tạo App Password
- **Revoke unused** App Passwords thường xuyên

### 2. SMTP Security:
```properties
# Luôn sử dụng TLS/SSL
spring.mail.properties.mail.smtp.starttls.enable=true
spring.mail.properties.mail.smtp.starttls.required=true
spring.mail.properties.mail.smtp.ssl.trust=smtp.gmail.com
```

## 🗄️ Database Security

### 1. Connection Security:
```properties
# SSL cho production
spring.datasource.url=jdbc:mysql://localhost:3306/db?useSSL=true&requireSSL=true

# Development có thể tắt SSL
spring.datasource.url=jdbc:mysql://localhost:3306/db?useSSL=false
```

### 2. User Privileges:
```sql
-- Tạo user riêng cho application, không dùng root
CREATE USER 'pickme_app'@'localhost' IDENTIFIED BY 'strong_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON pickmeapplication.* TO 'pickme_app'@'localhost';
FLUSH PRIVILEGES;
```

## 🔍 Security Checklist

### Before Deployment:
- [ ] Kiểm tra `.gitignore` chứa `.env`
- [ ] Verify không có secrets trong Git history
- [ ] Strong JWT secret (>32 characters)
- [ ] Database user có privileges tối thiểu
- [ ] Email App Password được tạo đúng cách
- [ ] HTTPS enabled cho production
- [ ] Rate limiting enabled
- [ ] Input validation đầy đủ

### Regular Security Maintenance:
- [ ] Rotate JWT secrets định kỳ (3-6 tháng)
- [ ] Update dependencies thường xuyên
- [ ] Monitor failed login attempts
- [ ] Review access logs
- [ ] Backup và test restore procedures

## 🚨 Security Incident Response

### Nếu secrets bị lộ:
1. **Immediately**: Revoke compromised credentials
2. **Generate new**: JWT secrets, database passwords, API keys
3. **Update**: All environments với credentials mới
4. **Invalidate**: All existing JWT tokens (force re-login)
5. **Investigate**: Logs để xem mức độ breach
6. **Document**: Incident và lessons learned

### Emergency Contacts:
- Database Admin: [contact info]
- DevOps Team: [contact info]
- Security Team: [contact info]

## 📚 Additional Resources

- [Spring Security Documentation](https://spring.io/projects/spring-security)
- [JWT Security Best Practices](https://auth0.com/blog/a-look-at-the-latest-draft-for-jwt-bcp/)
- [OWASP Application Security](https://owasp.org/www-project-application-security-verification-standard/)
- [Spring Boot Security Guide](https://spring.io/guides/gs/securing-web/)