import 'package:flutter/material.dart';

/// Defines the color scheme for the toolbar in a specific mode (light or dark).
///
/// Used by [StorybookTheme] to provide customizable toolbar colors.
@immutable
class StorybookToolbarColors {
  const StorybookToolbarColors({
    required this.color,
    required this.onColor,
    required this.surface,
    required this.onSurface,
  });

  /// Light toolbar colors (used regardless of the active storybook preset).
  static const StorybookToolbarColors light = StorybookToolbarColors(
    color: Color(0xFFFFFFFF),
    onColor: Color(0xFF000000),
    surface: Color(0xFFF5F5F5),
    onSurface: Color(0xFF212121),
  );

  /// Dark toolbar colors (used regardless of the active storybook preset).
  static const StorybookToolbarColors dark = StorybookToolbarColors(
    color: Color(0xFF212121),
    onColor: Color(0xFFFFFFFF),
    surface: Color(0xFF303030),
    onSurface: Color(0xFFFFFFFF),
  );

  /// The primary color for the toolbar.
  final Color color;

  /// The color for icons and text on top of [color].
  final Color onColor;

  /// The surface color for the toolbar background.
  final Color surface;

  /// The color for icons and text on top of [surface].
  final Color onSurface;

  /// Creates a copy of this object with the given fields replaced.
  StorybookToolbarColors copyWith({
    Color? color,
    Color? onColor,
    Color? surface,
    Color? onSurface,
  }) {
    return StorybookToolbarColors(
      color: color ?? this.color,
      onColor: onColor ?? this.onColor,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StorybookToolbarColors &&
        other.color == color &&
        other.onColor == onColor &&
        other.surface == surface &&
        other.onSurface == onSurface;
  }

  @override
  int get hashCode => Object.hash(color, onColor, surface, onSurface);

  /// Interpolates between two [StorybookToolbarColors] by [t].
  static StorybookToolbarColors? lerp(
    StorybookToolbarColors? a,
    StorybookToolbarColors? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    return StorybookToolbarColors(
      color: Color.lerp(a.color, b.color, t)!,
      onColor: Color.lerp(a.onColor, b.onColor, t)!,
      surface: Color.lerp(a.surface, b.surface, t)!,
      onSurface: Color.lerp(a.onSurface, b.onSurface, t)!,
    );
  }
}
