import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (user == null) return const Center(child: Text('Not logged in'));

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            
            // Avatar
            Container(
              width: AppSpacing.avatarXl, height: AppSpacing.avatarXl,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.primaryOrange.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Center(
                child: Text(user.name.initials, style: AppTextStyles.display.copyWith(color: Colors.white, fontSize: 36)),
              ),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

            const SizedBox(height: AppSpacing.lg),
            Text(user.name, style: AppTextStyles.h1),
            const SizedBox(height: 4),
            Text(user.pgName ?? '', style: AppTextStyles.body.copyWith(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            Text('Room ${user.roomNumber ?? 'N/A'}', style: AppTextStyles.bodySmall.copyWith(color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),

            const SizedBox(height: AppSpacing.xxl),

            // Info Cards
            GlassContainer(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  _InfoRow(Icons.email_outlined, 'Email', user.email),
                  const Divider(height: 24),
                  _InfoRow(Icons.phone_outlined, 'Phone', user.phone),
                  const Divider(height: 24),
                  _InfoRow(Icons.calendar_today_outlined, 'Member Since', user.joinDate != null ? Formatters.date(user.joinDate!) : 'N/A'),
                  const Divider(height: 24),
                  _InfoRow(Icons.home_outlined, 'Address', user.address ?? 'Not provided'),
                  if (user.emergencyContactName != null) ...[
                    const Divider(height: 24),
                    _InfoRow(Icons.emergency_outlined, 'Emergency Contact', '${user.emergencyContactName}\n${user.emergencyContact ?? ''}'),
                  ],
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0),

            const SizedBox(height: AppSpacing.xl),

            // Quick Links
            GlassCard.info(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              subtitle: 'Update personal & emergency details',
              iconColor: AppColors.primaryOrange,
              onTap: () => context.push('/edit-profile'),
              trailing: const Icon(Icons.chevron_right, size: 20),
            ),
            GlassCard.info(
              icon: Icons.bed_outlined,
              title: 'Room Details',
              subtitle: 'View room info & roommates',
              iconColor: AppColors.secondarySlate,
              onTap: () => context.push('/room'),
              trailing: const Icon(Icons.chevron_right, size: 20),
            ),
            GlassCard.info(
              icon: Icons.logout_outlined,
              title: 'Leave Notice',
              subtitle: 'Submit notice to vacate',
              iconColor: AppColors.accentTeal,
              onTap: () => context.push('/leave-notice'),
              trailing: const Icon(Icons.chevron_right, size: 20),
            ),
            GlassCard.info(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'Theme, notifications, logout',
              iconColor: Colors.grey,
              onTap: () => context.push('/settings'),
              trailing: const Icon(Icons.chevron_right, size: 20),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryOrange.withValues(alpha: 0.7)),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption.copyWith(color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.body),
            ],
          ),
        ),
      ],
    );
  }
}
