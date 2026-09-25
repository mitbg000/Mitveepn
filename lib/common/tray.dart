import 'dart:io';

import 'package:mitveepn/common/utils.dart';
import 'package:mitveepn/enum/enum.dart';
import 'package:mitveepn/models/models.dart';
import 'package:mitveepn/state.dart';
import 'package:mitveepn/views/proxies/common.dart' as proxies_common;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tray_manager/tray_manager.dart';

import 'app_localizations.dart';
import 'constant.dart';
import 'window.dart';

class Tray {
  Future _updateSystemTray({
    required Brightness? brightness,
    bool force = false,
  }) async {
    if (Platform.isAndroid) {
      return;
    }
    if (Platform.isLinux || force) {
      await trayManager.destroy();
    }
    await trayManager.setIcon(
      utils.getTrayIconPath(
        brightness: brightness ??
            WidgetsBinding.instance.platformDispatcher.platformBrightness,
      ),
      // isTemplate: true sẽ khiến macOS render icon thành ảnh 1 màu (đen/trắng
      // theo theme), làm mất màu gốc. Giữ false để hiện đúng icon nhiều màu.
      isTemplate: false,
    );
    if (!Platform.isLinux) {
      await trayManager.setToolTip(
        appName,
      );
    }
  }

  update({
    required TrayState trayState,
    bool focus = false,
  }) async {
    if (Platform.isAndroid) {
      return;
    }
    if (!Platform.isLinux) {
      await _updateSystemTray(
        brightness: trayState.brightness,
        force: focus,
      );
    }
    List<MenuItem> menuItems = [];
    final showMenuItem = MenuItem(
      label: appLocalizations.show,
      onClick: (_) {
        window?.show();
      },
    );
    menuItems.add(showMenuItem);
    final startMenuItem = MenuItem.checkbox(
      label: trayState.isStart ? appLocalizations.stop : appLocalizations.start,
      onClick: (_) async {
        globalState.appController.updateStart();
      },
      checked: false,
    );
    menuItems.add(startMenuItem);
    menuItems.add(MenuItem.separator());
    for (final mode in Mode.values) {
      menuItems.add(
        MenuItem.checkbox(
          label: Intl.message(mode.name),
          onClick: (_) {
            globalState.appController.changeMode(mode);
          },
          checked: mode == trayState.mode,
        ),
      );
    }
    menuItems.add(MenuItem.separator());
    if (Platform.isMacOS) {
      for (final group in trayState.groups) {
        List<MenuItem> subMenuItems = [];
        final nameWidth = group.all.fold<int>(
          0,
          (width, proxy) =>
              proxy.name.length > width ? proxy.name.length : width,
        );
        for (final proxy in group.all) {
          subMenuItems.add(
            MenuItem.checkbox(
              label: _proxyLabelWithDelay(proxy.name, nameWidth),
              checked: trayState.selectedMap[group.name] == proxy.name,
              onClick: (_) {
                final appController = globalState.appController;
                appController.updateCurrentSelectedMap(
                  group.name,
                  proxy.name,
                );
                appController.changeProxy(
                  groupName: group.name,
                  proxyName: proxy.name,
                );
              },
            ),
          );
        }
        menuItems.add(
          MenuItem.submenu(
            label: group.name,
            submenu: Menu(
              items: subMenuItems,
            ),
          ),
        );
      }
      if (trayState.groups.isNotEmpty) {
        menuItems.add(
          MenuItem(
            label: 'Test ping',
            onClick: (_) async {
              await _testAllProxiesDelay(trayState.groups);
            },
          ),
        );
        menuItems.add(MenuItem.separator());
      }
    }
    if (trayState.isStart) {
      menuItems.add(
        MenuItem.checkbox(
          label: appLocalizations.tun,
          onClick: (_) {
            globalState.appController.updateTun();
          },
          checked: trayState.tunEnable,
        ),
      );
      menuItems.add(
        MenuItem.checkbox(
          label: appLocalizations.systemProxy,
          onClick: (_) {
            globalState.appController.updateSystemProxy();
          },
          checked: trayState.systemProxy,
        ),
      );
      menuItems.add(MenuItem.separator());
    }
    final autoStartMenuItem = MenuItem.checkbox(
      label: appLocalizations.autoLaunch,
      onClick: (_) async {
        globalState.appController.updateAutoLaunch();
      },
      checked: trayState.autoLaunch,
    );
    final copyEnvVarMenuItem = MenuItem(
      label: appLocalizations.copyEnvVar,
      onClick: (_) async {
        await _copyEnv(trayState.port);
      },
    );
    menuItems.add(autoStartMenuItem);
    menuItems.add(copyEnvVarMenuItem);
    menuItems.add(MenuItem.separator());
    final exitMenuItem = MenuItem(
      label: appLocalizations.exit,
      onClick: (_) async {
        await globalState.appController.handleExit();
      },
    );
    menuItems.add(exitMenuItem);
    final menu = Menu(items: menuItems);
    await trayManager.setContextMenu(menu);
    if (Platform.isLinux) {
      await _updateSystemTray(
        brightness: trayState.brightness,
        force: focus,
      );
    }
  }

  updateTrayTitle([Traffic? traffic]) async {
    // if (!Platform.isMacOS) {
    //   return;
    // }
    // if (traffic == null) {
    //   await trayManager.setTitle("");
    // } else {
    //   await trayManager.setTitle(
    //     "${traffic.up.shortShow} ↑ \n${traffic.down.shortShow} ↓",
    //   );
    // }
  }

  Future<void> _copyEnv(int port) async {
    final url = "http://127.0.0.1:$port";

    final cmdline = Platform.isWindows
        ? "set \$env:all_proxy=$url"
        : "export all_proxy=$url";

    await Clipboard.setData(
      ClipboardData(
        text: cmdline,
      ),
    );
  }

  /// Nhãn hiển thị trong tray menu: tên proxy, ping đã test gần nhất (nếu có)
  /// được đẩy sang lề phải bằng khoảng trắng đệm theo [nameWidth].
  String _proxyLabelWithDelay(String proxyName, int nameWidth) {
    final testUrl = globalState.config.appSetting.testUrl;
    final delay = globalState.appState.delayMap[testUrl]?[proxyName];
    if (delay == null) {
      return proxyName;
    }
    final delayText = delay <= 0 ? 'timeout' : '${delay}ms';
    final padding = ' ' * (nameWidth - proxyName.length + 4);
    return '$proxyName$padding$delayText';
  }

  /// Test ping cho toàn bộ proxy đang có trong tray menu, sau đó rebuild menu
  /// một lần để hiện ping mới (tray_manager không hỗ trợ sửa label tại chỗ).
  Future<void> _testAllProxiesDelay(List<Group> groups) async {
    final allProxies = <String, Proxy>{};
    for (final group in groups) {
      for (final proxy in group.all) {
        allProxies[proxy.name] = proxy;
      }
    }
    if (allProxies.isEmpty) {
      return;
    }
    await proxies_common.delayTest(allProxies.values.toList());
    await globalState.appController.updateTray();
  }
}

final tray = Tray();
