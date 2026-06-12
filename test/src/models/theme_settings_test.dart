import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/models/theme_settings.dart';
import 'package:storybook_ds/src/models/multiple_theme_settings.dart';

void main() {
  group('ThemeSettings', () {
    test('creates instance with required parameters', () {
      final lightTheme = ThemeData.light();
      final settings = ThemeSettings(
        title: 'Light Theme',
        light: lightTheme,
      );

      expect(settings.title, 'Light Theme');
      expect(settings.light, lightTheme);
      expect(settings.dark, lightTheme);
      expect(settings.switchThemeMode, false);
      expect(settings.isDarkMode, false);
    });

    test('creates instance with dark theme', () {
      final lightTheme = ThemeData.light();
      final darkTheme = ThemeData.dark();
      final settings = ThemeSettings(
        title: 'Test Theme',
        light: lightTheme,
        dark: darkTheme,
      );

      expect(settings.switchThemeMode, true);
      expect(settings.dark, darkTheme);
    });

    test('creates instance with data', () {
      final settings = ThemeSettings(
        title: 'Test',
        light: ThemeData.light(),
        data: {'custom': 'value'},
      );

      expect(settings.data, {'custom': 'value'});
    });

    test('currentTheme returns light when isDarkMode is false', () {
      final settings = ThemeSettings(
        title: 'Test',
        light: ThemeData.light(),
        isDarkMode: false,
      );

      expect(settings.currentTheme(), settings.light);
    });

    test('currentTheme returns dark when isDarkMode is true', () {
      final lightTheme = ThemeData.light();
      final darkTheme = ThemeData.dark();
      final settings = ThemeSettings(
        title: 'Test',
        light: lightTheme,
        dark: darkTheme,
        isDarkMode: true,
      );

      expect(settings.currentTheme(), darkTheme);
    });

    test('setCurrentTheme updates isDarkMode', () {
      final settings = ThemeSettings(
        title: 'Test',
        light: ThemeData.light(),
        dark: ThemeData.dark(),
        isDarkMode: false,
      );

      expect(settings.isDarkMode, false);

      settings.setCurrentTheme(true);
      expect(settings.isDarkMode, true);

      settings.setCurrentTheme(false);
      expect(settings.isDarkMode, false);
    });

    test('isDarkMode returns false when no dark theme', () {
      final settings = ThemeSettings(
        title: 'Test',
        light: ThemeData.light(),
      );

      expect(settings.isDarkMode, false);
    });
  });

  group('MultipleThemeSettings', () {
    test('creates instance with selectable themes', () {
      final theme1 = ThemeSettings(
        title: 'Theme 1',
        light: ThemeData.light(),
      );
      final theme2 = ThemeSettings(
        title: 'Theme 2',
        light: ThemeData.light(),
      );

      final settings = MultipleThemeSettings(
        selectableThemes: [theme1, theme2],
      );

      expect(settings.selectableThemes.length, 2);
      expect(settings.selectedThemes, theme1);
    });

    test('creates instance with initSelectedTheme', () {
      final theme1 = ThemeSettings(
        title: 'Theme 1',
        light: ThemeData.light(),
      );
      final theme2 = ThemeSettings(
        title: 'Theme 2',
        light: ThemeData.light(),
      );

      final settings = MultipleThemeSettings(
        selectableThemes: [theme1, theme2],
        initSelectedTheme: theme2,
      );

      expect(settings.selectedThemes, theme2);
    });

    test('selectedThemes can be updated', () {
      final theme1 = ThemeSettings(
        title: 'Theme 1',
        light: ThemeData.light(),
      );
      final theme2 = ThemeSettings(
        title: 'Theme 2',
        light: ThemeData.light(),
      );

      final settings = MultipleThemeSettings(
        selectableThemes: [theme1, theme2],
      );

      expect(settings.selectedThemes, theme1);

      settings.selectedThemes = theme2;
      expect(settings.selectedThemes, theme2);
    });
  });
}
