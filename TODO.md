# Xboard-Mihomo Client - TODO & Customization Checklist

## 📋 Setup Checklist

### Phase 1: Initial Setup
- [ ] Clone repository: `git clone <url>`
- [ ] Run setup script: `./setup_custom.sh` or `setup_custom.bat`
- [ ] Verify all submodules initialized: `git submodule status`
- [ ] Verify SDK code generated: check `lib/sdk/flutter_xboard_sdk/lib/src/models/*.g.dart` exists
- [ ] Run `flutter doctor` to check environment

### Phase 2: Backend Configuration
- [ ] Edit `config.json`:
  - [ ] Update `panels.<provider>.url` with your XBoard backend URL
  - [ ] Update `onlineSupport` URLs
  - [ ] Add optional `proxy`, `ws`, `update`, `subscription` URLs if needed
- [ ] Upload `config.json` to hosting:
  - [ ] GitHub raw URL, or
  - [ ] Gitee raw URL, or
  - [ ] Your own CDN/server
- [ ] Note down the hosted URL for next step

### Phase 3: Client Configuration
- [ ] Edit `assets/config/xboard.config.yaml`:
  - [ ] Set `provider` to match key in `config.json`
  - [ ] Update `remote_config.sources[0].url` with hosted `config.json` URL
  - [ ] Set `app.title` to your app name
  - [ ] Set `app.website` to your domain
  - [ ] Configure `log.level` (use `debug` for development)

### Phase 4: Branding Customization
- [ ] Change app name:
  - [ ] `android/app/src/main/AndroidManifest.xml` → `android:label`
  - [ ] `pubspec.yaml` → `name`
  - [ ] Windows: `windows/runner/Runner.rc` → `VALUE "ProductName"`
- [ ] Change app ID:
  - [ ] Android: `android/app/build.gradle` → `applicationId`
  - [ ] iOS/macOS: In Xcode, change Bundle Identifier
- [ ] Replace app icon:
  - [ ] Update `assets/images/logo.png`
  - [ ] Or use `flutter_launcher_icons` package
- [ ] Update splash screen (optional)
- [ ] Customize theme colors in `lib/common/constant.dart` (optional)

### Phase 5: Security Configuration (if needed)
- [ ] If using encrypted subscription:
  - [ ] Get `decrypt_key` from backend admin
  - [ ] Set in `xboard.config.yaml` → `security.decrypt_key`
  - [ ] Set `subscription.prefer_encrypt: true`
- [ ] If backend uses response obfuscation:
  - [ ] Get obfuscation prefix from backend config
  - [ ] Set in `xboard.config.yaml` → `security.obfuscation_prefix`
- [ ] If using domain racing with User-Agent authentication:
  - [ ] Get encrypted token from backend admin
  - [ ] Update `security.user_agents.api_encrypted`
- [ ] If using custom TLS certificate:
  - [ ] Place certificate in `lib/sdk/flutter_xboard_sdk/assets/cer/`
  - [ ] Update `security.certificate.path`

### Phase 6: Testing
- [ ] Test configuration loading:
  - [ ] Run `flutter run` in debug mode
  - [ ] Check logs for config loading success
  - [ ] Verify backend connection
- [ ] Test authentication:
  - [ ] Try login with test account
  - [ ] Verify token storage
  - [ ] Test logout
- [ ] Test subscription:
  - [ ] Get subscription URL
  - [ ] Test proxy connection
  - [ ] Verify traffic routing
- [ ] Test on multiple devices (if available)

### Phase 7: Build & Distribution
- [ ] Build for target platforms:
  - [ ] Android: `dart setup.dart android`
  - [ ] Windows: `dart setup.dart windows --arch amd64`
  - [ ] macOS: `dart setup.dart macos --arch arm64`
  - [ ] Linux: `dart setup.dart linux --arch amd64`
- [ ] Sign builds (for production):
  - [ ] Android: Setup keystore and signing config
  - [ ] macOS: Code signing with Apple Developer cert
  - [ ] Windows: Code signing with certificate (optional)
- [ ] Test signed builds on real devices
- [ ] Setup auto-update mechanism (optional)
- [ ] Prepare distribution:
  - [ ] Google Play Store (Android)
  - [ ] App Store / TestFlight (macOS/iOS)
  - [ ] Direct download from website
  - [ ] GitHub Releases

---

## 🎨 Optional Customizations

### UI/UX Enhancements
- [ ] Customize color theme
- [ ] Add custom fonts
- [ ] Redesign login screen
- [ ] Add onboarding flow
- [ ] Implement dark mode toggle
- [ ] Add animations

### Feature Additions
- [ ] Add multi-language support (i18n)
- [ ] Implement analytics tracking
- [ ] Add crash reporting (Sentry, Firebase Crashlytics)
- [ ] Implement push notifications
- [ ] Add QR code scanner for quick login
- [ ] Add server latency display
- [ ] Implement traffic statistics charts

### Advanced Features
- [ ] Custom protocol support
- [ ] Split tunneling configuration
- [ ] DNS configuration UI
- [ ] Advanced routing rules
- [ ] Connection diagnostics tools
- [ ] Export/import configuration

---

## 🚀 Deployment Checklist

### Pre-Production
- [ ] All tests passing
- [ ] Debug logs disabled in production build
- [ ] Certificate verification enabled
- [ ] API keys secured (not hardcoded)
- [ ] Analytics/tracking configured
- [ ] Crash reporting setup
- [ ] Privacy policy prepared
- [ ] Terms of service prepared

### Production Release
- [ ] Version number updated in `pubspec.yaml`
- [ ] Changelog prepared
- [ ] Release notes written
- [ ] Builds signed with production certificates
- [ ] Tested on multiple devices/OS versions
- [ ] Backend capacity verified
- [ ] Support channels ready
- [ ] Documentation updated
- [ ] Marketing materials prepared (if needed)

### Post-Release
- [ ] Monitor crash reports
- [ ] Monitor user feedback
- [ ] Track analytics metrics
- [ ] Prepare for bug fix updates
- [ ] Plan next version features

---

## 📝 Notes & Considerations

### Configuration Management
- Keep `config.json` version controlled in a private repo
- Use different `config.json` for development/staging/production
- Consider using environment-specific configs
- Document all configuration changes

### Security Best Practices
- Never commit API keys or secrets to git
- Use environment variables for sensitive data
- Enable certificate verification in production
- Regularly update dependencies
- Monitor for security advisories

### Performance Optimization
- Enable domain racing for faster connection
- Configure appropriate timeouts
- Implement connection caching
- Monitor memory usage
- Profile app performance regularly

### User Support
- Prepare FAQ documentation
- Setup support ticket system
- Create troubleshooting guides
- Monitor support requests
- Gather user feedback

---

## 🐛 Known Issues & Workarounds

- **Issue**: SDK code generation fails
  - **Workaround**: Clean and regenerate - see troubleshooting section

- **Issue**: Submodules not initialized
  - **Workaround**: `git submodule update --init --recursive`

- **Issue**: Build fails on first attempt
  - **Workaround**: Run `flutter clean && flutter pub get` then rebuild

---

## 📅 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0   | TBD  | Initial custom build |

---

## 🔗 Useful Links

- [Flutter Documentation](https://flutter.dev/docs)
- [Xboard Backend](https://github.com/cedar2025/Xboard)
- [Clash Meta Documentation](https://wiki.metacubex.one/)
- [FlClash Project](https://github.com/chen08209/FlClash)

---

**Last Updated**: [Date]
**Maintainer**: [Your Name/Team]
