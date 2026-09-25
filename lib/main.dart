import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:mitveepn/plugins/app.dart';
import 'package:mitveepn/plugins/tile.dart';
import 'package:mitveepn/plugins/vpn.dart';
import 'package:mitveepn/state.dart';
import 'package:mitveepn/xboard/config/xboard_config.dart';
import 'package:mitveepn/xboard/config/utils/config_file_loader.dart'; // 配置文件加载器
import 'package:mitveepn/xboard/infrastructure/network/domain_racing_service.dart'; // 域名竞速服务
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application.dart';
import 'clash/core.dart';
import 'clash/lib.dart';
import 'common/common.dart';
import 'models/models.dart';
import 'package:mitveepn/xboard/features/remote_task/remote_task_manager.dart'; // 导入远程任务管理器

import 'package:mitveepn/xboard/sdk/xboard_sdk.dart'; // 导入域名服务

// 定义一个全局变量来持有 RemoteTaskManager 实例，方便在整个应用生命周期中访问和管理
RemoteTaskManager? remoteTaskManager;

/// Trần thời gian cho phần khởi tạo cần mạng. Khi mất mạng, chuỗi
/// fetch config (2 nguồn × 4 lần thử × timeout 30s) cộng với竞速 domain có thể
/// treo vài phút; vì toàn bộ nằm trước runApp() nên app chỉ hiện cửa sổ trắng.
const _xboardInitTimeout = Duration(seconds: 15);

Future<void> main() async {
  globalState.isService = false;
  WidgetsFlutterBinding.ensureInitialized(); // 确保 Flutter 绑定已初始化

  // 首先初始化XBoard配置模块和域名服务（必须在RemoteTaskManager之前）
  await _initializeXBoardServices();

  // 初始化 RemoteTaskManager - 已禁用 (WebSocket 功能不需要)
  // try {
  //   remoteTaskManager = await RemoteTaskManager.create();
  //   if (remoteTaskManager != null) {
  //     remoteTaskManager!.initialize(); // 初始化管理器
  //     remoteTaskManager!.start(); // 启动 WebSocket 连接
  //     print('RemoteTaskManager 从配置初始化成功');
  //   } else {
  //     print('警告: RemoteTaskManager 初始化失败 - 配置中未找到 WebSocket URL，应用将继续启动但远程任务功能不可用');
  //   }
  // } catch (e) {
  //   print('警告: RemoteTaskManager 初始化异常: $e，应用将继续启动但远程任务功能不可用');
  //   remoteTaskManager = null;
  // }
  print('[Main] RemoteTaskManager 已禁用 - 不使用 WebSocket 功能');

  final version = await system.version;
  await clashCore.preload();
  await globalState.initApp(version);
  await android?.init();
  await window?.init(version); // 假设 window?.init(version) 是正确的调用
  HttpOverrides.global = MitveepnHttpOverrides();

  // 注册 WidgetsBindingObserver 来监听应用生命周期事件
  WidgetsBinding.instance.addObserver(AppLifecycleObserver());

  runApp(ProviderScope(
    child: const Application(),
  ));
}

/// 加载安全配置（证书路径、UA、解密密钥等）
Future<void> _loadSecurityConfig() async {
  try {
    // 加载证书配置
    final certConfig = await ConfigFileLoaderHelper.getCertificateConfig();
    final certPath = certConfig['path'] as String?;
    final certEnabled = certConfig['enabled'] as bool? ?? true;
    
    if (certEnabled && certPath != null && certPath.isNotEmpty) {
      // 设置证书路径（需要添加 packages/ 前缀）
      final fullCertPath = certPath.startsWith('packages/') 
          ? certPath 
          : 'packages/$certPath';
      DomainRacingService.setCertificatePath(fullCertPath);
      print('[Main] 证书路径配置: $fullCertPath');
    }
    
    // 其他安全配置可以在这里加载
    // 如 UA、解密密钥等
    
  } catch (e) {
    print('[Main] 加载安全配置失败（使用默认值）: $e');
  }
}

/// 初始化XBoard配置模块和域名服务
Future<void> _initializeXBoardServices() async {
  try {
    print('[Main] 开始初始化XBoard配置模块...');
    
    // 1. 从配置文件加载配置（开源友好：用户只需修改 xboard.config.yaml）
    final configSettings = await ConfigFileLoader.loadFromFile();
    print('[Main] 配置文件加载成功，Provider: ${configSettings.currentProvider}');
    
    // 2. 加载安全配置（UA、证书、解密密钥等）
    await _loadSecurityConfig();
    print('[Main] 安全配置加载成功');
    
    // 3. 初始化V2配置模块
    await XBoardConfig.initialize(settings: configSettings)
        .timeout(_xboardInitTimeout);
    print('[Main] XBoard配置模块初始化成功');

    // 4. 初始化XBoard SDK
    await XBoardSDK.initialize(
      configProvider: XBoardConfig.provider,
      baseUrl: null, // 没有基础URL，完全依赖域名服务
      strategy: 'race_fastest',
    ).timeout(_xboardInitTimeout);

    print('[Main] XBoard SDK初始化成功');

  } on TimeoutException catch (e) {
    print('[Main] XBoard服务初始化quá thời gian chờ (mất mạng?): $e');
    // Không rethrow: app phải vào được UI để chạy offline bằng dữ liệu đã lưu.
  } catch (e) {
    print('[Main] XBoard服务初始化失败（可能是网络问题）: $e');
    // 不 rethrow：此时还在 runApp() 之前，若抛出异常应用将永远停留在启动画面。
    // 让应用继续启动，DomainStatusService 在检查域名时会自动重试初始化 XBoardSDK。
  }
}


// 创建一个 AppLifecycleObserver 类来处理应用生命周期事件
class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 当应用被完全终止时（例如，从任务管理器中划掉），释放资源
    if (state == AppLifecycleState.detached) {
      remoteTaskManager?.dispose();
      XBoardSDK.dispose(); // 释放SDK资源
      print('应用生命周期状态改变: $state, 所有服务资源已释放。');
    }
  }
}

@pragma('vm:entry-point')
Future<void> _service(List<String> flags) async {
  globalState.isService = true;
  WidgetsFlutterBinding.ensureInitialized();
  final quickStart = flags.contains("quick");
  final clashLibHandler = ClashLibHandler();
  await globalState.init();

  tile?.addListener(
    _TileListenerWithService(
      onStop: () async {
        await app?.tip(appLocalizations.stopVpn);
        clashLibHandler.stopListener();
        await vpn?.stop();
        exit(0);
      },
    ),
  );

  vpn?.handleGetStartForegroundParams = () {
    final traffic = clashLibHandler.getTraffic();
    return json.encode({
      "title": clashLibHandler.getCurrentProfileName(),
      "content": "$traffic"
    });
  };

  vpn?.addListener(
    _VpnListenerWithService(
      onDnsChanged: (String dns) {
        print("handle dns $dns");
        clashLibHandler.updateDns(dns);
      },
    ),
  );
  if (!quickStart) {
    _handleMainIpc(clashLibHandler);
  } else {
    commonPrint.log("quick start");
    await ClashCore.initGeo();
    app?.tip(appLocalizations.startVpn);
    final homeDirPath = await appPath.homeDirPath;
    final version = await system.version;
    final clashConfig = globalState.config.patchClashConfig.copyWith.tun(
      enable: true,
    );
    Future(() async {
      final profileId = globalState.config.currentProfileId;
      if (profileId == null) {
        return;
      }
      final params = await globalState.getSetupParams(
        pathConfig: clashConfig,
      );
      final res = await clashLibHandler.quickStart(
        InitParams(
          homeDir: homeDirPath,
          version: version,
        ),
        params,
        globalState.getCoreState(),
      );
      debugPrint(res);
      if (res.isNotEmpty) {
        await vpn?.stop();
        exit(0);
      }
      await vpn?.start(
        clashLibHandler.getAndroidVpnOptions(),
      );
      clashLibHandler.startListener();
    });
  }
}

_handleMainIpc(ClashLibHandler clashLibHandler) {
  final sendPort = IsolateNameServer.lookupPortByName(mainIsolate);
  if (sendPort == null) {
    return;
  }
  final serviceReceiverPort = ReceivePort();
  serviceReceiverPort.listen((message) async {
    final res = await clashLibHandler.invokeAction(message);
    sendPort.send(res);
  });
  sendPort.send(serviceReceiverPort.sendPort);
  final messageReceiverPort = ReceivePort();
  clashLibHandler.attachMessagePort(
    messageReceiverPort.sendPort.nativePort,
  );
  messageReceiverPort.listen((message) {
    sendPort.send(message);
  });
}

@immutable
class _TileListenerWithService with TileListener {
  final Function() _onStop;

  const _TileListenerWithService({
    required Function() onStop,
  }) : _onStop = onStop;

  @override
  void onStop() {
    _onStop();
  }
}

@immutable
class _VpnListenerWithService with VpnListener {
  final Function(String dns) _onDnsChanged;

  const _VpnListenerWithService({
    required Function(String dns) onDnsChanged,
  }) : _onDnsChanged = onDnsChanged;

  @override
  void onDnsChanged(String dns) {
    super.onDnsChanged(dns);
    _onDnsChanged(dns);
  }
}
