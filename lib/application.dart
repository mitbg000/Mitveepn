import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mitveepn/clash/clash.dart';
import 'package:mitveepn/common/common.dart';
import 'package:mitveepn/l10n/l10n.dart';
import 'package:mitveepn/manager/hotkey_manager.dart';
import 'package:mitveepn/manager/manager.dart';
import 'package:mitveepn/plugins/app.dart';
import 'package:mitveepn/providers/providers.dart';
import 'package:mitveepn/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller.dart';
import 'pages/pages.dart';
import 'xboard/xboard.dart';
import 'package:mitveepn/xboard/sdk/xboard_sdk.dart';
import 'package:mitveepn/xboard/features/online_support/providers/websocket_auto_connector.dart';
import 'package:mitveepn/xboard/infrastructure/network/domain_racing_service.dart';

class Application extends ConsumerStatefulWidget {
  const Application({
    super.key,
  });

  @override
  ConsumerState<Application> createState() => ApplicationState();
}

class ApplicationState extends ConsumerState<Application> {
  Timer? _autoUpdateGroupTaskTimer;

  final _pageTransitionsTheme = const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: CommonPageTransitionsBuilder(),
      TargetPlatform.windows: CommonPageTransitionsBuilder(),
      TargetPlatform.linux: CommonPageTransitionsBuilder(),
      TargetPlatform.macOS: CommonPageTransitionsBuilder(),
    },
  );

  ColorScheme _getAppColorScheme({
    required Brightness brightness,
    int? primaryColor,
  }) {
    return ref.read(genColorSchemeProvider(brightness));
  }

  @override
  void initState() {
    super.initState();
    _autoUpdateGroupTask();
    // Tắt tự động tải lại subscription theo lịch — profile đã thêm chỉ
    // được cập nhật khi người dùng bấm Update thủ công.
    globalState.appController = AppController(context, ref);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final currentContext = globalState.navigatorKey.currentContext;
      if (currentContext != null) {
        globalState.appController = AppController(currentContext, ref);
      }
      await globalState.appController.init();
      globalState.appController.initLink();
      app?.initShortcuts();

      // 使用新的域名服务架构，简化认证检查
      _performQuickAuthWithDomainService();
    });
  }

  /// 使用新域名服务架构进行快速认证检查
  void _performQuickAuthWithDomainService() {
    // 立即检查token存在性，不延迟
    Future.microtask(() async {
      try {
        print('[Application] 开始使用新域名服务进行快速认证检查...');

        // 优先获取Flclash入口域名
        String? entryDomain;

        try {
          // 使用竞速方式获取最快的入口域名
          entryDomain = await XBoardConfig.getFastestPanelUrl();
          print('[Application] 竞速获取到最快Flclash入口域名: $entryDomain');
        } catch (e) {
          print('[Application] 竞速获取域名失败，尝试传统方式: $e');
          // 降级到传统方式
          try {
            entryDomain = XBoardConfig.panelUrl;
            print('[Application] 传统方式获取到Flclash入口域名: $entryDomain');
          } catch (e2) {
            print('[Application] 获取Flclash入口域名完全失败: $e2');
            entryDomain = null;
          }
        }

        final userNotifier = ref.read(xboardUserProvider.notifier);
        await userNotifier.quickAuth();

        // 强制刷新UI，确保_AppHomeRouter能够响应最新的认证状态
        if (mounted) {
          setState(() {});
        }

        print('[Application] 快速认证检查完成');
      } catch (e) {
        print('[Application] 快速认证检查失败: $e');
        // 即使认证检查失败，也要确保UI能正常显示
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  _autoUpdateGroupTask() {
    _autoUpdateGroupTaskTimer = Timer(const Duration(milliseconds: 20000), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        globalState.appController.updateGroupsDebounce();
        _autoUpdateGroupTask();
      });
    });
  }

  _buildPlatformState(Widget child) {
    if (system.isDesktop) {
      return WindowManager(
        child: TrayManager(
          child: HotKeyManager(
            child: ProxyManager(
              child: child,
            ),
          ),
        ),
      );
    }
    return AndroidManager(
      child: TileManager(
        child: child,
      ),
    );
  }

  _buildState(Widget child) {
    return AppStateManager(
      child: ClashManager(
        child: ConnectivityManager(
          onConnectivityChanged: (results) async {
            if (!results.contains(ConnectivityResult.vpn)) {
              await clashCore.closeConnections();
            }
            // Đổi mạng thì domain nhanh nhất có thể khác, bỏ cache竞速.
            DomainRacingService.clearCache();
            globalState.appController.updateLocalIp();
            globalState.appController.addCheckIpNumDebounce();
          },
          child: child,
        ),
      ),
    );
  }

  _buildPlatformApp(Widget child) {
    if (system.isDesktop) {
      return WindowHeaderContainer(
        child: child,
      );
    }
    return VpnManager(
      child: child,
    );
  }

  _buildApp(Widget child) {
    return MessageManager(
      child: ThemeManager(
        child: child,
      ),
    );
  }

  @override
  Widget build(context) {
    return _buildPlatformState(
      _buildState(
        Consumer(
          builder: (_, ref, child) {
            // 初始化 WebSocket 自动连接器 - 监听登录状态并自动管理 WebSocket 连接
            // 这个 Provider 会在登录成功时自动连接,登出时自动断开
            ref.watch(webSocketAutoConnectorProvider);

            final localeString =
                ref.watch(appSettingProvider.select((state) => state.locale));
            final themeProps = ref.watch(themeSettingProvider);
            final parsedLocale = utils.getLocaleForString(localeString);
            Locale? resolvedLocale;
            if (parsedLocale != null) {
              for (final supportedLocale
                  in AppLocalizations.delegate.supportedLocales) {
                if (supportedLocale.toString() == parsedLocale.toString()) {
                  resolvedLocale = supportedLocale;
                  break;
                }
              }
              resolvedLocale ??= AppLocalizations.delegate.supportedLocales
                  .cast<Locale?>()
                  .firstWhere(
                    (l) => l?.languageCode == parsedLocale.languageCode,
                    orElse: () => null,
                  );
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: globalState.navigatorKey,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              builder: (_, child) {
                return AppEnvManager(
                  child: _buildPlatformApp(
                    _buildApp(child!),
                  ),
                );
              },
              scrollBehavior: BaseScrollBehavior(),
              title: appName,
              locale: resolvedLocale,
              supportedLocales: AppLocalizations.delegate.supportedLocales,
              themeMode: themeProps.themeMode,
              theme: ThemeData(
                useMaterial3: true,
                pageTransitionsTheme: _pageTransitionsTheme,
                colorScheme: _getAppColorScheme(
                  brightness: Brightness.light,
                  primaryColor: themeProps.primaryColor,
                ),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                pageTransitionsTheme: _pageTransitionsTheme,
                colorScheme: _getAppColorScheme(
                  brightness: Brightness.dark,
                  primaryColor: themeProps.primaryColor,
                ).toPureBlack(themeProps.pureBlack),
              ),
              home: child,
            );
          },
          child: const _AppHomeRouter(),
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    try {
      linkManager.destroy();
      _autoUpdateGroupTaskTimer?.cancel();

      // 释放XBoard SDK资源
      try {
        XBoardSDK.dispose();
        // ignore: empty_catches
      } catch (e) {}

      await clashCore.destroy();
      await globalState.appController.savePreferences();
      await globalState.appController.handleExit();

      // ignore: empty_catches
    } catch (e) {}

    super.dispose();
  }
}

/// 应用主页面路由器 - 根据认证状态自动选择页面
class _AppHomeRouter extends ConsumerStatefulWidget {
  const _AppHomeRouter();

  @override
  ConsumerState<_AppHomeRouter> createState() => _AppHomeRouterState();
}

class _AppHomeRouterState extends ConsumerState<_AppHomeRouter> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(xboardUserProvider);
    final userInfo = ref.watch(userInfoProvider);
    final profiles = ref.watch(profilesProvider);
    final hasProfiles = profiles.isNotEmpty;

    debugPrint(
        '[_AppHomeRouter] build called. isAuthenticated: ${userState.isAuthenticated}, isInitialized: ${userState.isInitialized}, hasProfiles: $hasProfiles');

    // Kiểm tra authentication trước
    if (userState.isAuthenticated) {
      debugPrint('[_AppHomeRouter] 状态: 已认证，跳转到主页面');
      return const HomePage();
    }

    if (userState.isInitialized) {
      // Nếu có profile thì vẫn cho vào app (trường hợp chưa đăng nhập nhưng có profile thủ công)
      // NHƯNG nếu user đã logout (có user info trước đó), thì phải về login
      if (hasProfiles && userInfo == null) {
        debugPrint('[_AppHomeRouter] 状态: 有配置文件且未登录过，跳转到主页面 (无需登录)');
        return const HomePage();
      }

      debugPrint('[_AppHomeRouter] 状态: 未认证但已初始化，显示登录页面');
      return const LoginPage();
    } else {
      debugPrint('[_AppHomeRouter] 状态: 初始化中，显示加载页面');
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
