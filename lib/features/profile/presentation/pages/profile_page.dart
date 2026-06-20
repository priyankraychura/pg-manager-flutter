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
import '../../../auth/domain/entities/user_entity.dart';
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

            // Premium Glassmorphic Profile Header Card
            GlassContainer(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  // Avatar Section on the left
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer glowing border ring
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryOrange.withValues(alpha: 0.35),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryOrange.withValues(alpha: 0.15),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      // Inner Avatar
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryOrange, AppColors.primaryOrangeLight],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ClipOval(
                          child: user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                              ? Image.network(
                                  user.profileImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => _buildInitialsAvatar(user, fontSize: 24),
                                )
                              : _buildInitialsAvatar(user, fontSize: 24),
                        ),
                      ),
                      // Verified badge on avatar corner
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.verified_rounded,
                            size: 18,
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ],
                  ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

                  const SizedBox(width: AppSpacing.lg),

                  // Info Section on the right
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Name
                        Text(
                          user.name,
                          style: AppTextStyles.h2.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        // User Email
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 14,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                user.email,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),


                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0),

            const SizedBox(height: AppSpacing.xl),

            // Info Cards
            GlassContainer(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [

                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: user.phone,
                    color: AppColors.success,
                  ),
                  const Divider(height: 24, thickness: 0.5),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Member Since',
                    value: user.joinDate != null ? Formatters.date(user.joinDate!) : 'N/A',
                    color: AppColors.warning,
                  ),
                  const Divider(height: 24, thickness: 0.5),
                  _InfoRow(
                    icon: Icons.home_outlined,
                    label: 'Address',
                    value: user.address ?? 'Not provided',
                    color: AppColors.secondarySlate,
                  ),
                  if (user.emergencyContactName != null) ...[
                    const Divider(height: 24, thickness: 0.5),
                    _InfoRow(
                      icon: Icons.contact_emergency_outlined,
                      label: 'Emergency Contact',
                      value: '${user.emergencyContactName} (${user.emergencyContact ?? 'N/A'})',
                      color: AppColors.error,
                    ),
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

  Widget _buildInitialsAvatar(UserEntity user, {double fontSize = 22}) {
    return Center(
      child: Text(
        user.name.initials,
        style: AppTextStyles.display.copyWith(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }


}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColor = color ?? AppColors.primaryOrange;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: themeColor.withValues(alpha: isDark ? 0.12 : 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: themeColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: themeColor,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
