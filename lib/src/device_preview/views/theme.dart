import 'package:flutter/material.dart';
import 'package:storybook_ds/src/device_preview/state/state.dart';
import 'package:storybook_ds/src/theme/storybook_toolbar_colors.dart';

extension ThemeBackgroundExtension on DevicePreviewBackgroundThemeData {
  /// Converts a [DevicePreviewBackgroundThemeData] to a [ThemeData].
  ThemeData asThemeData() {
    switch (this) {
      case DevicePreviewBackgroundThemeData.dark:
        return ThemeData.dark();
      case DevicePreviewBackgroundThemeData.light:
        return ThemeData.light();
    }
  }
}

extension ThemeToolbarExtension on DevicePreviewToolBarThemeData {
  /// Converts a [DevicePreviewToolBarThemeData] to a [ThemeData].
  ///
  /// Uses [StorybookToolbarColors] when available, otherwise falls back to defaults.
  ThemeData asThemeData() {
    switch (this) {
      case DevicePreviewToolBarThemeData.dark:
        final base = ThemeData.dark();
        const colors = StorybookToolbarColors(
          color: Colors.white,
          onColor: Colors.black,
          surface: Color(0xFF303030),
          onSurface: Colors.white,
        );
        return base.copyWith(
          colorScheme: ColorScheme.dark(
            primary: colors.color,
            secondary: colors.color,
          ),
          primaryColor: colors.color,
          primaryColorDark: colors.color,
          highlightColor: colors.color.withValues(alpha: 0.1),
          sliderTheme: base.sliderTheme.copyWith(
            thumbColor: colors.color,
            activeTrackColor: colors.color.withValues(alpha: 0.7),
            inactiveTrackColor: colors.color.withValues(alpha: 0.12),
            activeTickMarkColor: colors.color,
            inactiveTickMarkColor: colors.color,
            overlayColor: colors.color.withValues(alpha: 0.12),
          ),
        );
      case DevicePreviewToolBarThemeData.light:
        final base = ThemeData.light();
        const colors = StorybookToolbarColors(
          color: Colors.black,
          onColor: Colors.white,
          surface: Color(0xFFF5F5F5),
          onSurface: Color(0xFF212121),
        );
        const barColor = Color(0xFF303030);
        return base.copyWith(
          colorScheme: ColorScheme.light(
            primary: colors.color,
            secondary: colors.color,
          ),
          primaryColor: colors.color,
          primaryColorDark: colors.color,
          highlightColor: colors.color,
          appBarTheme: base.appBarTheme.copyWith(
            backgroundColor: barColor,
          ),
          sliderTheme: base.sliderTheme.copyWith(
            thumbColor: colors.color,
            activeTrackColor: colors.color.withValues(alpha: 0.7),
            inactiveTrackColor: colors.color.withValues(alpha: 0.12),
            activeTickMarkColor: colors.color,
            inactiveTickMarkColor: colors.color,
            overlayColor: colors.color.withValues(alpha: 0.12),
          ),
        );
    }
  }
}
