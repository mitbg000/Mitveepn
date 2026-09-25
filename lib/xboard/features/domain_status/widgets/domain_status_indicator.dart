import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitveepn/common/common.dart';
import 'package:mitveepn/widgets/widgets.dart';
import 'package:mitveepn/state.dart';
import '../models/domain_status_state.dart';
import '../providers/domain_status_provider.dart';
import 'login_add_profile_view.dart';

/// 域名状态指示器组件
class DomainStatusIndicator extends ConsumerWidget {
  final bool showText;
  final bool showLatency;
  final EdgeInsets? padding;

  const DomainStatusIndicator({
    super.key,
    this.showText = true,
    this.showLatency = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final domainStatus = ref.watch(domainStatusProvider);
    final colorScheme = Theme.of(context).colorScheme;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (domainStatus.status) {
      case DomainStatus.checking:
        statusColor = Colors.orange;
        statusText = appLocalizations.domainStatusChecking;
        statusIcon = Icons.sync;
        break;
      case DomainStatus.success:
        statusColor = Colors.green;
        statusText = appLocalizations.domainStatusAvailable;
        statusIcon = Icons.check_circle;
        break;
      case DomainStatus.failed:
        statusColor = Colors.red;
        statusText = appLocalizations.domainStatusUnavailable;
        statusIcon = Icons.error;
        break;
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 状态指示器
        domainStatus.status == DomainStatus.checking
            ? SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                ),
              )
            : Icon(
                statusIcon,
                size: 12,
                color: statusColor,
              ),
        
        if (showText) ...[
          const SizedBox(width: 6),
          Text(
            statusText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
        
        if (showLatency && domainStatus.latency != null) ...[
          const SizedBox(width: 4),
          Text(
            '${domainStatus.latency}ms',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withAlpha(179),
              fontSize: 10,
            ),
          ),
        ],
      ],
    );

    if (padding != null) {
      return Padding(
        padding: padding!,
        child: content,
      );
    }

    return content;
  }
}

/// 域名状态详情对话框
class DomainStatusDialog extends ConsumerStatefulWidget {
  const DomainStatusDialog({super.key});

  @override
  ConsumerState<DomainStatusDialog> createState() => _DomainStatusDialogState();
}

class _DomainStatusDialogState extends ConsumerState<DomainStatusDialog> {

  /// Xử lý thêm profile và chuyển vào app
  void _handleAddProfileSuccess() {
    debugPrint('[DomainStatusDialog] Profile added successfully! Navigating to home...');

    // Sử dụng WidgetsBinding để đảm bảo navigation chạy sau frame hiện tại
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final navigator = globalState.navigatorKey.currentState;
        if (navigator == null) {
          debugPrint('[DomainStatusDialog] Navigator is null!');
          return;
        }

        debugPrint('[DomainStatusDialog] Navigator found, navigating...');

        // Đóng tất cả và navigate đến home
        navigator.pushNamedAndRemoveUntil('/', (route) => false);

        debugPrint('[DomainStatusDialog] Navigation command sent');

        // Hiển thị thông báo
        Future.delayed(const Duration(milliseconds: 800), () {
          if (navigator.context.mounted) {
            ScaffoldMessenger.of(navigator.context).showSnackBar(
              SnackBar(
                content: Text(appLocalizations.profileAddedSuccessfully),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        });
      } catch (e, stackTrace) {
        debugPrint('[DomainStatusDialog] Navigation error: $e');
        debugPrint('[DomainStatusDialog] Stack trace: $stackTrace');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final domainStatus = ref.watch(domainStatusProvider);
    final domainNotifier = ref.read(domainStatusProvider.notifier);

    return AlertDialog(
      title: Text(appLocalizations.domainStatusTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 当前状态
          _buildInfoRow(
            context,
            Icons.dns,
            appLocalizations.status,
            _getStatusText(domainStatus.status),
          ),
          
          // 当前域名
          if (domainStatus.currentDomain != null)
            _buildInfoRow(
              context,
              Icons.language,
              appLocalizations.domain,
              domainStatus.currentDomain!,
            ),
          
          // 延迟
          if (domainStatus.latency != null)
            _buildInfoRow(
              context,
              Icons.speed,
              appLocalizations.delay,
              '${domainStatus.latency}ms',
            ),
          
          // 最后检查时间
          if (domainStatus.lastChecked != null)
            _buildInfoRow(
              context,
              Icons.access_time,
              appLocalizations.lastChecked,
              _formatDateTime(domainStatus.lastChecked!),
            ),
          
          // 错误信息
          if (domainStatus.errorMessage != null)
            _buildInfoRow(
              context,
              Icons.error_outline,
              appLocalizations.errorMessage,
              domainStatus.errorMessage!,
              isError: true,
            ),
          
          // 可用域名数量
          if (domainStatus.availableDomains.isNotEmpty)
            _buildInfoRow(
              context,
              Icons.list,
              appLocalizations.availableDomains,
              '${domainStatus.availableDomains.length}',
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Mở trang add profile (subscription) với callback
            showExtend(
              context,
              builder: (_, type) {
                return AdaptiveSheetScaffold(
                  type: type,
                  body: LoginAddProfileView(
                    parentContext: context,
                    onProfileAdded: _handleAddProfileSuccess,
                  ),
                  title: appLocalizations.addSubscription,
                );
              },
            );
          },
          child: Text(appLocalizations.addSubscription),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await domainNotifier.refresh();
          },
          child: Text(appLocalizations.refresh),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(appLocalizations.cancel),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    bool isError = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isError 
                        ? Theme.of(context).colorScheme.error 
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(DomainStatus status) {
    switch (status) {
      case DomainStatus.checking:
        return appLocalizations.domainStatusChecking;
      case DomainStatus.success:
        return appLocalizations.domainStatusAvailable;
      case DomainStatus.failed:
        return appLocalizations.domainStatusUnavailable;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return appLocalizations.just;
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${appLocalizations.minutes}${appLocalizations.ago}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${appLocalizations.hours}${appLocalizations.ago}';
    } else {
      return '${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}

/// 显示域名状态详情对话框
void showDomainStatusDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const DomainStatusDialog(),
  );
}
