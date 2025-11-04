# 🚀 HƯỚNG DẪN DEPLOY BACKEND LÊN RENDER.COM

## Bước 1: Chuẩn bị Repository

1. **Push code lên GitHub** (nếu chưa có):
```bash
git add .
git commit -m "Prepare for Render deployment"
git push origin main
```

## Bước 2: Tạo Web Service trên Render

1. **Truy cập**: https://render.com/
2. **Đăng nhập/Đăng ký** bằng tài khoản GitHub
3. **Tạo Web Service**:
   - Click **"New"** → **"Web Service"**
   - Connect GitHub repository: `PickMe`
   - **Root Directory**: `PickMeApplication`
   - **Runtime**: `Java`
   - **Build Command**: `mvn clean install -DskipTests`
   - **Start Command**: `java -Xmx512m -Dserver.port=$PORT -jar target/PickMeApplication-1.0-SNAPSHOT.jar --spring.profiles.active=prod`

## Bước 3: Cấu hình Environment Variables

Thêm các biến môi trường sau trong Render Dashboard:

### **🔐 Database (Neon.tech)**
```
DATABASE_URL=jdbc:postgresql://ep-solitary-thunder-ad72gnev-pooler.c-2.us-east-1.aws.neon.tech/pickmeapplication?sslmode=require&channel_binding=require
DB_USERNAME=neondb_owner
DB_PASSWORD=npg_7QKchdN0pnJX
```

### **🔑 JWT Security**
```
JWT_SECRET=mySecretKey12345678901234567890123456789012345678901234567890
JWT_EXPIRATION=86400000
```

### **📧 Email Configuration**
```
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-16-digit-app-password
```

### **💰 Payment (SePay)**
```
SEPAY_BANK_NAME=VPBank
SEPAY_ACCOUNT_NUMBER=0868767029
SEPAY_ACCOUNT_HOLDER=PICK ME APPLICATION
SEPAY_WEBHOOK_SECRET=your-webhook-secret
SEPAY_WEBHOOK_URL=https://your-backend-url.onrender.com/api/payments/sepay/webhook
```

### **🌐 CORS & App URLs**
```
CORS_ORIGINS=https://your-frontend.vercel.app,https://localhost:3000
APP_BASE_URL=https://your-backend-url.onrender.com
```

### **⚡ Performance**
```
SPRING_PROFILES_ACTIVE=prod
JAVA_OPTS=-Xmx512m -XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0
```

## Bước 4: Deploy

1. **Deploy**: Click **"Create Web Service"**
2. **Monitor**: Theo dõi build logs trong Render dashboard
3. **Test**: Kiểm tra health endpoint: `https://your-app.onrender.com/actuator/health`

## 🔍 Kiểm tra sau khi deploy

- ✅ **Health Check**: `/actuator/health`
- ✅ **API Documentation**: `/swagger-ui.html` (chỉ development)
- ✅ **Database Connection**: Kiểm tra logs không có lỗi kết nối
- ✅ **CORS**: Test từ frontend domain

## 📝 Lưu ý quan trọng

1. **Free Plan Render**: App sẽ sleep sau 15 phút không hoạt động
2. **Cold Start**: Lần đầu truy cập có thể mất 30-60 giây
3. **Database Pool**: Đã tối ưu cho free tier (max 3 connections)
4. **Memory**: Giới hạn 512MB RAM cho free plan

## 🛠️ Troubleshooting

### Lỗi thường gặp:
- **Build Failed**: Kiểm tra Java version (cần Java 17)
- **Database Connection**: Verify Neon.tech credentials
- **Memory Issues**: App restart do hết RAM → Upgrade plan
- **CORS Error**: Kiểm tra domain trong CORS_ORIGINS

### Logs:
- **Build Logs**: Trong Render Dashboard
- **Runtime Logs**: Click vào service → Logs tab