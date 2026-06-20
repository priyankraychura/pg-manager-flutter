import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../injection/service_locator.dart';
import '../../domain/entities/room_entity.dart';
import '../../domain/repositories/room_repository.dart';

final roomProvider = FutureProvider<RoomEntity>((ref) async {
  return getIt<RoomRepository>().getRoomDetails();
});

class RoomDetailsPage extends ConsumerWidget {
  const RoomDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomAsync = ref.watch(roomProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const GlassAppBar(
        title: 'Room Details',
        subtitle: 'View room info & roommates',
      ),
      body: GradientBackground(
        child: roomAsync.when(
          loading: () => const CommonLoader(),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (room) => SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium Glassmorphic Header Card
                GlassContainer(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      // Room Image or Glowing Circle
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 88,
                            height: 88,
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
                          Container(
                            width: 76,
                            height: 76,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [AppColors.primaryOrange, AppColors.primaryOrangeLight],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: room.roomImageUrl != null && room.roomImageUrl!.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      room.roomImageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _buildRoomInitials(room.roomNumber),
                                    ),
                                  )
                                : _buildRoomInitials(room.roomNumber),
                          ),
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
                                Icons.meeting_room_rounded,
                                size: 20,
                                color: AppColors.primaryOrange,
                              ),
                            ),
                          ),
                        ],
                      ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

                      const SizedBox(height: AppSpacing.lg),
                      
                      Text(
                        'Room ${room.roomNumber}',
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),
                      
                      // Room Details InfoRows
                      _InfoRow(
                        icon: Icons.layers_outlined,
                        label: 'Floor',
                        value: 'Floor ${room.floor}',
                        color: AppColors.info,
                      ),
                      const Divider(height: 24, thickness: 0.5),
                      _InfoRow(
                        icon: Icons.bed_outlined,
                        label: 'Bed Type',
                        value: room.bedType,
                        color: AppColors.warning,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0),

                const SizedBox(height: AppSpacing.xxl),

                // Amenities
                Text(
                  'Amenities',
                  style: AppTextStyles.h2.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                GlassContainer(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: room.amenities.map((a) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withValues(alpha: isDark ? 0.12 : 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryOrange.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                          const SizedBox(width: 6),
                          Text(
                            a,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                const SizedBox(height: AppSpacing.xxl),

                // Roommates
                if (room.roommates.isNotEmpty) ...[
                  Text(
                    'Roommates',
                    style: AppTextStyles.h2.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...room.roommates.map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: GlassCard(
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [AppColors.accentTeal, Color(0xFF00B4D8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accentTeal.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: r.profileImageUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      r.profileImageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _buildInitialsAvatar(r.name),
                                    ),
                                  )
                                : _buildInitialsAvatar(r.name),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.name,
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 12,
                                      color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Since ${Formatters.date(r.joinDate)}',
                                      style: AppTextStyles.caption.copyWith(
                                        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (r.phone != null)
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.phone_rounded, size: 20),
                                color: AppColors.success,
                                onPressed: () {},
                              ),
                            ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideX(begin: 0.1, end: 0)),
                  const SizedBox(height: 100),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomInitials(String roomNumber) {
    return Center(
      child: Text(
        roomNumber,
        style: AppTextStyles.h2.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildInitialsAvatar(String name) {
    return Center(
      child: Text(
        name.initials,
        style: AppTextStyles.h3.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.12 : 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
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
