import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../core/widgets/common_bottom_sheet.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/glass_button.dart';
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
  int _selectedWeek = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedDay = (DateTime.now().day % 14);
    _selectedWeek = _selectedDay < 7 ? 0 : 1;

    final indexInWeek = _selectedDay % 7;
    double offset = (indexInWeek * 76.0) - 130.0;
    if (offset < 0) offset = 0;
    _scrollController = ScrollController(initialScrollOffset: offset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelected() {
    if (!_scrollController.hasClients) return;
    final indexInWeek = _selectedDay % 7;
    double offset = (indexInWeek * 76.0) - 130.0;
    if (offset < 0) offset = 0;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (offset > maxScroll) offset = maxScroll;

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showFeedbackSheet(BuildContext context) {
    final commentController = TextEditingController();
    int rating = 0;

    showCommonBottomSheet(
      context: context,
      title: 'Menu Feedback',
      builder: (ctx, setState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rate this week\'s menu', style: AppTextStyles.inputLabel),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: AppColors.primaryOrange,
                  size: 36,
                ),
                onPressed: () => setState(() => rating = index + 1),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.lg),
          GlassTextField(
            controller: commentController,
            label: 'Comments (Optional)',
            hint: 'Tell us what you liked or how we can improve',
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.xxl),
          GlassButton(
            label: 'Submit Feedback',
            onPressed: () {
              if (rating == 0) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Please provide a rating'), backgroundColor: AppColors.warning, behavior: SnackBarBehavior.floating),
                 );
                 return;
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Thank you for your feedback!'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              );
            },
          ),
        ],
      ),
    );
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
        final currentWeek = _selectedWeek + 1;

        return Scaffold(
          appBar: GlassAppBar(
            title: 'Meal Menu',
            subtitle: '2-Week Rotating Menu • Week $currentWeek',
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primaryOrange,
            child: const Icon(Icons.rate_review_outlined, color: Colors.white),
            onPressed: () => _showFeedbackSheet(context),
          ),
          body: GradientBackground(
            child: CustomScrollView(
            slivers: [
              // Week Toggle
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.sm),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedWeek = 0;
                                if (_selectedDay > 6) _selectedDay -= 7;
                              });
                              _scrollToSelected();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedWeek == 0 ? AppColors.primaryOrange : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Week 1',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _selectedWeek == 0 ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedWeek = 1;
                                if (_selectedDay < 7) _selectedDay += 7;
                              });
                              _scrollToSelected();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedWeek == 1 ? AppColors.primaryOrange : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Week 2',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _selectedWeek == 1 ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Day Selector
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 80,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.md),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      final actualIndex = _selectedWeek * 7 + index;
                      final isSelected = actualIndex == _selectedDay;
                      final todayIndex = DateTime.now().day % 14;
                      final isToday = actualIndex == todayIndex;
                      
                      final difference = actualIndex - todayIndex;
                      final mealDate = DateTime.now().add(Duration(days: difference));

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDay = actualIndex),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 68,
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
                                DateFormat('E').format(mealDate),
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat('dd MMM').format(mealDate),
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
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
