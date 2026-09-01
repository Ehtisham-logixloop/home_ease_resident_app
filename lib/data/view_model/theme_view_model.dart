import 'package:flutter/material.dart';
import '../core/services/local_storage_service.dart';

enum ThemeModeOption { system, light, dark }

class ThemeProvider extends ChangeNotifier {
  ThemeModeOption _themeModeOption = ThemeModeOption.system;

  ThemeModeOption get themeModeOption => _themeModeOption;

  ThemeMode get themeMode {
    switch (_themeModeOption) {
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
      case ThemeModeOption.system:
        return ThemeMode.system;
    }
  }

  bool get isDarkMode {
    if (_themeModeOption == ThemeModeOption.dark) {
      return true;
    }
    return false;
  }

  bool get isSystemMode {
    return _themeModeOption == ThemeModeOption.system;
  }

  Future<void> loadThemeMode() async {
    final saved = await LocalStorageService.getThemeMode();
    if (saved != null) {
      switch (saved) {
        case 'light':
          _themeModeOption = ThemeModeOption.light;
          break;
        case 'dark':
          _themeModeOption = ThemeModeOption.dark;
          break;
        case 'system':
          _themeModeOption = ThemeModeOption.system;
          break;
      }
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeModeOption option) async {
    _themeModeOption = option;
    String modeString;
    switch (option) {
      case ThemeModeOption.light:
        modeString = 'light';
        break;
      case ThemeModeOption.dark:
        modeString = 'dark';
        break;
      case ThemeModeOption.system:
        modeString = 'system';
        break;
    }
    await LocalStorageService.saveThemeMode(modeString);
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool isDark) async {
    if (isDark) {
      await setThemeMode(ThemeModeOption.dark);
    } else {
      await setThemeMode(ThemeModeOption.light);
    }
  }
}
