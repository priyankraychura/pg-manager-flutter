import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../injection/service_locator.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notices_repository.dart';

final noticesProvider = FutureProvider<List<NoticeEntity>>((ref) async {
  return getIt<NoticesRepository>().getNotices();
});

class NoticesPage extends ConsumerWidget {
  const NoticesPage({super.key});

  StatusType _priorityType(NoticePriority p) {
    switch (p) {
      case NoticePriority.urgent: return StatusType.error;
      case NoticePriority.high: return StatusType.warning;
      case NoticePriority.medium: return StatusType.info;
      case NoticePriority.low: return StatusType.neutral;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticesAsync = ref.watch(noticesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Notices',
        subtitle: 'Important updates & announcements',
      ),
      body: GradientBackground(
        child: noticesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (notices) => ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: notices.length,
            itemBuilder: (context, index) {
              final notice = notices[index];
              return GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4, height: 36,
                          decoration: BoxDecoration(
                            color: _priorityColor(notice.priority),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(child: Text(notice.title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600))),
                        StatusBadge(label: notice.priority.name, type: _priorityType(notice.priority), small: true),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.lg + 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notice.description, style: AppTextStyles.bodySmall.copyWith(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                          const SizedBox(height: AppSpacing.sm),
                          Text('${Formatters.relative(notice.postedDate)} • ${notice.postedBy}',
                            style: AppTextStyles.caption.copyWith(color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Color _priorityColor(NoticePriority p) {
    switch (p) {
      case NoticePriority.urgent: return AppColors.error;
      case NoticePriority.high: return AppColors.warning;
      case NoticePriority.medium: return AppColors.info;
      case NoticePriority.low: return Colors.grey;
    }
  }
}
