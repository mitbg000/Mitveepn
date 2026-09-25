# 📚 Documentation Index

Chào mừng đến với Xboard-Mihomo Client customization project!

## 🚀 Bắt đầu nhanh

**Bạn là người mới?** → Đọc theo thứ tự này:

1. **[SETUP_COMPLETE.md](SETUP_COMPLETE.md)** - ⭐ ĐỌC ĐẦU TIÊN
   - Tổng quan về những gì đã setup
   - Quick navigation
   - Key points và tips

2. **[QUICK_START.md](QUICK_START.md)** - 5 phút setup
   - Hướng dẫn từng bước
   - Cấu hình cơ bản
   - Build commands

3. **[CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md)** - Chi tiết đầy đủ
   - Kiến trúc project
   - Customization options
   - Security configuration
   - Distribution guide

4. **[TODO.md](TODO.md)** - Checklist
   - Setup checklist
   - Development tasks
   - Deployment checklist

---

## 📖 Documentation Structure

```
📚 Documentation
│
├── 🎯 Getting Started
│   ├── SETUP_COMPLETE.md      ⭐ Start here!
│   ├── QUICK_START.md         Quick 5-minute guide
│   └── README_CUSTOM.md       Project overview
│
├── 📘 Detailed Guides  
│   ├── CUSTOMIZATION_GUIDE.md  Complete customization guide
│   └── TODO.md                 Task checklists
│
├── 📄 Original Docs
│   ├── README.md               Original project README
│   └── docs/                   Original documentation
│
├── ⚙️ Configuration
│   ├── config.example.json            Backend URLs template
│   └── assets/config/
│       └── xboard.config.example.yaml Client config template
│
└── 🛠️ Scripts
    ├── setup_custom.sh         Auto setup (Linux/macOS)
    ├── setup_custom.bat        Auto setup (Windows)
    └── dev-helpers.sh          Development shortcuts
```

---

## 🎯 Common Tasks

### Setup Project
```bash
# Linux/macOS
./setup_custom.sh

# Windows  
setup_custom.bat

# Manual steps (if script fails)
# See QUICK_START.md
```

### Configure Backend
```bash
# 1. Edit config
cp config.example.json config.json
nano config.json  # Add your backend URLs

# 2. Upload to hosting (GitHub/Gitee/CDN)
# 3. Update client config
nano assets/config/xboard.config.yaml
```

### Build App
```bash
# Android
dart setup.dart android

# Windows
dart setup.dart windows --arch amd64

# macOS
dart setup.dart macos --arch arm64

# Test/Development
flutter run
```

### Development Helpers
```bash
# Load helper functions
source dev-helpers.sh

# Common commands
xb-status          # Check project status
xb-regen           # Regenerate SDK code
xb-build-android   # Build Android
xb-help            # Show all commands
```

---

## 📝 Configuration Files

### Must Create (from templates):

1. **config.json** (from config.example.json)
   - Backend panel URLs
   - Online support URLs
   - Optional: proxy, ws, update URLs

2. **assets/config/xboard.config.yaml** (from xboard.config.example.yaml)
   - Provider name (must match config.json)
   - Remote config source URL
   - App branding
   - Security settings

### Already Configured:

- pubspec.yaml - Dependencies
- android/ios/windows/macos/linux configs - Platform specific

---

## 🏗️ Project Architecture

```
xboard-mihomo-client/
│
├── lib/
│   ├── xboard/                    🎯 Main customization here
│   │   ├── config/                Config management
│   │   ├── features/              Auth, subscription, payment
│   │   ├── infrastructure/        HTTP client, storage
│   │   ├── sdk/                   XBoard SDK wrapper
│   │   └── services/              Business logic
│   │
│   ├── sdk/flutter_xboard_sdk/    XBoard SDK (submodule)
│   ├── main.dart                  Entry point
│   └── application.dart           App initialization
│
├── core/Clash.Meta/               Clash Meta core (submodule)
├── plugins/                       Flutter plugins (submodule)
├── assets/config/                 Configuration files
├── android/ios/windows/...        Platform specific code
│
└── docs/                          Documentation
```

---

## 🔍 Quick Reference

### Essential Commands

| Task | Command |
|------|---------|
| Setup project | `./setup_custom.sh` |
| Generate SDK | `cd lib/sdk/flutter_xboard_sdk && dart run build_runner build --delete-conflicting-outputs` |
| Install deps | `flutter pub get` |
| Run app | `flutter run` |
| Build Android | `dart setup.dart android` |
| Clean build | `flutter clean` |
| Check status | `flutter doctor` |

### Configuration Flow

```
1. Edit config.json
   ↓
2. Upload to hosting
   ↓
3. Get hosted URL
   ↓
4. Update xboard.config.yaml
   ↓
5. Test with flutter run
   ↓
6. Build production
```

### Important Files

| File | Purpose |
|------|---------|
| `config.json` | Backend URLs (upload to hosting) |
| `assets/config/xboard.config.yaml` | Client configuration |
| `lib/xboard/` | XBoard customization code |
| `pubspec.yaml` | Dependencies & app metadata |
| `android/app/build.gradle` | Android app ID & version |

---

## 🆘 Troubleshooting

### Common Issues

**Setup fails?** → See [QUICK_START.md](QUICK_START.md#-troubleshooting)

**SDK generation error?** → 
```bash
cd lib/sdk/flutter_xboard_sdk
flutter clean && flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**Cannot connect to backend?** →
- Check `config.json` URL is correct
- Verify `provider` matches key in `config.json`
- Enable debug logs in `xboard.config.yaml`

**Build error?** →
```bash
flutter clean
flutter pub get
# Try build again
```

For more: [CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md#-debugging--troubleshooting)

---

## 📞 Getting Help

1. **Check docs first:**
   - [QUICK_START.md](QUICK_START.md) for basic setup
   - [CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md) for detailed guide
   - [TODO.md](TODO.md) for checklists

2. **Enable debug logs:**
   ```yaml
   # xboard.config.yaml
   log:
     level: debug
   ```

3. **Check original project:**
   - [Xboard-Mihomo Issues](https://github.com/ElinksTeam/Xboard-Mihomo/issues)
   - [FlClash Issues](https://github.com/chen08209/FlClash/issues)

---

## 🎓 Learning Path

### Beginner
1. Read [SETUP_COMPLETE.md](SETUP_COMPLETE.md)
2. Follow [QUICK_START.md](QUICK_START.md)
3. Build and test app
4. Basic customization (name, icon)

### Intermediate
1. Read [CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md)
2. Understand project architecture
3. Customize UI/branding
4. Configure security features

### Advanced
1. Deep dive into `lib/xboard/` code
2. Add custom features
3. Modify SDK integration
4. Optimize performance
5. Setup CI/CD pipeline

---

## 🔗 External Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Xboard Backend](https://github.com/cedar2025/Xboard)
- [Xboard-Mihomo Original](https://github.com/ElinksTeam/Xboard-Mihomo)
- [FlClash](https://github.com/chen08209/FlClash)
- [Clash Meta Wiki](https://wiki.metacubex.one/)

---

## ✅ Setup Checklist

Quick checklist to verify setup:

- [ ] Project cloned
- [ ] Submodules initialized (`git submodule status`)
- [ ] SDK code generated (check `.g.dart` files exist)
- [ ] Dependencies installed (`flutter pub get` done)
- [ ] `config.json` created and configured
- [ ] `xboard.config.yaml` created and configured
- [ ] App runs with `flutter run`
- [ ] Backend connection working

---

## 🎉 You're All Set!

Bây giờ bạn đã có:
- ✅ Project được setup đầy đủ
- ✅ Documentation đầy đủ
- ✅ Config templates
- ✅ Helper scripts
- ✅ Troubleshooting guides

**Next:** Đọc [SETUP_COMPLETE.md](SETUP_COMPLETE.md) để bắt đầu!

---

**Questions?** Check the docs or create an issue!
