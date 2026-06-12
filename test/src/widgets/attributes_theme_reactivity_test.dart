import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:storybook_ds/src/models/multiple_theme_settings.dart';
import 'package:storybook_ds/src/models/theme_settings.dart';
import 'package:storybook_ds/src/widgets/attributes_theme_widget.dart';
import 'package:storybook_ds/src/widgets/custom_chip_selected.dart';

/// Regressão: o `AttributesThemeWidget` é um `StatefulWidget` e o seu
/// `_handleThemeSelection` / `_handleThemeModeChange` mutam o
/// `themeSettings` in-place e chamam `onUpdateTheme`, mas não chamam
/// `setState`. Isso significa que o `build` não é re-executado e os
/// chips de tema (light/dark) não atualizam o estado "selecionado" no
/// painel lateral após o tap.
///
/// Esperado: o chip clicado fica visualmente selecionado após o tap
/// (i.e., o widget reconstrói e o `selected` do chip é recalculado).
void main() {
  testWidgets(
    'AttributesThemeWidget rebuilda e destaca o chip selecionado após o tap',
    (tester) async {
      final themeA = ThemeSettings(title: 'A', light: ThemeData.light());
      final themeB = ThemeSettings(title: 'B', light: ThemeData.light());
      final themeSettings = MultipleThemeSettings(
        selectableThemes: [themeA, themeB],
      );
      final updates = <MultipleThemeSettings>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AttributesThemeWidget(
              themeSettings: themeSettings,
              onUpdateTheme: updates.add,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Expande o ExpansionTile para expor os chips.
      await tester.tap(find.text(themeA.title));
      await tester.pumpAndSettle();

      // Encontra o chip "B" e clica.
      final chipB = find.text('B');
      expect(chipB, findsOneWidget);
      await tester.tap(chipB);
      await tester.pumpAndSettle();

      // O widget pai do chip "B" deve estar marcado como selecionado.
      final chipBWidget = tester.widget<CustomChipSelected>(
        find.ancestor(of: chipB, matching: find.byType(CustomChipSelected)),
      );
      expect(
        chipBWidget.selected,
        isTrue,
        reason:
            'Após o tap, o chip "B" deve estar visualmente selecionado. '
            'Se isto falhar, o AttributesThemeWidget não está chamando '
            'setState após a mudança do tema selecionado.',
      );

      // O callback também deve ter sido disparado com o tema B.
      expect(updates, isNotEmpty);
      expect(updates.last.selectedThemes.title, 'B');
    },
  );

  testWidgets(
    'AttributesThemeWidget rebuilda e destaca o chip light/dark após o tap',
    (tester) async {
      final themeA = ThemeSettings(
        title: 'A',
        light: ThemeData.light(),
        dark: ThemeData.dark(),
      );
      final themeSettings = MultipleThemeSettings(
        selectableThemes: [themeA],
      );
      final updates = <MultipleThemeSettings>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AttributesThemeWidget(
              themeSettings: themeSettings,
              onUpdateTheme: updates.add,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final darkChip = find.text('dark');
      expect(darkChip, findsOneWidget);
      await tester.tap(darkChip);
      await tester.pumpAndSettle();

      final darkChipWidget = tester.widget<CustomChipSelected>(
        find.ancestor(of: darkChip, matching: find.byType(CustomChipSelected)),
      );
      expect(
        darkChipWidget.selected,
        isTrue,
        reason:
            'Após o tap em "dark", o chip "dark" deve estar selecionado.',
      );
      expect(updates.last.selectedThemes.isDarkMode, isTrue);
    },
  );
}
