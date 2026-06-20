import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Theme state provider — controls light/dark mode toggle.
class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false); // false = light mode (default)

  void toggle() => state = !state;
  void setDark() => state = true;
  void setLight() => state = false;
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

/// Performance mode state provider — controls high-performance (no blur/reduced animations) toggle.
class PerformanceModeNotifier extends StateNotifier<bool> {
  PerformanceModeNotifier() : super(true); // true = Performance Mode active (smooth, static fallbacks) by default

  void toggle() => state = !state;
  void setEnabled(bool value) => state = value;
}

final performanceModeProvider = StateNotifierProvider<PerformanceModeNotifier, bool>((ref) {
  return PerformanceModeNotifier();
});
