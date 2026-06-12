import 'package:flutter/material.dart';
import 'package:storybook_ds/src/theme/storybook_toolbar_colors.dart';

@immutable
class StorybookTheme extends ThemeExtension<StorybookTheme> {
  const StorybookTheme({
    required this.panelBorderColor,
    required this.panelBorderWidth,
    required this.panelBorderRadius,
    required this.chipBorderColor,
    required this.chipBorderWidth,
    required this.chipBorderRadius,
    required this.chipSelectedBackgroundColor,
    required this.chipUnselectedBackgroundColor,
    required this.chipSelectedTextColor,
    required this.chipUnselectedTextColor,
    required this.checkColor,
    required this.checkBackgroundColor,
    required this.toolbarLightColors,
    required this.toolbarDarkColors,
    required this.appBarTitle,
    required this.appBarTitleStyle,
    required this.expansionTileIconColor,
    required this.expansionTileTextColor,
    required this.expansionTileBackgroundColor,
    required this.requiredAsteriskColor,
    required this.collapsiblePanelWidth,
  });

  final Color panelBorderColor;
  final double panelBorderWidth;
  final BorderRadius panelBorderRadius;
  final Color chipBorderColor;
  final double chipBorderWidth;
  final BorderRadius chipBorderRadius;
  final Color chipSelectedBackgroundColor;
  final Color chipUnselectedBackgroundColor;
  final Color chipSelectedTextColor;
  final Color chipUnselectedTextColor;
  final Color checkColor;
  final Color checkBackgroundColor;
  final StorybookToolbarColors toolbarLightColors;
  final StorybookToolbarColors toolbarDarkColors;
  final String appBarTitle;
  final TextStyle appBarTitleStyle;
  final Color expansionTileIconColor;
  final Color expansionTileTextColor;
  final Color expansionTileBackgroundColor;
  final Color requiredAsteriskColor;
  final double collapsiblePanelWidth;

  static StorybookTheme defaults() {
    return const StorybookTheme(
      panelBorderColor: Color(0xFF9E9E9E),
      panelBorderWidth: 1.0,
      panelBorderRadius: BorderRadius.all(Radius.circular(8)),
      chipBorderColor: Color(0xFF9E9E9E),
      chipBorderWidth: 1.0,
      chipBorderRadius: BorderRadius.all(Radius.circular(24)),
      chipSelectedBackgroundColor: Color(0xFFE0E0E0),
      chipUnselectedBackgroundColor: Color(0xFFFFFFFF),
      chipSelectedTextColor: Color(0xFF212121),
      chipUnselectedTextColor: Color(0xFF424242),
      checkColor: Color(0xFFFFFFFF),
      checkBackgroundColor: Color(0xFF424242),
      toolbarLightColors: StorybookToolbarColors.light,
      toolbarDarkColors: StorybookToolbarColors.dark,
      appBarTitle: 'Device preview',
      appBarTitleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF212121),
      ),
      expansionTileIconColor: Color(0xFF757575),
      expansionTileTextColor: Color(0xFF212121),
      expansionTileBackgroundColor: Color(0xFFFFFFFF),
      requiredAsteriskColor: Color(0xFFD32F2F),
      collapsiblePanelWidth: 64.0,
    );
  }

  @override
  StorybookTheme copyWith({
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
      panelBorderColor: panelBorderColor ?? this.panelBorderColor,
      panelBorderWidth: panelBorderWidth ?? this.panelBorderWidth,
      panelBorderRadius: panelBorderRadius ?? this.panelBorderRadius,
      chipBorderColor: chipBorderColor ?? this.chipBorderColor,
      chipBorderWidth: chipBorderWidth ?? this.chipBorderWidth,
      chipBorderRadius: chipBorderRadius ?? this.chipBorderRadius,
      chipSelectedBackgroundColor: chipSelectedBackgroundColor ?? this.chipSelectedBackgroundColor,
      chipUnselectedBackgroundColor: chipUnselectedBackgroundColor ?? this.chipUnselectedBackgroundColor,
      chipSelectedTextColor: chipSelectedTextColor ?? this.chipSelectedTextColor,
      chipUnselectedTextColor: chipUnselectedTextColor ?? this.chipUnselectedTextColor,
      checkColor: checkColor ?? this.checkColor,
      checkBackgroundColor: checkBackgroundColor ?? this.checkBackgroundColor,
      toolbarLightColors: toolbarLightColors ?? this.toolbarLightColors,
      toolbarDarkColors: toolbarDarkColors ?? this.toolbarDarkColors,
      appBarTitle: appBarTitle ?? this.appBarTitle,
      appBarTitleStyle: appBarTitleStyle ?? this.appBarTitleStyle,
      expansionTileIconColor: expansionTileIconColor ?? this.expansionTileIconColor,
      expansionTileTextColor: expansionTileTextColor ?? this.expansionTileTextColor,
      expansionTileBackgroundColor: expansionTileBackgroundColor ?? this.expansionTileBackgroundColor,
      requiredAsteriskColor: requiredAsteriskColor ?? this.requiredAsteriskColor,
      collapsiblePanelWidth: collapsiblePanelWidth ?? this.collapsiblePanelWidth,
    );
  }

  @override
  StorybookTheme lerp(ThemeExtension<StorybookTheme>? other, double t) {
    if (other is! StorybookTheme) return this;
    return copyWith(
      panelBorderColor: Color.lerp(panelBorderColor, other.panelBorderColor, t) ?? panelBorderColor,
      panelBorderWidth: _lerpDouble(panelBorderWidth, other.panelBorderWidth, t),
      panelBorderRadius: BorderRadius.lerp(panelBorderRadius, other.panelBorderRadius, t) ?? panelBorderRadius,
      chipBorderColor: Color.lerp(chipBorderColor, other.chipBorderColor, t) ?? chipBorderColor,
      chipBorderWidth: _lerpDouble(chipBorderWidth, other.chipBorderWidth, t),
      chipBorderRadius: BorderRadius.lerp(chipBorderRadius, other.chipBorderRadius, t) ?? chipBorderRadius,
      chipSelectedBackgroundColor: Color.lerp(chipSelectedBackgroundColor, other.chipSelectedBackgroundColor, t) ?? chipSelectedBackgroundColor,
      chipUnselectedBackgroundColor: Color.lerp(chipUnselectedBackgroundColor, other.chipUnselectedBackgroundColor, t) ?? chipUnselectedBackgroundColor,
      chipSelectedTextColor: Color.lerp(chipSelectedTextColor, other.chipSelectedTextColor, t) ?? chipSelectedTextColor,
      chipUnselectedTextColor: Color.lerp(chipUnselectedTextColor, other.chipUnselectedTextColor, t) ?? chipUnselectedTextColor,
      checkColor: Color.lerp(checkColor, other.checkColor, t) ?? checkColor,
      checkBackgroundColor: Color.lerp(checkBackgroundColor, other.checkBackgroundColor, t) ?? checkBackgroundColor,
      toolbarLightColors: StorybookToolbarColors.lerp(toolbarLightColors, other.toolbarLightColors, t) ?? toolbarLightColors,
      toolbarDarkColors: StorybookToolbarColors.lerp(toolbarDarkColors, other.toolbarDarkColors, t) ?? toolbarDarkColors,
      appBarTitle: t < 0.5 ? appBarTitle : other.appBarTitle,
      appBarTitleStyle: TextStyle.lerp(appBarTitleStyle, other.appBarTitleStyle, t) ?? appBarTitleStyle,
      expansionTileIconColor: Color.lerp(expansionTileIconColor, other.expansionTileIconColor, t) ?? expansionTileIconColor,
      expansionTileTextColor: Color.lerp(expansionTileTextColor, other.expansionTileTextColor, t) ?? expansionTileTextColor,
      expansionTileBackgroundColor: Color.lerp(expansionTileBackgroundColor, other.expansionTileBackgroundColor, t) ?? expansionTileBackgroundColor,
      requiredAsteriskColor: Color.lerp(requiredAsteriskColor, other.requiredAsteriskColor, t) ?? requiredAsteriskColor,
      collapsiblePanelWidth: _lerpDouble(collapsiblePanelWidth, other.collapsiblePanelWidth, t),
    );
  }

  double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StorybookTheme &&
        other.panelBorderColor == panelBorderColor &&
        other.panelBorderWidth == panelBorderWidth &&
        other.panelBorderRadius == panelBorderRadius &&
        other.chipBorderColor == chipBorderColor &&
        other.chipBorderWidth == chipBorderWidth &&
        other.chipBorderRadius == chipBorderRadius &&
        other.chipSelectedBackgroundColor == chipSelectedBackgroundColor &&
        other.chipUnselectedBackgroundColor == chipUnselectedBackgroundColor &&
        other.chipSelectedTextColor == chipSelectedTextColor &&
        other.chipUnselectedTextColor == chipUnselectedTextColor &&
        other.checkColor == checkColor &&
        other.checkBackgroundColor == checkBackgroundColor &&
        other.toolbarLightColors == toolbarLightColors &&
        other.toolbarDarkColors == toolbarDarkColors &&
        other.appBarTitle == appBarTitle &&
        other.appBarTitleStyle == appBarTitleStyle &&
        other.expansionTileIconColor == expansionTileIconColor &&
        other.expansionTileTextColor == expansionTileTextColor &&
        other.expansionTileBackgroundColor == expansionTileBackgroundColor &&
        other.requiredAsteriskColor == requiredAsteriskColor &&
        other.collapsiblePanelWidth == collapsiblePanelWidth;
  }

  @override
  int get hashCode {
    // Split into two Object.hash calls due to Dart SDK limitation of 20 arguments.
    final hash1 = Object.hash(
      panelBorderColor,
      panelBorderWidth,
      panelBorderRadius,
      chipBorderColor,
      chipBorderWidth,
      chipBorderRadius,
      chipSelectedBackgroundColor,
      chipUnselectedBackgroundColor,
      chipSelectedTextColor,
      chipUnselectedTextColor,
      checkColor,
      checkBackgroundColor,
      toolbarLightColors,
      toolbarDarkColors,
      appBarTitle,
      appBarTitleStyle,
      expansionTileIconColor,
      expansionTileTextColor,
      expansionTileBackgroundColor,
      requiredAsteriskColor,
    );
    final hash2 = collapsiblePanelWidth.hashCode;
    return Object.hash(hash1, hash2);
  }
}

class StorybookThemePresets {
  StorybookThemePresets._();

  static StorybookTheme get light => const StorybookTheme(
    panelBorderColor: Color(0xFF9E9E9E),
    panelBorderWidth: 1.0,
    panelBorderRadius: BorderRadius.all(Radius.circular(8)),
    chipBorderColor: Color(0xFF9E9E9E),
    chipBorderWidth: 1.0,
    chipBorderRadius: BorderRadius.all(Radius.circular(24)),
    chipSelectedBackgroundColor: Color(0xFFE0E0E0),
    chipUnselectedBackgroundColor: Color(0xFFFFFFFF),
    chipSelectedTextColor: Color(0xFF212121),
    chipUnselectedTextColor: Color(0xFF424242),
    checkColor: Color(0xFFFFFFFF),
    checkBackgroundColor: Color(0xFF424242),
    toolbarLightColors: StorybookToolbarColors.light,
    toolbarDarkColors: StorybookToolbarColors.dark,
    appBarTitle: 'Device preview',
    appBarTitleStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFF212121),
    ),
    expansionTileIconColor: Color(0xFF757575),
    expansionTileTextColor: Color(0xFF212121),
    expansionTileBackgroundColor: Color(0xFFFFFFFF),
    requiredAsteriskColor: Color(0xFFD32F2F),
    collapsiblePanelWidth: 64.0,
  );

  static StorybookTheme get dark => const StorybookTheme(
    panelBorderColor: Color(0xFF424242),
    panelBorderWidth: 1.0,
    panelBorderRadius: BorderRadius.all(Radius.circular(8)),
    chipBorderColor: Color(0xFF616161),
    chipBorderWidth: 1.0,
    chipBorderRadius: BorderRadius.all(Radius.circular(24)),
    chipSelectedBackgroundColor: Color(0xFF424242),
    chipUnselectedBackgroundColor: Color(0xFF303030),
    chipSelectedTextColor: Color(0xFFFFFFFF),
    chipUnselectedTextColor: Color(0xFFE0E0E0),
    checkColor: Color(0xFF212121),
    checkBackgroundColor: Color(0xFFE0E0E0),
    toolbarLightColors: StorybookToolbarColors.light,
    toolbarDarkColors: StorybookToolbarColors.dark,
    appBarTitle: 'Device preview',
    appBarTitleStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFFFFFFFF),
    ),
    expansionTileIconColor: Color(0xFFBDBDBD),
    expansionTileTextColor: Color(0xFFFFFFFF),
    expansionTileBackgroundColor: Color(0xFF303030),
    requiredAsteriskColor: Color(0xFFEF5350),
    collapsiblePanelWidth: 64.0,
  );

  static StorybookTheme get cupertino => const StorybookTheme(
    panelBorderColor: Color(0xFFC0C0C0),
    panelBorderWidth: 1.0,
    panelBorderRadius: BorderRadius.all(Radius.circular(6)),
    chipBorderColor: Color(0xFFC0C0C0),
    chipBorderWidth: 1.0,
    chipBorderRadius: BorderRadius.all(Radius.circular(16)),
    chipSelectedBackgroundColor: Color(0xFF007AFF),
    chipUnselectedBackgroundColor: Color(0xFFFFFFFF),
    chipSelectedTextColor: Color(0xFFFFFFFF),
    chipUnselectedTextColor: Color(0xFF007AFF),
    checkColor: Color(0xFFFFFFFF),
    checkBackgroundColor: Color(0xFF007AFF),
    toolbarLightColors: StorybookToolbarColors.light,
    toolbarDarkColors: StorybookToolbarColors.dark,
    appBarTitle: 'Device preview',
    appBarTitleStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFF212121),
    ),
    expansionTileIconColor: Color(0xFF007AFF),
    expansionTileTextColor: Color(0xFF212121),
    expansionTileBackgroundColor: Color(0xFFFFFFFF),
    requiredAsteriskColor: Color(0xFFFF3B30),
    collapsiblePanelWidth: 64.0,
  );

  static StorybookTheme get material3 => const StorybookTheme(
    panelBorderColor: Color(0xFF6750A4),
    panelBorderWidth: 1.0,
    panelBorderRadius: BorderRadius.all(Radius.circular(12)),
    chipBorderColor: Color(0xFF6750A4),
    chipBorderWidth: 1.0,
    chipBorderRadius: BorderRadius.all(Radius.circular(8)),
    chipSelectedBackgroundColor: Color(0xFF6750A4),
    chipUnselectedBackgroundColor: Color(0xFFFFFFFF),
    chipSelectedTextColor: Color(0xFFFFFFFF),
    chipUnselectedTextColor: Color(0xFF6750A4),
    checkColor: Color(0xFFFFFFFF),
    checkBackgroundColor: Color(0xFF6750A4),
    toolbarLightColors: StorybookToolbarColors.light,
    toolbarDarkColors: StorybookToolbarColors.dark,
    appBarTitle: 'Device preview',
    appBarTitleStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFF212121),
    ),
    expansionTileIconColor: Color(0xFF6750A4),
    expansionTileTextColor: Color(0xFF212121),
    expansionTileBackgroundColor: Color(0xFFFFFFFF),
    requiredAsteriskColor: Color(0xFFB3261E),
    collapsiblePanelWidth: 64.0,
  );
}
