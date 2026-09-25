# ⚠️ LỖI VÀ CÁCH FIX

## Lỗi gặp phải

```
error: The file "FlClashCore" couldn't be opened because there is no such file.
```

## Nguyên nhân

Clash Meta core chưa được build. File `libclash/macos/FlClashCore` không tồn tại.

---

## ✅ CÁCH FIX NHANH (3 bước)

### 1️⃣ Build Clash Meta Core

```bash
cd "/Users/mitbg000/Library/CloudStorage/OneDrive-Personal/VPN/mitveepn app/Mitveepn/xboard-mihomo-client/core"

go mod tidy

go build -buildmode=c-shared -o libclash.dylib -trimpath -ldflags="-w -s" .
```

**Chờ 2-3 phút để build...**

### 2️⃣ Copy vào đúng vị trí

```bash
cd "/Users/mitbg000/Library/CloudStorage/OneDrive-Personal/VPN/mitveepn app/Mitveepn/xboard-mihomo-client"

mkdir -p libclash/macos

cp core/libclash.dylib libclash/macos/FlClashCore
```

### 3️⃣ Run app

```bash
flutter clean
flutter run
```

---

## 🎯 Copy & Paste - Tất cả lệnh

```bash
cd "/Users/mitbg000/Library/CloudStorage/OneDrive-Personal/VPN/mitveepn app/Mitveepn/xboard-mihomo-client/core" && \
go mod tidy && \
go build -buildmode=c-shared -o libclash.dylib -trimpath -ldflags="-w -s" . && \
cd .. && \
mkdir -p libclash/macos && \
cp core/libclash.dylib libclash/macos/FlClashCore && \
flutter clean && \
flutter run
```

---

## 🐛 Nếu gặp lỗi khác

**Lỗi: "go mod tidy fails"**
```bash
cd core
rm go.sum
go clean -modcache
go mod tidy
```

**Lỗi: "build fails - ld: library not found"**
```bash
xcode-select --install
```

**Lỗi: "permission denied"**
```bash
chmod +x build_core.sh
./build_core.sh
```

---

## ℹ️ Giải thích

- **Clash Meta core** là proxy engine (viết bằng Go)
- Cần build thành **shared library** (.dylib cho macOS)
- Flutter app sẽ load library này để chạy proxy
- File phải tên là `FlClashCore` và đặt ở `libclash/macos/`

---

## ✅ Sau khi fix xong

Bạn sẽ có:
```
xboard-mihomo-client/
├── core/
│   └── libclash.dylib          (~20-30MB)
└── libclash/
    └── macos/
        └── FlClashCore          (~20-30MB - copy của libclash.dylib)
```

Và `flutter run` sẽ không còn lỗi "FlClashCore not found"!

---

**Chạy 3 bước trên là xong! 🚀**
