import 'package:flutter/material.dart';

/// ViewModel for the Settings screen.
///
/// Manages theme mode preference.
class SettingsViewModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  /// The current theme mode.
  ThemeMode get themeMode => _themeMode;

  /// Whether dark mode is currently active.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Toggle between light and dark theme.
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  /// Set a specific theme mode.
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }
}
