import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../design_system/tokens/app_colors.dart';

/// Singleton holding the light/dark preference. Flips [AppColors.isDark]
/// and notifies listeners so the root [ListenableBuilder] in main.dart
/// rebuilds the whole app — every screen reads `AppColors.xxx` at build
/// time, so a full rebuild is enough to retheme everything without each
/// widget needing its own listener.
class ThemeController extends ChangeNotifier {
  ThemeController._();
  static final instance = ThemeController._();

  static const _prefsKey = 'dark_mode';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    AppColors.isDark = prefs.getBool(_prefsKey) ?? false;
    notifyListeners();
  }

  Future<void> toggle() async {
    AppColors.isDark = !AppColors.isDark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, AppColors.isDark);
  }
}
