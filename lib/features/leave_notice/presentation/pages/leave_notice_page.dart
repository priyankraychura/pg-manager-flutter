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
import '../../../../core/widgets/common_loader.dart';
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
          loading: () => const CommonLoader(),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (notice) {
            if (notice != null) return _ExistingNotice(notice: notice, isDark: isDark);
            
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero Header
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: AppColors.accentTeal.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentTeal.withValues(alpha: 0.2),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.flight_takeoff_rounded, size: 56, color: AppColors.accentTeal),
                    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack).fadeIn(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  Text(
                    'Plan Your Move',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h1.copyWith(
                      color: isDark ? Colors.white : Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ).animate().slideY(begin: 0.2, duration: 500.ms).fadeIn(),
                  
                  const SizedBox(height: AppSpacing.xs),
                  
                  Text(
                    'Provide at least 1 month advance notice before vacating the premises.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      height: 1.4,
                    ),
                  ).animate().slideY(begin: 0.2, duration: 500.ms, delay: 100.ms).fadeIn(),

                  const SizedBox(height: AppSpacing.xxl),

                  // Sleek Form Card
                  GlassContainer(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Intended Leave Date', style: AppTextStyles.inputLabel),
                        const SizedBox(height: AppSpacing.sm),
                        
                        // Enhanced Date Picker
                        GestureDetector(
                          onTap: _selectDate,
                          child: AnimatedContainer(
                            duration: 200.ms,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                            decoration: BoxDecoration(
                              color: _selectedDate != null 
                                  ? AppColors.accentTeal.withValues(alpha: 0.1)
                                  : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                              border: Border.all(
                                color: _selectedDate != null 
                                    ? AppColors.accentTeal.withValues(alpha: 0.5)
                                    : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _selectedDate != null 
                                        ? AppColors.accentTeal.withValues(alpha: 0.2)
                                        : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.event_available_rounded, 
                                    size: 24,
                                    color: _selectedDate != null 
                                        ? AppColors.accentTeal
                                        : (isDark ? Colors.white70 : Colors.black54),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedDate != null ? 'Selected Date' : 'Choose a Date',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _selectedDate != null ? Formatters.date(_selectedDate!) : 'Tap to select', 
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          fontWeight: _selectedDate != null ? FontWeight.w600 : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_selectedDate == null)
                                  Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white54 : Colors.black54),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xl),
                        
                        GlassTextField(
                          controller: _reasonController, 
                          label: 'Reason for Leaving', 
                          hint: 'Please briefly explain why you are leaving...', 
                          maxLines: 4,
                        ),

                        const SizedBox(height: AppSpacing.xxl),
                        
                        // Floating Action Style Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: GlassButton(
                            label: 'Submit Notice', 
                            isLoading: _isSubmitting, 
                            color: AppColors.accentTeal, 
                            onPressed: _submit,
                          ),
                        ),
                      ],
                    ),
                  ).animate().slideY(begin: 0.1, duration: 600.ms, delay: 200.ms).fadeIn(),
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

  Color _getStatusColor() {
    switch (notice.status) {
      case LeaveNoticeStatus.pending:
        return AppColors.warning;
      case LeaveNoticeStatus.approved:
        return AppColors.success;
      case LeaveNoticeStatus.rejected:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon() {
    switch (notice.status) {
      case LeaveNoticeStatus.pending:
        return Icons.hourglass_top_rounded;
      case LeaveNoticeStatus.approved:
        return Icons.check_circle_rounded;
      case LeaveNoticeStatus.rejected:
        return Icons.cancel_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status Hero
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor.withValues(alpha: 0.15),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.2),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 2000.ms, color: statusColor.withValues(alpha: 0.3)),
                Icon(_getStatusIcon(), size: 64, color: statusColor)
                    .animate()
                    .scale(duration: 500.ms, curve: Curves.easeOutBack),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          Text(
            'Notice ${notice.status.name.toUpperCase()}',
            textAlign: TextAlign.center,
            style: AppTextStyles.h1.copyWith(
              color: statusColor,
              letterSpacing: 1,
            ),
          ).animate().slideY(begin: 0.2).fadeIn(duration: 500.ms),
          
          const SizedBox(height: AppSpacing.xxl),
          
          // Info Grid/Cards
          GlassContainer(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                _buildInfoCard(
                  context,
                  title: 'Leave Date',
                  value: Formatters.date(notice.intendedLeaveDate),
                  icon: Icons.event_available_rounded,
                  isDark: isDark,
                  isHighlighted: true,
                ),
                const SizedBox(height: AppSpacing.md),
                Divider(height: 1, color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1)),
                const SizedBox(height: AppSpacing.md),
                _buildInfoCard(
                  context,
                  title: 'Submitted On',
                  value: Formatters.date(notice.submittedDate),
                  icon: Icons.history_rounded,
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.md),
                Divider(height: 1, color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1)),
                const SizedBox(height: AppSpacing.md),
                _buildInfoCard(
                  context,
                  title: 'Reason',
                  value: notice.reason,
                  icon: Icons.subject_rounded,
                  isDark: isDark,
                  isMultiline: true,
                ),
              ],
            ),
          ).animate().slideY(begin: 0.1).fadeIn(duration: 600.ms, delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required bool isDark,
    bool isHighlighted = false,
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon, 
            size: 20, 
            color: isHighlighted ? AppColors.accentTeal : (isDark ? Colors.white70 : Colors.black54),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
                  color: isHighlighted 
                      ? (isDark ? Colors.white : Colors.black87)
                      : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
