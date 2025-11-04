# 🚀 KẾ HOẠCH TRIỂN KHAI TỔNG THỂ - PICKME SYSTEM

## 📊 TỔNG QUAN HỆ THỐNG

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │   React Web     │    │  Spring Boot    │
│   (APK Build)   │◄──►│   (Vercel)      │◄──►│   (Render)      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                                       ▼
                                              ┌─────────────────┐
                                              │  PostgreSQL     │
                                              │  (Neon.tech)    │
                                              └─────────────────┘
```

## 🎯 THỨ TỰ TRIỂN KHAI

### **Phase 1: Database Setup** ✅ (Đã hoàn thành)

- [x] Neon.tech PostgreSQL configured
- [x] Connection string available
- [x] PostGIS extension enabled

### **Phase 2: Backend Deployment** 🔄 (Tiếp theo)

**Platform:** Render.com  
**Timeline:** 15-30 minutes  
**Status:** Ready to deploy

**Checklist:**

- [ ] Push code to GitHub
- [ ] Create Render Web Service
- [ ] Configure environment variables
- [ ] Deploy và test health endpoint
- [ ] Verify API endpoints working

### **Phase 3: Frontend Web Deployment** 🔄 (Sau Backend)

**Platform:** Vercel  
**Timeline:** 10-15 minutes  
**Dependencies:** Backend URL từ Phase 2

**Checklist:**

- [ ] Update API URL từ Render
- [ ] Deploy to Vercel
- [ ] Configure environment variables
- [ ] Update CORS trong backend
- [ ] Test full web application

### **Phase 4: Mobile App Build** 🔄 (Song song với Phase 3)

**Platform:** Local build → APK distribution  
**Timeline:** 20-30 minutes  
**Dependencies:** Backend URL từ Phase 2

**Checklist:**

- [ ] Update API URL trong Flutter app
- [ ] Setup Android keystore
- [ ] Build release APK
- [ ] Test installation và functionality
- [ ] Prepare distribution method

## 🔧 CHI TIẾT TRIỂN KHAI

### **1. Backend (Spring Boot → Render.com)**

**Chuẩn bị:**

- ✅ `render.yaml` configured
- ✅ `application-prod.properties` ready
- ✅ Health check endpoint added
- ✅ Deployment guide created

**Environment Variables cần thiết:**

```bash
DATABASE_URL=jdbc:postgresql://ep-solitary-thunder-ad72gnev-pooler.c-2.us-east-1.aws.neon.tech/pickmeapplication?sslmode=require&channel_binding=require
DB_USERNAME=neondb_owner
DB_PASSWORD=npg_7QKchdN0pnJX
JWT_SECRET=mySecretKey12345678901234567890123456789012345678901234567890
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
SEPAY_ACCOUNT_NUMBER=0868767029
SEPAY_WEBHOOK_URL=https://your-backend.onrender.com/api/payments/sepay/webhook
CORS_ORIGINS=https://your-frontend.vercel.app
```

**Deployment Steps:**

1. Push code to GitHub
2. Connect repository in Render
3. Set root directory: `PickMeApplication`
4. Configure environment variables
5. Deploy và monitor logs

### **2. Frontend Web (React → Vercel)**

**Chuẩn bị:**

- ✅ `vercel.json` configured
- ✅ Environment variables setup
- ✅ Build script updated
- ✅ Deployment guide created

**Deployment Steps:**

1. Update `VITE_API_URL` với backend URL
2. Connect GitHub repo in Vercel
3. Set root directory: `pickme_fe_web`
4. Configure environment variables
5. Deploy và test

### **3. Mobile App (Flutter → APK)**

**Chuẩn bị:**

- ✅ `.env` file for API URL
- ✅ Android build configuration
- ✅ Build guide created
- 🔄 Keystore setup needed

**Build Steps:**

1. Update API URL với backend production
2. Setup Android keystore
3. Build release APK
4. Test installation
5. Setup distribution method

## 📝 ENVIRONMENT VARIABLES SUMMARY

### **Backend (Render)**

```bash
DATABASE_URL=<neon-connection-string>
DB_USERNAME=neondb_owner
DB_PASSWORD=npg_7QKchdN0pnJX
JWT_SECRET=<strong-jwt-secret>
SPRING_PROFILES_ACTIVE=prod
MAIL_USERNAME=<your-gmail>
MAIL_PASSWORD=<gmail-app-password>
CORS_ORIGINS=<vercel-frontend-url>
SEPAY_ACCOUNT_NUMBER=0868767029
SEPAY_WEBHOOK_URL=<render-backend-url>/api/payments/sepay/webhook
```

### **Frontend Web (Vercel)**

```bash
VITE_API_URL=<render-backend-url>/api
```

### **Mobile App (.env)**

```bash
API_BASE_URL=<render-backend-url>/api
```

## 🔍 TESTING CHECKLIST

### **Backend API Tests:**

- [ ] Health check: `/actuator/health`
- [ ] Auth endpoints: `/api/auth/login`, `/api/auth/register`
- [ ] User endpoints: `/api/users/**`
- [ ] Merchant endpoints: `/api/merchants/**`
- [ ] Payment endpoints: `/api/payments/**`

### **Frontend Web Tests:**

- [ ] Landing page loads
- [ ] Authentication flow
- [ ] User dashboard
- [ ] Merchant dashboard
- [ ] Order placement
- [ ] Payment integration

### **Mobile App Tests:**

- [ ] App launches successfully
- [ ] API connectivity
- [ ] Authentication works
- [ ] Map functionality
- [ ] Image upload
- [ ] Push notifications

## 🛠️ MONITORING & MAINTENANCE

### **Backend (Render)**

- **Logs:** Render Dashboard → Service → Logs
- **Metrics:** Response time, error rate
- **Alerts:** Setup via Render notifications
- **Free Tier Limits:** 512MB RAM, sleeps after 15min idle

### **Frontend (Vercel)**

- **Analytics:** Vercel Analytics (optional)
- **Performance:** Lighthouse scores
- **Deployment:** Auto-deploy on git push
- **Limits:** 100GB bandwidth/month (free)

### **Mobile App**

- **Distribution:** Direct APK download
- **Updates:** Manual APK replacement
- **Analytics:** Consider Firebase Analytics
- **Crash Reporting:** Consider Crashlytics

## 🚨 EMERGENCY PROCEDURES

### **Backend Down:**

1. Check Render service status
2. Review application logs
3. Verify database connectivity
4. Check environment variables
5. Restart service if needed

### **Frontend Issues:**

1. Check Vercel deployment status
2. Verify API connectivity
3. Check browser console errors
4. Rollback to previous deployment

### **Mobile App Issues:**

1. Check API connectivity
2. Verify app permissions
3. Re-build and distribute new APK
4. Check device compatibility

## 📞 SUPPORT & DOCUMENTATION

- **Backend Deployment:** `RENDER_DEPLOYMENT_GUIDE.md`
- **Frontend Deployment:** `VERCEL_DEPLOYMENT_GUIDE.md`
- **Mobile App Build:** `FLUTTER_APK_BUILD_GUIDE.md`
- **API Documentation:** Available at backend `/swagger-ui.html` (dev only)
- **Database Schema:** Check migration files in `src/main/resources/`
