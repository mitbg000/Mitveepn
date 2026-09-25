import 'package:mitveepn/common/common.dart';
import 'package:mitveepn/xboard/sdk/xboard_sdk.dart';
import 'package:mitveepn/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:mitveepn/xboard/features/subscription/providers/xboard_subscription_provider.dart';
import 'package:mitveepn/xboard/features/payment/providers/selected_plan_provider.dart';
import 'plan_purchase_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlansView extends ConsumerStatefulWidget {
  const PlansView({super.key});
  @override
  ConsumerState<PlansView> createState() => _PlansViewState();
}

class _PlansViewState extends ConsumerState<PlansView> with PageMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final subscriptionNotifier = ref.read(xboardSubscriptionProvider.notifier);
      subscriptionNotifier.autoRefreshIfNeeded();
    });
  }
  Future<void> _refreshPlans() async {
    final subscriptionNotifier = ref.read(xboardSubscriptionProvider.notifier);
    await subscriptionNotifier.refreshPlans();
  }
  String _formatPrice(double? price) {
    if (price == null) return '-';
    return '¥${price.toStringAsFixed(2)}';
  }
  String _formatTraffic(double transferEnable) {
    if (transferEnable >= 1024) {
      return '${(transferEnable / 1024).toStringAsFixed(1)}TB';
    }
    return '${transferEnable.toStringAsFixed(0)}GB';
  }
  String _getLowestPrice(PlanData plan) {
    List<double> prices = [];
    if (plan.monthPrice != null) prices.add(plan.monthPrice!);
    if (plan.quarterPrice != null) prices.add(plan.quarterPrice!);
    if (plan.halfYearPrice != null) prices.add(plan.halfYearPrice!);
    if (plan.yearPrice != null) prices.add(plan.yearPrice!);
    if (plan.twoYearPrice != null) prices.add(plan.twoYearPrice!);
    if (plan.threeYearPrice != null) prices.add(plan.threeYearPrice!);
    if (plan.onetimePrice != null) prices.add(plan.onetimePrice!);
    if (prices.isEmpty) return '-';
    final lowestPrice = prices.reduce((a, b) => a < b ? a : b);
    return _formatPrice(lowestPrice);
  }
  int? _getSpeedLimitText(PlanData plan) {
    // 直接使用PlanData模型中的formattedSpeedLimit方法
    return plan.speedLimit;
  }
  Widget _buildPlanCard(PlanData plan, {required bool isDesktop}) {
    final textTheme = context.textTheme;

    return Container(
      margin: isDesktop
        ? EdgeInsets.zero
        : const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6FCF97), Color(0xFF4DB8A0)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.name.toUpperCase(),
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 6,
              children: [
                Text(
                  '¥',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _getLowestPrice(plan).replaceAll('¥', ''),
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                Text(
                  appLocalizations.xboardPerMonth,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFeatureRow(
              Icons.data_usage_rounded,
              _formatTraffic(plan.transferEnable),
              textTheme,
            ),
            const SizedBox(height: 10),
            if (_getSpeedLimitText(plan) != null)
              _buildFeatureRow(
                Icons.speed_rounded,
                '${_getSpeedLimitText(plan)} ${appLocalizations.xboardMbps}',
                textTheme,
              ),
            if (_getSpeedLimitText(plan) != null)
              const SizedBox(height: 10),
            _buildFeatureRow(
              Icons.devices_rounded,
              plan.deviceLimit != null && plan.deviceLimit! > 0
                  ? '${plan.deviceLimit} ${appLocalizations.xboardDevices}'
                  : appLocalizations.xboardUnlimited,
              textTheme,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: plan.hasPrice ? () => _navigateToPurchase(plan) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2A3A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  appLocalizations.xboardSelectAPlan,
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text, TextTheme textTheme) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  void _navigateToPurchase(PlanData plan) {
    // Set selected plan in provider
    ref.read(selectedPlanProvider.notifier).state = plan;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Dialog.fullscreen(
        child: PlanPurchasePage(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPlans,
      child: Consumer(
        builder: (context, ref, child) {
          final plans = ref.watch(xboardSubscriptionProvider);
          final uiState = ref.watch(userUIStateProvider);
          if (uiState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (uiState.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    appLocalizations.xboardLoadFailed,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      uiState.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshPlans,
                      child: Text(appLocalizations.xboardRetry),
                    ),
                  ],
                ),
              );
            }
            if (plans.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      appLocalizations.xboardNoPlansAvailable,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalizations.xboardSelectAPlan,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      const cardsPerRow = 3;
                      const spacing = 24.0;
                      final isWide = constraints.maxWidth > 700;
                      if (!isWide) {
                        return Column(
                          children: plans
                              .map((plan) => _buildPlanCard(plan, isDesktop: false))
                              .toList(),
                        );
                      }
                      final cardWidth =
                          (constraints.maxWidth - spacing * (cardsPerRow - 1)) /
                              cardsPerRow;
                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: plans.map((plan) {
                          return SizedBox(
                            width: cardWidth,
                            child: _buildPlanCard(plan, isDesktop: true),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
    );
  }
}