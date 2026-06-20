import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/gradient_background.dart';
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
      appBar: const GlassAppBar(title: 'Room Details'),
      body: GradientBackground(
        child: roomAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (room) => SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Info
                GlassContainer(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    children: [
                      Container(
                        width: 70, height: 70,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: Text(room.roomNumber, style: AppTextStyles.h2.copyWith(color: AppColors.primaryPurple))),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Room ${room.roomNumber}', style: AppTextStyles.h1),
                      const SizedBox(height: 4),
                      Text('Floor ${room.floor} • ${room.bedType}', style: AppTextStyles.body.copyWith(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0),

                const SizedBox(height: AppSpacing.xxl),

                // Amenities
                Text('Amenities', style: AppTextStyles.h2),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: room.amenities.map((a) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                      border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 14, color: AppColors.success),
                        const SizedBox(width: 6),
                        Text(a, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )).toList(),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                const SizedBox(height: AppSpacing.xxl),

                // Roommates
                if (room.roommates.isNotEmpty) ...[
                  Text('Roommates', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.md),
                  ...room.roommates.map((r) => GlassCard(
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text(r.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                              Text('Since ${Formatters.date(r.joinDate)}', style: AppTextStyles.caption.copyWith(color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)),
                            ],
                          ),
                        ),
                        if (r.phone != null)
                          Icon(Icons.phone_outlined, size: 20, color: AppColors.primaryPurple),
                      ],
                    ),
                  )),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
