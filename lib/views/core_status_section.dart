import 'dart:io';

import 'package:mitveepn/common/common.dart';
import 'package:mitveepn/enum/enum.dart';
import 'package:mitveepn/models/models.dart';
import 'package:mitveepn/providers/providers.dart';
import 'package:mitveepn/state.dart';
import 'package:mitveepn/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoreStatusSection extends ConsumerWidget {
  const CoreStatusSection({super.key});

  String _getModeLabel(BuildContext context, Mode mode) {
    switch (mode) {
      case Mode.rule:
        return appLocalizations.rule;
      case Mode.global:
        return appLocalizations.global;
      case Mode.direct:
        return appLocalizations.direct;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(runTimeProvider) != null;
    final vpnProps = ref.watch(vpnSettingProvider);
    final networkProps = ref.watch(networkSettingProvider);
    final mode = ref.watch(patchClashConfigProvider.select((state) => state.mode));
    final isTunMode = ref.watch(vpnSettingProvider.select((state) => state.enable));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            appLocalizations.xboardCoreStatus,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Connected status (read-only)
        ListItem(
          leading: Icon(
            isConnected ? Icons.check_circle : Icons.cancel,
            color: isConnected ? Colors.green : Colors.grey,
          ),
          title: Text(appLocalizations.xboardConnected),
          trailing: Text(
            isConnected ? appLocalizations.xboardYes : appLocalizations.xboardNo,
            style: TextStyle(
              color: isConnected ? Colors.green : context.textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Divider(height: 0),

        // System proxy toggle
        ListItem.switchItem(
          leading: const Icon(Icons.settings_ethernet),
          title: Text(appLocalizations.systemProxy),
          subtitle: Text(networkProps.systemProxy ? appLocalizations.xboardEnabled : appLocalizations.xboardDisabled),
          delegate: SwitchDelegate(
            value: networkProps.systemProxy,
            onChanged: (value) {
              globalState.appController.updateSystemProxy();
            },
          ),
        ),

        if (Platform.isAndroid) ...[
          const Divider(height: 0),
          // Attach HTTP proxy to VpnService toggle (Android only)
          ListItem.switchItem(
            leading: const Icon(Icons.link),
            title: Text(appLocalizations.vpnSystemProxyDesc),
            delegate: SwitchDelegate(
              value: vpnProps.systemProxy,
              onChanged: (value) {
                ref.read(vpnSettingProvider.notifier).updateState(
                  (state) => state.copyWith(systemProxy: value),
                );
              },
            ),
          ),
        ],

        const Divider(height: 0),

        // TUN toggle
        ListItem.switchItem(
          leading: const Icon(Icons.vpn_lock),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(appLocalizations.tun),
              if (Platform.isWindows || Platform.isLinux)
                Text(
                  appLocalizations.tunDesc,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
          subtitle: Text(isTunMode ? appLocalizations.xboardEnabled : appLocalizations.xboardDisabled),
          delegate: SwitchDelegate(
            value: isTunMode,
            onChanged: (value) {
              globalState.appController.updateTun();
            },
          ),
        ),

        const Divider(height: 0),

        // Outbound mode selector
        ListItem<Mode>.options(
          leading: const Icon(Icons.alt_route),
          title: Text(appLocalizations.outboundMode),
          subtitle: Text(_getModeLabel(context, mode)),
          delegate: OptionsDelegate(
            title: appLocalizations.outboundMode,
            options: Mode.values,
            onChanged: (Mode? value) {
              if (value != null) {
                ref.read(patchClashConfigProvider.notifier).updateState(
                  (state) => state.copyWith(mode: value),
                );
              }
            },
            textBuilder: (mode) => _getModeLabel(context, mode),
            value: mode,
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
