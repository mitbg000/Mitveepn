import 'dart:io';

import 'package:mitveepn/common/common.dart';
import 'package:mitveepn/l10n/l10n.dart';
import 'package:mitveepn/models/models.dart';
import 'package:mitveepn/providers/providers.dart';
import 'package:mitveepn/views/access.dart';
import 'package:mitveepn/views/application_setting.dart';
import 'package:mitveepn/views/config/config.dart';
import 'package:mitveepn/views/core_status_section.dart';
import 'package:mitveepn/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show dirname, join;

import 'developer.dart';
import 'theme.dart';

class ToolsView extends ConsumerStatefulWidget {
  const ToolsView({super.key});

  @override
  ConsumerState<ToolsView> createState() => _ToolboxViewState();
}

class _ToolboxViewState extends ConsumerState<ToolsView> {
  _buildNavigationMenuItem(NavigationItem navigationItem) {
    return ListItem.open(
      leading: navigationItem.icon,
      title: Text(Intl.message(navigationItem.label.name)),
      subtitle: navigationItem.description != null
          ? Text(Intl.message(navigationItem.description!))
          : null,
      delegate: OpenDelegate(
        title: Intl.message(navigationItem.label.name),
        widget: navigationItem.view,
      ),
    );
  }

  Widget _buildNavigationMenu(List<NavigationItem> navigationItems) {
    return Column(
      children: [
        for (final navigationItem in navigationItems) ...[
          _buildNavigationMenuItem(navigationItem),
          navigationItems.last != navigationItem
              ? const Divider(
                  height: 0,
                )
              : Container(),
        ]
      ],
    );
  }

  List<Widget> _getOtherList(bool enableDeveloperMode) {
    return generateSection(
      title: appLocalizations.other,
      items: [
        if (enableDeveloperMode) _DeveloperItem(),
      ],
    );
  }

  _getSettingList() {
    return generateSection(
      title: appLocalizations.settings,
      items: [
        _LocaleItem(),
        _ThemeItem(),
        if (Platform.isWindows) _LoopbackItem(),
        if (Platform.isAndroid) _AccessItem(),
        _ConfigItem(),
        _SettingItem(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm2 = ref.watch(
      appSettingProvider.select(
        (state) => VM2(a: state.locale, b: state.developerMode),
      ),
    );
    final items = [
      CoreStatusSection(),
      const Divider(height: 1, thickness: 1),
      Consumer(
        builder: (_, ref, __) {
          final state = ref.watch(moreToolsSelectorStateProvider);
          if (state.navigationItems.isEmpty) {
            return Container();
          }
          return Column(
            children: [
              ListHeader(title: appLocalizations.more),
              _buildNavigationMenu(state.navigationItems)
            ],
          );
        },
      ),
      ..._getSettingList(),
      ..._getOtherList(vm2.b),
    ];
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, index) => items[index],
      padding: const EdgeInsets.only(bottom: 20),
    );
  }
}

class _LocaleItem extends ConsumerWidget {
  const _LocaleItem();

  static const List<String> _preferredOrder = [
    'en',
    'zh_CN',
    'vi',
  ];

  String _getLocaleString(Locale? locale) {
    if (locale == null) return appLocalizations.defaultText;
    switch (locale.toString()) {
      case 'en':
        return appLocalizations.en;
      case 'zh_CN':
        return appLocalizations.zh_CN;
      case 'vi':
        return appLocalizations.vi;
      default:
        return locale.toString();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale =
        ref.watch(appSettingProvider.select((state) => state.locale));
    final currentLocale = utils.getLocaleForString(locale);
    final supportedLocales = AppLocalizations.delegate.supportedLocales;

    final localeMap = <String, Locale>{
      for (final supportedLocale in supportedLocales)
        supportedLocale.toString(): supportedLocale,
    };
    final sortedSupportedLocales = <Locale>[
      for (final code in _preferredOrder)
        if (localeMap[code] != null) localeMap[code]!,
      for (final supportedLocale in supportedLocales)
        if (!_preferredOrder.contains(supportedLocale.toString()))
          supportedLocale,
    ];

    Locale? supportedCurrentLocale;
    if (currentLocale != null) {
      for (final supportedLocale in supportedLocales) {
        if (supportedLocale.toString() == currentLocale.toString()) {
          supportedCurrentLocale = supportedLocale;
          break;
        }
      }
      supportedCurrentLocale ??= supportedLocales
          .cast<Locale?>()
          .firstWhere(
            (l) => l?.languageCode == currentLocale.languageCode,
            orElse: () => null,
          );
    }
    return ListItem<Locale?>.options(
      leading: const Icon(Icons.language_outlined),
      title: Text(appLocalizations.language),
      subtitle: Text(_getLocaleString(supportedCurrentLocale)),
      delegate: OptionsDelegate(
        title: appLocalizations.language,
        options: [null, ...sortedSupportedLocales],
        onChanged: (Locale? locale) {
          ref.read(appSettingProvider.notifier).updateState(
                (state) => state.copyWith(locale: locale?.toString()),
              );
        },
        textBuilder: (locale) => _getLocaleString(locale),
        value: supportedCurrentLocale,
      ),
    );
  }
}

class _ThemeItem extends StatelessWidget {
  const _ThemeItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.style),
      title: Text(appLocalizations.theme),
      subtitle: Text(appLocalizations.themeDesc),
      delegate: OpenDelegate(
        title: appLocalizations.theme,
        widget: const ThemeView(),
      ),
    );
  }
}

class _LoopbackItem extends StatelessWidget {
  const _LoopbackItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.lock),
      title: Text(appLocalizations.loopback),
      subtitle: Text(appLocalizations.loopbackDesc),
      onTap: () {
        windows?.runas(
          '"${join(dirname(Platform.resolvedExecutable), "EnableLoopback.exe")}"',
          "",
        );
      },
    );
  }
}

class _AccessItem extends StatelessWidget {
  const _AccessItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.view_list),
      title: Text(appLocalizations.accessControl),
      subtitle: Text(appLocalizations.accessControlDesc),
      delegate: OpenDelegate(
        title: appLocalizations.appAccessControl,
        widget: const AccessView(),
      ),
    );
  }
}

class _ConfigItem extends StatelessWidget {
  const _ConfigItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.edit),
      title: Text(appLocalizations.basicConfig),
      subtitle: Text(appLocalizations.basicConfigDesc),
      delegate: OpenDelegate(
        title: appLocalizations.override,
        widget: const ConfigView(),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  const _SettingItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.settings),
      title: Text(appLocalizations.application),
      subtitle: Text(appLocalizations.applicationDesc),
      delegate: OpenDelegate(
        title: appLocalizations.application,
        widget: const ApplicationSettingView(),
      ),
    );
  }
}

class _DeveloperItem extends StatelessWidget {
  const _DeveloperItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.developer_board),
      title: Text(appLocalizations.developerMode),
      delegate: OpenDelegate(
        title: appLocalizations.developerMode,
        widget: const DeveloperView(),
      ),
    );
  }
}
