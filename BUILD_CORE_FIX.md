# ⚠️ BUILD CORE FIX - Hướng dẫn Manual Build

## Vấn đề
Lỗi "FlClashCore not found" xảy ra vì Clash Meta core chưa được build.

Thêm nữa, path của project có **khoảng trắng** (`mitveepn app`) nên script `setup.dart` bị lỗi.

---

## ✅ Giải pháp - Build Core Manual

### Bước 1: Build Clash Meta Core

Mở terminal và chạy:

```bash
cd "/Users/mitbg000/Library/CloudStorage/OneDrive-Personal/VPN/mitveepn app/Mitveepn/xboard-mihomo-client/core"

# Clean và update Go dependencies
go mod tidy

# Build library
export CGO_ENABLED=1
export GOOS=darwin
export GOARCH=arm64

go build -buildmode=c-shared -o libclash.dylib -trimpath -ldflags="-w -s" .
```

**Kiểm tra:**
```bash
ls -lh libclash.dylib
# Phải thấy file libclash.dylib (khoảng 20-30MB)
```

### Bước 2: Copy vào đúng vị trí

```bash
cd ..
mkdir -p libclash/macos
cp core/libclash.dylib libclash/macos/FlClashCore
```

**Kiểm tra:**
```bash
ls -lh libclash/macos/FlClashCore
# Phải thấy file FlClashCore
```

### Bước 3: Chạy app

```bash
cd "/Users/mitbg000/Library/CloudStorage/OneDrive-Personal/VPN/mitveepn app/Mitveepn/xboard-mihomo-client"
flutter clean
flutter run
```

---

## 🔧 Troubleshooting

### Lỗi: "go mod tidy fails"

```bash
cd core
rm go.sum
go mod tidy
```

### Lỗi: "CGO_ENABLED not supported"

Cài Xcode Command Line Tools:
```bash
xcode-select --install
```

### Lỗi: "ld: library not found"

Cài compiler tools:
```bash
brew install gcc
```

---

## 📝 Script Tự động (Nếu muốn)

Tôi đã tạo sẵn script `build_core.sh`. Chạy:

```bash
cd "/Users/mitbg000/Library/CloudStorage/OneDrive-Personal/VPN/mitveepn app/Mitveepn/xboard-mihomo-client"
chmod +x build_core.sh
./build_core.sh
```

---

## 🎯 Tổng kết

**3 lệnh chính bạn cần chạy:**

```bash
# 1. Build core
cd "/Users/mitbg000/Library/CloudStorage/OneDrive-Personal/VPN/mitveepn app/Mitveepn/xboard-mihomo-client/core"
go mod tidy
go build -buildmode=c-shared -o libclash.dylib -trimpath -ldflags="-w -s" .

# 2. Copy vào vị trí
cd ..
mkdir -p libclash/macos
cp core/libclash.dylib libclash/macos/FlClashCore

# 3. Run app
flutter clean
flutter run
```

---

## ⚠️ Lưu ý về Path có khoảng trắng

Project path của bạn có khoảng trắng: `mitveepn app/Mitveepn`

**Khuyến nghị:** Nên đổi tên folder thành không có khoảng trắng:
```bash
cd "/Users/mitbg000/Library/CloudStorage/OneDrive-Personal/VPN"
mv "mitveepn app" mitveepn-app
# Rồi update path trong commands
```

Nhưng hiện tại vẫn work được nếu bạn dùng quotes đúng cách như trên.

---

## 📚 Sau khi build xong

File structure sẽ như này:
```
xboard-mihomo-client/
├── core/
│   └── libclash.dylib          ← Vừa build xong
└── libclash/
    └── macos/
        └── FlClashCore          ← Copy từ libclash.dylib
```

Xcode sẽ tìm `FlClashCore` tại `libclash/macos/FlClashCore` khi build app.

---

## ✅ Checklist

Sau khi làm xong, verify:
- [ ] File `core/libclash.dylib` tồn tại (~20-30MB)
- [ ] File `libclash/macos/FlClashCore` tồn tại (copy của libclash.dylib)
- [ ] `flutter run` không còn lỗi "FlClashCore not found"

---

**Need help?** Paste error message nếu gặp vấn đề!
