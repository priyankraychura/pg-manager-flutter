import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../injection/service_locator.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaints_repository.dart';

final complaintsProvider = FutureProvider<List<ComplaintEntity>>((ref) async {
  return getIt<ComplaintsRepository>().getComplaints();
});

class ComplaintsPage extends ConsumerWidget {
  const ComplaintsPage({super.key});

  StatusType _statusType(ComplaintStatus s) {
    switch (s) {
      case ComplaintStatus.open: return StatusType.warning;
      case ComplaintStatus.inProgress: return StatusType.info;
      case ComplaintStatus.resolved: return StatusType.success;
      case ComplaintStatus.closed: return StatusType.neutral;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complaintsAsync = ref.watch(complaintsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: GlassAppBar(
        title: 'Complaints',
        subtitle: 'Raise & track maintenance issues',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showRaiseComplaintSheet(context, ref),
          ),
        ],
      ),
      body: GradientBackground(
        child: complaintsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (complaints) {
            if (complaints.isEmpty) {
              return EmptyState(
                icon: Icons.check_circle_outline,
                title: 'No Complaints',
                subtitle: 'Everything looks good! Raise a complaint if needed.',
                actionLabel: 'Raise Complaint',
                onAction: () => _showRaiseComplaintSheet(context, ref),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                final c = complaints[index];
                return GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(c.title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600))),
                          StatusBadge(label: c.status.name, type: _statusType(c.status), small: true),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(c.description, style: AppTextStyles.bodySmall.copyWith(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.primaryOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                            child: Text(c.category.name, style: AppTextStyles.caption.copyWith(color: AppColors.primaryOrange)),
                          ),
                          const Spacer(),
                          Text(Formatters.relative(c.createdAt), style: AppTextStyles.caption.copyWith(color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
                        ],
                      ),
                      if (c.adminReply != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.reply_rounded, size: 16, color: AppColors.info),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(child: Text(c.adminReply!, style: AppTextStyles.caption.copyWith(color: AppColors.info))),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showRaiseComplaintSheet(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    var selectedCategory = ComplaintCategory.maintenance;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.xxl, AppSpacing.xxl, MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.xxl),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: AppSpacing.xxl),
                Text('Raise Complaint', style: AppTextStyles.h2),
                const SizedBox(height: AppSpacing.xxl),
                GlassTextField(controller: titleController, label: 'Title', hint: 'Brief description of the issue'),
                const SizedBox(height: AppSpacing.lg),
                Text('Category', style: AppTextStyles.inputLabel),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: ComplaintCategory.values.map((cat) => GestureDetector(
                    onTap: () => setState(() => selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: selectedCategory == cat ? AppColors.primaryOrange : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: selectedCategory == cat ? AppColors.primaryOrange : Colors.grey.shade400),
                      ),
                      child: Text(cat.name, style: TextStyle(fontSize: 13, color: selectedCategory == cat ? Colors.white : null)),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                GlassTextField(controller: descController, label: 'Description', hint: 'Describe the issue in detail', maxLines: 4),
                const SizedBox(height: AppSpacing.xxl),
                GlassButton(
                  label: 'Submit Complaint',
                  onPressed: () async {
                    if (titleController.text.isEmpty) return;
                    await getIt<ComplaintsRepository>().raiseComplaint(
                      title: titleController.text,
                      description: descController.text,
                      category: selectedCategory,
                    );
                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                      ref.invalidate(complaintsProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text('Complaint submitted!'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
