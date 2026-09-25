import 'dart:io';

import 'package:mitveepn/common/common.dart';
import 'package:mitveepn/enum/enum.dart';
import 'package:mitveepn/models/models.dart';
import 'package:mitveepn/providers/providers.dart';
import 'package:mitveepn/state.dart';
import 'package:mitveepn/widgets/widgets.dart';
import 'package:mitveepn/xboard/features/online_support/providers/chat_provider.dart';
import 'package:mitveepn/xboard/features/online_support/services/service_config.dart';
import 'package:mitveepn/xboard/features/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

typedef OnSelected = void Function(int index);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeBackScope(
      child: Consumer(
        builder: (_, ref, child) {
          final state = ref.watch(homeStateProvider);
          final viewMode = state.viewMode;
          final navigationItems = state.navigationItems;
          final pageLabel = state.pageLabel;
          final index = navigationItems.lastIndexWhere(
            (element) => element.label == pageLabel,
          );
          final currentIndex = index == -1 ? 0 : index;
          final navigationBar = CommonNavigationBar(
            viewMode: viewMode,
            navigationItems: navigationItems,
            currentIndex: currentIndex,
          );
          final bottomNavigationBar =
              viewMode == ViewMode.mobile ? navigationBar : null;
          final sideNavigationBar =
              viewMode != ViewMode.mobile ? navigationBar : null;
          return CommonScaffold(
            key: globalState.homeScaffoldKey,
            title: _pageTitle(pageLabel),
            sideNavigationBar: sideNavigationBar,
            body: child!,
            bottomNavigationBar: bottomNavigationBar,
            leadingWidth: pageLabel == PageLabel.xboard ? 100 : null,
            backgroundColor:
                pageLabel == PageLabel.xboard ? const Color(0xFF0D1216) : null,
          );
        },
        child: _HomePageView(),
      ),
    );
  }

  String _pageTitle(PageLabel label) {
    return switch (label) {
      PageLabel.xboard => appLocalizations.xboardHome,
      PageLabel.proxies => appLocalizations.proxies,
      PageLabel.tools => appLocalizations.settings,
      PageLabel.profiles => appLocalizations.profiles,
      _ => Intl.message(label.name),
    };
  }
}

class _HomePageView extends ConsumerStatefulWidget {
  const _HomePageView();

  @override
  ConsumerState createState() => _HomePageViewState();
}

class _HomePageViewState extends ConsumerState<_HomePageView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _pageIndex,
      keepPage: true,
    );
    ref.listenManual(currentPageLabelProvider, (prev, next) {
      if (prev != next) {
        _toPage(next);
      }
    });
    ref.listenManual(currentNavigationsStateProvider, (prev, next) {
      if (prev?.value.length != next.value.length) {
        _updatePageController();
      }
    });
  }

  int get _pageIndex {
    final navigationItems = ref.read(currentNavigationsStateProvider).value;
    return navigationItems.indexWhere(
      (item) => item.label == globalState.appState.pageLabel,
    );
  }

  _toPage(PageLabel pageLabel, [bool ignoreAnimateTo = false]) async {
    if (!mounted) {
      return;
    }
    final navigationItems = ref.read(currentNavigationsStateProvider).value;
    final index = navigationItems.indexWhere((item) => item.label == pageLabel);
    if (index == -1) {
      return;
    }
    final isAnimateToPage = ref.read(appSettingProvider).isAnimateToPage;
    final isMobile = ref.read(isMobileViewProvider);
    if (isAnimateToPage && isMobile && !ignoreAnimateTo) {
      await _pageController.animateToPage(
        index,
        duration: kTabScrollDuration,
        curve: Curves.easeOut,
      );
    } else {
      _pageController.jumpToPage(index);
    }
  }

  _updatePageController() {
    final pageLabel = globalState.appState.pageLabel;
    _toPage(pageLabel, true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigationItems = ref.watch(currentNavigationsStateProvider).value;
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: navigationItems.length,
      // onPageChanged: (index) {
      //   debouncer.call(DebounceTag.pageChange, () {
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       if (_pageIndex != index) {
      //         final pageLabel = navigationItems[index].label;
      //         _toPage(pageLabel, true);
      //       }
      //     });
      //   });
      // },
      itemBuilder: (_, index) {
        final navigationItem = navigationItems[index];
        return KeepScope(
          keep: navigationItem.keep,
          key: Key(navigationItem.label.name),
          child: navigationItem.view,
        );
      },
    );
  }
}

class CommonNavigationBar extends ConsumerWidget {
  final ViewMode viewMode;
  final List<NavigationItem> navigationItems;
  final int currentIndex;

  const CommonNavigationBar({
    super.key,
    required this.viewMode,
    required this.navigationItems,
    required this.currentIndex,
  });

  // 为指定的 PageLabel 创建带未读标记的图标
  Widget _buildIconWithBadge(PageLabel label, Widget icon, WidgetRef ref) {
    // 只有联系客服页面需要显示未读标记
    if (label == PageLabel.onlineSupport) {
      // Chưa có cấu hình API online support (ví dụ mất mạng lúc khởi động)
      // thì không đọc chatProvider, tránh throw exception làm crash UI.
      final unreadCount = CustomerSupportServiceConfig.apiBaseUrl != null
          ? ref.watch(chatProvider).unreadCount
          : 0;

      return BadgeIcon(
        icon: icon,
        count: unreadCount,
      );
    }
    return icon;
  }

  @override
  Widget build(BuildContext context, ref) {
    if (viewMode == ViewMode.mobile) {
      // Filter out plans page from bottom navigation
      final visibleItems = navigationItems
          .where((item) => item.label != PageLabel.plans)
          .toList();
      final visibleIndex = visibleItems.indexWhere(
        (item) => item.label == navigationItems[currentIndex].label,
      );

      return NavigationBarTheme(
        data: _NavigationBarDefaultsM3(
          context,
          dark: navigationItems[currentIndex].label == PageLabel.xboard,
        ),
        child: NavigationBar(
          destinations: visibleItems
              .map(
                (e) => NavigationDestination(
                  icon: _buildIconWithBadge(e.label, e.icon, ref),
                  label: _navigationLabel(e.label),
                ),
              )
              .toList(),
          onDestinationSelected: (index) {
            globalState.appController.toPage(visibleItems[index].label);
          },
          selectedIndex: visibleIndex == -1 ? 0 : visibleIndex,
        ),
      );
    }
    return const _DesktopNavigationBar();
  }
}

class _DesktopNavigationBar extends ConsumerWidget {
  const _DesktopNavigationBar();

  String _label(PageLabel label) {
    return _navigationLabel(label);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeStateProvider);
    // Filter out plans page from desktop sidebar
    final items = state.navigationItems
        .where((item) =>
            item.modes.contains(NavigationItemMode.desktop) &&
            item.label != PageLabel.plans)
        .toList();
    final selected = items.indexWhere((item) => item.label == state.pageLabel);
    return Material(
      color: const Color(0xFF1A2027),
      child: SizedBox(
        width: 100,
        child: SafeArea(
          bottom: false,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(10, 32, 10, 20),
            itemCount: items.length,
            separatorBuilder: (_, index) => SizedBox(
              height: index == 0 ? 8 : 12,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = index == selected;
              return _DesktopNavigationItem(
                item: item,
                isSelected: isSelected,
                label: _label(item.label),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DesktopNavigationItem extends StatefulWidget {
  final NavigationItem item;
  final bool isSelected;
  final String label;

  const _DesktopNavigationItem({
    required this.item,
    required this.isSelected,
    required this.label,
  });

  @override
  State<_DesktopNavigationItem> createState() => _DesktopNavigationItemState();
}

class _DesktopNavigationItemState extends State<_DesktopNavigationItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final showBackground = widget.isSelected || _isHovered;
    final icon = IconTheme(
      data: IconThemeData(
        size: 24,
        color: widget.isSelected
            ? const Color(0xFFD8F0FF)
            : const Color(0xFFC4CFD9),
      ),
      child: widget.item.icon,
    );

    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: widget.label,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => globalState.appController.toPage(widget.item.label),
            borderRadius: BorderRadius.circular(16),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: showBackground
                          ? const Color(0xFF24577C)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: widget.item.label == PageLabel.onlineSupport
                          ? BadgeIcon(icon: icon)
                          : icon,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: widget.isSelected
                          ? const Color(0xFFF0F6FA)
                          : const Color(0xFFD1D9E0),
                      fontSize: 13,
                      fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _navigationLabel(PageLabel label) {
  return switch (label) {
    PageLabel.xboard => appLocalizations.xboardHome,
    PageLabel.proxies => appLocalizations.proxies,
    PageLabel.tools => appLocalizations.settings,
    PageLabel.profiles => appLocalizations.profiles,
    _ => Intl.message(label.name),
  };
}

class _NavigationBarDefaultsM3 extends NavigationBarThemeData {
  _NavigationBarDefaultsM3(this.context, {required this.dark})
      : super(
          height: 60.0,
          elevation: 3.0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        );

  final BuildContext context;
  final bool dark;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  Color? get backgroundColor =>
      dark ? const Color(0xFF171D21) : _colors.surfaceContainer;

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  WidgetStateProperty<IconThemeData?>? get iconTheme {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      return IconThemeData(
        size: 24.0,
        color: states.contains(WidgetState.disabled)
            ? _colors.onSurfaceVariant.opacity38
            : states.contains(WidgetState.selected)
                ? (dark ? const Color(0xFFF0F6FA) : _colors.onSecondaryContainer)
                : (dark ? const Color(0xFFC4CFD9) : _colors.onSurfaceVariant),
      );
    });
  }

  @override
  Color? get indicatorColor =>
      dark ? const Color(0xFF24577C) : _colors.secondaryContainer;

  @override
  ShapeBorder? get indicatorShape => const StadiumBorder();

  @override
  WidgetStateProperty<TextStyle?>? get labelTextStyle {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      final TextStyle style = _textTheme.labelMedium!;
      return style.apply(
          overflow: TextOverflow.ellipsis,
          color: states.contains(WidgetState.disabled)
              ? _colors.onSurfaceVariant.opacity38
              : states.contains(WidgetState.selected)
                  ? (dark ? const Color(0xFFF0F6FA) : _colors.onSurface)
                  : (dark
                      ? const Color(0xFFC4CFD9)
                      : _colors.onSurfaceVariant));
    });
  }
}

class HomeBackScope extends StatelessWidget {
  final Widget child;

  const HomeBackScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return CommonPopScope(
        onPop: () async {
          final canPop = Navigator.canPop(context);
          if (canPop) {
            Navigator.pop(context);
          } else {
            await globalState.appController.handleBackOrExit();
          }
          return false;
        },
        child: child,
      );
    }
    return child;
  }
}
