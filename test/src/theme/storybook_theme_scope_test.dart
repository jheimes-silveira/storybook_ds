import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/theme/storybook_theme.dart';
import 'package:storybook_ds/src/theme/storybook_theme_scope.dart';

void main() {
  group('StorybookThemeScope', () {
    testWidgets('provides theme to descendants', (tester) async {
      final theme = StorybookTheme.defaults();

      await tester.pumpWidget(
        MaterialApp(
          home: StorybookThemeScope(
            theme: theme,
            child: Builder(
              builder: (context) {
                final retrievedTheme = StorybookThemeScope.of(context);
                expect(retrievedTheme, theme);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('theme is accessible in nested widgets', (tester) async {
      final theme = StorybookTheme.defaults();

      await tester.pumpWidget(
        MaterialApp(
          home: StorybookThemeScope(
            theme: theme,
            child: Column(
              children: [
                Builder(
                  builder: (context) {
                    final retrievedTheme = StorybookThemeScope.of(context);
                    expect(retrievedTheme, theme);
                    return const SizedBox();
                  },
                ),
 Builder(
                  builder: (context) {
                    final retrievedTheme = StorybookThemeScope.of(context);
                    expect(retrievedTheme, theme);
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });

    testWidgets('updateShouldNotify returns true for different themes', (tester) async {
      final theme1 = StorybookTheme.defaults();
      final theme2 = StorybookThemePresets.dark;

      final scope = StorybookThemeScope(
        theme: theme1,
        child: const SizedBox(),
      );

      // Create a new scope with different theme
      final newScope = StorybookThemeScope(
        theme: theme2,
        child: const SizedBox(),
      );

      expect(scope.updateShouldNotify(newScope), isTrue);
    });

    testWidgets('updateShouldNotify returns false for same themes', (tester) async {
      final theme = StorybookTheme.defaults();

      final scope1 = StorybookThemeScope(
        theme: theme,
        child: const SizedBox(),
      );

      final scope2 = StorybookThemeScope(
        theme: theme,
        child: const SizedBox(),
      );

      expect(scope1.updateShouldNotify(scope2), isFalse);
    });
  });
}
