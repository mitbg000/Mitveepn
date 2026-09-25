import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitveepn/xboard/features/notice/providers/notice_provider.dart';
import 'package:mitveepn/xboard/sdk/xboard_sdk.dart';
import 'package:intl/intl.dart';

/// Notice List Page - 公告列表页面
class NoticeListPage extends ConsumerStatefulWidget {
  const NoticeListPage({super.key});

  @override
  ConsumerState<NoticeListPage> createState() => _NoticeListPageState();
}

class _NoticeListPageState extends ConsumerState<NoticeListPage> {
  @override
  void initState() {
    super.initState();
    // Fetch notices on page load
    Future.microtask(() => ref.read(noticeProvider.notifier).fetchNotices());
  }

  @override
  Widget build(BuildContext context) {
    final noticeState = ref.watch(noticeProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF171D21),
        elevation: 0,
      ),
      body: _buildBody(noticeState),
    );
  }

  Widget _buildBody(NoticeState state) {
    if (state.isLoading && state.notices.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF38BDF8),
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFFE95A5A),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load notifications',
              style: TextStyle(
                color: const Color(0xFFF8FAFC).withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.error ?? '',
              style: TextStyle(
                color: const Color(0xFFF8FAFC).withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(noticeProvider.notifier).fetchNotices(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF38BDF8),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (state.notices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: const Color(0xFFF8FAFC).withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications',
              style: TextStyle(
                color: const Color(0xFFF8FAFC).withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(noticeProvider.notifier).fetchNotices(),
      color: const Color(0xFF38BDF8),
      backgroundColor: const Color(0xFF171D21),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.notices.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final notice = state.notices[index];
          return _NoticeCard(
            notice: notice,
            onTap: () => _showNoticeDetail(notice),
          );
        },
      ),
    );
  }

  void _showNoticeDetail(NoticeData notice) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _NoticeDetailSheet(notice: notice),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final NoticeData notice;
  final VoidCallback onTap;

  const _NoticeCard({
    required this.notice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = _formatDate(notice.createdAt);

    return Material(
      color: const Color(0xFF171D21),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF2B353B),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.campaign_rounded,
                    size: 20,
                    color: Color(0xFF38BDF8),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      notice.title,
                      style: const TextStyle(
                        color: Color(0xFFF8FAFC),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notice.content,
                style: TextStyle(
                  color: const Color(0xFFF8FAFC).withValues(alpha: 0.7),
                  fontSize: 14,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: const Color(0xFFF8FAFC).withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateText,
                    style: TextStyle(
                      color: const Color(0xFFF8FAFC).withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: const Color(0xFFF8FAFC).withValues(alpha: 0.4),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }
}

class _NoticeDetailSheet extends StatelessWidget {
  final NoticeData notice;

  const _NoticeDetailSheet({required this.notice});

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('MMM dd, yyyy HH:mm').format(
      DateTime.fromMillisecondsSinceEpoch(notice.createdAt * 1000),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0B0E14),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.campaign_rounded,
                          size: 24,
                          color: Color(0xFF38BDF8),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            notice.title,
                            style: const TextStyle(
                              color: Color(0xFFF8FAFC),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: const Color(0xFFF8FAFC).withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          dateText,
                          style: TextStyle(
                            color: const Color(0xFFF8FAFC).withValues(alpha: 0.5),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF171D21),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2B353B),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        notice.content,
                        style: const TextStyle(
                          color: Color(0xFFF8FAFC),
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ),
                    if (notice.imgUrl != null && notice.imgUrl!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          notice.imgUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: const Color(0xFF171D21),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF2B353B),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 48,
                                  color: const Color(0xFFF8FAFC).withValues(alpha: 0.3),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38BDF8),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
