import 'dart:ui';

import 'package:mitveepn/common/common.dart';
import 'package:mitveepn/enum/enum.dart';
import 'package:mitveepn/models/models.dart';
import 'package:mitveepn/providers/providers.dart';
import 'package:mitveepn/state.dart';
import 'package:mitveepn/views/profiles/edit_profile.dart';
import 'package:mitveepn/views/profiles/override_profile.dart';
import 'package:mitveepn/views/profiles/scripts.dart';
import 'package:mitveepn/widgets/widgets.dart';
import 'package:mitveepn/xboard/features/auth/pages/login_page.dart';
import 'package:mitveepn/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:mitveepn/xboard/features/invite/dialogs/logout_dialog.dart';
import 'package:mitveepn/xboard/sdk/xboard_sdk.dart';
import 'package:flutter_xboard_sdk/flutter_xboard_sdk.dart' as sdk;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_profile.dart';

final profileTrafficLogProvider =
    FutureProvider.autoDispose<List<sdk.TrafficLog>>(
  (ref) => XBoardSDK.subscription.getTrafficLog(),
);

class ProfilesView extends StatefulWidget {
  const ProfilesView({super.key});

  @override
  State<ProfilesView> createState() => _ProfilesViewState();
}

class _ProfilesViewState extends State<ProfilesView> with PageMixin {
  Function? applyConfigDebounce;

  _handleShowAddExtendPage() {
    showExtend(
      globalState.navigatorKey.currentState!.context,
      builder: (_, type) {
        return AdaptiveSheetScaffold(
          type: type,
          body: AddProfileView(
            context: globalState.navigatorKey.currentState!.context,
          ),
          title: "${appLocalizations.add}${appLocalizations.profile}",
        );
      },
    );
  }

  _updateProfiles() async {
    final profiles = globalState.config.profiles;
    final messages = [];
    final updateProfiles = profiles.map<Future>(
      (profile) async {
        if (profile.type == ProfileType.file) return;
        globalState.appController.setProfile(
          profile.copyWith(isUpdating: true),
        );
        try {
          await globalState.appController.updateProfile(profile);
        } catch (e) {
          messages.add("${profile.label ?? profile.id}: $e \n");
          globalState.appController.setProfile(
            profile.copyWith(
              isUpdating: false,
            ),
          );
        }
      },
    );
    final titleMedium = context.textTheme.titleMedium;
    await Future.wait(updateProfiles);
    if (messages.isNotEmpty) {
      globalState.showMessage(
        title: appLocalizations.tip,
        message: TextSpan(
          children: [
            for (final message in messages)
              TextSpan(text: message, style: titleMedium)
          ],
        ),
      );
    }
  }

  @override
  List<Widget> get actions => [
        IconButton(
          onPressed: () {
            _updateProfiles();
          },
          icon: const Icon(Icons.sync),
        ),
        IconButton(
          onPressed: () {
            showExtend(
              context,
              builder: (_, type) {
                return ScriptsView();
              },
            );
          },
          icon: Consumer(
            builder: (context, ref, __) {
              final isScriptMode = ref.watch(
                  scriptStateProvider.select((state) => state.realId != null));
              return Icon(
                Icons.functions,
                color: isScriptMode ? context.colorScheme.primary : null,
              );
            },
          ),
        ),
        IconButton(
          onPressed: () {
            final profiles = globalState.config.profiles;
            showSheet(
              context: context,
              builder: (_, type) {
                return ReorderableProfilesSheet(
                  type: type,
                  profiles: profiles,
                );
              },
            );
          },
          icon: const Icon(Icons.sort),
          iconSize: 26,
        ),
      ];

  @override
  Widget? get floatingActionButton => FloatingActionButton(
        heroTag: null,
        onPressed: _handleShowAddExtendPage,
        child: const Icon(
          Icons.add,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        ref.listenManual(
          isCurrentPageProvider(PageLabel.profiles),
          (prev, next) {
            if (prev != next && next == true) {
              initPageState();
              // Fetch a fresh monthly traffic log whenever the profile page
              // becomes active again.
              ref.invalidate(profileTrafficLogProvider);
            }
          },
          fireImmediately: true,
        );
        final profilesSelectorState = ref.watch(profilesSelectorStateProvider);
        return _ProfileDashboard(
          profiles: profilesSelectorState.profiles,
          columns: profilesSelectorState.columns,
          currentProfileId: profilesSelectorState.currentProfileId,
          onProfileChanged: (profileId) {
            ref.read(currentProfileIdProvider.notifier).value = profileId;
          },
        );
      },
    );
  }
}

class _ProfileDashboard extends ConsumerWidget {
  final List<Profile> profiles;
  final int columns;
  final String? currentProfileId;
  final ValueChanged<String?> onProfileChanged;

  const _ProfileDashboard({
    required this.profiles,
    required this.columns,
    required this.currentProfileId,
    required this.onProfileChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);
    final subscription = ref.watch(subscriptionInfoProvider);
    final current = ref.watch(currentProfileProvider);
    final compact = ref.watch(isMobileViewProvider);
    final isAuthenticated = ref.watch(
      xboardUserProvider.select((state) => state.isAuthenticated),
    );
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding:
            EdgeInsets.fromLTRB(compact ? 12 : 24, 16, compact ? 12 : 24, 96),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AccountCard(
                user: user,
                compact: compact,
                isAuthenticated: isAuthenticated,
              ),
              const SizedBox(height: 18),
              _SubscriptionDashboardCard(
                user: user,
                subscription: subscription,
                profile: current,
                compact: compact,
                onBuyPlan: () =>
                    globalState.appController.toPage(PageLabel.plans),
              ),
              const SizedBox(height: 18),
              _TrafficTrendCard(
                profile: current,
                compact: compact,
              ),
              // Profile section hidden per user request
              // if (profiles.isNotEmpty) ...[
              //   const SizedBox(height: 18),
              //   Text(
              //     appLocalizations.profile,
              //     style: Theme.of(context).textTheme.titleLarge?.copyWith(
              //           fontWeight: FontWeight.w700,
              //         ),
              //   ),
              //   const SizedBox(height: 10),
              //   Grid(
              //     mainAxisSpacing: 16,
              //     crossAxisSpacing: 16,
              //     crossAxisCount: compact ? 1 : columns,
              //     children: [
              //       for (final profile in profiles)
              //         GridItem(
              //           child: ProfileItem(
              //             key: Key(profile.id),
              //             profile: profile,
              //             groupValue: currentProfileId,
              //             onChanged: onProfileChanged,
              //           ),
              //         ),
              //     ],
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}

const _profileCard = Color(0xff181f23);
const _profileMuted = Color(0xffaeb6bd);

/// XBoard returns one record per day and server-rate.  Collapse those records
/// into one point per calendar day before displaying them in the trend chart.
List<sdk.TrafficLog> _groupTrafficLogs(List<sdk.TrafficLog> source) {
  final dailyRecords = source.where((log) => log.recordType == 'd').toList();
  // Some XBoard versions do not expose record_type in the resource. In that
  // case all returned rows are daily rows; if it is exposed, discard monthly
  // aggregate rows to avoid counting the same traffic twice.
  final records = dailyRecords.isNotEmpty ? dailyRecords : source;
  final buckets = <DateTime, List<int>>{};
  for (final log in records) {
    final day =
        DateTime(log.recordAt.year, log.recordAt.month, log.recordAt.day);
    final bucket = buckets.putIfAbsent(day, () => [0, 0]);
    bucket[0] += log.upload;
    bucket[1] += log.download;
  }
  final now = DateTime.now();
  final firstDay = DateTime(now.year, now.month);
  final lastDay = DateTime(now.year, now.month, now.day);
  for (var day = firstDay;
      !day.isAfter(lastDay);
      day = day.add(const Duration(days: 1))) {
    buckets.putIfAbsent(day, () => [0, 0]);
  }
  final days = buckets.keys.toList()..sort();
  return [
    for (final day in days)
      sdk.TrafficLog(
        recordAt: day,
        upload: buckets[day]![0],
        download: buckets[day]![1],
      ),
  ];
}

class _AccountCard extends StatelessWidget {
  final UserInfo? user;
  final bool compact;
  final bool isAuthenticated;
  const _AccountCard({
    required this.user,
    required this.compact,
    required this.isAuthenticated,
  });

  @override
  Widget build(BuildContext context) {
    final email = user?.email ?? 'XBoard';
    return Container(
      padding: EdgeInsets.all(compact ? 16 : 22),
      decoration: BoxDecoration(
          color: _profileCard, borderRadius: BorderRadius.circular(22)),
      child: Row(
        children: [
          CircleAvatar(
            radius: compact ? 28 : 36,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundImage: user?.avatarUrl.isNotEmpty == true
                ? NetworkImage(user!.avatarUrl)
                : null,
            child: user?.avatarUrl.isNotEmpty == true
                ? null
                : Icon(Icons.person, size: compact ? 28 : 34),
          ),
          SizedBox(width: compact ? 12 : 16),
          Expanded(
            child: Text(
              email,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          if (!isAuthenticated)
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginPage()),
              ),
              child: Text(appLocalizations.xboardLogin),
            ),
          TextButton(
            onPressed: () => showDialog(
                context: context, builder: (_) => const LogoutDialog()),
            child: Text(
              appLocalizations.logout,
              style: context.textTheme.labelLarge?.copyWith(
                color: Colors.red.shade200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionDashboardCard extends StatelessWidget {
  final UserInfo? user;
  final SubscriptionData? subscription;
  final Profile? profile;
  final bool compact;
  final VoidCallback onBuyPlan;
  const _SubscriptionDashboardCard({
    required this.user,
    required this.subscription,
    required this.profile,
    required this.compact,
    required this.onBuyPlan,
  });

  String _bytes(num value) {
    if (value >= 1024 * 1024 * 1024) {
      return '${(value / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
    if (value >= 1024 * 1024) {
      return '${(value / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(value / 1024).toStringAsFixed(1)} KB';
  }

  @override
  Widget build(BuildContext context) {
    final local = profile?.subscriptionInfo;
    final localTotal = local?.total ?? 0;
    final total = (localTotal > 0
            ? localTotal
            : subscription?.transferEnable?.toInt() ??
                user?.transferEnable.toInt() ??
                0)
        .toDouble();
    final localUsed = (local?.upload ?? 0) + (local?.download ?? 0);
    final used = (localUsed > 0
            ? localUsed
            : (subscription?.u ?? 0) + (subscription?.d ?? 0))
        .toDouble();
    final progress = total > 0 ? (used / total).clamp(0.0, 1.0) : 0.0;
    final plan = subscription?.planName ?? 'Pro X';
    final expiry = subscription?.expiredAt ?? user?.expiredAt;
    final expiryText = expiry == null
        ? '—'
        : '${expiry.year}-${expiry.month.toString().padLeft(2, '0')}-${expiry.day.toString().padLeft(2, '0')}';
    return Container(
      padding: EdgeInsets.all(compact ? 16 : 22),
      decoration: BoxDecoration(
          color: _profileCard, borderRadius: BorderRadius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(
                child: Text(plan,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ))),
            Icon(Icons.calendar_today_outlined, size: 20, color: _profileMuted),
            const SizedBox(width: 8),
            Text(expiryText,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: _profileMuted,
                  fontSize: 14,
                )),
          ]),
          const SizedBox(height: 18),
          Divider(color: Colors.white.withValues(alpha: .16), height: 1),
          const SizedBox(height: 18),
          Row(children: [
            Icon(Icons.data_usage, color: Colors.white70, size: 24),
            const SizedBox(width: 12),
            Expanded(
                child: Text(appLocalizations.xboardDataUsage,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: _profileMuted,
                    ))),
            Text('${_bytes(used)} / ${_bytes(total)}',
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
          ]),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
                value: progress,
                minHeight: compact ? 11 : 15,
                backgroundColor: Colors.white.withValues(alpha: .9),
                valueColor: const AlwaysStoppedAnimation(Color(0xff83c9ff))),
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: onBuyPlan,
              icon: const Icon(Icons.shopping_cart_outlined),
              label: Text(appLocalizations.xboardBuyPlan,
                  style: context.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  )),
              style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xffff3f3f),
                  padding: EdgeInsets.symmetric(
                      horizontal: compact ? 18 : 28,
                      vertical: compact ? 12 : 16),
                  shape: const StadiumBorder()),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrafficTrendCard extends ConsumerStatefulWidget {
  final Profile? profile;
  final bool compact;
  const _TrafficTrendCard({required this.profile, required this.compact});

  @override
  ConsumerState<_TrafficTrendCard> createState() => _TrafficTrendCardState();
}

class _TrafficTrendCardState extends ConsumerState<_TrafficTrendCard> {
  Offset? _hoverPosition;
  int? _hoveredIndex;
  List<sdk.TrafficLog> _currentLogs = [];

  String _bytes(num value) {
    if (value >= 1024 * 1024 * 1024) {
      return '${(value / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
    if (value >= 1024 * 1024) {
      return '${(value / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(value / 1024).toStringAsFixed(1)} KB';
  }

  @override
  Widget build(BuildContext context) {
    final sub = widget.profile?.subscriptionInfo;
    final accountSubscription = ref.watch(subscriptionInfoProvider);
    final traffic = ref.watch(totalTrafficProvider);
    final rawLogs = ref.watch(profileTrafficLogProvider).valueOrNull;
    final logs = _groupTrafficLogs(rawLogs ?? const <sdk.TrafficLog>[]);
    _currentLogs = logs;
    final hasApiData = rawLogs?.isNotEmpty == true;
    final profileUpload = sub?.upload ?? 0;
    final profileDownload = sub?.download ?? 0;
    final upload = hasApiData
        ? logs.fold<int>(0, (sum, log) => sum + log.upload).toDouble()
        : profileUpload > 0
            ? profileUpload.toDouble()
            : accountSubscription?.u?.toDouble() ?? traffic.up.value.toDouble();
    final download = hasApiData
        ? logs.fold<int>(0, (sum, log) => sum + log.download).toDouble()
        : profileDownload > 0
            ? profileDownload.toDouble()
            : accountSubscription?.d?.toDouble() ??
                traffic.down.value.toDouble();
    return Container(
      padding: EdgeInsets.all(widget.compact ? 16 : 22),
      decoration: BoxDecoration(
          color: _profileCard, borderRadius: BorderRadius.circular(22)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(appLocalizations.xboardTrafficTrend,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 4),
                Text(appLocalizations.xboardBandwidthUsageHistory,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: _profileMuted,
                    )),
              ])),
          Icon(Icons.show_chart, color: const Color(0xff83c9ff), size: 24),
        ]),
        const SizedBox(height: 22),
        if (widget.compact) ...[
          _TrafficStat(
              label: appLocalizations.upload,
              value: _bytes(upload),
              color: const Color(0xff2196f3),
              compact: true),
          const SizedBox(height: 12),
          _TrafficStat(
              label: appLocalizations.download,
              value: _bytes(download),
              color: const Color(0xff4caf50),
              compact: true),
        ] else
          Row(children: [
            Expanded(
                child: _TrafficStat(
                    label: appLocalizations.upload,
                    value: _bytes(upload),
                    color: const Color(0xff2196f3),
                    compact: false)),
            const SizedBox(width: 18),
            Expanded(
                child: _TrafficStat(
                    label: appLocalizations.download,
                    value: _bytes(download),
                    color: const Color(0xff4caf50),
                    compact: false)),
          ]),
        const SizedBox(height: 22),
        SizedBox(
            height: widget.compact ? 220 : 300,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return MouseRegion(
                  onHover: (event) {
                    if (_currentLogs.isEmpty) return;

                    final chartWidth = constraints.maxWidth;
                    final hoverX = event.localPosition.dx;

                    // Calculate index based on normalized position
                    if (hoverX >= 0 && hoverX <= chartWidth) {
                      final normalizedX = hoverX / chartWidth;
                      final newIndex = (normalizedX * (_currentLogs.length - 1)).round().clamp(0, _currentLogs.length - 1);

                      setState(() {
                        _hoverPosition = event.localPosition;
                        if (_hoveredIndex != newIndex) {
                          _hoveredIndex = newIndex;
                        }
                      });
                    }
                  },
                  onExit: (event) {
                    setState(() {
                      _hoverPosition = null;
                      _hoveredIndex = null;
                    });
                  },
                  child: Stack(
                    children: [
                      SizedBox.expand(
                        child: CustomPaint(
                          painter: _TrafficTrendPainter(
                            upload: upload,
                            download: download,
                            logs: _currentLogs,
                            labelStyle: context.textTheme.bodySmall ?? const TextStyle(),
                            hoveredIndex: _hoveredIndex,
                          ),
                        ),
                      ),
                      if (_hoveredIndex != null && _currentLogs.isNotEmpty && _hoveredIndex! < _currentLogs.length)
                        _buildTooltip(_currentLogs[_hoveredIndex!], constraints.maxWidth),
                    ],
                  ),
                );
              },
            )),
      ]),
    );
  }

  Widget _buildTooltip(sdk.TrafficLog log, double chartWidth) {
    if (_hoverPosition == null) return const SizedBox.shrink();

    final date = log.recordAt;
    final dateStr = '${date.day}/${date.month}/${date.year}';
    final uploadStr = _bytes(log.upload);
    final downloadStr = _bytes(log.download);

    // Calculate if tooltip should appear on left or right
    final tooltipWidth = 200.0; // Approximate tooltip width
    final shouldShowLeft = _hoverPosition!.dx + tooltipWidth + 10 > chartWidth;

    return Positioned(
      left: shouldShowLeft ? _hoverPosition!.dx - tooltipWidth - 10 : _hoverPosition!.dx + 10,
      top: (_hoverPosition!.dy - 80).clamp(0.0, double.infinity),
      child: Container(
        width: tooltipWidth,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF334155), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dateStr,
              style: const TextStyle(
                color: Color(0xFFE2E8F0),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xff2196f3),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${appLocalizations.upload}: $uploadStr',
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xff4caf50),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${appLocalizations.download}: $downloadStr',
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrafficStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool compact;
  const _TrafficStat(
      {required this.label,
      required this.value,
      required this.color,
      required this.compact});
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(compact ? 14 : 20),
        decoration: BoxDecoration(
            color: color.withValues(alpha: .10),
            borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          Container(
              width: compact ? 12 : 15,
              height: compact ? 12 : 15,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: _profileMuted,
                )),
            Text(value,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ))
          ]),
        ]),
      );
}

class _TrafficTrendPainter extends CustomPainter {
  final double upload;
  final double download;
  final List<sdk.TrafficLog> logs;
  final TextStyle labelStyle;
  final int? hoveredIndex;

  const _TrafficTrendPainter({
    required this.upload,
    required this.download,
    this.logs = const [],
    this.labelStyle = const TextStyle(),
    this.hoveredIndex,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(0, 8, size.width, size.height - 34);

    final grid = Paint()
      ..color = Colors.white.withValues(alpha: .08)
      ..strokeWidth = 1;
    for (var i = 0; i < 3; i++) {
      canvas.drawLine(Offset(chart.left, chart.top + chart.height * i / 2),
          Offset(chart.right, chart.top + chart.height * i / 2), grid);
    }
    final upPath = Path(), downPath = Path();
    // Do not manufacture points when the API is unavailable. A flat zero
    // chart is preferable to showing values that do not belong to the user.
    final upValues =
        logs.isNotEmpty ? logs.map((e) => e.upload.toDouble()).toList() : [0.0];
    final downValues = logs.isNotEmpty
        ? logs.map((e) => e.download.toDouble()).toList()
        : [0.0];
    final maxUp = upValues.reduce((a, b) => a > b ? a : b);
    final maxDown = downValues.reduce((a, b) => a > b ? a : b);
    final maxValue = maxUp > maxDown ? maxUp : maxDown;
    final upPoints = <Offset>[];
    final downPoints = <Offset>[];
    for (var i = 0; i < upValues.length; i++) {
      final x = upValues.length == 1
          ? chart.left + chart.width / 2
          : chart.left + chart.width * i / (upValues.length - 1);
      final y1 = chart.top +
          chart.height * (1 - upValues[i] / (maxValue == 0 ? 1 : maxValue));
      final y2 = chart.top +
          chart.height * (1 - downValues[i] / (maxValue == 0 ? 1 : maxValue));
      upPoints.add(Offset(x, y1));
      downPoints.add(Offset(x, y2));
    }
    void addSmoothPath(Path path, List<Offset> points) {
      path.moveTo(points.first.dx, points.first.dy);
      if (points.length == 1) return;
      for (var i = 1; i < points.length; i++) {
        final p0 = points[i - 2 < 0 ? 0 : i - 2];
        final p1 = points[i - 1];
        final p2 = points[i];
        final p3 = points[i + 1 >= points.length ? points.length - 1 : i + 1];
        final control1 =
            Offset(p1.dx + (p2.dx - p0.dx) / 6, p1.dy + (p2.dy - p0.dy) / 6);
        final control2 =
            Offset(p2.dx - (p3.dx - p1.dx) / 6, p2.dy - (p3.dy - p1.dy) / 6);
        path.cubicTo(
            control1.dx, control1.dy, control2.dx, control2.dy, p2.dx, p2.dy);
      }
    }

    addSmoothPath(upPath, upPoints);
    addSmoothPath(downPath, downPoints);

    // Create fill paths
    final upFill = Path.from(upPath);
    final downFill = Path.from(downPath);

    if (upPoints.length == 1) {
      // For single point, create a small area around it
      final point = upPoints.first;
      upFill
        ..lineTo(point.dx, chart.bottom)
        ..lineTo(point.dx, chart.bottom)
        ..close();
    } else {
      upFill
        ..lineTo(chart.right, chart.bottom)
        ..lineTo(chart.left, chart.bottom)
        ..close();
    }

    if (downPoints.length == 1) {
      // For single point, create a small area around it
      final point = downPoints.first;
      downFill
        ..lineTo(point.dx, chart.bottom)
        ..lineTo(point.dx, chart.bottom)
        ..close();
    } else {
      downFill
        ..lineTo(chart.right, chart.bottom)
        ..lineTo(chart.left, chart.bottom)
        ..close();
    }

    canvas.drawPath(upFill,
        Paint()..color = const Color(0xff2196f3).withValues(alpha: .10));
    canvas.drawPath(downFill,
        Paint()..color = const Color(0xff4caf50).withValues(alpha: .09));

    // Draw points as circles for single point, lines for multiple
    if (upPoints.length == 1) {
      canvas.drawCircle(upPoints.first, 4,
          Paint()..color = const Color(0xff2196f3));
    } else {
      canvas.drawPath(
          upPath,
          Paint()
            ..color = const Color(0xff2196f3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.round);
    }

    if (downPoints.length == 1) {
      canvas.drawCircle(downPoints.first, 4,
          Paint()..color = const Color(0xff4caf50));
    } else {
      canvas.drawPath(
          downPath,
          Paint()
            ..color = const Color(0xff4caf50)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.round);
    }

    if (logs.isNotEmpty) {
      final indices = <int>{0, logs.length ~/ 2, logs.length - 1};
      for (final index in indices) {
        final date = logs[index].recordAt;
        final text = '${date.day}/${date.month}';
        final painter = TextPainter(
          text: TextSpan(
            text: text,
            style: labelStyle.copyWith(color: const Color(0xff9ca6ad)),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        final pointX = logs.length == 1
            ? chart.left + chart.width / 2
            : chart.left + chart.width * index / (logs.length - 1);
        final minX = chart.left;
        final maxX = (chart.right - painter.width).clamp(chart.left, chart.right);
        final x = (pointX - painter.width / 2).clamp(minX, maxX);
        painter.paint(canvas, Offset(x, size.height - painter.height));
      }
    }

    // Draw hover dots
    if (hoveredIndex != null && hoveredIndex! >= 0 && hoveredIndex! < upPoints.length && hoveredIndex! < downPoints.length) {
      final upPoint = upPoints[hoveredIndex!];
      final downPoint = downPoints[hoveredIndex!];

      // Draw white dot with colored border for upload line
      canvas.drawCircle(
        upPoint,
        6,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        upPoint,
        6,
        Paint()
          ..color = const Color(0xff2196f3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      // Draw white dot with colored border for download line
      canvas.drawCircle(
        downPoint,
        6,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        downPoint,
        6,
        Paint()
          ..color = const Color(0xff4caf50)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TrafficTrendPainter oldDelegate) =>
      oldDelegate.upload != upload ||
      oldDelegate.download != download ||
      oldDelegate.logs != logs ||
      oldDelegate.labelStyle != labelStyle ||
      oldDelegate.hoveredIndex != hoveredIndex;
}

class ProfileItem extends StatelessWidget {
  final Profile profile;
  final String? groupValue;
  final void Function(String? value) onChanged;

  const ProfileItem({
    super.key,
    required this.profile,
    required this.groupValue,
    required this.onChanged,
  });

  _handleDeleteProfile(BuildContext context) async {
    final res = await globalState.showMessage(
      title: appLocalizations.tip,
      message: TextSpan(
        text: appLocalizations.deleteTip(appLocalizations.profile),
      ),
    );
    if (res != true) {
      return;
    }
    await globalState.appController.deleteProfile(profile.id);
  }

  Future updateProfile() async {
    final appController = globalState.appController;
    if (profile.type == ProfileType.file) return;
    await globalState.safeRun(silence: false, () async {
      try {
        appController.setProfile(
          profile.copyWith(
            isUpdating: true,
          ),
        );
        await appController.updateProfile(profile);
      } catch (e) {
        appController.setProfile(
          profile.copyWith(
            isUpdating: false,
          ),
        );
        rethrow;
      }
    });
  }

  _handleShowEditExtendPage(BuildContext context) {
    showExtend(
      context,
      builder: (_, type) {
        return AdaptiveSheetScaffold(
          type: type,
          body: EditProfileView(
            profile: profile,
            context: context,
          ),
          title: "${appLocalizations.edit}${appLocalizations.profile}",
        );
      },
    );
  }

  List<Widget> _buildUrlProfileInfo(BuildContext context) {
    final subscriptionInfo = profile.subscriptionInfo;
    return [
      const SizedBox(
        height: 8,
      ),
      if (subscriptionInfo != null)
        SubscriptionInfoView(
          subscriptionInfo: subscriptionInfo,
        ),
      Text(
        profile.lastUpdateDate?.lastUpdateTimeDesc ?? "",
        style: context.textTheme.labelMedium?.toLight,
      ),
    ];
  }

  List<Widget> _buildFileProfileInfo(BuildContext context) {
    return [
      const SizedBox(
        height: 8,
      ),
      Text(
        profile.lastUpdateDate?.lastUpdateTimeDesc ?? "",
        style: context.textTheme.labelMedium?.toLight,
      ),
    ];
  }

  // _handleCopyLink(BuildContext context) async {
  //   await Clipboard.setData(
  //     ClipboardData(
  //       text: profile.url,
  //     ),
  //   );
  //   if (context.mounted) {
  //     context.showNotifier(appLocalizations.copySuccess);
  //   }
  // }

  _handleExportFile(BuildContext context) async {
    final commonScaffoldState = context.commonScaffoldState;
    final res = await commonScaffoldState?.loadingRun<bool>(
      () async {
        final file = await profile.getFile();
        final value = await picker.saveFile(
          profile.label ?? profile.id,
          file.readAsBytesSync(),
        );
        if (value == null) return false;
        return true;
      },
      title: appLocalizations.tip,
    );
    if (res == true && context.mounted) {
      context.showNotifier(appLocalizations.exportSuccess);
    }
  }

  _handlePushGenProfilePage(BuildContext context, String id) {
    final overrideProfileView = OverrideProfileView(
      profileId: id,
    );
    BaseNavigator.modal(
      context,
      overrideProfileView,
    );
  }

  // Check if profile is from XBoard API (logged in user's subscription)
  bool get _isXBoardProfile {
    // XBoard profiles are labeled as "XBoard Subscription" when created
    return profile.label == 'XBoard Subscription';
  }

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      isSelected: profile.id == groupValue,
      onPressed: () {
        onChanged(profile.id);
      },
      child: ListItem(
        key: Key(profile.id),
        horizontalTitleGap: 16,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        trailing: SizedBox(
          height: 40,
          width: 40,
          child: FadeThroughBox(
            child: profile.isUpdating
                ? const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  )
                : CommonPopupBox(
                    popup: CommonPopupMenu(
                      items: [
                        // Only show edit, override, export, delete for non-XBoard profiles
                        if (!_isXBoardProfile) ...[
                          PopupMenuItemData(
                            icon: Icons.edit_outlined,
                            label: appLocalizations.edit,
                            onPressed: () {
                              _handleShowEditExtendPage(context);
                            },
                          ),
                        ],
                        if (profile.type == ProfileType.url) ...[
                          PopupMenuItemData(
                            icon: Icons.sync_alt_sharp,
                            label: appLocalizations.sync,
                            onPressed: () {
                              updateProfile();
                            },
                          ),
                        ],
                        if (!_isXBoardProfile) ...[
                          PopupMenuItemData(
                            icon: Icons.extension_outlined,
                            label: appLocalizations.override,
                            onPressed: () {
                              _handlePushGenProfilePage(context, profile.id);
                            },
                          ),
                          PopupMenuItemData(
                            icon: Icons.file_copy_outlined,
                            label: appLocalizations.exportFile,
                            onPressed: () {
                              _handleExportFile(context);
                            },
                          ),
                          PopupMenuItemData(
                            icon: Icons.delete_outlined,
                            label: appLocalizations.delete,
                            onPressed: () {
                              _handleDeleteProfile(context);
                            },
                          ),
                        ],
                      ],
                    ),
                    targetBuilder: (open) {
                      return IconButton(
                        onPressed: () {
                          open();
                        },
                        icon: Icon(Icons.more_vert),
                      );
                    },
                  ),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                profile.label ?? profile.id,
                style: context.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...switch (profile.type) {
                    ProfileType.file => _buildFileProfileInfo(context),
                    ProfileType.url => _buildUrlProfileInfo(context),
                  },
                ],
              ),
            ],
          ),
        ),
        tileTitleAlignment: ListTileTitleAlignment.titleHeight,
      ),
    );
  }
}

class ReorderableProfilesSheet extends StatefulWidget {
  final List<Profile> profiles;
  final SheetType type;

  const ReorderableProfilesSheet({
    super.key,
    required this.profiles,
    required this.type,
  });

  @override
  State<ReorderableProfilesSheet> createState() =>
      _ReorderableProfilesSheetState();
}

class _ReorderableProfilesSheetState extends State<ReorderableProfilesSheet> {
  late List<Profile> profiles;

  @override
  void initState() {
    super.initState();
    profiles = List.from(widget.profiles);
  }

  Widget proxyDecorator(
    Widget child,
    int index,
    Animation<double> animation,
  ) {
    final profile = profiles[index];
    return AnimatedBuilder(
      animation: animation,
      builder: (_, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        key: Key(profile.id),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: CommonCard(
          type: CommonCardType.filled,
          child: ListTile(
            contentPadding: const EdgeInsets.only(
              right: 44,
              left: 16,
            ),
            title: Text(profile.label ?? profile.id),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveSheetScaffold(
      type: widget.type,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            globalState.appController.setProfiles(profiles);
          },
          icon: Icon(
            Icons.save,
          ),
        )
      ],
      body: Padding(
        padding: EdgeInsets.only(
          bottom: 32,
          top: 16,
        ),
        child: ReorderableListView.builder(
          buildDefaultDragHandles: false,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          proxyDecorator: proxyDecorator,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final profile = profiles.removeAt(oldIndex);
              profiles.insert(newIndex, profile);
            });
          },
          itemBuilder: (_, index) {
            final profile = profiles[index];
            return Container(
              key: Key(profile.id),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: CommonCard(
                type: CommonCardType.filled,
                child: ListTile(
                  contentPadding: const EdgeInsets.only(
                    right: 16,
                    left: 16,
                  ),
                  title: Text(profile.label ?? profile.id),
                  trailing: ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle),
                  ),
                ),
              ),
            );
          },
          itemCount: profiles.length,
        ),
      ),
      title: appLocalizations.profilesSort,
    );
  }
}
