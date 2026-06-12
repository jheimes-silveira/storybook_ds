import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/storybook_ds.dart';

import '../test_storybook_widget.dart';

/// Helper para montar um [TestStorybook] em testes de reatividade.
///
/// Retorna o state do Storybook para que o teste possa acessar a lista
/// de atributos (e.g., para verificar mudanças programáticas).
Future<TestStorybookState> pumpTestStorybook(
  WidgetTester tester, {
  required List<AttributeModel> attributes,
}) async {
  late TestStorybookState capturedState;
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestStorybook(
        attributes: attributes,
        onStateReady: (state) => capturedState = state,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return capturedState;
}

/// Helper variante: monta o [TestStorybook] dentro de um
/// [StorybookThemeScope] com o [theme] fornecido. Útil para testes de
/// editor de atributo que precisam ler o tema via
/// `StorybookThemeScope.of(context)`.
Future<TestStorybookState> pumpTestStorybookInTheme(
  WidgetTester tester, {
  required List<AttributeModel> attributes,
  StorybookTheme? theme,
}) async {
  late TestStorybookState capturedState;
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StorybookThemeScope(
        theme: theme ?? StorybookTheme.defaults(),
        child: TestStorybook(
          attributes: attributes,
          onStateReady: (state) => capturedState = state,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return capturedState;
}
