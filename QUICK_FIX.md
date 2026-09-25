# 🚀 QUICK FIX - Flutter Run Error

## ❌ Error You Got

```
error: The file "FlClashCore" couldn't be opened because there is no such file.
** BUILD FAILED **
```

---

## ✅ SOLUTION (Copy & Paste vào Terminal)

```bash
cd "/Users/mitbg000/Library/CloudStorage/OneDrive-Personal/VPN/mitveepn app/Mitveepn/xboard-mihomo-client/core" && go mod tidy && go build -buildmode=c-shared -o libclash.dylib -trimpath -ldflags="-w -s" . && cd .. && mkdir -p libclash/macos && cp core/libclash.dylib libclash/macos/FlClashCore && flutter clean && flutter run
```

**Thời gian:** 2-3 phút để build core

---

## 📖 Chi tiết

Xem file:
- **[FIX_ERROR.md](FIX_ERROR.md)** - Hướng dẫn ngắn gọn từng bước
- **[BUILD_CORE_FIX.md](BUILD_CORE_FIX.md)** - Hướng dẫn chi tiết + troubleshooting

---

## 🎯 What's Next?

Sau khi fix xong và app chạy được:

1. **Đọc:** [MITVEEPN_SETUP.md](MITVEEPN_SETUP.md) - Customize cho Mitveepn
2. **Upload:** `config.json` lên GitHub/Gitee/CDN
3. **Update:** URL trong `assets/config/xboard.config.yaml` (line 16)
4. **Test:** Login với Mitveepn account

---

Gặp vấn đề? Paste error message!
