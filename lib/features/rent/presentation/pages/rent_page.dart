import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../injection/service_locator.dart';
import '../../domain/entities/rent_entity.dart';
import '../../domain/repositories/rent_repository.dart';

final currentRentProvider = FutureProvider<RentEntity>((ref) async {
  return getIt<RentRepository>().getCurrentRent();
});

final paymentHistoryProvider = FutureProvider<List<RentEntity>>((ref) async {
  return getIt<RentRepository>().getPaymentHistory();
});

class RentPage extends ConsumerWidget {
  const RentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(paymentHistoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.lg, AppSpacing.screenPadding, 0),
              child: Text('Rent & Payments', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: historyAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (payments) {
                  final current = payments.isNotEmpty ? payments.first : null;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (current != null && current.status != RentStatus.paid) ...[
                        _CurrentRentCard(rent: current, isDark: isDark),
                        const SizedBox(height: AppSpacing.lg),
                        GlassButton(
                          label: 'Mark as Paid',
                          icon: Icons.upload_file_outlined,
                          onPressed: () => _showMarkAsPaidSheet(context),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                      Text('Payment History', style: AppTextStyles.h2),
                      const SizedBox(height: AppSpacing.md),
                      ...payments.map((p) => _PaymentTile(payment: p, isDark: isDark)),
                    ],
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  void _showMarkAsPaidSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkSurface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: AppSpacing.xxl),
            Text('Mark Rent as Paid', style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.sm),
            Text('Upload a screenshot of your payment as proof.', style: AppTextStyles.body.copyWith(color: Colors.grey)),
            const SizedBox(height: AppSpacing.xxl),
            GlassButton.outlined(
              label: 'Upload Screenshot',
              icon: Icons.camera_alt_outlined,
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: const Text('Payment marked as processing! Admin will verify.'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            GlassButton(
              label: 'Submit Without Screenshot',
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: const Text('Payment marked! Admin will verify.'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(ctx).padding.bottom + AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _CurrentRentCard extends StatelessWidget {
  final RentEntity rent;
  final bool isDark;
  const _CurrentRentCard({required this.rent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(rent.month, style: AppTextStyles.h3),
              StatusBadge(
                label: rent.status.name.toUpperCase(),
                type: rent.status == RentStatus.paid ? StatusType.success : StatusType.warning,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(Formatters.currency(rent.amount), style: AppTextStyles.display.copyWith(fontSize: 36)),
          const SizedBox(height: AppSpacing.xs),
          Text('Due by ${Formatters.date(rent.dueDate)}', style: AppTextStyles.bodySmall.copyWith(color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
          if (rent.breakdown != null) ...[
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            _BreakdownRow('Room Rent', rent.breakdown!.roomRent),
            _BreakdownRow('Electricity', rent.breakdown!.electricity),
            _BreakdownRow('Water', rent.breakdown!.water),
            _BreakdownRow('Maintenance', rent.breakdown!.maintenance),
            if (rent.breakdown!.other != null) _BreakdownRow('Other', rent.breakdown!.other!),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0);
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final double amount;
  const _BreakdownRow(this.label, this.amount);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          Text(Formatters.currency(amount), style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final RentEntity payment;
  final bool isDark;
  const _PaymentTile({required this.payment, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: (payment.status == RentStatus.paid ? AppColors.success : AppColors.warning).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              payment.status == RentStatus.paid ? Icons.check_circle_outline : Icons.pending_outlined,
              color: payment.status == RentStatus.paid ? AppColors.success : AppColors.warning,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payment.month, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                Text(
                  payment.paidDate != null ? 'Paid on ${Formatters.date(payment.paidDate!)}' : 'Due ${Formatters.date(payment.dueDate)}',
                  style: AppTextStyles.caption.copyWith(color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                ),
              ],
            ),
          ),
          Text(Formatters.currency(payment.amount), style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
