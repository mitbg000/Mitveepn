# Hướng dẫn Setup - Mitveepn Client

## 🎯 Config đã được tạo sẵn!

Tôi đã tạo cả 2 files config cho Mitveepn với 5 servers của bạn:

### ✅ Files đã tạo:

1. **[config.json](../../config.json)** - Backend URLs configuration
   - ✅ 5 panel servers (api, cnxt1, cxt2, home, mail)
   - ✅ Online support với Crisp integration
   - ✅ Update servers
   - ✅ Subscription servers
   - ✅ WebSocket servers

2. **[xboard.config.yaml](xboard.config.yaml)** - Client configuration
   - ✅ Provider: `mitveepn`
   - ✅ Domain racing enabled
   - ✅ Vietnamese language default
   - ✅ Crisp customer support ID configured

---

## 🚀 Next Steps (3 bước đơn giản)

### Bước 1: Upload config.json

Upload file `config.json` lên một trong các nơi sau:

**Option A: GitHub (Khuyến nghị)**
```bash
# 1. Tạo repo mới trên GitHub (private hoặc public)
# 2. Upload config.json vào repo
# 3. Lấy raw URL

# Ví dụ URL:
https://raw.githubusercontent.com/YOUR_USERNAME/mitveepn-config/main/config.json
```

**Option B: Gitee (Tốt cho người dùng Trung Quốc)**
```bash
# Tương tự GitHub
# URL example:
https://gitee.com/YOUR_USERNAME/mitveepn-config/raw/main/config.json
```

**Option C: CDN/Server riêng**
```bash
# Upload lên server của bạn
https://cdn.mitveepn.com/config.json
```

### Bước 2: Cập nhật URL trong xboard.config.yaml

Mở file [`assets/config/xboard.config.yaml`](xboard.config.yaml) và thay dòng:

```yaml
# TÌM dòng này (line 14):
url: https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/config.json

# THAY BẰNG URL thực tế của bạn:
url: https://raw.githubusercontent.com/mitveepn/config/main/config.json
```

### Bước 3: Generate SDK Code và Test

```bash
# Generate SDK code (BẮT BUỘC)
cd lib/sdk/flutter_xboard_sdk
flutter pub get
dart run build_runner build --delete-conflicting-outputs
cd ../../..

# Install dependencies
flutter pub get

# Test app
flutter run
```

---

## 📋 Cấu hình Mitveepn

### Backend Servers (đã config sẵn)

| Server | URL | Priority | Mô tả |
|--------|-----|----------|-------|
| **Main** | `api.mitveepn.com` | 100 | Server chính |
| **CNXT1** | `cnxt1.mitveepn.com` | 90 | China Telecom 1 |
| **CXT2** | `cxt2.mitveepn.com` | 90 | China Telecom 2 |
| **Home** | `home.mitveepn.com` | 85 | Home server |
| **Mail** | `mail.mitveepn.com` | 85 | Mail server |

Client sẽ tự động **domain racing** - chọn server nhanh nhất!

### Features đã enable:

- ✅ **Domain Racing** - Tự động chọn server nhanh nhất
- ✅ **Multi-server Failover** - Chuyển đổi tự động khi server fail
- ✅ **Crisp Customer Support** - Chat support trong app
- ✅ **Auto Update** - Kiểm tra update tự động (24h/lần)
- ✅ **Vietnamese Language** - Ngôn ngữ mặc định tiếng Việt
- ✅ **SSL Verification** - Bảo mật HTTPS

---

## 🎨 Customization (Tuỳ chọn)

### Thay đổi tên app

**Android** - `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="Mitveepn"
    ...>
```

**pubspec.yaml**:
```yaml
name: mitveepn_client
description: Mitveepn VPN Client
```

### Thay đổi App ID

**Android** - `android/app/build.gradle`:
```gradle
defaultConfig {
    applicationId "com.mitveepn.vpn"
    ...
}
```

### Thay icon

Đặt icon mới vào `assets/images/logo.png` hoặc dùng `flutter_launcher_icons`:

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.0

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/app_icon.png"
```

Chạy: `dart run flutter_launcher_icons`

---

## 🔧 Cấu hình nâng cao (nếu cần)

### Encrypted Subscription

Nếu backend Xboard của bạn có enable encrypted subscription:

1. Lấy `decrypt_key` từ admin backend
2. Cập nhật trong `xboard.config.yaml`:

```yaml
security:
  decrypt_key: "your-32-character-key-from-backend"
subscription:
  prefer_encrypt: true
```

### Response Obfuscation

Nếu backend dùng Caddy để obfuscate responses:

```yaml
security:
  obfuscation_prefix: "YOUR_OBFS_PREFIX_"
```

### Custom User-Agent Authentication

Nếu backend yêu cầu authentication qua User-Agent:

```yaml
security:
  user_agents:
    api_encrypted: "Mozilla/5.0 (compatible; YOUR_SECRET_TOKEN)"
```

---

## 🏗️ Build App

### Android APK
```bash
dart setup.dart android
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Windows
```bash
dart setup.dart windows --arch amd64
# Output: build/windows/runner/Release/
```

### macOS
```bash
dart setup.dart macos --arch arm64  # M1/M2/M3
# hoặc
dart setup.dart macos --arch amd64  # Intel
# Output: build/macos/Build/Products/Release/
```

### Linux
```bash
dart setup.dart linux --arch amd64
# Output: build/linux/x64/release/bundle/
```

---

## 🧪 Testing Flow

### 1. Test Domain Racing

Khi app khởi động, nó sẽ:
```
1. Đọc xboard.config.yaml
2. Fetch config.json từ remote URL
3. Domain racing: Test cả 5 servers
   - api.mitveepn.com
   - cnxt1.mitveepn.com
   - cxt2.mitveepn.com
   - home.mitveepn.com
   - mail.mitveepn.com
4. Chọn server nhanh nhất
5. Kết nối tới server đó
```

### 2. Test Authentication

```
1. Mở app
2. Nhập email/password
3. Login
4. Verify token được save
5. Check user info hiển thị đúng
```

### 3. Test Subscription

```
1. Sau khi login
2. Lấy subscription URL
3. Download proxy config
4. Kết nối proxy
5. Test internet connection
```

---

## 📊 Monitoring & Logs

Enable debug logs để xem chi tiết:

```yaml
# xboard.config.yaml
log:
  enabled: true
  level: debug  # Thay vì info

sdk:
  enable_debug_log: true
```

Xem logs:
```bash
flutter run
# hoặc
flutter logs
```

---

## 🐛 Troubleshooting

### Issue: "Cannot connect to backend"

**Check:**
1. Backend servers có đang chạy không?
   - Test: `curl https://api.mitveepn.com/api/v1/guest/comm/config`
2. `config.json` URL có đúng không?
3. `provider: mitveepn` có khớp với `panels.mitveepn` không?

**Fix:**
```yaml
# xboard.config.yaml
log:
  level: debug  # Enable debug logs
```

### Issue: "SDK generation failed"

**Fix:**
```bash
cd lib/sdk/flutter_xboard_sdk
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
cd ../../..
flutter pub get
```

### Issue: "Domain racing timeout"

**Fix:** Tăng timeout trong config:
```yaml
domain_service:
  test_timeout_seconds: 10  # Tăng từ 5 lên 10
  max_concurrent_tests: 3    # Giảm từ 5 xuống 3
```

---

## 📱 Distribution

### Android - Signing

1. Generate keystore:
```bash
keytool -genkey -v -keystore ~/mitveepn.jks -keyalg RSA -keysize 2048 -validity 10000 -alias mitveepn
```

2. Configure `android/key.properties`:
```properties
storePassword=yourPassword
keyPassword=yourPassword
keyAlias=mitveepn
storeFile=/path/to/mitveepn.jks
```

3. Build signed APK:
```bash
dart setup.dart android
```

### Publishing

- **Google Play**: Upload APK/AAB qua Play Console
- **App Store**: Upload IPA qua App Store Connect
- **Direct Download**: Host APK trên server/GitHub Releases

---

## 📈 Update Strategy

Để update app, bạn có 2 options:

### Option 1: Update config.json (không cần rebuild app)

- Thêm/xoá servers
- Thay đổi URLs
- Update settings

→ User chỉ cần restart app!

### Option 2: Update app binary (cần rebuild)

- UI changes
- New features
- Bug fixes

→ User cần download bản mới

---

## ✅ Checklist

- [x] `config.json` created với 5 Mitveepn servers
- [x] `xboard.config.yaml` configured
- [ ] Upload `config.json` lên hosting
- [ ] Update remote URL trong `xboard.config.yaml`
- [ ] Generate SDK code
- [ ] Test app với `flutter run`
- [ ] Customize branding (name, icon)
- [ ] Build production app
- [ ] Test signed build
- [ ] Distribute to users

---

## 🔗 Your Servers

Đây là các servers bạn có:

```
✅ api.mitveepn.com      (Main)
✅ cnxt1.mitveepn.com    (China Telecom 1)
✅ cxt2.mitveepn.com     (China Telecom 2)
✅ home.mitveepn.com     (Home)
✅ mail.mitveepn.com     (Mail)
```

Client sẽ tự động chọn server nhanh nhất cho từng user!

---

## 🆘 Need Help?

- 📖 [CUSTOMIZATION_GUIDE.md](../../CUSTOMIZATION_GUIDE.md) - Chi tiết đầy đủ
- 📚 [DOCS_INDEX.md](../../DOCS_INDEX.md) - Navigation
- 🐛 Issues? Enable debug logs và check Flutter logs

---

**Ready to test?** Run: `flutter run` 🚀
