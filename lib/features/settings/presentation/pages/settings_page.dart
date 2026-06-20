import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: const GlassAppBar(title: 'Settings'),
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Appearance', style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.md),
              GlassCard(
                animate: false,
                child: Row(
                  children: [
                    Icon(Icons.dark_mode_outlined, color: AppColors.primaryPurple),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: Text('Dark Mode', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500))),
                    Switch.adaptive(
                      value: isDarkMode,
                      activeThumbColor: AppColors.primaryPurple,
                      onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),
              Text('General', style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.md),

              GlassCard.info(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage push notifications',
                iconColor: AppColors.warning,
                trailing: const Icon(Icons.chevron_right, size: 20),
                animate: false,
              ),
              GlassCard.info(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'FAQ and contact admin',
                iconColor: AppColors.info,
                trailing: const Icon(Icons.chevron_right, size: 20),
                animate: false,
              ),
              GlassCard.info(
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'PG Manager v1.0.0',
                iconColor: AppColors.secondaryCyan,
                trailing: const Icon(Icons.chevron_right, size: 20),
                animate: false,
              ),

              const SizedBox(height: AppSpacing.xxl),

              GlassCard(
                onTap: () {
                  ref.read(authProvider.notifier).logout();
                  context.go('/login');
                },
                animate: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Logout', style: AppTextStyles.body.copyWith(color: AppColors.error, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
