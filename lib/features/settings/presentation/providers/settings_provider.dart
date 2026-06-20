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
