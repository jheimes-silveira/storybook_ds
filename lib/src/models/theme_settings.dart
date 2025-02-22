import 'package:flutter/material.dart';

class ThemeSettings {
  final ThemeData _light;
  final ThemeData? _dark;
  final String _title;
  final dynamic _data;
  bool _isDarkMode;
  ThemeSettings({
    required final String title,
    required final ThemeData light,
    final ThemeData? dark,
    final dynamic data,
    final bool isDarkMode = false,
  })  : _title = title,
        _light = light,
        _dark = dark,
        _data = data,
        _isDarkMode = isDarkMode;

  bool get switchThemeMode => _dark != null;

  dynamic get data => _data;
  String get title => _title;
  ThemeData get light => _light;
  ThemeData get dark => _dark ?? _light;

  bool get isDarkMode => _dark == null ? false : _isDarkMode;

  ThemeData currentTheme() {
    return _isDarkMode ? dark : light;
  }

  void setCurrentTheme(bool isDarkMode) {
    _isDarkMode = isDarkMode;
  }
}
