import 'package:mitveepn/common/common.dart';
import 'package:mitveepn/models/models.dart';
import 'package:mitveepn/pages/scan.dart';
import 'package:mitveepn/state.dart';
import 'package:mitveepn/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitveepn/providers/providers.dart';

/// AddProfileView dành riêng cho login page
/// Không navigate đến profiles page, mà xử lý trực tiếp
class LoginAddProfileView extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  final VoidCallback? onProfileAdded;

  const LoginAddProfileView({
    super.key,
    required this.parentContext,
    this.onProfileAdded,
  });

  @override
  ConsumerState<LoginAddProfileView> createState() => _LoginAddProfileViewState();
}

class _LoginAddProfileViewState extends ConsumerState<LoginAddProfileView> {
  bool _isLoading = false;

  Future<void> _handleAddProfileFromFile() async {
    if (_isLoading) return;

    try {
      setState(() => _isLoading = true);

      final platformFile = await globalState.safeRun(picker.pickerFile);
      final bytes = platformFile?.bytes;
      if (bytes == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Chỉ giữ 1 session tại 1 thời điểm: dọn sạch profile cũ trước khi thêm mới
      await globalState.appController.clearAllProfiles();

      // Tạo profile từ file
      final profile = await Profile.normal(label: platformFile?.name).saveFile(bytes);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (profile != null) {
        // Thêm profile vào state và chuyển sang dùng ngay (thao tác chủ động của người dùng)
        ref.read(profilesProvider.notifier).setProfile(profile);
        ref.read(currentProfileIdProvider.notifier).value = profile.id;

        debugPrint('[LoginAddProfile] Profile added from file: ${profile.label}');

        // Apply profile để load proxies (đang ở LoginPage, HomePage chưa mount nên phải dùng silence)
        try {
          await globalState.appController.applyProfile(silence: true);
          debugPrint('[LoginAddProfile] Profile applied successfully');
        } catch (e) {
          debugPrint('[LoginAddProfile] Error applying profile: $e');
        }

        widget.onProfileAdded?.call();
      }
    } catch (e) {
      debugPrint('[LoginAddProfile] Error adding profile from file: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(content: Text('Failed to add profile: $e')),
        );
      }
    }
  }

  Future<void> _handleAddProfileFromURL(String url) async {
    if (_isLoading) return;

    try {
      debugPrint('[LoginAddProfile] Adding profile from URL: $url');
      setState(() => _isLoading = true);

      // Chỉ giữ 1 session tại 1 thời điểm: dọn sạch profile cũ trước khi thêm mới
      await globalState.appController.clearAllProfiles();

      // Tạo profile từ URL với timeout
      final profile = await Profile.normal(url: url).update().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          debugPrint('[LoginAddProfile] Timeout while updating profile');
          throw Exception('Connection timeout. Please check your internet connection.');
        },
      );

      debugPrint('[LoginAddProfile] Profile updated successfully: ${profile?.label}');

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (profile != null) {
        // Thêm profile vào state và chuyển sang dùng ngay (thao tác chủ động của người dùng)
        ref.read(profilesProvider.notifier).setProfile(profile);
        ref.read(currentProfileIdProvider.notifier).value = profile.id;

        debugPrint('[LoginAddProfile] Profile added to state: ${profile.label}, ID: ${profile.id}');

        // Apply profile để load proxies (đang ở LoginPage, HomePage chưa mount nên phải dùng silence)
        try {
          await globalState.appController.applyProfile(silence: true);
          debugPrint('[LoginAddProfile] Profile applied successfully');
        } catch (e) {
          debugPrint('[LoginAddProfile] Error applying profile: $e');
        }

        // Đợi một chút để đảm bảo state đã cập nhật
        await Future.delayed(const Duration(milliseconds: 300));

        if (mounted) {
          widget.onProfileAdded?.call();
        }
      } else {
        debugPrint('[LoginAddProfile] Profile is null after update');
        if (mounted) {
          ScaffoldMessenger.of(widget.parentContext).showSnackBar(
            const SnackBar(content: Text('Failed to add profile: Profile is null')),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('[LoginAddProfile] Error adding profile from URL: $e');
      debugPrint('[LoginAddProfile] Stack trace: $stackTrace');
      if (mounted) {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(
            content: Text('Failed to add profile: $e'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _toScan() async {
    if (_isLoading) return;

    if (system.isDesktop) {
      final url = await globalState.safeRun(picker.pickerConfigQRCode);
      if (url != null) {
        await _handleAddProfileFromURL(url);
      }
      return;
    }
    final url = await BaseNavigator.push(
      widget.parentContext,
      const ScanPage(),
    );
    if (url != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleAddProfileFromURL(url);
      });
    }
  }

  Future<void> _toAdd() async {
    if (_isLoading) return;

    final url = await globalState.showCommonDialog<String>(
      child: InputDialog(
        autovalidateMode: AutovalidateMode.onUnfocus,
        title: appLocalizations.importFromURL,
        labelText: appLocalizations.url,
        value: '',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return appLocalizations.emptyTip("").trim();
          }
          if (!value.isUrl) {
            return appLocalizations.urlTip("").trim();
          }
          return null;
        },
      ),
    );
    if (url != null) {
      await _handleAddProfileFromURL(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            ListItem(
              leading: const Icon(Icons.qr_code_sharp),
              title: Text(appLocalizations.qrcode),
              subtitle: Text(appLocalizations.qrcodeDesc),
              onTap: _isLoading ? null : _toScan,
            ),
            ListItem(
              leading: const Icon(Icons.upload_file_sharp),
              title: Text(appLocalizations.file),
              subtitle: Text(appLocalizations.fileDesc),
              onTap: _isLoading ? null : _handleAddProfileFromFile,
            ),
            ListItem(
              leading: const Icon(Icons.cloud_download_sharp),
              title: Text(appLocalizations.url),
              subtitle: Text(appLocalizations.urlDesc),
              onTap: _isLoading ? null : _toAdd,
            )
          ],
        ),
        if (_isLoading)
          Container(
            color: Colors.black26,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
