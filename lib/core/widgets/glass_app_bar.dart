import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../../features/settings/presentation/providers/settings_provider.dart';

/// Glassmorphic app bar that floats over the content with blur effect.
class GlassAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool centerTitle;

  const GlassAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(
      AppSpacing.appBarHeight + (subtitle != null ? 14.0 : 0.0));

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

    // Premium Custom Back Button
    final Widget? leadingWidget = leading ??
        (showBackButton
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onBackPressed ?? () {
                        if (Navigator.canPop(context)) {
                          Navigator.maybePop(context);
                        } else {
                          context.go('/dashboard');
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.black.withValues(alpha: 0.08),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 22,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : null);

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
        title: Column(
          crossAxisAlignment:
              centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextStyles.h2.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: centerTitle,
        leading: leadingWidget,
        leadingWidth: showBackButton ? 56 : null,
        actions: actions?.map((w) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: w,
          );
        }).toList(),
      ),
    );

    if (!perfMode) {
      appBarWidget = ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: appBarWidget,
        ),
      );
    }

    return appBarWidget;
  }
}

