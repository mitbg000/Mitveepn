import 'package:mitveepn/xboard/sdk/xboard_sdk.dart';
import 'package:mitveepn/xboard/core/core.dart';
import 'package:mitveepn/xboard/features/auth/providers/xboard_user_provider.dart';
import 'package:mitveepn/xboard/features/payment/providers/xboard_payment_provider.dart';
import 'package:mitveepn/xboard/features/payment/providers/selected_plan_provider.dart';

import '../widgets/payment_waiting_overlay.dart';
import '../models/payment_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mitveepn/l10n/l10n.dart';
class PlanPurchasePage extends ConsumerStatefulWidget {
  const PlanPurchasePage({
    super.key,
  });
  @override
  ConsumerState<PlanPurchasePage> createState() => _PlanPurchasePageState();
}
class _PlanPurchasePageState extends ConsumerState<PlanPurchasePage> {
  String? _selectedPeriod;
  String? _couponCode;
  final _couponController = TextEditingController();
  bool _isCouponValidating = false;
  bool? _isCouponValid;
  double? _discountAmount;
  double? _finalPrice;
  double? _userBalance;
  bool _isLoadingBalance = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final periods = _getAvailablePeriods(context);
      if (periods.isNotEmpty && _selectedPeriod == null) {  
        setState(() {
          _selectedPeriod = periods.first['period'];
        });
      }
      _loadUserBalance();
    });
  }
  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }
  String _formatTraffic(double transferEnable) {
    if (transferEnable >= 1024) {
      return '${(transferEnable / 1024).toStringAsFixed(1)}TB';
    }
    return '${transferEnable.toStringAsFixed(0)}GB';
  }
  String _formatPrice(double? price) {
    if (price == null) return '-';
    return '¥${price.toStringAsFixed(2)}';
  }
  Future<void> _loadUserBalance() async {
    setState(() {
      _isLoadingBalance = true;
    });
    try {
      final userInfo = await XBoardSDK.getUserInfo();
      setState(() {
        _userBalance = userInfo?.balanceInYuan;
      });
    } catch (e) {
      setState(() {
        _userBalance = null;
      });
    } finally {
      setState(() {
        _isLoadingBalance = false;
      });
    }
  }
  List<Map<String, dynamic>> _getAvailablePeriods(BuildContext context) {
    final plan = ref.read(selectedPlanProvider);
    if (plan == null) return [];

    final List<Map<String, dynamic>> periods = [];
    if (plan.monthPrice != null) {
      periods.add({
        'period': 'month_price',
        'label': AppLocalizations.of(context).xboardMonthlyPayment,
        'price': plan.monthPrice!,
        'description': AppLocalizations.of(context).xboardMonthlyRenewal,
      });
    }
    if (plan.quarterPrice != null) {
      periods.add({
        'period': 'quarter_price',
        'label': AppLocalizations.of(context).xboardQuarterlyPayment,
        'price': plan.quarterPrice!,
        'description': AppLocalizations.of(context).xboardThreeMonthCycle,
      });
    }
    if (plan.halfYearPrice != null) {
      periods.add({
        'period': 'half_year_price',
        'label': AppLocalizations.of(context).xboardHalfYearlyPayment,
        'price': plan.halfYearPrice!,
        'description': AppLocalizations.of(context).xboardSixMonthCycle,
      });
    }
    if (plan.yearPrice != null) {
      periods.add({
        'period': 'year_price',
        'label': AppLocalizations.of(context).xboardYearlyPayment,
        'price': plan.yearPrice!,
        'description': AppLocalizations.of(context).xboardTwelveMonthCycle,
      });
    }
    // Loại bỏ 2 year, 3 year, và one time periods
    return periods;
  }
  Future<void> _proceedToPurchase() async {
    final plan = ref.read(selectedPlanProvider);
    if (plan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).xboardPlanNotFound)),
      );
      return;
    }

    if (_selectedPeriod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).xboardPleaseSelectPaymentPeriod)),
      );
      return;
    }
    try {
      String? tradeNo;
      XBoardLogger.debug('[FlClash] [确认购买] 开始购买流程，套餐ID: ${plan.id}, 周期: $_selectedPeriod');

      // Step 1: Create order first (without showing overlay)
      XBoardLogger.debug('[FlClash] [确认购买] 步骤1: 开始创建订单');
      XBoardLogger.debug('[FlClash] [确认购买] 调用 createOrder 接口');
      final paymentNotifier = ref.read(xboardPaymentProvider.notifier);
      tradeNo = await paymentNotifier.createOrder(
        planId: plan.id,
        period: _selectedPeriod!,
        couponCode: _couponCode,
      );
      XBoardLogger.debug('[FlClash] [确认购买] createOrder 返回结果: $tradeNo');
      if (tradeNo == null) {
        final errorMessage = ref.read(userUIStateProvider).errorMessage;
        XBoardLogger.debug('[FlClash] [确认购买] 订单创建失败: $errorMessage');
        if (!mounted) return;
        throw Exception('${AppLocalizations.of(context).xboardOrderCreationFailed}: ${errorMessage ?? AppLocalizations.of(context).xboardOperationFailed}');
      }
      XBoardLogger.debug('[FlClash] [确认购买] 订单创建成功，订单号: $tradeNo');

      // Step 2: Get payment methods
      XBoardLogger.debug('[FlClash] [确认购买] 获取支付方式列表');
      final paymentMethods = await XBoardSDK.getPaymentMethods();
      XBoardLogger.debug('[FlClash] 支付方式获取响应: 获取到 ${paymentMethods.length} 个支付方式');
      if (paymentMethods.isEmpty) {
        if (!mounted) return;
        throw Exception(AppLocalizations.of(context).xboardNoPaymentMethods);
      }

      // Step 3: Show payment method selection dialog (no overlay blocking it)
      if (!mounted) return;
      final selectedMethod = await _showPaymentMethodDialog(paymentMethods);
      if (selectedMethod == null) {
        // User cancelled - no need to show/hide overlay since it was never shown
        return;
      }

      // Step 4: User selected a payment method - NOW show the waiting overlay
      XBoardLogger.debug('[FlClash] 用户选择支付方式: ID=${selectedMethod.id}, Name=${selectedMethod.name}');
      if (mounted) {
        XBoardLogger.debug('[FlClash] [确认购买] 显示支付等待页面');
        PaymentWaitingManager.show(
          context,
          onClose: () {
            Navigator.of(context).pop();
          },
          onPaymentSuccess: () {
            XBoardLogger.debug('[支付成功] ===== 收到支付成功回调 =====');
            XBoardLogger.debug('[支付成功] 当前页面是否已挂载: $mounted');
            XBoardLogger.debug('[支付成功] 开始刷新订阅信息');

            try {
              final userProvider = ref.read(xboardUserProvider.notifier);
              XBoardLogger.debug('[支付成功] 获取到 xboardUserProvider: $userProvider');
              userProvider.refreshSubscriptionInfoAfterPayment();
              XBoardLogger.debug('[支付成功] 订阅信息刷新请求已发送');
            } catch (e) {
              XBoardLogger.debug('[支付成功] 刷新订阅信息时出错: $e');
            }

            XBoardLogger.debug('[支付成功] 准备延迟300ms后导航');
            Future.delayed(const Duration(milliseconds: 300), () {
              XBoardLogger.debug('[支付成功] 延迟结束，检查页面挂载状态: $mounted');
              if (mounted) {
                XBoardLogger.debug('[支付成功] 开始导航回首页，当前路由栈深度: ${Navigator.of(context).canPop()}');
                try {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  XBoardLogger.debug('[支付成功] 导航完成，已返回首页');
                } catch (e) {
                  XBoardLogger.debug('[支付成功] 导航时出错: $e');
                }
              } else {
                XBoardLogger.debug('[支付成功] 页面已卸载，无法导航');
              }
            });
          },
          tradeNo: tradeNo,
        );
        PaymentWaitingManager.updateStep(PaymentStep.cancelingOrders);
      }

      // Step 5: Continue with payment processing
      XBoardLogger.debug('[FlClash] [确认购买] 步骤2: 开始加载支付页面');
      PaymentWaitingManager.updateStep(PaymentStep.loadingPayment);
      XBoardLogger.debug('[FlClash] [确认购买] 步骤3: 验证支付方式');
      PaymentWaitingManager.updateStep(PaymentStep.verifyPayment);
      XBoardLogger.debug('[FlClash] [确认购买] 检查订单状态...');
      try {
        final orderStatus = await XBoardSDK.getOrderByTradeNo(tradeNo);
        if (orderStatus != null) {
          XBoardLogger.debug('[FlClash] [确认购买] 订单状态检查: status=${orderStatus.status}, trade_no=${orderStatus.tradeNo}');
        } else {
          XBoardLogger.debug('[FlClash] [确认购买] 警告: 无法找到订单状态信息');
        }
      } catch (e) {
        XBoardLogger.debug('[FlClash] [确认购买] 订单状态检查失败: $e');
      }
      XBoardLogger.debug('[FlClash] [确认购买] 开始创建支付网关，订单号: $tradeNo, 支付方式: ${selectedMethod.id}');
      XBoardLogger.debug('[FlClash] [确认购买] 使用 PaymentProvider 提交支付');
      XBoardLogger.debug('[FlClash] [确认购买] 支付方式ID类型: ${selectedMethod.id.runtimeType}, 值: ${selectedMethod.id}');
      final paymentUrl = await paymentNotifier.submitPayment(
        tradeNo: tradeNo,
        method: selectedMethod.id.toString(),
      );
      XBoardLogger.debug('[FlClash] [确认购买] 支付提交完成，支付链接: $paymentUrl');
      if (mounted) {
        XBoardLogger.debug('[FlClash] [确认购买] 处理支付结果');
        if (paymentUrl != null && paymentUrl.isNotEmpty) {
          // 支付提交成功，打开支付链接
          PaymentWaitingManager.updateStep(PaymentStep.waitingPayment);
          XBoardLogger.debug('[FlClash] [确认购买] 支付链接获取成功，准备打开浏览器');
          
          // 打开支付链接
          await _launchPaymentUrl(paymentUrl, tradeNo);

          XBoardLogger.debug('[FlClash] [确认购买] 支付链接已打开，等待用户完成支付');
        } else {
          if (!mounted) return;
          throw Exception(AppLocalizations.of(context).xboardPaymentFailed);
        }
      }
    } catch (e) {
      XBoardLogger.error('购买流程出错: $e');
      // Error handling for domain service exceptions
      XBoardLogger.error('支付错误详情: $e');
      if (mounted) {
        PaymentWaitingManager.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context).xboardOperationFailed}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  Future<void> _launchPaymentUrl(String url, String tradeNo) async {
    try {
      if (mounted) {
        await Clipboard.setData(ClipboardData(text: url));
        final uri = Uri.parse(url);
        if (!await canLaunchUrl(uri)) {
          if (!mounted) return;
          throw Exception(AppLocalizations.of(context).xboardCannotOpenPaymentLink);
        }
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          if (!mounted) return;
          throw Exception(AppLocalizations.of(context).xboardCannotLaunchBrowser);
        }
        XBoardLogger.debug('[FlClash] 支付页面已在浏览器中打开，订单号: $tradeNo');
        XBoardLogger.debug('[FlClash] 支付链接已复制到剪贴板');
      }
    } catch (e) {
      if (mounted) {
        PaymentWaitingManager.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).xboardOpenPaymentPageFailed(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  Widget _buildPeriodSelector() {
    final periods = _getAvailablePeriods(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = ((screenWidth - 64) / 2).clamp(140.0, 300.0);

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: periods.map((period) {
        final isSelected = _selectedPeriod == period['period'];
        final discount = _calculateDiscount(period);

        return InkWell(
          onTap: () {
            setState(() {
              _selectedPeriod = period['period'];
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: cardWidth,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2D4A5C) : const Color(0xFF1A2332),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFF6FCF97) : const Color(0xFF2B3544),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: isSelected ? const Color(0xFF6FCF97) : const Color(0xFF6B7785),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            period['label'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : const Color(0xFFB0B8C1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _formatPrice(period['price']),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? const Color(0xFF6FCF97) : Colors.white,
                      ),
                    ),
                  ],
                ),
                if (discount > 0)
                  Positioned(
                    top: -8,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '-${discount.toInt()}%',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  int _calculateDiscount(Map<String, dynamic> period) {
    // Calculate discount based on period
    switch (period['period']) {
      case 'quarter_price':
        return 10;
      case 'half_year_price':
        return 25;
      case 'year_price':
        return 33;
      default:
        return 0;
    }
  }
  Future<void> _validateCoupon() async {
    if (_couponController.text.trim().isEmpty) {
      if (mounted) {
        setState(() {
          _isCouponValid = null;
          _discountAmount = null;
          _finalPrice = null;
          _couponCode = null;
        });
      }
      return;
    }
    if (mounted) {
      setState(() {
        _isCouponValidating = true;
        _isCouponValid = null;
      });
    }
    try {
      final plan = ref.read(selectedPlanProvider);
      if (plan == null) return;

      final couponCode = _couponController.text.trim();
      final isValid = await XBoardSDK.checkCoupon(
        code: couponCode,
        planId: plan.id,
      );
      if (isValid) {
        if (mounted) {
          setState(() {
            _isCouponValid = true;
            _couponCode = couponCode;
            _discountAmount = null;
            _finalPrice = null;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isCouponValid = false;
            _discountAmount = null;
            _finalPrice = null;
            _couponCode = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCouponValid = false;
          _discountAmount = null;
          _finalPrice = null;
          _couponCode = null;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCouponValidating = false;
        });
      }
    }
  }
  // ignore: unused_element
  double _getCurrentPrice() {
    if (_selectedPeriod == null) return 0.0;
    final periods = _getAvailablePeriods(context);
    final selectedPeriod = periods.firstWhere(
      (period) => period['period'] == _selectedPeriod,
      orElse: () => {},
    );
    return selectedPeriod['price']?.toDouble() ?? 0.0;
  }

  Widget _buildCouponSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2B3544), width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F1621),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isCouponValid == false
                    ? Colors.red.shade300
                    : _isCouponValid == true
                        ? const Color(0xFF6FCF97)
                        : const Color(0xFF2B3544),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _couponController,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppLocalizations.of(context).xboardEnterCouponCode,
                hintStyle: const TextStyle(
                  color: Color(0xFF6B7785),
                  fontSize: 15,
                ),
                prefixIcon: Icon(
                  Icons.local_offer_outlined,
                  color: _isCouponValid == false
                      ? Colors.red.shade400
                      : _isCouponValid == true
                          ? const Color(0xFF6FCF97)
                          : const Color(0xFF6B7785),
                  size: 20,
                ),
                suffixIcon: _isCouponValid != null
                    ? Icon(
                        _isCouponValid! ? Icons.check_circle : Icons.cancel,
                        color: _isCouponValid! ? const Color(0xFF6FCF97) : Colors.red,
                        size: 20,
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: (value) {
                if (_isCouponValid != null) {
                  setState(() {
                    _isCouponValid = null;
                    _discountAmount = null;
                    _finalPrice = null;
                    _couponCode = null;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isCouponValidating ? null : _validateCoupon,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6FCF97),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                elevation: 0,
              ),
              child: _isCouponValidating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context).xboardApply,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final plan = ref.watch(selectedPlanProvider);
    if (plan == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0B0E14),
        body: Center(child: Text(AppLocalizations.of(context).xboardPlanNotFound, style: const TextStyle(color: Colors.white))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      body: Column(
        children: [
          // Custom header with back button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF0B0E14),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF2B3544),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).xboardCreateOrder,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).xboardSelectAPlan,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildSelectedPlanCard(plan),
            const SizedBox(height: 28),
            Text(
              AppLocalizations.of(context).xboardSelectPeriod,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildPeriodSelector(),
            const SizedBox(height: 24),
            _buildCouponSection(),
            const SizedBox(height: 24),
            _buildPriceSummary(),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Consumer(
                builder: (context, ref, child) {
                  final paymentState = ref.watch(userUIStateProvider);
                  return ElevatedButton(
                    onPressed: paymentState.isLoading
                        ? null
                        : () => _proceedToPurchase(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6FCF97),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: paymentState.isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(AppLocalizations.of(context).xboardProcessing),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.credit_card, size: 20),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  AppLocalizations.of(context).xboardSelectPaymentMethod,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
          ],
        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPlanCard(PlanData plan) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6FCF97), Color(0xFF4DB8A0)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  plan.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2A3A),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context).xboardChange,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                '¥',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                _getLowestPrice(plan).replaceAll('¥', ''),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context).xboardPerMonth,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.data_usage_rounded, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    _formatTraffic(plan.transferEnable),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.speed_rounded, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    '${plan.speedLimit ?? 100} ${AppLocalizations.of(context).xboardMbps}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.devices_rounded, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      plan.deviceLimit != null && plan.deviceLimit! > 0
                          ? '${plan.deviceLimit} ${AppLocalizations.of(context).xboardDevices}'
                          : AppLocalizations.of(context).xboardUnlimited,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
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
    return lowestPrice.toStringAsFixed(2);
  }

  Future<PaymentMethod?> _showPaymentMethodDialog(
    List<PaymentMethod> paymentMethods,
  ) {
    return showModalBottomSheet<PaymentMethod>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1A2332),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B3544),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                AppLocalizations.of(context).xboardSelectPaymentMethod,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ...paymentMethods.map((method) {
                return InkWell(
                  onTap: () => Navigator.of(context).pop(method),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1621),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2B3544), width: 1),
                    ),
                    child: Row(
                      children: [
                        if (method.icon != null && method.icon!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Image.network(
                              method.icon!,
                              width: 28,
                              height: 28,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.payment,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.payment,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            method.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF6B7785),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceSummary() {
    final currentPrice = _getCurrentPrice();
    final discount = _discountAmount ?? 0.0;
    final finalAmount = _finalPrice ?? currentPrice;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2B3544), width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).xboardOriginalPrice,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFFB0B8C1),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _formatPrice(currentPrice),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).xboardDiscount,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFFB0B8C1),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _formatPrice(discount),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF2B3544), height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).xboardAmountToPay,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                _formatPrice(finalAmount),
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF6FCF97),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 