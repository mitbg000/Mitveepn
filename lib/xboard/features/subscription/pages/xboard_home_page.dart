import 'dart:async';
import 'dart:math' as math;
import 'package:mitveepn/common/common.dart';
import 'package:mitveepn/enum/enum.dart';
import 'package:mitveepn/models/models.dart';
import 'package:mitveepn/providers/providers.dart';
import 'package:mitveepn/state.dart';
import 'package:mitveepn/widgets/widgets.dart';
import 'package:mitveepn/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mitveepn/xboard/features/shared/shared.dart';
import 'package:mitveepn/xboard/features/latency/services/auto_latency_service.dart';
import 'package:mitveepn/xboard/features/subscription/services/subscription_status_checker.dart';
import 'package:mitveepn/xboard/features/subscription/services/subscription_status_service.dart';
import 'package:mitveepn/xboard/features/auth/pages/login_page.dart';
import 'package:mitveepn/xboard/features/online_support/pages/online_support_wrapper.dart';
import 'package:mitveepn/xboard/features/online_support/providers/chat_provider.dart';
import 'package:mitveepn/xboard/features/online_support/services/service_config.dart';
import 'package:mitveepn/xboard/features/notice/pages/notice_list_page.dart';
import 'package:mitveepn/xboard/features/notice/providers/notice_provider.dart';

class XBoardHomePage extends ConsumerStatefulWidget {
  const XBoardHomePage({super.key});
  @override
  ConsumerState<XBoardHomePage> createState() => _XBoardHomePageState();
}

class _XBoardHomePageState extends ConsumerState<XBoardHomePage>
    with PageMixin {
  @override
  Widget? get leading {
    // 桌面端不显示联系客服按钮，因为已经在侧边栏中了
    if (system.isDesktop) {
      return null;
    }

    // Chưa có cấu hình API online support (ví dụ mất mạng lúc khởi động,
    // chưa lấy được config từ remote) thì không đọc chatProvider (nó sẽ
    // throw exception làm crash UI) — vẫn hiện nút, chỉ ẩn số tin chưa đọc.
    // OnlineSupportWrapper tự kiểm tra config riêng khi mở, không phụ thuộc
    // vào apiBaseUrl này.
    final hasApiConfig = CustomerSupportServiceConfig.apiBaseUrl != null;

    // 使用 Consumer 来监听未读消息数
    return Consumer(
      builder: (context, ref, child) {
        final unreadCount =
            hasApiConfig ? ref.watch(chatProvider).unreadCount : 0;

        return TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const OnlineSupportWrapper(),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            overlayColor: Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BadgeIcon(
                icon: Icon(
                  Icons.support_agent,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                count: unreadCount,
                badgeSize: 14,
              ),
              const SizedBox(width: 4),
              Text(
                appLocalizations.contactSupport,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  List<Widget> get actions {
    if (system.isDesktop) {
      return [
        IconButton(
          tooltip: appLocalizations.contactSupport,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const OnlineSupportWrapper(),
              ),
            );
          },
          icon: const Icon(Icons.support_agent_rounded, size: 30),
        ),
        Consumer(
          builder: (context, ref, child) {
            final noticeCount = ref.watch(noticeProvider).notices.length;
            return IconButton(
              tooltip: appLocalizations.xboardNotifications,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NoticeListPage(),
                  ),
                );
              },
              icon: BadgeIcon(
                icon: const Icon(Icons.notifications_rounded, size: 30),
                count: noticeCount,
                badgeSize: 17,
              ),
            );
          },
        ),
      ];
    }
    return [
      TextButton.icon(
        icon: const Icon(Icons.card_giftcard, size: 20),
        label: Text(appLocalizations.xboardPlanInfo),
        onPressed: () {
          globalState.appController.toPage(PageLabel.plans);
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    ];
  }

  bool _hasInitialized = false;
  bool _hasStartedLatencyTesting = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_hasInitialized) return;
      _hasInitialized = true;
      final userState = ref.read(xboardUserProvider);
      if (userState.isAuthenticated) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            subscriptionStatusChecker.checkSubscriptionStatusOnStartup(
                context, ref);
          }
        });
        // Fetch notices when user is authenticated
        ref.read(noticeProvider.notifier).fetchNotices();
      }
      autoLatencyService.initialize(ref);
      _waitForGroupsAndStartTesting();
    });
    ref.listenManual(xboardUserProvider, (previous, next) {
      if (next.errorMessage == 'TOKEN_EXPIRED') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showTokenExpiredDialog();
        });
      }
    });
    ref.listenManual(currentProfileProvider, (previous, next) {
      if (previous?.label != next?.label && previous != null) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            autoLatencyService.testCurrentNode(forceTest: true);
          }
        });
      }
    });
    ref.listenManual(groupsProvider, (previous, next) {
      if ((previous?.isEmpty ?? true) &&
          next.isNotEmpty &&
          !_hasStartedLatencyTesting) {
        _hasStartedLatencyTesting = true;
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _performInitialLatencyTest();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        ref.listenManual(
          isCurrentPageProvider(PageLabel.xboard),
          (prev, next) {
            if (prev != next && next == true) {
              initPageState();
            }
          },
          fireImmediately: true,
        );

        return _ConnectionDashboard(isCompact: !system.isDesktop);
      },
    );
  }

  void _showTokenExpiredDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(appLocalizations.xboardTokenExpiredTitle),
        content: Text(appLocalizations.xboardTokenExpiredContent),
        actions: [
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final userNotifier = ref.read(xboardUserProvider.notifier);
              navigator.pop();
              if (!mounted) return;
              userNotifier.clearTokenExpiredError();
              await userNotifier.handleTokenExpired();
              if (!mounted) return;
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false,
              );
            },
            child: Text(appLocalizations.xboardRelogin),
          ),
        ],
      ),
    );
  }

  void _waitForGroupsAndStartTesting() {
    if (_hasStartedLatencyTesting) {
      return;
    }
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      try {
        final groups = ref.read(groupsProvider);
        if (groups.isNotEmpty && !_hasStartedLatencyTesting) {
          timer.cancel();
          _hasStartedLatencyTesting = true;
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              _performInitialLatencyTest();
            }
          });
        }
      } catch (_) {
        // Providers can briefly be unavailable while the core is starting.
      }
    });
  }

  void _performInitialLatencyTest() {
    if (!mounted) return;
    autoLatencyService.testCurrentNode();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final userState = ref.read(xboardUserProvider);
        if (userState.isAuthenticated) {
          autoLatencyService.testCurrentGroupNodes();
        }
      }
    });
  }
}
// plan expire on home page
// Dấu X chỉ ẩn banner trong phiên hiện tại (state trong RAM, provider không
// persist) — mở app lại (cold start) provider được tạo lại nên banner hiện lại.
final _planExpiringBannerDismissedProvider = StateProvider<bool>((ref) => false);

class _PlanExpiringBanner extends ConsumerWidget {
  const _PlanExpiringBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dismissed = ref.watch(_planExpiringBannerDismissedProvider);
    final userState = ref.watch(xboardUserProvider);
    final profileSubscriptionInfo = ref.watch(currentProfileProvider)?.subscriptionInfo;
    final statusResult = subscriptionStatusService.checkSubscriptionStatus(
      userState: userState,
      profileSubscriptionInfo: profileSubscriptionInfo,
    );
    final remainingDays = statusResult.remainingDays;
    final showBanner = !dismissed &&
        statusResult.type == SubscriptionStatusType.valid &&
        remainingDays != null &&
        remainingDays >= 0 &&
        remainingDays <= 3;
    if (!showBanner) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF7A45), Color(0xFFE64A19)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    remainingDays == 0
                        ? appLocalizations.subscriptionExpiresToday
                        : appLocalizations.subscriptionExpiringInDays,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    remainingDays == 0
                        ? appLocalizations.subscriptionExpiresTodayDetail
                        : appLocalizations.subscriptionExpiringInDaysDetail(remainingDays),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () => globalState.appController.toPage(PageLabel.plans),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFE64A19),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              child: Text(appLocalizations.xboardRenewPlan),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 18),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              onPressed: () =>
                  ref.read(_planExpiringBannerDismissedProvider.notifier).state = true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectionDashboard extends ConsumerWidget {
  final bool isCompact;

  const _ConnectionDashboard({required this.isCompact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final circleSize = math.min(
          isCompact ? 200.0 : 260.0,
          math.max(160.0, constraints.maxWidth * (isCompact ? 0.52 : 0.26)),
        );
        final content = SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            isCompact ? 16 : 24,
            isCompact ? 20 : 26,
            isCompact ? 16 : 24,
            isCompact ? 20 : 28,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: math.max(
                0,
                constraints.maxHeight - (isCompact ? 40 : 54),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: const _PlanExpiringBanner(),
                ),
                _ConnectionCircle(size: circleSize),
                SizedBox(height: isCompact ? 30 : 52),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: const _NetworkCard(),
                ),
                if (isCompact) ...[
                  const SizedBox(height: 22),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: _DashboardUpdateButton(compact: true),
                  ),
                ],
              ],
            ),
          ),
        );

        return Stack(
          children: [
            Positioned.fill(child: content),
            if (!isCompact)
              const Positioned(
                right: 24,
                bottom: 24,
                child: _DashboardUpdateButton(),
              ),
          ],
        );
      },
    );
  }
}

class _ConnectionCircle extends ConsumerStatefulWidget {
  final double size;

  const _ConnectionCircle({required this.size});

  @override
  ConsumerState<_ConnectionCircle> createState() => _ConnectionCircleState();
}

class _ConnectionCircleState extends ConsumerState<_ConnectionCircle> {
  bool _isHovered = false;

  void _toggle(WidgetRef ref, bool isStart) {
    final state = ref.read(startButtonSelectorStateProvider);
    if (!state.isInit || !state.hasProfile) return;
    debouncer.call(
      FunctionTag.updateStatus,
      () => globalState.appController.updateStatus(!isStart),
      duration: commonDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isStart = ref.watch(runTimeProvider) != null;
    final runTime = ref.watch(runTimeProvider);
    final colors = isStart
        ? const [Color(0xFF35D19D), Color(0xFF08A97F)]
        : (_isHovered
            ? const [Color(0xFF22D3EE), Color(0xFF14B8A6)]
            : const [Color(0xFF2D6D96), Color(0xFF20516F)]);

    final effectiveSize = _isHovered ? widget.size * 1.05 : widget.size;

    return Semantics(
      button: true,
      label: isStart ? appLocalizations.xboardDisconnect : appLocalizations.xboardConnect,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _toggle(ref, isStart),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: effectiveSize,
              height: effectiveSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.last.withValues(alpha: 0.24),
                    blurRadius: 28,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isStart ? appLocalizations.xboardConnected : appLocalizations.xboardConnect,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.size >= 280 ? 36 : 29,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (isStart) ...[
                    const SizedBox(height: 12),
                    Text(
                      utils.getTimeText(runTime),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: widget.size >= 280 ? 24 : 19,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NetworkCard extends ConsumerWidget {
  const _NetworkCard();

  List<Point> _points(List<Traffic> values) {
    final points = values.asMap().entries.map((entry) {
      return Point(entry.key.toDouble() + 1, entry.value.speed.toDouble());
    }).toList();
    return [const Point(0, 0), const Point(1, 0), ...points];
  }

  String _formatRate(TrafficValue value) {
    final shown = value.trafficValueShow;
    final decimals = shown.value >= 100
        ? 0
        : shown.value >= 10
            ? 1
            : 2;
    return '${shown.value.toStringAsFixed(decimals)}${shown.unit.name}/s';
  }

  Group? _groupFor(List<Group> groups, String? preferred) {
    if (groups.isEmpty) return null;
    if (preferred != null) {
      for (final group in groups) {
        if (group.name == preferred) return group;
      }
    }
    for (final group in groups) {
      if (group.name != GroupName.GLOBAL.name && group.hidden != true) {
        return group;
      }
    }
    return groups.first;
  }

  String _getFlagEmoji(String nodeName) {
    final name = nodeName.toUpperCase();

    // Common country codes
    final countryMap = {
      'SG': '🇸🇬', 'US': '🇺🇸', 'HK': '🇭🇰', 'JP': '🇯🇵', 'KR': '🇰🇷',
      'TW': '🇹🇼', 'CN': '🇨🇳', 'UK': '🇬🇧', 'DE': '🇩🇪', 'FR': '🇫🇷',
      'CA': '🇨🇦', 'AU': '🇦🇺', 'IN': '🇮🇳', 'RU': '🇷🇺', 'BR': '🇧🇷',
      'NL': '🇳🇱', 'SE': '🇸🇪', 'NO': '🇳🇴', 'FI': '🇫🇮', 'DK': '🇩🇰',
      'IT': '🇮🇹', 'ES': '🇪🇸', 'CH': '🇨🇭', 'AT': '🇦🇹', 'BE': '🇧🇪',
      'PL': '🇵🇱', 'CZ': '🇨🇿', 'PT': '🇵🇹', 'GR': '🇬🇷', 'TR': '🇹🇷',
      'TH': '🇹🇭', 'VN': '🇻🇳', 'MY': '🇲🇾', 'ID': '🇮🇩', 'PH': '🇵🇭',
      'SINGAPORE': '🇸🇬', 'UNITED STATES': '🇺🇸', 'HONG KONG': '🇭🇰',
      'JAPAN': '🇯🇵', 'KOREA': '🇰🇷', 'TAIWAN': '🇹🇼', 'CHINA': '🇨🇳',
    };

    // Check for exact matches
    for (final entry in countryMap.entries) {
      if (name.contains(entry.key)) {
        return entry.value;
      }
    }

    return '🌐'; // Default globe icon
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final traffics = ref.watch(trafficsProvider).list;
    final lastTraffic = traffics.isEmpty ? Traffic() : traffics.last;
    final profile = ref.watch(currentProfileProvider);
    final selectedMap = ref.watch(selectedMapProvider);
    final groups = ref.watch(groupsProvider);
    final group = _groupFor(groups, profile?.currentGroupName);
    final nodeName = group == null
        ? null
        : (selectedMap[group.name] ??
            group.now ??
            (group.all.isEmpty ? null : group.all.first.name));
    final delay = nodeName == null
        ? null
        : ref.watch(getDelayProvider(
            proxyName: nodeName,
            testUrl: ref.watch(appSettingProvider).testUrl,
          ));
    final textColor = const Color(0xFFD2D8DD);
    final mutedColor = const Color(0xFFA7B0B8);
    final latencyColor = delay != null && delay > 0
        ? (utils.getDelayColor(delay) ?? const Color(0xFF31C778))
        : const Color(0xFF31C778);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF171D21),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2B353B), width: 1.3),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.speed_rounded,
                size: 16,
                color: Color(0xFF7DCBFF),
              ),
              const SizedBox(width: 6),
              Text(
                'Network speed',
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '\u2191 ${_formatRate(lastTraffic.up)}   \u2193 ${_formatRate(lastTraffic.down)}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 70,
            width: double.infinity,
            child: LineChart(
              gradient: true,
              color: const Color(0xFF85C9FF),
              points: _points(traffics),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (nodeName != null)
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        _getFlagEmoji(nodeName),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          nodeName,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (delay != null && delay > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          '${delay}ms',
                          style: TextStyle(
                            color: latencyColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_upward_rounded,
                      size: 16, color: Color(0xFF66C6FF)),
                  const SizedBox(width: 3),
                  Text(
                    ref.watch(totalTrafficProvider).up.shortShow,
                    style: TextStyle(color: mutedColor, fontSize: 13),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_downward_rounded,
                      size: 16, color: Color(0xFF6E9FC4)),
                  const SizedBox(width: 3),
                  Text(
                    ref.watch(totalTrafficProvider).down.shortShow,
                    style: TextStyle(color: mutedColor, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardUpdateButton extends ConsumerStatefulWidget {
  final bool compact;

  const _DashboardUpdateButton({this.compact = false});

  @override
  ConsumerState<_DashboardUpdateButton> createState() =>
      _DashboardUpdateButtonState();
}

class _DashboardUpdateButtonState
    extends ConsumerState<_DashboardUpdateButton> {
  bool _isLoading = false;

  Future<void> _update() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await globalState.appController.updateProfiles();
      await globalState.appController.updateGroups();
      if (mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(content: Text('Updated successfully')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(content: Text('Update failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = _isLoading
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : const Icon(Icons.sync_rounded, size: 20, color: Colors.white);
    if (widget.compact) {
      return IconButton.filledTonal(
        tooltip: 'Update',
        onPressed: _isLoading ? null : _update,
        icon: child,
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFF168EB3),
          foregroundColor: Colors.white,
        ),
      );
    }
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _isLoading ? null : _update,
        child: Ink(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0EA8E5), Color(0xFF08A99F)],
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              child,
              const SizedBox(width: 10),
              const Text(
                'Update',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
