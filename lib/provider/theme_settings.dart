import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSettings extends ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.light;
  Color _currentColor = Color.fromARGB(255, 255, 182, 0);
  int _currentFontSize = 20;

  final Color _resetColor = Color.fromARGB(255, 255, 182, 0);
  final ThemeMode _resetMode = ThemeMode.light;
  final int _resetfontSize = 20;

  ThemeMode get currentTheme => _currentTheme;
  Color get currentColor => _currentColor;
  int get currentFontSize => _currentFontSize;

  ThemeSettings(bool isDark, Color color, int fontSize) {
    if (isDark) {
      _currentTheme = ThemeMode.dark;
    } else {
      _currentTheme = ThemeMode.light;
    }
    _currentColor = color;
    _currentFontSize = fontSize;
  }

  Future<void> toggleTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (_currentTheme == ThemeMode.light) {
      _currentTheme = ThemeMode.dark;
      sharedPreferences.setBool('is_dark', true);
    } else {
      _currentTheme = ThemeMode.light;
      sharedPreferences.setBool('is_dark', false);
    }
    notifyListeners();
  }

  Future<void> saveColor(Color color) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _currentColor = color;
    sharedPreferences.setInt('color', color.value);
    notifyListeners();
  }

  Future<void> saveFontSize(int fontSize) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _currentFontSize = fontSize;
    sharedPreferences.setInt('font_size', fontSize);
    notifyListeners();
  }

  Future resetSettings() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _currentTheme = _resetMode;
    _currentColor = _resetColor;
    _currentFontSize = _resetfontSize;
    sharedPreferences.setBool('is_dark', false);
    sharedPreferences.setInt('color', _resetColor.value);
    sharedPreferences.setInt('font_size', _resetfontSize);
    notifyListeners();
  }
}
