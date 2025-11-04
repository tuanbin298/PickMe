# 🚀 HƯỚNG DẪN DEPLOY FRONTEND LÊN VERCEL

## Bước 1: Chuẩn bị Repository

1. **Đảm bảo code đã được push lên GitHub**:

```bash
cd pickme_fe_web
git add .
git commit -m "Prepare frontend for Vercel deployment"
git push origin main
```

## Bước 2: Deploy trên Vercel

### **Option 1: Deploy qua Vercel Dashboard (Recommended)**

1. **Truy cập**: https://vercel.com/
2. **Đăng nhập** bằng tài khoản GitHub
3. **Import Project**:

   - Click **"Add New"** → **"Project"**
   - Select GitHub repository: `PickMe`
   - **Root Directory**: `pickme_fe_web`
   - **Framework Preset**: `Vite`
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`

4. **Environment Variables**:

   ```
   VITE_API_URL=https://your-backend-url.onrender.com/api
   ```

   _(Thay `your-backend-url` bằng URL thực của backend từ Render)_

5. **Deploy**: Click **"Deploy"**

### **Option 2: Deploy qua Vercel CLI**

1. **Install Vercel CLI**:

```bash
npm i -g vercel
```

2. **Login và Deploy**:

```bash
cd pickme_fe_web
vercel login
vercel --prod
```

## Bước 3: Cấu hình Domain (Optional)

1. **Custom Domain**: Trong Vercel Dashboard → Settings → Domains
2. **Thêm domain**: your-domain.com
3. **DNS Configuration**: Theo hướng dẫn của Vercel

## Bước 4: Cập nhật Backend CORS

Sau khi có URL Vercel, cập nhật CORS trong Render:

```
CORS_ORIGINS=https://your-frontend.vercel.app,https://your-custom-domain.com
```

## 🔍 Kiểm tra sau khi deploy

- ✅ **Frontend URL**: https://your-project.vercel.app
- ✅ **API Connection**: Test login/register functions
- ✅ **Responsive**: Kiểm tra trên mobile/desktop
- ✅ **Performance**: Lighthouse score

## 📝 Lưu ý quan trọng

1. **Environment Variables**: Phải bắt đầu với `VITE_` để Vite nhận diện
2. **Build Time**: Khoảng 1-3 phút cho free plan
3. **Auto Deploy**: Mỗi git push sẽ tự động trigger deploy
4. **Preview**: Mỗi pull request tạo preview deployment

## 🛠️ Troubleshooting

### Lỗi thường gặp:

1. **Build Failed**:

   - Kiểm tra `package.json` và dependencies
   - Xem build logs trong Vercel dashboard

2. **API Connection Failed**:

   - Verify `VITE_API_URL` environment variable
   - Check CORS settings in backend
   - Kiểm tra backend có running không

3. **404 on Refresh**:

   - Đã có `vercel.json` với routing config
   - Nếu vẫn lỗi, check routing trong React app

4. **Slow Loading**:
   - Enable Vercel Analytics
   - Optimize images và bundle size

### Useful Commands:

```bash
# Check deployment status
vercel ls

# View logs
vercel logs

# Remove deployment
vercel remove your-project-name
```
