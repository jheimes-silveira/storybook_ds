import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/custom_card_storybook.dart';

void main() {
  testWidgets('CustomCardStorybook monta sem exceção', (tester) async {
    final errors = <Object>[];

    FlutterError.onError = (details) {
      errors.add(details.exception);
    };

    await tester.pumpWidget(
      MaterialApp(
        home: CustomCardStorybook(onThemeChanged: (_) {}),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 300));

    if (errors.isNotEmpty) {
      // Imprime stack trace completo do primeiro erro para diagnóstico.
      // ignore: avoid_print
      print('FIRST ERROR: ${errors.first}');
    }
    expect(errors, isEmpty, reason: 'Nenhum erro esperado no build inicial.');
  });
}
