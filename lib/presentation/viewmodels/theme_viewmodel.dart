import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = ChangeNotifierProvider((ref) {
  final vm = ThemeViewModel();
  vm.init();
  return vm;
});

/// Holds the current [ThemeMode] and notifies listeners on toggle.
class ThemeViewModel extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  bool _isManualOverride = false;
  Timer? _timer;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void init() {
    _updateThemeBasedOnTime();
    // Check every minute for time-based theme changes
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!_isManualOverride) {
        _updateThemeBasedOnTime();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateThemeBasedOnTime() {
    final now = DateTime.now();
    final hour = now.hour;

    // 7 AM to 5 PM (17:00) is light mode
    final shouldBeLight = hour >= 7 && hour < 17;
    final newMode = shouldBeLight ? ThemeMode.light : ThemeMode.dark;

    if (_mode != newMode) {
      _mode = newMode;
      notifyListeners();
    }
  }

  void toggle() {
    _isManualOverride = true;
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
