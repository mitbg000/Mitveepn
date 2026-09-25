import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mitveepn/common/common.dart';
import '../../../config/utils/config_file_loader.dart';
import '../../../core/logger/logger.dart';

/// Crisp Chat 客服支持页面
class CrispChatPage extends StatefulWidget {
  const CrispChatPage({super.key});

  @override
  State<CrispChatPage> createState() => _CrispChatPageState();
}

class _CrispChatPageState extends State<CrispChatPage> {
  bool _isLoading = true;
  String? _errorMessage;
  WebViewController? _webViewController;
  String? _crispWebsiteId;

  @override
  void initState() {
    super.initState();
    _initializeCrisp();
  }

  Future<void> _initializeCrisp() async {
    try {
      // 从配置获取 Crisp Website ID
      final crispId = await ConfigFileLoaderHelper.getCrispWebsiteId();

      if (crispId == null || crispId.isEmpty) {
        setState(() {
          _errorMessage = '未配置 Crisp Website ID';
          _isLoading = false;
        });
        return;
      }

      _crispWebsiteId = crispId;

      // 初始化 WebView
      _initializeWebView();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      XBoardLogger.error('初始化 Crisp Chat 失败', e);
      setState(() {
        _errorMessage = '初始化客服系统失败: $e';
        _isLoading = false;
      });
    }
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            XBoardLogger.info('WebView started loading: $url');
          },
          onPageFinished: (String url) {
            XBoardLogger.info('WebView finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            XBoardLogger.error('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://go.crisp.chat/chat/embed/?website_id=$_crispWebsiteId'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.onlineSupport),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('正在加载客服系统...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _initializeCrisp();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('重试'),
            ),
          ],
        ),
      );
    }

    // 显示 Crisp Chat WebView
    if (_webViewController != null) {
      return WebViewWidget(controller: _webViewController!);
    }

    return const Center(
      child: Text('加载失败'),
    );
  }
}
