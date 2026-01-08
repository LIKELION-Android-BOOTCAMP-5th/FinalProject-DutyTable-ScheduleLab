import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final List<String> themeList = ["라이트모드", "다크모드", "시스템모드"];
  String _selectedOption = "시스템모드";

  ThemeMode _themeMode = ThemeMode.system;

  String get selectedOption => _selectedOption;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  void updateTheme(String selectedText) async {
    _selectedOption = selectedText;

    _themeMode = switch (selectedText) {
      "라이트모드" => ThemeMode.light,
      "다크모드" => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedOption', selectedText);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedOption = prefs.getString('selectedOption');

    if (savedOption != null) {
      _selectedOption = savedOption;

      _themeMode = switch (savedOption) {
        "라이트모드" => ThemeMode.light,
        "다크모드" => ThemeMode.dark,
        _ => ThemeMode.system,
      };

      notifyListeners();
    }
  }
}
