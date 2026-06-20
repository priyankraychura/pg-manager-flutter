import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../../features/settings/presentation/providers/settings_provider.dart';

/// Core glassmorphism container widget.
/// All glass_* widgets are built on top of this.
/// Provides frosted glass effect with customizable blur, opacity, and border.
class GlassContainer extends ConsumerWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blurSigma;
  final double? opacity;
  final Color? borderColor;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = AppSpacing.radiusXl,
    this.blurSigma = AppSpacing.glassBlurSigma,
    this.opacity,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final perfMode = ref.watch(performanceModeProvider);

    // Determine colors based on performance mode
    final Color fillColor;
    final Color border;
    final List<BoxShadow> shadow;

    if (perfMode) {
      // High performance fallback - elegant semi-transparent surface without BackdropFilter blur
      fillColor = isDark
          ? AppColors.darkSurface.withValues(alpha: 0.85)
          : AppColors.lightSurface.withValues(alpha: 0.85);
      border = borderColor ??
          (isDark
              ? AppColors.darkGlassBorder.withValues(alpha: 0.15)
              : AppColors.lightGlassBorder.withValues(alpha: 0.3));
      shadow = [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
        )
      ];
    } else {
      // Standard Glassmorphism fill, border, shadow
      final baseFill = isDark ? AppColors.darkGlassFill : AppColors.lightGlassFill;
      final appliedOpacity = opacity ?? baseFill.a;
      fillColor = baseFill.withValues(alpha: appliedOpacity);
      border = borderColor ??
          (isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder);
      shadow = [
        BoxShadow(
          color: isDark ? AppColors.darkGlassShadow : AppColors.lightGlassShadow,
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];
    }

    Widget innerContent = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );

    // Add ink ripple if onTap is provided, inside the Material widget to avoid clipping issues
    if (onTap != null) {
      innerContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: innerContent,
        ),
      );
    }

    Widget container = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: border,
          width: AppSpacing.glassBorderWidth,
        ),
        boxShadow: shadow,
      ),
      child: innerContent,
    );

    // Only apply BackdropFilter blur if performance mode is disabled and blurSigma > 0
    final useBlur = !perfMode && blurSigma > 0;
    if (useBlur) {
      container = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma.clamp(0.0, 10.0), // Limit maximum blur to 10 for performance
            sigmaY: blurSigma.clamp(0.0, 10.0),
          ),
          child: container,
        ),
      );
    }

    if (margin != null) {
      container = Padding(padding: margin!, child: container);
    }

    return container;
  }
}
