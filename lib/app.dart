import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_spacing.dart';
import 'core/theme/app_text_styles.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'core/providers/update_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

/// Root MaterialApp widget with theme and router configuration.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final updateAsync = ref.watch(updateProvider);

    return MaterialApp.router(
      title: 'PG Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            updateAsync.maybeWhen(
              data: (info) {
                if (info.updateType == UpdateType.major) {
                  return Positioned.fill(
                    child: _MajorUpdateOverlay(updateInfo: info),
                  );
                }
                return const SizedBox.shrink();
              },
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}

class _MajorUpdateOverlay extends StatelessWidget {
  final AppUpdateInfo updateInfo;

  const _MajorUpdateOverlay({required this.updateInfo});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Blur background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Dialog
          Center(
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.xl),
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.system_update_rounded,
                    size: 64,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Update Required',
                    style: AppTextStyles.h2.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'A new major version (${updateInfo.latestVersion}) is available. You must update to continue using the app.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        ),
                      ),
                      onPressed: () async {
                        final uri = Uri.parse(updateInfo.storeUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      },
                      child: const Text(
                        'Update Now',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
