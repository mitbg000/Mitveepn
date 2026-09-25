# Xboard Mihomo Client - Custom Setup

Đây là bản custom của [Xboard-Mihomo](https://github.com/ElinksTeam/Xboard-Mihomo) để kết nối với backend [Xboard](https://github.com/cedar2025/Xboard).

## 📋 Tổng quan

Client cross-platform (Android, Windows, macOS, Linux) sử dụng Flutter + Clash Meta core để kết nối với XBoard backend.

## 🚀 Quick Start

**Cách nhanh nhất:**
```bash
chmod +x setup_custom.sh
./setup_custom.sh
```

Sau đó xem **[QUICK_START.md](QUICK_START.md)** để cấu hình backend.

## 📚 Documentation

- **[QUICK_START.md](QUICK_START.md)** - Hướng dẫn bắt đầu nhanh (5 phút)
- **[CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md)** - Hướng dẫn customization chi tiết
- **[docs/](docs/)** - Tài liệu gốc từ Xboard-Mihomo

## 🛠️ Requirements

- Flutter SDK >= 3.0
- Dart SDK >= 2.19
- Golang >= 1.19 (để build Clash Meta core)
- Git

## 📦 Project Structure

```
xboard-mihomo-client/
├── lib/
│   ├── xboard/              # XBoard integration module
│   └── sdk/
│       └── flutter_xboard_sdk/  # XBoard SDK (submodule)
├── core/Clash.Meta/         # Clash Meta core (submodule)
├── assets/config/
│   ├── xboard.config.yaml   # Client configuration
│   └── xboard.config.example.yaml
├── config.json              # Backend URLs configuration
├── config.example.json
├── setup_custom.sh          # Auto setup script
├── QUICK_START.md           # Quick start guide
└── CUSTOMIZATION_GUIDE.md   # Detailed customization guide
```

## 🎯 Features

- ✅ Multi-platform: Android, Windows, macOS, Linux
- ✅ XBoard backend integration
- ✅ Domain racing for high availability
- ✅ Encrypted subscription support
- ✅ Auto-update checking
- ✅ Online customer support integration
- ✅ WebSocket real-time communication
- ✅ Anti-censorship features

## 🔧 Configuration

### 1. Backend Configuration (`config.json`)

```json
{
    "panels": {
        "your-provider": [
            {
                "url": "https://your-backend.com",
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

### 2. Client Configuration (`assets/config/xboard.config.yaml`)

```yaml
xboard:
  provider: your-provider  # Must match key in config.json
  
  remote_config:
    sources:
      - name: main_source
        url: https://your-hosting.com/config.json
        priority: 100
  
  app:
    title: YourAppName
    website: your-domain.com
```

## 🏗️ Build Commands

```bash
# Android
dart setup.dart android

# Windows
dart setup.dart windows --arch amd64

# macOS
dart setup.dart macos --arch arm64

# Linux
dart setup.dart linux --arch amd64

# Development
flutter run
```

## 📖 Detailed Documentation

See [CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md) for:
- Complete configuration reference
- Branding customization
- Security setup (encryption, obfuscation)
- UI/UX customization
- Distribution & signing
- Troubleshooting

## 🙏 Credits

- Based on [Xboard-Mihomo](https://github.com/ElinksTeam/Xboard-Mihomo)
- Built on [FlClash](https://github.com/chen08209/FlClash)
- Uses [Clash Meta](https://github.com/MetaCubeX/Clash.Meta) core
- Connects to [Xboard](https://github.com/cedar2025/Xboard) backend

## 📄 License

Based on FlClash's license. See [LICENSE](LICENSE).

## ⚠️ Disclaimer

For learning and research purposes only. Users are responsible for compliance with local laws and regulations.

---

**Ready to start?** → [QUICK_START.md](QUICK_START.md)
