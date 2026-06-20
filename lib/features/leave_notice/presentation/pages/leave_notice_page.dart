import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../injection/service_locator.dart';
import '../../domain/entities/leave_notice_entity.dart';
import '../../domain/repositories/leave_notice_repository.dart';

final leaveNoticeProvider = FutureProvider<LeaveNoticeEntity?>((ref) async {
  return getIt<LeaveNoticeRepository>().getCurrentNotice();
});

class LeaveNoticePage extends ConsumerStatefulWidget {
  const LeaveNoticePage({super.key});

  @override
  ConsumerState<LeaveNoticePage> createState() => _LeaveNoticePageState();
}

class _LeaveNoticePageState extends ConsumerState<LeaveNoticePage> {
  final _reasonController = TextEditingController();
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month + 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (_selectedDate == null || _reasonController.text.isEmpty) return;
    setState(() => _isSubmitting = true);
    await getIt<LeaveNoticeRepository>().submitNotice(
      intendedLeaveDate: _selectedDate!,
      reason: _reasonController.text,
    );
    ref.invalidate(leaveNoticeProvider);
    setState(() => _isSubmitting = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Leave notice submitted!'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final noticeAsync = ref.watch(leaveNoticeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Leave Notice',
        subtitle: 'Submit notice to vacate',
      ),
      body: GradientBackground(
        child: noticeAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (notice) {
            if (notice != null) return _ExistingNotice(notice: notice, isDark: isDark);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: AppColors.accentTeal.withValues(alpha: 0.12), shape: BoxShape.circle),
                    child: const Icon(Icons.exit_to_app_rounded, size: 40, color: AppColors.accentTeal),
                  ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

                  const SizedBox(height: AppSpacing.xxl),

                  GlassContainer(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Submit Leave Notice', style: AppTextStyles.h2),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Provide at least 1 month advance notice before vacating.', style: AppTextStyles.body.copyWith(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                        const SizedBox(height: AppSpacing.xxl),

                        Text('Intended Leave Date', style: AppTextStyles.inputLabel),
                        const SizedBox(height: AppSpacing.sm),
                        GestureDetector(
                          onTap: _selectDate,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                              border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, size: 20),
                                const SizedBox(width: AppSpacing.md),
                                Text(_selectedDate != null ? Formatters.date(_selectedDate!) : 'Select date', style: AppTextStyles.bodyLarge),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),
                        GlassTextField(controller: _reasonController, label: 'Reason', hint: 'Why are you leaving?', maxLines: 3),

                        const SizedBox(height: AppSpacing.xxl),
                        GlassButton(label: 'Submit Notice', isLoading: _isSubmitting, color: AppColors.accentTeal, onPressed: _submit),
                      ],
                    ),
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ExistingNotice extends StatelessWidget {
  final LeaveNoticeEntity notice;
  final bool isDark;
  const _ExistingNotice({required this.notice, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: GlassContainer(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline, size: 60, color: AppColors.success),
            const SizedBox(height: AppSpacing.lg),
            Text('Notice Submitted', style: AppTextStyles.h1),
            const SizedBox(height: AppSpacing.xxl),
            _Row('Status', notice.status.name.toUpperCase()),
            _Row('Submitted', Formatters.date(notice.submittedDate)),
            _Row('Leave Date', Formatters.date(notice.intendedLeaveDate)),
            _Row('Reason', notice.reason),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey))),
          Expanded(child: Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
