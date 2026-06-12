import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/storybook_ds.dart';

import 'package:storybook_ds/src/widgets/attributes_variant/strategies/function_attribute_editor.dart';

import 'helpers/test_helpers.dart';

void main() {
  setUpAll(() {
    registerStandardAttributeStrategies(AttributeEditorRegistry.instance);
  });

  group('FunctionAttributeEditor (handles)', () {
    test('handles returns true for FunctionType', () {
      final attr = AttributeModel.function(
        name: 'onTap',
        function: () {},
      );
      expect(attr.variableOptionType, isA<FunctionType>());
      expect(const FunctionAttributeEditor().handles(attr), isTrue);
    });

    test('handles returns false for non-FunctionType', () {
      final attr = AttributeModel(
        type: 'String',
        name: 'label',
        selectedValue: VariableOption(value: 'x'),
      );
      expect(const FunctionAttributeEditor().handles(attr), isFalse);
    });

    test('handles returns false for Function* type-string with wrong variableOptionType', () {
      // Cria um DTO "malformado" com type="Function" mas variableOptionType=DefaultType.
      final attr = AttributeModel(
        type: 'Function',
        name: 'broken',
      );
      expect(attr.variableOptionType, isA<DefaultType>());
      expect(const FunctionAttributeEditor().handles(attr), isFalse);
    });
  });

  group('AttributeModel.function factory', () {
    test('creates instance with FunctionType', () {
      final attr = AttributeModel.function(
        name: 'onTap',
        function: () {},
      );
      expect(attr.type, 'Function');
      expect(attr.name, 'onTap');
      expect(attr.variableOptionType, isA<FunctionType>());
    });

    test('accepts scenarios list', () {
      final attr = AttributeModel.function(
        name: 'onTap',
        function: () {},
        scenarios: const [
          FunctionCallbackScenario(label: 'Tap rápido'),
          FunctionCallbackScenario(
            label: 'Tap duplo',
            args: [42],
          ),
        ],
      );
      final type = attr.variableOptionType as FunctionType;
      expect(type.scenarios.length, 2);
      expect(type.scenarios[0].label, 'Tap rápido');
      expect(type.scenarios[1].args, [42]);
    });

    test('default scenarios is empty', () {
      final attr = AttributeModel.function(name: 'cb', function: () {});
      final type = attr.variableOptionType as FunctionType;
      expect(type.scenarios, isEmpty);
    });

    test('canBeNull produces Function? type', () {
      final attr = AttributeModel.function(
        name: 'onTap',
        function: null,
        canBeNull: true,
      );
      expect(attr.type, 'Function?');
    });
  });

  group('ItemAttributeFunction widget', () {
    testWidgets('renders header with name and type for VoidCallback',
        (tester) async {
      final attr = AttributeModel.function(
        name: 'onTap',
        function: () {},
      );
      await pumpTestStorybookInTheme(tester, attributes: [attr]);

      // "onTap" aparece duas vezes: no título do AttributeVariant e
      // no header do ItemAttributeFunction.
      expect(find.text('onTap'), findsNWidgets(2));
      // Type "Function" aparece ao menos uma vez (no header do editor).
      expect(find.textContaining('Function'), findsWidgets);
      // Ícone de funções presente.
      expect(find.byIcon(Icons.functions), findsOneWidget);
    });

    testWidgets('does NOT show "Tipo inválido" anymore', (tester) async {
      final attr = AttributeModel.function(name: 'onTap', function: () {});
      await pumpTestStorybookInTheme(tester, attributes: [attr]);
      expect(find.textContaining('Tipo inválido'), findsNothing);
    });

    testWidgets('shows "Não disparar" chip and scenario chips',
        (tester) async {
      final attr = AttributeModel.function(
        name: 'onTap',
        function: () {},
        scenarios: const [
          FunctionCallbackScenario(label: 'Tap rápido'),
          FunctionCallbackScenario(
            label: 'Submit texto',
            args: ['hello'],
          ),
        ],
      );
      await pumpTestStorybookInTheme(tester, attributes: [attr]);

      expect(find.text('Não disparar'), findsOneWidget);
      expect(find.text('Tap rápido'), findsOneWidget);
      expect(find.text('Submit texto'), findsOneWidget);
    });

    testWidgets('selecting a scenario enables the dispatch button',
        (tester) async {
      final attr = AttributeModel.function(
        name: 'onTap',
        function: () {},
        scenarios: const [
          FunctionCallbackScenario(label: 'Tap rápido'),
        ],
      );
      await pumpTestStorybookInTheme(tester, attributes: [attr]);

      // Estado inicial: nenhum cenário selecionado + scenarios não-vazio
      // → botão desabilitado.
      const buttonFinder = ValueKey('function-dispatch-onTap');
      expect(find.byKey(buttonFinder), findsOneWidget);
      final buttonWidget = tester.widget<ElevatedButton>(find.byKey(buttonFinder));
      expect(buttonWidget.onPressed, isNull);

      // Seleciona "Tap rápido".
      await tester.tap(find.text('Tap rápido'));
      await tester.pumpAndSettle();

      final updated = tester.widget<ElevatedButton>(find.byKey(buttonFinder));
      expect(updated.onPressed, isNotNull);
    });

    testWidgets('dispatching a VoidCallback scenario invokes the function',
        (tester) async {
      var invoked = 0;
      final attr = AttributeModel.function(
        name: 'onTap',
        function: () => invoked++,
        scenarios: const [
          FunctionCallbackScenario(label: 'Tap rápido'),
        ],
      );
      await pumpTestStorybookInTheme(tester, attributes: [attr]);

      await tester.tap(find.text('Tap rápido'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('function-dispatch-onTap')));
      await tester.pumpAndSettle();

      expect(invoked, 1);
      // Histórico aparece.
      expect(find.text('Histórico'), findsOneWidget);
    });

    testWidgets('dispatching a Function(int) scenario passes the int arg',
        (tester) async {
      int? captured;
      final attr = AttributeModel.function(
        name: 'onChange',
        function: (int v) => captured = v,
        scenarios: const [
          FunctionCallbackScenario(label: 'Set to 42', args: [42]),
        ],
      );
      await pumpTestStorybookInTheme(tester, attributes: [attr]);

      await tester.tap(find.text('Set to 42'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('function-dispatch-onChange')));
      await tester.pumpAndSettle();

      expect(captured, 42);
    });

    testWidgets('dispatching with wrong args records an error in history',
        (tester) async {
      final attr = AttributeModel.function(
        name: 'onChange',
        function: (int v) {},
        scenarios: const [
          // Passa uma String onde se espera int — deve capturar erro.
          FunctionCallbackScenario(label: 'Bad', args: ['not an int']),
        ],
      );
      await pumpTestStorybookInTheme(tester, attributes: [attr]);

      await tester.tap(find.text('Bad'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('function-dispatch-onChange')));
      await tester.pumpAndSettle();

      // O histórico mostra "ERR ..." para o erro capturado.
      expect(find.textContaining('ERR'), findsOneWidget);
    });

    testWidgets(
        'Function with no scenarios allows direct dispatch (nullary)',
        (tester) async {
      var invoked = 0;
      final attr = AttributeModel.function(
        name: 'onReady',
        function: () => invoked++,
      );
      await pumpTestStorybookInTheme(tester, attributes: [attr]);

      // Botão habilitado (cenários vazios = sem args necessários).
      final button = tester.widget<ElevatedButton>(
        find.byKey(const ValueKey('function-dispatch-onReady')),
      );
      expect(button.onPressed, isNotNull);

      await tester.tap(find.byKey(const ValueKey('function-dispatch-onReady')));
      await tester.pumpAndSettle();
      expect(invoked, 1);
    });

    testWidgets('Function with scenarios but none selected disables button',
        (tester) async {
      final attr = AttributeModel.function(
        name: 'onSubmit',
        function: (String s) {},
        scenarios: const [
          FunctionCallbackScenario(label: 'Submit texto', args: ['hi']),
        ],
      );
      await pumpTestStorybookInTheme(tester, attributes: [attr]);

      final button = tester.widget<ElevatedButton>(
        find.byKey(const ValueKey('function-dispatch-onSubmit')),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('history keeps at most 3 entries', (tester) async {
      var invoked = 0;
      final attr = AttributeModel.function(
        name: 'onTap',
        function: () => invoked++,
        scenarios: const [FunctionCallbackScenario(label: 'Tap')],
      );
      await pumpTestStorybookInTheme(tester, attributes: [attr]);

      await tester.tap(find.text('Tap'));
      await tester.pumpAndSettle();
      final dispatch = find.byKey(const ValueKey('function-dispatch-onTap'));
      for (var i = 0; i < 5; i++) {
        await tester.tap(dispatch);
        await tester.pumpAndSettle();
      }
      expect(invoked, 5);
      // Cada linha do histórico começa com `[HH:MM:SS]` — contamos
      // os `Text` que correspondem ao pattern (3 máx).
      final historyLines = find.byWidgetPredicate(
        (w) =>
            w is Text &&
            w.data != null &&
            RegExp(r'^\[\d{2}:\d{2}:\d{2}\]').hasMatch(w.data!),
      );
      expect(historyLines.evaluate().length, lessThanOrEqualTo(3));
    });
  });
}
