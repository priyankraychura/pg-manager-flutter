import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Animated gradient background with floating decorative circles.
/// Used as the base scaffold background across all screens.
class GradientBackground extends StatefulWidget {
  final Widget child;
  final bool animate;

  const GradientBackground({
    super.key,
    required this.child,
    this.animate = false, // Static by default to maximize performance and avoid BackdropFilter lag
  });

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        gradient: isDark
            ? AppColors.darkBackgroundGradient
            : AppColors.lightBackgroundGradient,
      ),
      child: Stack(
        children: [
          // Decorative floating orbs
          if (widget.animate)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  size: size,
                  painter: _OrbsPainter(
                    progress: _controller.value,
                    isDark: isDark,
                  ),
                );
              },
            )
          else
            CustomPaint(
              size: size,
              painter: _OrbsPainter(
                progress: 0.0, // Static paint, cached by Flutter
                isDark: isDark,
              ),
            ),
          // Main content
          widget.child,
        ],
      ),
    );
  }
}

class _OrbsPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _OrbsPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Orb 1 - Large purple
    final orb1X = size.width * 0.2 + math.sin(progress * 2 * math.pi) * 30;
    final orb1Y = size.height * 0.15 + math.cos(progress * 2 * math.pi) * 20;
    paint.color = AppColors.primaryPurple.withValues(alpha: isDark ? 0.08 : 0.06);
    canvas.drawCircle(Offset(orb1X, orb1Y), 120, paint);

    // Orb 2 - Medium cyan
    final orb2X =
        size.width * 0.8 + math.cos(progress * 2 * math.pi + 1) * 25;
    final orb2Y =
        size.height * 0.35 + math.sin(progress * 2 * math.pi + 1) * 30;
    paint.color =
        AppColors.secondaryCyan.withValues(alpha: isDark ? 0.06 : 0.05);
    canvas.drawCircle(Offset(orb2X, orb2Y), 90, paint);

    // Orb 3 - Small pink
    final orb3X =
        size.width * 0.5 + math.sin(progress * 2 * math.pi + 2) * 20;
    final orb3Y =
        size.height * 0.7 + math.cos(progress * 2 * math.pi + 2) * 25;
    paint.color = AppColors.accentPink.withValues(alpha: isDark ? 0.05 : 0.04);
    canvas.drawCircle(Offset(orb3X, orb3Y), 80, paint);
  }

  @override
  bool shouldRepaint(_OrbsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
