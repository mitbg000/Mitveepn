# Hướng dẫn Customization - Xboard Mihomo Client

## 📋 Tổng quan

Tài liệu này hướng dẫn chi tiết cách customize Xboard-Mihomo client để kết nối với backend Xboard của bạn.

---

## 🎯 Kiến trúc Project

### Cấu trúc thư mục chính

```
xboard-mihomo-client/
├── lib/
│   ├── xboard/                    # Module XBoard (tất cả customization ở đây)
│   │   ├── config/                # Cấu hình XBoard
│   │   ├── core/                  # Core utilities
│   │   ├── features/              # Các tính năng (auth, subscription, payment...)
│   │   ├── infrastructure/        # HTTP client, storage
│   │   ├── sdk/                   # XBoard SDK wrapper
│   │   └── services/              # Business services
│   ├── sdk/
│   │   └── flutter_xboard_sdk/    # XBoard SDK (submodule)
│   ├── main.dart                  # Entry point
│   └── application.dart           # App initialization
├── assets/
│   └── config/
│       └── xboard.config.yaml     # Cấu hình client chính
├── core/Clash.Meta/               # Clash Meta core (submodule)
├── config.json                    # Cấu hình backend URLs
└── pubspec.yaml                   # Dependencies

```

### Luồng hoạt động

```
1. Client khởi động → đọc assets/config/xboard.config.yaml
2. Lấy remote_config.sources[].url → download config.json
3. Parse panels từ config.json → kết nối backend XBoard
4. Authenticate → lấy subscription → connect proxy
```

---

## 🔧 Các bước Customization

### Bước 1: Cấu hình Backend URLs

#### 1.1. Tạo file `config.json` (đặt ở root project)

```json
{
    "panels": {
        "mitveepn": [
            {
                "url": "https://your-xboard-backend.com",
                "description": "Main Panel"
            },
            {
                "url": "https://backup-panel.com",
                "description": "Backup Panel"
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
    ],
    "proxy": [
        {
            "url": "username:password@proxy.example.com:8080",
            "description": "HTTP Proxy",
            "protocol": "http"
        }
    ],
    "ws": [
        {
            "url": "wss://ws.your-domain.com/ws/",
            "description": "WebSocket Server"
        }
    ],
    "update": [
        {
            "url": "https://update.your-domain.com",
            "description": "Update Server"
        }
    ],
    "subscription": [
        {
            "url": "https://sub1.your-domain.com",
            "description": "Subscription Server 1"
        },
        {
            "url": "https://sub2.your-domain.com",
            "description": "Subscription Server 2"
        }
    ]
}
```

**Chú ý:**
- `panels.mitveepn` - key name "mitveepn" phải khớp với `provider` trong bước tiếp theo
- Chỉ có `panels` và `onlineSupport` là bắt buộc
- Các field khác (`proxy`, `ws`, `update`, `subscription`) là optional

#### 1.2. Host file `config.json`

Upload file này lên một trong các nơi:
- GitHub: `https://raw.githubusercontent.com/username/repo/main/config.json`
- Gitee: `https://gitee.com/username/repo/raw/main/config.json`
- Server của bạn: `https://your-cdn.com/config.json`
- Object Storage (S3, OSS, etc.)

---

### Bước 2: Cấu hình Client

Chỉnh sửa file [`assets/config/xboard.config.yaml`](assets/config/xboard.config.yaml):

```yaml
xboard:
  # Provider name - PHẢI KHỚP với key trong config.json
  provider: mitveepn
  
  # Remote config sources
  remote_config:
    sources:
      - name: main_source
        url: https://raw.githubusercontent.com/your-username/your-repo/main/config.json
        priority: 100
      
      # Backup source (optional)
      - name: backup_source
        url: https://gitee.com/your-username/your-repo/raw/main/config.json
        priority: 90
        encryption_key: YOUR_ENCRYPTION_KEY  # If using Gitee encrypted
    
    timeout_seconds: 10
    max_retries: 3
    retry_delay_seconds: 2
  
  # Latency test configuration
  latency_test:
    test_url: http://www.gstatic.com/generate_204
    timeout_seconds: 5
  
  # Domain racing service
  domain_service:
    enable: true
    cache_minutes: 5
    max_retries: 3
    test_timeout_seconds: 5
    max_concurrent_tests: 10
  
  # SDK configuration
  sdk:
    timeout_milliseconds: 6000
    enable_debug_log: true
    strategy: race_fastest  # or 'default'
  
  # Logging
  log:
    enabled: true
    level: info  # debug, info, warning, error
    prefix: "[MitveeVPN]"
  
  # App branding
  app:
    title: MitveeVPN
    website: mitveepn.com
  
  # Subscription settings
  subscription:
    # true: prefer encrypted subscription (with domain racing)
    # false: use normal subscription directly
    prefer_encrypt: false
  
  # Security & encryption
  security:
    # Decrypt key for encrypted subscriptions
    decrypt_key: YOUR_DECRYPT_KEY_HERE
    
    # Obfuscation prefix (must match backend Caddy config)
    # Leave empty if backend doesn't use obfuscation
    obfuscation_prefix: ""
    
    # User-Agent strings (for domain racing)
    user_agents:
      api_encrypted: Mozilla/5.0 (compatible; YOUR_ENCRYPTED_TOKEN)
      domain_racing_test: MitveeVPN/1.0 (Domain Racing Test)
    
    # TLS certificate
    certificate:
      path: flutter_xboard_sdk/assets/cer/client-cert.crt
      enabled: true
```

---

### Bước 3: Customize Branding

#### 3.1. Thay đổi tên ứng dụng

**Android** - [`android/app/src/main/AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml):
```xml
<application
    android:label="MitveeVPN"
    ...>
```

**iOS/macOS** - Chỉnh sửa trong Xcode hoặc [`ios/Runner/Info.plist`](ios/Runner/Info.plist):
```xml
<key>CFBundleDisplayName</key>
<string>MitveeVPN</string>
```

**Windows** - [`windows/runner/Runner.rc`](windows/runner/Runner.rc):
```c
VALUE "ProductName", "MitveeVPN"
```

#### 3.2. Thay đổi App ID

**pubspec.yaml**:
```yaml
name: mitveevpn_client
version: 1.0.0+1
```

**Android** - [`android/app/build.gradle`](android/app/build.gradle):
```gradle
applicationId "com.mitveepn.vpn"
```

**iOS/macOS** - Trong Xcode, thay đổi Bundle Identifier

#### 3.3. Thay đổi icon

Đặt icon mới vào:
- `assets/images/logo.png`
- Hoặc dùng tool như `flutter_launcher_icons`:

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

### Bước 4: Build ứng dụng

#### 4.1. Setup môi trường

```bash
# Đảm bảo đã init submodules
git submodule update --init --recursive

# Generate SDK code (QUAN TRỌNG!)
cd lib/sdk/flutter_xboard_sdk
flutter pub get
dart run build_runner build --delete-conflicting-outputs
cd ../../..

# Install dependencies
flutter pub get
```

#### 4.2. Build cho từng platform

**Android:**
```bash
dart setup.dart android
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Windows:**
```bash
dart setup.dart windows --arch amd64
# Output: build/windows/runner/Release/
```

**macOS:**
```bash
dart setup.dart macos --arch arm64  # M1/M2
# hoặc
dart setup.dart macos --arch amd64  # Intel
# Output: build/macos/Build/Products/Release/
```

**Linux:**
```bash
dart setup.dart linux --arch amd64
# Output: build/linux/x64/release/bundle/
```

#### 4.3. Development mode (nhanh hơn)

```bash
# List devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Run with release mode
flutter run --release
```

---

## 🔒 Cấu hình Security (Nâng cao)

### Subscription Encryption

Nếu backend của bạn sử dụng encrypted subscription:

1. **Backend**: Generate encryption key và configure trong Xboard panel
2. **Client**: Thêm vào `xboard.config.yaml`:

```yaml
security:
  decrypt_key: "your-32-character-encryption-key"
subscription:
  prefer_encrypt: true
```

### Response Obfuscation

Nếu sử dụng Caddy để obfuscate API responses:

**Caddy config:**
```caddy
replace "{\"status\"" "OBFS_PREFIX_{\"status\""
```

**Client config:**
```yaml
security:
  obfuscation_prefix: "OBFS_PREFIX_"
```

### Domain Racing với User-Agent

Backend có thể verify User-Agent để chống abuse:

```yaml
security:
  user_agents:
    api_encrypted: "Mozilla/5.0 (compatible; YOUR_SECRET_TOKEN)"
    domain_racing_test: "YourApp/1.0"
```

---

## 📱 Customization UI/UX

### Thay đổi theme colors

File [`lib/common/constant.dart`](lib/common/constant.dart) hoặc theme files:

```dart
class AppColors {
  static const primary = Color(0xFF6366F1);  // Indigo
  static const secondary = Color(0xFF8B5CF6);  // Purple
  // ...
}
```

### Thay đổi login screen

File: `lib/pages/auth/login_page.dart` (hoặc tương tự)

```dart
// Custom logo
Image.asset('assets/images/your_logo.png', height: 80)

// Custom welcome text
Text('Welcome to MitveeVPN')
```

---

## 🧩 XBoard SDK Integration

### Sử dụng XBoard SDK trực tiếp

```dart
import 'package:flutter_xboard_sdk/flutter_xboard_sdk.dart';

// Login
final response = await LoginApi.login(
  email: email,
  password: password,
);

// Get user info
final userInfo = await UserInfoApi.getUserInfo();

// Get subscription
final subscription = await SubscriptionApi.getSubscription();
```

### Custom API calls

Nếu backend có custom endpoints:

```dart
// File: lib/xboard/infrastructure/http/xboard_http_client.dart
class XBoardHttpClient {
  Future<ApiResponse<T>> customEndpoint<T>() async {
    return await httpService.get<T>(
      '/api/v1/custom/endpoint',
      // ...
    );
  }
}
```

---

## 🐛 Debugging & Troubleshooting

### Enable debug logs

```yaml
# xboard.config.yaml
log:
  enabled: true
  level: debug  # Thay vì info
sdk:
  enable_debug_log: true
```

### Common issues

**1. Submodule không khởi tạo:**
```bash
git submodule update --init --recursive
```

**2. SDK code generation lỗi:**
```bash
cd lib/sdk/flutter_xboard_sdk
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**3. Build lỗi - missing Clash.Meta core:**
```bash
# Check submodule status
git submodule status

# Re-init if needed
cd core/Clash.Meta
git pull origin main
```

**4. Cannot connect to backend:**
- Check `config.json` URL có đúng không
- Check `provider` name khớp với key trong `panels`
- Check network connectivity
- Enable debug logs để xem chi tiết

**5. Encrypted subscription không work:**
- Verify `decrypt_key` khớp với backend
- Check `prefer_encrypt: true` trong config
- Verify backend đã enable encryption

---

## 📦 Distribution

### Android APK signing

```bash
# Generate keystore
keytool -genkey -v -keystore ~/mitveevpn.jks -keyalg RSA -keysize 2048 -validity 10000 -alias mitveevpn

# Configure in android/key.properties
storePassword=yourPassword
keyPassword=yourPassword
keyAlias=mitveevpn
storeFile=/path/to/mitveevpn.jks
```

### macOS notarization

Cần Apple Developer account và certificate:
```bash
# Sign and notarize
xcrun notarytool submit YourApp.dmg --apple-id "your@email.com" --password "app-specific-password" --team-id "TEAM_ID"
```

### Windows code signing

Cần code signing certificate:
```bash
signtool sign /f certificate.pfx /p password /t http://timestamp.digicert.com YourApp.exe
```

---

## 🔄 Update Strategy

### Auto-update configuration

Trong `config.json`:
```json
{
  "update": [
    {
      "url": "https://api.github.com/repos/yourname/yourrepo/releases/latest",
      "description": "GitHub Releases"
    }
  ]
}
```

Client sẽ tự động check update dựa trên config này.

---

## 📚 Tài liệu tham khảo

- [XBoard Backend](https://github.com/cedar2025/Xboard)
- [XBoard-Mihomo Original](https://github.com/ElinksTeam/Xboard-Mihomo)
- [Flutter XBoard SDK](https://github.com/hakimi-x/flutter_xboard_sdk)
- [FlClash](https://github.com/chen08209/FlClash)
- [Clash Meta](https://github.com/MetaCubeX/Clash.Meta)

---

## ❓ FAQ

**Q: Có thể thay đổi Clash core không?**
A: Có, nhưng cần rebuild core. Project sử dụng Clash.Meta fork từ FlClash.

**Q: Có thể thêm custom features không?**
A: Có, thêm vào `lib/xboard/features/` theo pattern có sẵn.

**Q: Làm sao để multi-language?**
A: Project đã support i18n qua `arb/` files. Thêm file `app_vi.arb` cho tiếng Việt.

**Q: iOS có support không?**
A: Hiện tại đang trong roadmap, chưa có build script sẵn.

---

**Cần hỗ trợ?** Tạo issue hoặc liên hệ qua email.
