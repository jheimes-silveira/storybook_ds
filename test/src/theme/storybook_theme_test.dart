import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/theme/storybook_theme.dart';
import 'package:storybook_ds/src/theme/storybook_toolbar_colors.dart';

void main() {
  group('StorybookTheme', () {
    StorybookTheme createTheme({
      Color? panelBorderColor,
      double? panelBorderWidth,
      BorderRadius? panelBorderRadius,
      Color? chipBorderColor,
      double? chipBorderWidth,
      BorderRadius? chipBorderRadius,
      Color? chipSelectedBackgroundColor,
      Color? chipUnselectedBackgroundColor,
      Color? chipSelectedTextColor,
      Color? chipUnselectedTextColor,
      Color? checkColor,
      Color? checkBackgroundColor,
      StorybookToolbarColors? toolbarLightColors,
      StorybookToolbarColors? toolbarDarkColors,
      String? appBarTitle,
      TextStyle? appBarTitleStyle,
      Color? expansionTileIconColor,
      Color? expansionTileTextColor,
      Color? expansionTileBackgroundColor,
      Color? requiredAsteriskColor,
      double? collapsiblePanelWidth,
    }) {
      return StorybookTheme(
        panelBorderColor: panelBorderColor ?? const Color(0xFF9E9E9E),
        panelBorderWidth: panelBorderWidth ?? 1.0,
        panelBorderRadius: panelBorderRadius ?? const BorderRadius.all(Radius.circular(8)),
        chipBorderColor: chipBorderColor ?? const Color(0xFF9E9E9E),
        chipBorderWidth: chipBorderWidth ?? 1.0,
        chipBorderRadius: chipBorderRadius ?? const BorderRadius.all(Radius.circular(24)),
        chipSelectedBackgroundColor: chipSelectedBackgroundColor ?? const Color(0xFFE0E0E0),
        chipUnselectedBackgroundColor: chipUnselectedBackgroundColor ?? const Color(0xFFFFFFFF),
        chipSelectedTextColor: chipSelectedTextColor ?? const Color(0xFF212121),
        chipUnselectedTextColor: chipUnselectedTextColor ?? const Color(0xFF424242),
        checkColor: checkColor ?? const Color(0xFFFFFFFF),
        checkBackgroundColor: checkBackgroundColor ?? const Color(0xFF424242),
        toolbarLightColors: toolbarLightColors ?? StorybookToolbarColors.light,
        toolbarDarkColors: toolbarDarkColors ?? StorybookToolbarColors.dark,
        appBarTitle: appBarTitle ?? 'Device preview',
        appBarTitleStyle: appBarTitleStyle ?? const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF212121),
        ),
        expansionTileIconColor: expansionTileIconColor ?? const Color(0xFF757575),
        expansionTileTextColor: expansionTileTextColor ?? const Color(0xFF212121),
        expansionTileBackgroundColor: expansionTileBackgroundColor ?? const Color(0xFFFFFFFF),
        requiredAsteriskColor: requiredAsteriskColor ?? const Color(0xFFD32F2F),
        collapsiblePanelWidth: collapsiblePanelWidth ?? 64.0,
      );
    }

    test('creates instance with all required parameters', () {
      final theme = createTheme();

      expect(theme.panelBorderColor, const Color(0xFF9E9E9E));
      expect(theme.panelBorderWidth, 1.0);
      expect(theme.panelBorderRadius, const BorderRadius.all(Radius.circular(8)));
      expect(theme.chipBorderColor, const Color(0xFF9E9E9E));
      expect(theme.chipBorderWidth, 1.0);
      expect(theme.chipBorderRadius, const BorderRadius.all(Radius.circular(24)));
      expect(theme.chipSelectedBackgroundColor, const Color(0xFFE0E0E0));
      expect(theme.chipUnselectedBackgroundColor, const Color(0xFFFFFFFF));
      expect(theme.chipSelectedTextColor, const Color(0xFF212121));
      expect(theme.chipUnselectedTextColor, const Color(0xFF424242));
      expect(theme.checkColor, const Color(0xFFFFFFFF));
      expect(theme.checkBackgroundColor, const Color(0xFF424242));
      expect(theme.appBarTitle, 'Device preview');
      expect(theme.collapsiblePanelWidth, 64.0);
    });

    test('defaults() creates theme with legacy values', () {
      final theme = StorybookTheme.defaults();

      expect(theme.panelBorderColor, const Color(0xFF9E9E9E));
      expect(theme.panelBorderWidth, 1.0);
      expect(theme.panelBorderRadius, const BorderRadius.all(Radius.circular(8)));
      expect(theme.toolbarLightColors.color, const Color(0xFFFFFFFF));
      expect(theme.toolbarDarkColors.color, const Color(0xFF212121));
      expect(theme.appBarTitle, 'Device preview');
      expect(theme.collapsiblePanelWidth, 64.0);
    });

    test('copyWith creates new instance with updated values', () {
      final original = createTheme();
      final copied = original.copyWith(
        panelBorderColor: Colors.blue,
        collapsiblePanelWidth: 100.0,
      );

      expect(copied.panelBorderColor, Colors.blue);
      expect(copied.collapsiblePanelWidth, 100.0);
      expect(copied.panelBorderWidth, original.panelBorderWidth);
      expect(copied.appBarTitle, original.appBarTitle);
    });

    test('copyWith returns same instance when no parameters provided', () {
      final original = createTheme();
      final copied = original.copyWith();

      expect(copied, original);
    });

    test('equality works correctly', () {
      final theme1 = createTheme();
      final theme2 = createTheme();
      final theme3 = createTheme(panelBorderColor: Colors.blue);

      expect(theme1, theme2);
      expect(theme1, isNot(theme3));
    });

    group('lerp', () {
      test('returns same instance when other is null', () {
        final theme = createTheme();
        final result = theme.lerp(null, 0.5);

        expect(result, theme);
      });

      test('interpolates panelBorderWidth correctly', () {
        final theme1 = createTheme(panelBorderWidth: 0.0);
        final theme2 = createTheme(panelBorderWidth: 10.0);
        final result = theme1.lerp(theme2, 0.5);

        expect(result.panelBorderWidth, 5.0);
      });

      test('interpolates appBarTitle correctly at t<0.5', () {
        final theme1 = createTheme(appBarTitle: 'Title A');
        final theme2 = createTheme(appBarTitle: 'Title B');
        final result = theme1.lerp(theme2, 0.3);

        expect(result.appBarTitle, 'Title A');
      });

      test('interpolates appBarTitle correctly at t>=0.5', () {
        final theme1 = createTheme(appBarTitle: 'Title A');
        final theme2 = createTheme(appBarTitle: 'Title B');
        final result = theme1.lerp(theme2, 0.7);

        expect(result.appBarTitle, 'Title B');
      });
    });
  });

  group('StorybookThemePresets', () {
    test('light preset has correct values', () {
      final theme = StorybookThemePresets.light;

      expect(theme.panelBorderColor, const Color(0xFF9E9E9E));
      expect(theme.panelBorderWidth, 1.0);
      expect(theme.panelBorderRadius, const BorderRadius.all(Radius.circular(8)));
      expect(theme.chipBorderRadius, const BorderRadius.all(Radius.circular(24)));
      expect(theme.toolbarLightColors.color, const Color(0xFFFFFFFF));
      expect(theme.toolbarDarkColors.color, const Color(0xFF212121));
    });

    test('dark preset has correct values', () {
      final theme = StorybookThemePresets.dark;

      expect(theme.panelBorderColor, const Color(0xFF424242));
      expect(theme.chipSelectedBackgroundColor, const Color(0xFF424242));
      expect(theme.chipUnselectedBackgroundColor, const Color(0xFF303030));
      expect(theme.toolbarDarkColors.color, const Color(0xFF212121));
    });

    test('cupertino preset has iOS blue accent', () {
      final theme = StorybookThemePresets.cupertino;

      expect(theme.chipSelectedBackgroundColor, const Color(0xFF007AFF));
      expect(theme.chipUnselectedTextColor, const Color(0xFF007AFF));
      expect(theme.expansionTileIconColor, const Color(0xFF007AFF));
    });

    test('material3 preset has purple accent', () {
      final theme = StorybookThemePresets.material3;

      expect(theme.panelBorderColor, const Color(0xFF6750A4));
      expect(theme.chipSelectedBackgroundColor, const Color(0xFF6750A4));
      expect(theme.panelBorderRadius, const BorderRadius.all(Radius.circular(12)));
    });
  });
}
