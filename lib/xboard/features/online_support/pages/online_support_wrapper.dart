import 'package:flutter/material.dart';
import 'package:mitveepn/common/common.dart';
import 'package:mitveepn/xboard/config/utils/config_file_loader.dart';
import 'package:mitveepn/xboard/features/online_support/services/service_config.dart';
import 'crisp_chat_page.dart';
import 'online_support_page.dart';

/// 在线客服包装器 - 根据配置自动选择 Crisp 或传统客服
class OnlineSupportWrapper extends StatefulWidget {
  const OnlineSupportWrapper({super.key});

  @override
  State<OnlineSupportWrapper> createState() => _OnlineSupportWrapperState();
}

class _OnlineSupportWrapperState extends State<OnlineSupportWrapper> {
  bool _isLoading = true;
  bool _useCrisp = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkConfig();
  }

  Future<void> _checkConfig() async {
    try {
      // 检查是否启用客服支持
      final isEnabled = await ConfigFileLoaderHelper.isCustomerSupportEnabled();

      if (!isEnabled) {
        setState(() {
          _errorMessage = appLocalizations.xboardCustomerSupportNotEnabled;
          _isLoading = false;
        });
        return;
      }

      // 检查是否配置了 Crisp
      final crispId = await ConfigFileLoaderHelper.getCrispWebsiteId();

      setState(() {
        _useCrisp = (crispId != null && crispId.isNotEmpty);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = appLocalizations.xboardLoadConfigFailed(e.toString());
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(appLocalizations.onlineSupport),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(appLocalizations.onlineSupport),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 根据配置返回对应的页面
    return _useCrisp ? const CrispChatPage() : const OnlineSupportPage();
  }
}
