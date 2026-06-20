import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../injection/service_locator.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../../rent/domain/entities/rent_entity.dart';

final dashboardProvider = FutureProvider<DashboardEntity>((ref) async {
  return getIt<DashboardRepository>().getDashboardData();
});

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final authState = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GradientBackground(
      child: SafeArea(
        child: dashboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (data) => CustomScrollView(
            slivers: [
              // Greeting Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding, AppSpacing.lg,
                    AppSpacing.screenPadding, AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${authState.user?.name.split(' ').first ?? data.tenantName} 👋',
                              style: AppTextStyles.h1.copyWith(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              '${data.pgName} • Room ${data.roomNumber}',
                              style: AppTextStyles.body.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 500.ms),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/profile'),
                        child: Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          ),
                          child: Center(
                            child: Text(
                              (authState.user?.name ?? data.tenantName).substring(0, 1).toUpperCase(),
                              style: AppTextStyles.h2.copyWith(color: Colors.white),
                            ),
                          ),
                        ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.elasticOut),
                      ),
                    ],
                  ),
                ),
              ),

              // Rent Summary Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  child: _RentSummaryCard(
                    rentSummary: data.rentSummary,
                    isDark: isDark,
                    onTap: () => context.push('/rent'),
                  ),
                ),
              ),

              // Quick Actions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Quick Actions'),
                      _QuickActionsGrid(activeComplaints: data.activeComplaints),
                    ],
                  ),
                ),
              ),

              // Today's Meal
              if (data.todayNextMeal != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: "Today's Menu",
                          actionLabel: 'Full Menu',
                          onAction: () => context.go('/menu'),
                        ),
                        GlassCard(
                          onTap: () => context.go('/menu'),
                          child: Column(
                            children: [
                              _MealRow(icon: Icons.wb_sunny_outlined, label: 'Breakfast', dish: data.todayNextMeal!.breakfast.mainDish, time: data.todayNextMeal!.breakfast.timeSlot),
                              const Divider(height: 20),
                              _MealRow(icon: Icons.wb_cloudy_outlined, label: 'Lunch', dish: data.todayNextMeal!.lunch.mainDish, time: data.todayNextMeal!.lunch.timeSlot),
                              const Divider(height: 20),
                              _MealRow(icon: Icons.nightlight_outlined, label: 'Dinner', dish: data.todayNextMeal!.dinner.mainDish, time: data.todayNextMeal!.dinner.timeSlot),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Recent Notices
              if (data.recentNotices.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: 'Recent Notices',
                          actionLabel: 'View All',
                          onAction: () => context.push('/notices'),
                        ),
                        ...data.recentNotices.map((notice) => GlassCard(
                          onTap: () => context.push('/notices'),
                          child: Row(
                            children: [
                              Container(
                                width: 4, height: 40,
                                decoration: BoxDecoration(
                                  color: notice.priority == NoticePriority.high ? AppColors.error : AppColors.warning,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(notice.title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 2),
                                    Text(
                                      Formatters.relative(notice.postedDate),
                                      style: AppTextStyles.caption.copyWith(
                                        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RentSummaryCard extends StatelessWidget {
  final RentSummary rentSummary;
  final bool isDark;
  final VoidCallback onTap;

  const _RentSummaryCard({required this.rentSummary, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: AppSpacing.xxl, top: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rent Due', style: AppTextStyles.body.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              )),
              StatusBadge(
                label: rentSummary.status == RentStatus.paid ? 'Paid' : rentSummary.status == RentStatus.overdue ? 'Overdue' : 'Pending',
                type: rentSummary.status == RentStatus.paid ? StatusType.success : rentSummary.status == RentStatus.overdue ? StatusType.error : StatusType.warning,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            Formatters.currency(rentSummary.amountDue),
            style: AppTextStyles.display.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Due by ${Formatters.date(rentSummary.dueDate)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0);
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final int activeComplaints;

  const _QuickActionsGrid({required this.activeComplaints});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(Icons.payment_outlined, 'Rent', AppColors.primaryPurple, '/rent'),
      _QuickAction(Icons.wifi_outlined, 'WiFi', AppColors.secondaryCyan, '/wifi'),
      _QuickAction(Icons.restaurant_menu_outlined, 'Menu', AppColors.warning, '/menu'),
      _QuickAction(Icons.bed_outlined, 'Room', AppColors.success, '/room'),
      _QuickAction(Icons.report_problem_outlined, 'Complaints', AppColors.error, '/complaints', badge: activeComplaints > 0 ? '$activeComplaints' : null),
      _QuickAction(Icons.campaign_outlined, 'Notices', AppColors.info, '/notices'),
      _QuickAction(Icons.logout_outlined, 'Leave', AppColors.accentPink, '/leave-notice'),
      _QuickAction(Icons.settings_outlined, 'Settings', AppColors.lightTextTertiary, '/settings'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.85,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return GestureDetector(
          onTap: () => context.push(action.route),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: action.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: Icon(action.icon, color: action.color, size: 26),
                  ),
                  if (action.badge != null)
                    Positioned(
                      right: 0, top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                        child: Text(action.badge!, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(action.label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w500), textAlign: TextAlign.center),
            ],
          ),
        ).animate().fadeIn(delay: (100 * index).ms, duration: 400.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
      },
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  final String? badge;
  const _QuickAction(this.icon, this.label, this.color, this.route, {this.badge});
}

class _MealRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String dish;
  final String time;
  const _MealRow({required this.icon, required this.label, required this.dish, required this.time});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.warning),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption.copyWith(
                color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              )),
              Text(dish, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Text(time, style: AppTextStyles.caption.copyWith(
          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
        )),
      ],
    );
  }
}
