import 'package:flutter/material.dart';

/// App-wide color palette supporting light and dark themes.
/// Uses a deep purple/indigo + electric cyan palette with
/// glassmorphism-optimized transparency values.
class AppColors {
  AppColors._();

  // ─── Primary Palette ───────────────────────────────────────
  static const Color primaryPurple = Color(0xFF7C4DFF);
  static const Color primaryPurpleLight = Color(0xFFB388FF);
  static const Color primaryPurpleDark = Color(0xFF651FFF);

  // ─── Secondary / Accent ────────────────────────────────────
  static const Color secondaryCyan = Color(0xFF00E5FF);
  static const Color secondaryCyanDark = Color(0xFF00B8D4);
  static const Color accentPink = Color(0xFFFF6AC1);

  // ─── Semantic Colors ───────────────────────────────────────
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFD740);
  static const Color error = Color(0xFFFF5252);
  static const Color info = Color(0xFF448AFF);

  // ─── Light Mode ────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF3E8FF);
  static const Color lightBackgroundEnd = Color(0xFFE8EAF6);
  static const Color lightSurface = Color(0xFFFFFBFE);
  static const Color lightTextPrimary = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF4A4A6A);
  static const Color lightTextTertiary = Color(0xFF8A8AAA);

  static Color lightGlassFill = Colors.white.withValues(alpha: 0.45);
  static Color lightGlassBorder = Colors.white.withValues(alpha: 0.65);
  static Color lightGlassShadow = Colors.black.withValues(alpha: 0.04);

  // ─── Dark Mode ─────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0A0E21);
  static const Color darkBackgroundEnd = Color(0xFF1A1A3E);
  static const Color darkSurface = Color(0xFF1E1E3E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xB3FFFFFF); // 70%
  static const Color darkTextTertiary = Color(0x66FFFFFF); // 40%

  static Color darkGlassFill = Colors.white.withValues(alpha: 0.08);
  static Color darkGlassBorder = Colors.white.withValues(alpha: 0.12);
  static Color darkGlassShadow = Colors.black.withValues(alpha: 0.2);

  // ─── Gradient Presets ──────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, secondaryCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    colors: [lightBackground, lightBackgroundEnd, Color(0xFFE1F5FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [darkBackground, darkBackgroundEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [primaryPurple, accentPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
