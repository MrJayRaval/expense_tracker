import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _key = 'themeMode';
  static const String _animKey = 'animationsEnabled';

  ThemeMode _themeMode = ThemeMode.system;
  bool _isAnimationsEnabled = true;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isAnimationsEnabled => _isAnimationsEnabled;

  ThemeProvider() {
    _loadSettings();
  }

  void _loadSettings() async {
    final box = await Hive.openBox(_boxName);
    final savedTheme = box.get(_key);
    _isAnimationsEnabled = box.get(_animKey, defaultValue: true);

    if (savedTheme != null) {
      if (savedTheme == 'light') {
        _themeMode = ThemeMode.light;
      } else if (savedTheme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> toggleAnimations(bool value) async {
    _isAnimationsEnabled = value;
    final box = await Hive.openBox(_boxName);
    await box.put(_animKey, value);
    notifyListeners();
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final box = await Hive.openBox(_boxName);
    String value;
    if (mode == ThemeMode.light) {
      value = 'light';
    } else if (mode == ThemeMode.dark) {
      value = 'dark';
    } else {
      value = 'system';
    }
    await box.put(_key, value);
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    _saveTheme(_themeMode);
    notifyListeners();
  }

  void setDark() {
    _themeMode = ThemeMode.dark;
    _saveTheme(_themeMode);
    notifyListeners();
  }

  void setLight() {
    _themeMode = ThemeMode.light;
    _saveTheme(_themeMode);
    notifyListeners();
  }
}
