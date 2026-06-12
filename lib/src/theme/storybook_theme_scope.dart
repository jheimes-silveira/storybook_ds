import 'package:flutter/material.dart';
import 'package:storybook_ds/src/theme/storybook_theme.dart';

/// An [InheritedWidget] that provides [StorybookTheme] to all descendants.
///
/// Use [StorybookThemeScope.of] to access the theme from any descendant.
///
/// Example:
/// ```dart
/// StorybookThemeScope(
///   theme: StorybookThemePresets.light,
///   child: MyStorybook(),
/// )
/// ```
class StorybookThemeScope extends InheritedWidget {
  const StorybookThemeScope({
    super.key,
    required this.theme,
    required super.child,
  });

  /// The storybook theme provided to descendants.
  final StorybookTheme theme;

  /// Retrieves the nearest [StorybookTheme] from the given [context].
  ///
  /// Returns [StorybookTheme.defaults] if no [StorybookThemeScope] is found.
  static StorybookTheme of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<StorybookThemeScope>();
    return scope?.theme ?? StorybookTheme.defaults();
  }

  /// Retrieves the [StorybookTheme] from the nearest ancestor [StorybookThemeScope],
  /// or returns [defaultTheme] if none is found.
  static StorybookTheme maybeOf(BuildContext context, {StorybookTheme? defaultTheme}) {
    final scope = context.dependOnInheritedWidgetOfExactType<StorybookThemeScope>();
    return scope?.theme ?? defaultTheme ?? StorybookTheme.defaults();
  }

  @override
  bool updateShouldNotify(StorybookThemeScope oldWidget) {
    return theme != oldWidget.theme;
  }
}