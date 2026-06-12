import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/widgets/custom_chip_selected.dart';
import 'package:storybook_ds/src/theme/storybook_theme.dart';
import 'package:storybook_ds/src/theme/storybook_theme_scope.dart';

void main() {
  group('CustomChipSelected', () {
    testWidgets('displays label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StorybookThemeScope(
            theme: StorybookTheme.defaults(),
            child: Scaffold(
              body: CustomChipSelected(
                label: 'Test Chip',
                selected: false,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Chip'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StorybookThemeScope(
            theme: StorybookTheme.defaults(),
            child: Scaffold(
              body: CustomChipSelected(
                label: 'Test Chip',
                selected: false,
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomChipSelected));
      expect(tapped, true);
    });

    testWidgets('shows check icon when selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StorybookThemeScope(
            theme: StorybookTheme.defaults(),
            child: Scaffold(
              body: CustomChipSelected(
                label: 'Selected Chip',
                selected: true,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('does not show check icon when not selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StorybookThemeScope(
            theme: StorybookTheme.defaults(),
            child: Scaffold(
              body: CustomChipSelected(
                label: 'Unselected Chip',
                selected: false,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('shows leading icon when provided and selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StorybookThemeScope(
            theme: StorybookTheme.defaults(),
            child: Scaffold(
              body: CustomChipSelected(
                label: 'Leading Chip',
                selected: true,
                onTap: () {},
                leadingIcon: Icons.star,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('shows leading icon when provided and not selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StorybookThemeScope(
            theme: StorybookTheme.defaults(),
            child: Scaffold(
              body: CustomChipSelected(
                label: 'Leading Chip',
                selected: false,
                onTap: () {},
                leadingIcon: Icons.star,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('uses custom border radius', (tester) async {
      const customRadius = BorderRadius.all(Radius.circular(16));

      await tester.pumpWidget(
        MaterialApp(
          home: StorybookThemeScope(
            theme: StorybookTheme.defaults(),
            child: Scaffold(
              body: CustomChipSelected(
                label: 'Custom Radius',
                selected: false,
                onTap: () {},
                borderRadius: customRadius,
              ),
            ),
          ),
        ),
      );

      final chip = tester.widget<Chip>(find.byType(Chip));
      expect(chip.shape, isA<RoundedRectangleBorder>());
    });

    testWidgets('uses custom border color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StorybookThemeScope(
            theme: StorybookTheme.defaults(),
            child: Scaffold(
              body: CustomChipSelected(
                label: 'Custom Color',
                selected: false,
                onTap: () {},
                borderColor: Colors.red,
              ),
            ),
          ),
        ),
      );

      final chip = tester.widget<Chip>(find.byType(Chip));
      final shape = chip.shape as RoundedRectangleBorder;
      expect(shape.side.color, Colors.red);
    });

    testWidgets('uses custom background colors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StorybookThemeScope(
            theme: StorybookTheme.defaults(),
            child: Scaffold(
              body: CustomChipSelected(
                label: 'Custom Bg',
                selected: true,
                onTap: () {},
                selectedBackgroundColor: Colors.blue,
                unselectedBackgroundColor: Colors.grey,
              ),
            ),
          ),
        ),
      );

      final chip = tester.widget<Chip>(find.byType(Chip));
      expect(chip.backgroundColor, Colors.blue);
    });
  });
}
