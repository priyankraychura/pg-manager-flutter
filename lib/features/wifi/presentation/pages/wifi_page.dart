import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/clipboard_helper.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../injection/service_locator.dart';
import '../../domain/entities/wifi_entity.dart';
import '../../domain/repositories/wifi_repository.dart';

final wifiListProvider = FutureProvider<List<WifiEntity>>((ref) async {
  return getIt<WifiRepository>().getWifiList();
});

class WifiPage extends ConsumerStatefulWidget {
  const WifiPage({super.key});

  @override
  ConsumerState<WifiPage> createState() => _WifiPageState();
}

class _WifiPageState extends ConsumerState<WifiPage> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wifiListAsync = ref.watch(wifiListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const GlassAppBar(
        title: 'WiFi Networks',
        subtitle: 'Available connections & details',
      ),
      body: GradientBackground(
        child: wifiListAsync.when(
          loading: () => const CommonLoader(),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (wifiList) {
            if (wifiList.isEmpty) {
              return const Center(child: Text('No WiFi networks found.'));
            }
            // Use the troubleshooting tips from the first network, as they are global
            final tips = wifiList.first.troubleshootTips;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  // Carousel
                  SizedBox(
                    height: 340,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: wifiList.length,
                      itemBuilder: (context, index) {
                        final wifi = wifiList[index];
                        final isSelected = index == _currentPage;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: isSelected ? 0 : 16,
                          ),
                          child: Opacity(
                            opacity: isSelected ? 1.0 : 0.5,
                            child: _buildWifiCard(wifi, isDark),
                          ),
                        );
                      },
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.05, end: 0),

                  // Page Indicators
                  if (wifiList.length > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          wifiList.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppColors.primaryOrange
                                  : (isDark ? Colors.white24 : Colors.black12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: AppSpacing.lg),

                  // Troubleshooting
                  if (tips.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Troubleshooting', style: AppTextStyles.h2),
                          const SizedBox(height: AppSpacing.md),
                          ...tips.asMap().entries.map((entry) {
                            final tip = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.md),
                              child: GlassCard(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: AppColors.info.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                          child: Text('${entry.key + 1}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.info))),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(tip.title,
                                              style: AppTextStyles.body
                                                  .copyWith(fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 4),
                                          Text(tip.description,
                                              style: AppTextStyles.bodySmall.copyWith(
                                                  color: isDark
                                                      ? AppColors.darkTextSecondary
                                                      : AppColors.lightTextSecondary)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.05, end: 0),
                    ),
                  const SizedBox(height: AppSpacing.xxl * 2),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWifiCard(WifiEntity wifi, bool isDark) {
    return GlassContainer(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (wifi.isActive ? AppColors.success : AppColors.error).withValues(alpha: 0.2),
                  (wifi.isActive ? AppColors.success : AppColors.error).withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: (wifi.isActive ? AppColors.success : AppColors.error).withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              wifi.isActive ? Icons.wifi_rounded : Icons.wifi_off_rounded,
              size: 40,
              color: wifi.isActive ? AppColors.success : AppColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            wifi.networkName,
            style: AppTextStyles.h1.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: (wifi.isActive ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: wifi.isActive ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  wifi.isActive ? 'Active • ${wifi.speedInfo}' : 'Currently Offline',
                  style: AppTextStyles.caption.copyWith(
                    color: wifi.isActive ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Password Field
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(
                color: AppColors.primaryOrange.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.lock_outline, size: 20, color: AppColors.primaryOrange),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Password',
                          style: AppTextStyles.caption.copyWith(
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary)),
                      Text(wifi.password,
                          style: AppTextStyles.bodyLarge
                              .copyWith(fontWeight: FontWeight.w600, letterSpacing: 1)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 22),
                  color: AppColors.primaryOrange,
                  onPressed: () => ClipboardHelper.copy(context, wifi.password,
                      message: 'Password copied to clipboard!'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
