# ✅ Mitveepn Client - Hoàn tất!

## 🎉 Đã Setup Xong!

Tôi đã tạo config cho **Mitveepn** với 5 servers của bạn.

---

## 📝 Files đã tạo

### 1. Backend Configuration
**[config.json](config.json)** - Đã config sẵn với:
- ✅ 5 panel servers: api, cnxt1, cxt2, home, mail
- ✅ Crisp customer support (ID: 5d26cfe4-d28f-45de-8b83-65a9bd8754a5)
- ✅ Update server (lanzouw.com)
- ✅ Subscription servers
- ✅ WebSocket servers

### 2. Client Configuration
**[assets/config/xboard.config.yaml](assets/config/xboard.config.yaml)** - Đã config:
- ✅ Provider: `mitveepn`
- ✅ Domain racing enabled
- ✅ Vietnamese language
- ✅ Crisp support integrated
- ⚠️ Cần update: `remote_config.sources[0].url` (xem bên dưới)

---

## 🚀 3 Bước Tiếp Theo

### Bước 1: Upload config.json (5 phút)

Upload file `config.json` lên:
- **GitHub** (khuyến nghị): https://github.com → Create repo → Upload file
- **Gitee**: Tương tự GitHub
- **Your CDN**: Upload lên server riêng

Lấy raw URL, ví dụ:
```
https://raw.githubusercontent.com/mitveepn/config/main/config.json
```

### Bước 2: Update xboard.config.yaml (1 phút)

Mở file [`assets/config/xboard.config.yaml`](assets/config/xboard.config.yaml)

Tìm dòng 14 và thay URL:
```yaml
# BEFORE:
url: https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/config.json

# AFTER (thay bằng URL thực tế của bạn):
url: https://raw.githubusercontent.com/mitveepn/config/main/config.json
```

### Bước 3: Generate SDK & Run (5 phút)

```bash
# Generate SDK code (REQUIRED)
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

## 🎯 Cách hoạt động

```
App khởi động
  ↓
Load xboard.config.yaml (local)
  ↓
Fetch config.json từ GitHub/Gitee (remote URL)
  ↓
Domain Racing: Test 5 servers
  • api.mitveepn.com (Main)
  • cnxt1.mitveepn.com (CN Telecom 1)
  • cxt2.mitveepn.com (CN Telecom 2) 
  • home.mitveepn.com (Home)
  • mail.mitveepn.com (Mail)
  ↓
Chọn server nhanh nhất
  ↓
Connect & authenticate ✅
```

---

## 📚 Documentation

**BẮT ĐẦU TỪ ĐÂY:**
1. **[MITVEEPN_SETUP.md](MITVEEPN_SETUP.md)** ⭐ Hướng dẫn chi tiết cho Mitveepn
2. **[QUICK_START.md](QUICK_START.md)** - Quick guide
3. **[CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md)** - Advanced customization

**Navigation:**
- **[DOCS_INDEX.md](DOCS_INDEX.md)** - Tất cả docs
- **[TODO.md](TODO.md)** - Checklist đầy đủ

---

## ⚡ Quick Commands

```bash
# Generate SDK (required before first run)
cd lib/sdk/flutter_xboard_sdk && dart run build_runner build --delete-conflicting-outputs && cd ../../..

# Run app (development)
flutter run

# Build Android
dart setup.dart android

# Build Windows
dart setup.dart windows --arch amd64

# Build macOS
dart setup.dart macos --arch arm64

# Development helpers
source dev-helpers.sh
xb-status  # Check status
xb-help    # Show all commands
```

---

## 🔧 Your Configuration

### Servers (sẽ auto domain racing)
| Server | URL | Priority |
|--------|-----|----------|
| Main | `api.mitveepn.com` | 100 (highest) |
| CN Telecom 1 | `cnxt1.mitveepn.com` | 90 |
| CN Telecom 2 | `cxt2.mitveepn.com` | 90 |
| Home | `home.mitveepn.com` | 85 |
| Mail | `mail.mitveepn.com` | 85 |

### Features Enabled
- ✅ Domain racing (tự động chọn server nhanh nhất)
- ✅ Multi-server failover
- ✅ Crisp customer support chat
- ✅ Auto update check (24h interval)
- ✅ Vietnamese language
- ✅ SSL verification

### Update Configuration
- Latest Version: `1.1.0`
- Download: https://wwbch.lanzouw.com/s/mitveepn
- Minimum Version: `0.8.0`
- Force Update: `false`

---

## 🎨 Branding (Optional)

Để custom app name & icon:

```bash
# 1. App name
# Edit: android/app/src/main/AndroidManifest.xml
# Change: android:label="Mitveepn"

# 2. App ID  
# Edit: android/app/build.gradle
# Change: applicationId "com.mitveepn.vpn"

# 3. App icon
# Replace: assets/images/logo.png
# Or use: flutter_launcher_icons package
```

---

## 🐛 Troubleshooting

**SDK generation fails?**
```bash
cd lib/sdk/flutter_xboard_sdk
flutter clean && flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**Cannot connect?**
- Check backend servers running: `curl https://api.mitveepn.com/api/v1/guest/comm/config`
- Enable debug logs in `xboard.config.yaml`
- Verify config.json URL accessible

**More help:** See [MITVEEPN_SETUP.md](MITVEEPN_SETUP.md#-troubleshooting)

---

## ✅ Quick Checklist

Setup phase:
- [x] Project cloned
- [x] Config files created (config.json, xboard.config.yaml)
- [ ] Upload config.json to GitHub/Gitee
- [ ] Update remote URL in xboard.config.yaml
- [ ] Generate SDK code
- [ ] Run `flutter run` to test

Build phase:
- [ ] Test on device
- [ ] Customize branding (optional)
- [ ] Build production app
- [ ] Sign app (for distribution)
- [ ] Distribute to users

---

## 📞 Support

**Backend servers có vấn đề?**
- Test từng server: `curl https://api.mitveepn.com`
- Check backend Xboard panel logs
- Verify all servers in config.json are accessible

**App issues?**
- Enable debug logs
- Check Flutter logs: `flutter logs`
- See troubleshooting in [MITVEEPN_SETUP.md](MITVEEPN_SETUP.md)

---

## 🎓 Learn More

- Backend: Your Xboard servers
- Client: [Xboard-Mihomo](https://github.com/ElinksTeam/Xboard-Mihomo)
- Core: [Clash Meta](https://wiki.metacubex.one/)

---

**Next Step:** Upload config.json và update URL → [MITVEEPN_SETUP.md](MITVEEPN_SETUP.md) 🚀
