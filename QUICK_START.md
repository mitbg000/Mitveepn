# Quick Start Guide - Xboard Mihomo Client

## 🚀 Bắt đầu nhanh (5 phút)

### Bước 1: Chạy script setup tự động

```bash
cd xboard-mihomo-client
chmod +x setup_custom.sh
./setup_custom.sh
```

Script sẽ tự động:
- ✅ Initialize git submodules
- ✅ Generate XBoard SDK code
- ✅ Install dependencies
- ✅ Tạo config files từ templates

### Bước 2: Cấu hình Backend

#### 2.1. Chỉnh sửa `config.json`

```json
{
    "panels": {
        "mitveepn": [
            {
                "url": "https://your-xboard-backend.com",
                "description": "Main Panel"
            }
        ]
    },
    "onlineSupport": [
        {
            "url": "https://support.your-domain.com",
            "description": "Customer Support",
            "apiBaseUrl": "https://support.your-domain.com",
            "wsBaseUrl": "wss://support.your-domain.com"
        }
    ]
}
```

Thay `https://your-xboard-backend.com` bằng URL backend XBoard thực tế của bạn.

#### 2.2. Upload `config.json` lên hosting

**Option 1: GitHub**
```bash
# Tạo repo mới trên GitHub
# Upload config.json vào repo
# Lấy raw URL: https://raw.githubusercontent.com/username/repo/main/config.json
```

**Option 2: Server riêng**
```bash
# Upload lên server của bạn
# URL: https://your-cdn.com/config.json
```

#### 2.3. Cấu hình `assets/config/xboard.config.yaml`

```yaml
xboard:
  provider: mitveepn  # Phải khớp với key trong config.json
  
  remote_config:
    sources:
      - name: main_source
        url: https://raw.githubusercontent.com/username/repo/main/config.json
        priority: 100
  
  app:
    title: MitveeVPN
    website: mitveepn.com
```

Thay URL trong `remote_config.sources[0].url` bằng URL đã upload ở bước 2.2.

### Bước 3: Customize Branding (Optional)

#### Thay đổi tên app

**Android** - `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="MitveeVPN"
```

**pubspec.yaml**:
```yaml
name: mitveevpn_client
```

#### Thay đổi App ID

**Android** - `android/app/build.gradle`:
```gradle
applicationId "com.mitveepn.vpn"
```

### Bước 4: Build App

#### Android
```bash
dart setup.dart android
# Output: build/app/outputs/flutter-apk/app-release.apk
```

#### Windows
```bash
dart setup.dart windows --arch amd64
```

#### macOS
```bash
dart setup.dart macos --arch arm64  # M1/M2
# hoặc
dart setup.dart macos --arch amd64  # Intel
```

#### Development mode (test nhanh)
```bash
flutter devices  # Xem danh sách devices
flutter run      # Chạy trên device mặc định
```

---

## 🔧 Manual Setup (nếu script không chạy được)

### 1. Initialize submodules
```bash
git submodule update --init --recursive
```

### 2. Generate SDK code
```bash
cd lib/sdk/flutter_xboard_sdk
flutter pub get
dart run build_runner build --delete-conflicting-outputs
cd ../../..
```

### 3. Install dependencies
```bash
flutter pub get
```

### 4. Copy config templates
```bash
cp config.example.json config.json
cp assets/config/xboard.config.example.yaml assets/config/xboard.config.yaml
```

Sau đó edit 2 files theo hướng dẫn ở Bước 2.

---

## ✅ Checklist

- [ ] Đã chạy `./setup_custom.sh` hoặc manual setup
- [ ] Đã edit `config.json` với backend URL thực tế
- [ ] Đã upload `config.json` lên hosting
- [ ] Đã update `remote_config.sources[0].url` trong `xboard.config.yaml`
- [ ] Đã test kết nối với `flutter run`
- [ ] Đã build app cho platform mong muốn

---

## 🐛 Troubleshooting

### Lỗi: "Failed to generate SDK code"

**Giải pháp:**
```bash
cd lib/sdk/flutter_xboard_sdk
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
cd ../../..
```

### Lỗi: "Cannot connect to backend"

**Kiểm tra:**
1. URL trong `config.json` có đúng không?
2. `provider` trong `xboard.config.yaml` có khớp với key trong `config.json` không?
3. Backend có đang chạy không?
4. Enable debug logs:
   ```yaml
   log:
     enabled: true
     level: debug
   ```

### Lỗi: "Submodule not initialized"

**Giải pháp:**
```bash
git submodule update --init --recursive
git submodule status  # Verify
```

### Lỗi build Android: "NDK not found"

**Giải pháp:**
1. Mở Android Studio
2. SDK Manager → SDK Tools → Install NDK
3. Set environment variable:
   ```bash
   export ANDROID_NDK=/path/to/ndk
   ```

---

## 📚 Next Steps

Sau khi setup xong, xem:
- **[CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md)** - Hướng dẫn chi tiết customization
- **[docs/](docs/)** - Tài liệu về features, security, deployment

---

## 💡 Tips

1. **Development**: Dùng `flutter run` để test nhanh, không cần build full
2. **Config changes**: Chỉ cần edit `config.json` trên hosting, không cần rebuild app
3. **Multiple backends**: Thêm nhiều URLs vào `panels` array trong `config.json` để có high availability
4. **Debug**: Enable `level: debug` trong config để xem chi tiết logs

---

## 🆘 Need Help?

- 📖 Đọc [CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md) cho hướng dẫn chi tiết
- 🐛 Tạo issue nếu gặp lỗi
- 📧 Liên hệ qua email support

---

**Happy Coding! 🎉**
