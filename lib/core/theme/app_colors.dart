import 'package:flutter/material.dart';

/// App-wide color palette supporting light and dark themes.
/// Uses a deep purple/indigo + electric cyan palette with
/// glassmorphism-optimized transparency values.
class AppColors {
  AppColors._();

  // ─── Primary Palette ───────────────────────────────────────
  static const Color primaryOrange = Color(0xFFEA580C); // Professional Solid Orange
  static const Color primaryOrangeLight = Color(0xFFFB923C); // Soft Orange Accent
  static const Color primaryOrangeDark = Color(0xFFC2410C); // Deep Corporate Orange

  // ─── Secondary / Accent ────────────────────────────────────
  static const Color secondarySlate = Color(0xFF475569); // Professional Slate Gray
  static const Color secondarySlateDark = Color(0xFF1E293B); // Dark Slate Gray
  static const Color accentTeal = Color(0xFF0F766E); // Elegant Teal Accent

  // ─── Semantic Colors ───────────────────────────────────────
  static const Color success = Color(0xFF10B981); // Mint Green
  static const Color warning = Color(0xFFF59E0B); // Amber Gold
  static const Color error = Color(0xFFEF4444); // Rose Red
  static const Color info = Color(0xFF3B82F6); // Blue Slate

  // ─── Light Mode ────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate-50 Background
  static const Color lightBackgroundEnd = Color(0xFFE2E8F0); // Slate-200 Soft End
  static const Color lightSurface = Color(0xFFFFFFFF); // Clean White
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate-900 Primary Text
  static const Color lightTextSecondary = Color(0xFF475569); // Slate-600 Secondary Text
  static const Color lightTextTertiary = Color(0xFF94A3B8); // Slate-400 Subtle Text

  static Color lightGlassFill = Colors.white.withValues(alpha: 0.45);
  static Color lightGlassBorder = Colors.white.withValues(alpha: 0.65);
  static Color lightGlassShadow = Colors.black.withValues(alpha: 0.03);

  // ─── Dark Mode ─────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF030712); // Obsidian Black Background
  static const Color darkBackgroundEnd = Color(0xFF111827); // Dark Slate Gray End
  static const Color darkSurface = Color(0xFF1F2937); // Charcoal Slate Surface
  static const Color darkTextPrimary = Color(0xFFF9FAFB); // Cool Off-White Primary Text
  static const Color darkTextSecondary = Color(0xFFD1D5DB); // Light Gray Secondary Text
  static const Color darkTextTertiary = Color(0xFF9CA3AF); // Muted Gray Subtle Text

  static Color darkGlassFill = Colors.white.withValues(alpha: 0.04);
  static Color darkGlassBorder = Colors.white.withValues(alpha: 0.08);
  static Color darkGlassShadow = Colors.black.withValues(alpha: 0.15);

  // ─── Gradient Presets ──────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryOrange, secondarySlate],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    colors: [lightBackground, lightBackgroundEnd, Color(0xFFF1F5F9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [darkBackground, darkBackgroundEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [primaryOrange, accentTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
