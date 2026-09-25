import 'package:mitveepn/providers/providers.dart';
import 'package:mitveepn/common/common.dart';
import 'package:mitveepn/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  static const List<String> _preferredOrder = [
    'en',
    'zh_CN',
    'vi',
  ];

  List<Locale?> _getLocaleOptions() {
    final supportedLocales = AppLocalizations.delegate.supportedLocales;
    final localeMap = <String, Locale>{
      for (final locale in supportedLocales) locale.toString(): locale,
    };

    final orderedLocales = <Locale>[
      for (final code in _preferredOrder)
        if (localeMap[code] != null) localeMap[code]!,
      for (final locale in supportedLocales)
        if (!_preferredOrder.contains(locale.toString())) locale,
    ];

    return [null, ...orderedLocales];
  }

  String _getLocaleLabel(Locale? locale) {
    if (locale == null) return appLocalizations.defaultText;
    switch (locale.toString()) {
      case 'zh_CN':
        return appLocalizations.zh_CN;
      case 'en':
        return appLocalizations.en;
      case 'vi':
        return appLocalizations.vi;
      default:
        return locale.toString();
    }
  }

  String _getLocaleFlag(Locale? locale) {
    switch (locale?.toString()) {
      case 'zh_CN':
        return '🇨🇳';
      case 'en':
        return '🌐';
      case 'vi':
        return '🇻🇳';
      default:
        return '🌐';
    }
  }

  String _getLocaleShortCode(Locale? locale) {
    if (locale == null) return 'AUTO';
    if (locale.toString() == 'zh_CN') return '中';
    return locale.languageCode.toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final appSetting = ref.watch(appSettingProvider);
    final currentLocale = appSetting.locale;
    final currentLocaleObj = utils.getLocaleForString(currentLocale);
    final localeOptions = _getLocaleOptions();

    final selectedLocale = currentLocaleObj == null
        ? null
        : localeOptions
            .whereType<Locale>()
            .firstWhere(
              (l) => l.toString() == currentLocaleObj.toString(),
              orElse: () => currentLocaleObj,
            );

    return PopupMenuButton<Locale?>(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getLocaleFlag(selectedLocale),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 6),
            Text(
              _getLocaleShortCode(selectedLocale),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.expand_more,
              color: colorScheme.onSurfaceVariant,
              size: 18,
            ),
          ],
        ),
      ),
      tooltip: appLocalizations.language,
      onSelected: (Locale? locale) {
        ref.read(appSettingProvider.notifier).updateState(
          (state) => state.copyWith(locale: locale?.toString()),
        );
      },
      itemBuilder: (BuildContext context) {
        return localeOptions.map<PopupMenuEntry<Locale?>>((locale) {
          final isSelected = locale?.toString() == selectedLocale?.toString();
          return PopupMenuItem<Locale?>(
            value: locale,
              child: Row(
                children: [
                  Text(
                    _getLocaleFlag(locale),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getLocaleLabel(locale),
                      style: TextStyle(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check,
                      color: colorScheme.primary,
                      size: 18,
                    ),
                ],
              ),
          );
        }).toList();
      },
    );
  }
}
