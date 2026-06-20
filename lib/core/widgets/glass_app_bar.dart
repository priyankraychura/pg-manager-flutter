import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../../features/settings/presentation/providers/settings_provider.dart';

/// Glassmorphic app bar that floats over the content with blur effect.
class GlassAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;

  const GlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.appBarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final perfMode = ref.watch(performanceModeProvider);

    final Color bgColor;
    final Color borderColor;

    if (perfMode) {
      // Clean solid fallback under performance mode
      bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
      borderColor = isDark
          ? AppColors.darkGlassBorder.withValues(alpha: 0.2)
          : AppColors.lightGlassBorder.withValues(alpha: 0.1);
    } else {
      // Frosted translucent fill
      bgColor = isDark
          ? AppColors.darkGlassFill.withValues(alpha: 0.8)
          : AppColors.lightGlassFill.withValues(alpha: 0.8);
      borderColor = isDark
          ? AppColors.darkGlassBorder
          : AppColors.lightGlassBorder;
    }

    Widget appBarWidget = Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 0.5,
          ),
        ),
      ),
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: leading ??
            (showBackButton && Navigator.canPop(context)
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  )
                : null),
        actions: actions,
      ),
    );

    if (!perfMode) {
      appBarWidget = ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Limit blur to 10
          child: appBarWidget,
        ),
      );
    }

    return appBarWidget;
  }
}
