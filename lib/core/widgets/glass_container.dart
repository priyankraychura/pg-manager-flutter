import 'dart:ui';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Core glassmorphism container widget.
/// All glass_* widgets are built on top of this.
/// Provides frosted glass effect with customizable blur, opacity, and border.
class GlassContainer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fillColor = isDark
        ? AppColors.darkGlassFill
        : AppColors.lightGlassFill;
    final border = borderColor ??
        (isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder);
    final shadow =
        isDark ? AppColors.darkGlassShadow : AppColors.lightGlassShadow;

    final appliedOpacity = opacity ?? fillColor.a;
    final adjustedFill = fillColor.withValues(alpha: appliedOpacity);

    Widget container = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: adjustedFill,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: border,
              width: AppSpacing.glassBorderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: shadow,
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (margin != null) {
      container = Padding(padding: margin!, child: container);
    }

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: container);
    }

    return container;
  }
}
