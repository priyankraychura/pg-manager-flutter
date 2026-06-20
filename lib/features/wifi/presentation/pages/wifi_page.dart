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

final wifiProvider = FutureProvider<WifiEntity>((ref) async {
  return getIt<WifiRepository>().getWifiInfo();
});

class WifiPage extends ConsumerWidget {
  const WifiPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wifiAsync = ref.watch(wifiProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const GlassAppBar(
        title: 'WiFi Info',
        subtitle: 'Network credentials & connection details',
      ),
      body: GradientBackground(
        child: wifiAsync.when(
          loading: () => const CommonLoader(),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (wifi) => SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // WiFi Card
                GlassContainer(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    children: [
                      Container(
                        width: 70, height: 70,
                        decoration: BoxDecoration(
                          color: (wifi.isActive ? AppColors.success : AppColors.error).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          wifi.isActive ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                          size: 36,
                          color: wifi.isActive ? AppColors.success : AppColors.error,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(wifi.networkName, style: AppTextStyles.h1),
                      const SizedBox(height: 4),
                      Text(
                        wifi.isActive ? 'Active • ${wifi.speedInfo}' : 'Currently Offline',
                        style: AppTextStyles.body.copyWith(
                          color: wifi.isActive ? AppColors.success : AppColors.error,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Password
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_outline, size: 20),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Password', style: AppTextStyles.caption.copyWith(color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
                                  Text(wifi.password, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600, letterSpacing: 1)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy_rounded, size: 20),
                              onPressed: () => ClipboardHelper.copy(context, wifi.password, message: 'WiFi password copied!'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0),

                const SizedBox(height: AppSpacing.xxl),

                // Troubleshooting
                if (wifi.troubleshootTips.isNotEmpty) ...[
                  Text('Troubleshooting', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.md),
                  ...wifi.troubleshootTips.asMap().entries.map((entry) {
                    final tip = entry.value;
                    return GlassCard(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.info.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(child: Text('${entry.key + 1}', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.info))),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tip.title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(tip.description, style: AppTextStyles.bodySmall.copyWith(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
