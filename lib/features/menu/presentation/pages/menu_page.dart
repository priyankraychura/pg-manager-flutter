import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../injection/service_locator.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/menu_repository.dart';

final menuProvider = FutureProvider<List<MealEntity>>((ref) async {
  return getIt<MenuRepository>().getTwoWeekMenu();
});

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  int _selectedDay = 0;

  @override
  void initState() {
    super.initState();
    _selectedDay = (DateTime.now().day % 14);
  }

  @override
  Widget build(BuildContext context) {
    final menuAsync = ref.watch(menuProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return menuAsync.when(
      loading: () => const Scaffold(
        appBar: GlassAppBar(
          title: 'Meal Menu',
          subtitle: 'Loading Menu...',
        ),
        body: GradientBackground(
          child: CommonLoader(),
        ),
      ),
      error: (e, _) => Scaffold(
        appBar: const GlassAppBar(
          title: 'Meal Menu',
          subtitle: 'Error loading menu',
        ),
        body: GradientBackground(
          child: Center(child: Text('Error: $e')),
        ),
      ),
      data: (meals) {
        final currentMeal = meals[_selectedDay];
        final currentWeek = _selectedDay < 7 ? 1 : 2;

        return Scaffold(
          appBar: GlassAppBar(
            title: 'Meal Menu',
            subtitle: '2-Week Rotating Menu • Week $currentWeek',
          ),
          body: GradientBackground(
            child: CustomScrollView(
            slivers: [
              // Day Selector
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.md),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      final isSelected = index == _selectedDay;
                      final isToday = index == (DateTime.now().day % 14);

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDay = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 52,
                          margin: const EdgeInsets.only(right: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryOrange : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.5)),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                            border: isToday && !isSelected ? Border.all(color: AppColors.primaryOrange, width: 1.5) : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                meal.dayName.substring(0, 3),
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                              ),
                              Text(
                                'D${meal.dayNumber}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Meal Cards
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: Column(
                    key: ValueKey(_selectedDay),
                    children: [
                      _MealTimeCard(meal: currentMeal.breakfast, icon: Icons.wb_sunny_rounded, color: const Color(0xFFFF9800)),
                      _MealTimeCard(meal: currentMeal.lunch, icon: Icons.wb_cloudy_rounded, color: const Color(0xFF4CAF50)),
                      _MealTimeCard(meal: currentMeal.dinner, icon: Icons.nightlight_round, color: const Color(0xFF673AB7)),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          ),
        );
      },
    );
  }
}

class _MealTimeCard extends StatelessWidget {
  final MealTime meal;
  final IconData icon;
  final Color color;

  const _MealTimeCard({required this.meal, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meal.type[0].toUpperCase() + meal.type.substring(1), style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                    Text(meal.timeSlot, style: AppTextStyles.caption.copyWith(color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
                  ],
                ),
              ),
              if (meal.specialNote != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                  child: Text(meal.specialNote!, style: const TextStyle(fontSize: 11)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(meal.mainDish, style: AppTextStyles.h3),
          if (meal.sideItems.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: meal.sideItems.map((item) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(item, style: AppTextStyles.caption),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
