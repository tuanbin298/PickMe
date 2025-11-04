# 🎯 RENDER.COM DEPLOYMENT CHECKLIST

## Bước 1: Tạo Web Service

### 1.1 Truy cập Render Dashboard

- URL: https://render.com/
- Login bằng GitHub account
- Click "New" → "Web Service"

### 1.2 Connect Repository

- Select "tuanbin298/PickMe" repository
- Branch: "minhanh"
- **Root Directory**: `PickMeApplication`
- Click "Continue"

### 1.3 Service Configuration

```
Service Name: pickme-backend
Runtime: Java
Build Command: mvn clean install -DskipTests
Start Command: java -Xmx512m -Dserver.port=$PORT -jar target/PickMeApplication-1.0-SNAPSHOT.jar --spring.profiles.active=prod
Plan: Free
```

### 1.4 Advanced Settings

```
Auto Deploy: Yes
Health Check Path: /actuator/health
```

## Bước 2: Environment Variables

**Cần thêm các biến sau vào Render Dashboard:**

### Database Configuration

```
DATABASE_URL=jdbc:postgresql://ep-solitary-thunder-ad72gnev-pooler.c-2.us-east-1.aws.neon.tech/pickmeapplication?sslmode=require&channel_binding=require
DB_USERNAME=neondb_owner
DB_PASSWORD=npg_7QKchdN0pnJX
```

### Application Settings

```
SPRING_PROFILES_ACTIVE=prod
JWT_SECRET=pickme_jwt_secret_key_2024_production_super_secure_long_string_123456789
JWT_EXPIRATION=86400000
```

### Email Configuration

```
MAIL_USERNAME=[YOUR_GMAIL_ADDRESS]
MAIL_PASSWORD=[YOUR_GMAIL_APP_PASSWORD]
```

### Payment Configuration

```
SEPAY_BANK_NAME=VPBank
SEPAY_ACCOUNT_NUMBER=0868767029
SEPAY_ACCOUNT_HOLDER=PICK ME APPLICATION
SEPAY_WEBHOOK_SECRET=sepay_webhook_secret_2024
```

### CORS (Will be updated after frontend deployment)

```
CORS_ORIGINS=https://localhost:3000
```

## Bước 3: Deploy

1. **Click "Create Web Service"**
2. **Monitor Build Logs**: Theo dõi quá trình build (5-10 phút)
3. **Check Deploy Status**: Đợi status chuyển thành "Live"

## Bước 4: Test Deployment

### Health Check

- URL: `https://[your-service-name].onrender.com/actuator/health`
- Expected Response: `{"status":"UP"}`

### API Endpoints

- Swagger (Dev only): `https://[your-service-name].onrender.com/swagger-ui.html`
- Auth Test: `POST https://[your-service-name].onrender.com/api/auth/register`

## 📝 Notes

- **Build Time**: ~5-10 minutes for first deployment
- **Cold Start**: App sleeps after 15 minutes idle (free plan)
- **Wake Up Time**: 30-60 seconds for first request
- **Logs**: Available in Render dashboard

## ⚠️ Troubleshooting

### Common Issues:

1. **Build Failed**: Check Java version, Maven dependencies
2. **Health Check Failed**: Verify `/actuator/health` endpoint
3. **Database Connection**: Check Neon.tech credentials
4. **Memory Issues**: App restart due to 512MB limit

### Solutions:

- Check build logs in Render dashboard
- Verify environment variables
- Test database connection locally
- Monitor memory usage
