# 📱 HƯỚNG DẪN BUILD FLUTTER APK

## Bước 1: Chuẩn bị Environment

### **1.1 Kiểm tra Flutter SDK**
```powershell
flutter --version
flutter doctor
```

### **1.2 Cập nhật API URL**
Chỉnh sửa file `.env` với URL backend production:
```
API_BASE_URL=https://your-backend-url.onrender.com/api
```

## Bước 2: Tạo Keystore cho Release Build

### **2.1 Tạo Keystore (One-time setup)**
```powershell
cd pickme_fe_app\android
keytool -genkey -v -keystore app-release-key.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias pickme
```

**Thông tin cần nhập:**
- Password: `[Tạo password mạnh]`
- Name: `PickMe App`
- Organization: `Your Company`
- Country: `VN`

### **2.2 Cấu hình Key Properties**
Tạo file `android/key.properties`:
```properties
storePassword=your-keystore-password
keyPassword=your-key-password
keyAlias=pickme
storeFile=app-release-key.keystore
```

### **2.3 Cập nhật build.gradle.kts**
Thêm vào `android/app/build.gradle.kts`:

```kotlin
// Trước android block
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing code ...
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

## Bước 3: Build APK

### **3.1 Clean và Get Dependencies**
```powershell
cd pickme_fe_app
flutter clean
flutter pub get
```

### **3.2 Build Release APK**
```powershell
flutter build apk --release
```

### **3.3 Build App Bundle (For Google Play Store)**
```powershell
flutter build appbundle --release
```

### **3.4 Build Split APKs (Smaller file size)**
```powershell
flutter build apk --split-per-abi --release
```

## Bước 4: Locate Build Files

Sau khi build thành công, files sẽ ở:

### **APK Files:**
- **Universal APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **Split APKs**: 
  - `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (64-bit ARM)
  - `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` (32-bit ARM)
  - `build/app/outputs/flutter-apk/app-x86_64-release.apk` (64-bit Intel)

### **App Bundle:**
- `build/app/outputs/bundle/release/app-release.aab`

## Bước 5: Test APK

### **5.1 Install trên Device**
```powershell
# Via ADB
adb install build/app/outputs/flutter-apk/app-release.apk

# Or copy APK file to device and install manually
```

### **5.2 Kiểm tra Functionality**
- ✅ App launch và UI hiển thị đúng
- ✅ API calls hoạt động (login/register)
- ✅ Map và location services
- ✅ Camera và image picker
- ✅ Payment flows

## 🎯 Distribution Options

### **Option 1: Direct APK Distribution**
- Share APK file qua email, Google Drive, etc.
- Users enable "Install from Unknown Sources"
- Install APK manually

### **Option 2: Google Play Store**
- Upload `app-release.aab` to Play Console
- Follow Play Store review process
- Public/Internal testing tracks

### **Option 3: Firebase App Distribution**
- Upload APK to Firebase
- Invite testers via email
- Automatic updates

## 📊 APK Size Optimization

### **Current build sizes:**
- Universal APK: ~15-30MB
- ARM64 APK: ~8-15MB  
- ARM32 APK: ~8-15MB

### **To reduce size:**
```powershell
# Remove debug info
flutter build apk --release --split-debug-info=symbols

# Obfuscate code
flutter build apk --release --obfuscate --split-debug-info=symbols

# Use split APKs
flutter build apk --split-per-abi --release
```

## 🛠️ Troubleshooting

### **Common Issues:**

1. **Keystore not found:**
   - Ensure `key.properties` path is correct
   - Check keystore file location

2. **Build fails:**
   - Run `flutter clean`
   - Update Flutter: `flutter upgrade`
   - Check `android/local.properties` for SDK path

3. **Large APK size:**
   - Use `--split-per-abi`
   - Remove unused assets
   - Optimize images

4. **API not working in release:**
   - Check `.env` file is included in `pubspec.yaml`
   - Verify network permissions in `AndroidManifest.xml`
   - Test with actual backend URL

### **Useful Commands:**
```powershell
# Check APK details
flutter build apk --analyze-size

# Build with verbose output
flutter build apk --release -v

# Check what's in the APK
flutter build apk --release --analyze-size
```