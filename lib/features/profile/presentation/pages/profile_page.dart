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
                      // Interactive Edit badge on avatar corner
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => context.push('/edit-profile'),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryOrange,
                                width: 1.5,
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
                              Icons.edit_rounded,
                              size: 10,
                              color: AppColors.primaryOrange,
                            ),
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

                        // Active Tenant & Verified Row
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Active Tenant',
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.verified_user_rounded,
                              size: 12,
                              color: AppColors.info,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Verified',
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.info,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // PG and Room Badges
                        Wrap(
                          spacing: AppSpacing.xs,
                          runSpacing: AppSpacing.xs,
                          children: [
                            if (user.pgName != null && user.pgName!.isNotEmpty)
                              _buildHeaderChip(
                                icon: Icons.business_rounded,
                                label: user.pgName!,
                                themeColor: AppColors.primaryOrange,
                                isDark: isDark,
                              ),
                            _buildHeaderChip(
                              icon: Icons.meeting_room_rounded,
                              label: 'Room ${user.roomNumber ?? 'N/A'}',
                              themeColor: AppColors.accentTeal,
                              isDark: isDark,
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
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: user.email,
                    color: AppColors.info,
                  ),
                  const Divider(height: 24, thickness: 0.5),
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

  Widget _buildHeaderChip({
    required IconData icon,
    required String label,
    required Color themeColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: themeColor.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: themeColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
