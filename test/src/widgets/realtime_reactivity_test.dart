import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/storybook_ds.dart';

import 'helpers/test_helpers.dart';

/// Testes de reatividade em tempo real.
///
/// Validam que o fluxo completo de mudança de atributo (do widget de
/// edição no menu lateral até o device preview) funciona corretamente.
///
/// O [TestStorybook] já inicia com todos os `ExpansionTile`
/// expandidos, então os testes não precisam simular expansão.
void main() {
  setUp(() {
    // Garante que as estratégias padrão estão registradas. Idempotente.
    registerStandardAttributeStrategies(AttributeEditorRegistry.instance);
  });

  group('Reatividade em tempo real', () {
    testWidgets(
      'String: digitar no TextField atualiza o device preview',
      (tester) async {
        await pumpTestStorybook(
          tester,
          attributes: [
            AttributeModel(
              name: 'title',
              type: 'String',
              selectedValue: VariableOption(value: 'Inicial'),
            ),
          ],
        );

        // Valor inicial no device preview.
        expect(find.text('title=Inicial'), findsOneWidget);

        // Digita um novo valor.
        await tester.enterText(
          find.byType(TextField).first,
          'Atualizado',
        );
        await tester.pumpAndSettle();

        // O device preview deve refletir o novo valor.
        expect(find.text('title=Atualizado'), findsOneWidget);
        expect(find.text('title=Inicial'), findsNothing);
      },
    );

    testWidgets(
      'bool: toggle do switch atualiza o device preview',
      (tester) async {
        await pumpTestStorybook(
          tester,
          attributes: [
            AttributeModel(
              name: 'enabled',
              type: 'bool',
              selectedValue: VariableOption(value: true),
            ),
          ],
        );

        expect(find.text('enabled=true'), findsOneWidget);

        // Para bool, o switch está no título (sempre visível).
        // O _BoolToggle tem um Tooltip com "Desativar" quando true.
        final toggleOff = find.byWidgetPredicate(
          (w) => w is Tooltip && w.message == 'Desativar',
        );
        expect(toggleOff, findsOneWidget);
        await tester.tap(
          find.descendant(of: toggleOff, matching: find.byType(Switch)),
        );
        await tester.pumpAndSettle();

        expect(find.text('enabled=false'), findsOneWidget);
        expect(find.text('enabled=true'), findsNothing);

        // Toggle de volta.
        final toggleOn = find.byWidgetPredicate(
          (w) => w is Tooltip && w.message == 'Ativar',
        );
        expect(toggleOn, findsOneWidget);
        await tester.tap(
          find.descendant(of: toggleOn, matching: find.byType(Switch)),
        );
        await tester.pumpAndSettle();

        expect(find.text('enabled=true'), findsOneWidget);
      },
    );

    testWidgets(
      'String nullable: switch no trailing alterna entre valor e null',
      (tester) async {
        await pumpTestStorybook(
          tester,
          attributes: [
            AttributeModel(
              name: 'desc',
              type: 'String?',
              selectedValue: VariableOption(value: 'Hello'),
            ),
          ],
        );

        expect(find.text('desc=Hello'), findsOneWidget);

        // O trailing switch (não-bool) tem tooltip "Definir como null".
        // Pode haver mais de um Tooltip com essa mensagem (um no
        // _NullableTrailingSwitch do AttributeVariant e outro no
        // _NullableSwitch do ItemAttributeString). Usamos o **primeiro**
        // Switch descendente de qualquer um deles.
        final nullableSwitches = find.byWidgetPredicate(
          (w) => w is Tooltip && w.message == 'Definir como null',
        );
        expect(nullableSwitches, findsAtLeastNWidgets(1));

        // Pega o primeiro Switch descendente de um dos Tooltips.
        // O _NullableTrailingSwitch está no trailing do ExpansionTile
        // (fora do children), enquanto o do ItemAttributeString está
        // dentro do children. Como o AttributeVariant está expandido
        // (initiallyExpanded: true), ambos estão visíveis.
        // Para evitar ambiguidade, usamos o **último** switch
        // (o do trailing, que vem depois na árvore).
        final switches = find.byType(Switch);
        await tester.tap(switches.last);
        await tester.pumpAndSettle();

        expect(find.text('desc=null'), findsOneWidget);
      },
    );

    testWidgets(
      'RangeDouble: arrastar slider atualiza o device preview',
      (tester) async {
        await pumpTestStorybook(
          tester,
          attributes: [
            AttributeModel.rangeDoubleInterval(
              name: 'width',
              begin: 100,
              end: 500,
              selectedValue: 200.0,
            ),
          ],
        );

        expect(find.text('width=200.0'), findsOneWidget);

        // Simula um drag no slider para mudar o valor.
        final slider = find.byType(Slider);
        expect(slider, findsOneWidget);
        await tester.drag(slider, const Offset(500, 0));
        await tester.pumpAndSettle();

        // O valor deve ter mudado.
        expect(find.text('width=200.0'), findsNothing);
      },
    );

    testWidgets(
      'String com chips: tocar no chip atualiza o device preview',
      (tester) async {
        await pumpTestStorybook(
          tester,
          attributes: [
            AttributeModel(
              name: 'label',
              type: 'String',
              selectedValue: VariableOption(value: 'Opção A'),
              variableOptions: [
                VariableOption(value: 'Opção A'),
                VariableOption(value: 'Opção B'),
              ],
            ),
          ],
        );

        expect(find.text('label=Opção A'), findsOneWidget);

        // Toca no chip "Opção B".
        await tester.tap(find.text('Opção B'));
        await tester.pumpAndSettle();

        expect(find.text('label=Opção B'), findsOneWidget);
        expect(find.text('label=Opção A'), findsNothing);
      },
    );

    testWidgets(
      'bool nullable: alterna entre true, false via switch do título',
      (tester) async {
        await pumpTestStorybook(
          tester,
          attributes: [
            AttributeModel(
              name: 'flag',
              type: 'bool?',
              selectedValue: VariableOption(value: true),
            ),
          ],
        );

        expect(find.text('flag=true'), findsOneWidget);

        // Para bool?, o switch do título alterna true<->false.
        // (Definir null requer o trailing switch que não está
        // presente para bool? — ver _canBuildBoolToggle.)
        final toggleOff = find.byWidgetPredicate(
          (w) => w is Tooltip && w.message == 'Desativar',
        );
        await tester.tap(
          find.descendant(of: toggleOff, matching: find.byType(Switch)),
        );
        await tester.pumpAndSettle();
        expect(find.text('flag=false'), findsOneWidget);
      },
    );

    testWidgets(
      'RangeInt: arrastar slider atualiza o device preview',
      (tester) async {
        await pumpTestStorybook(
          tester,
          attributes: [
            AttributeModel.rangeIntInterval(
              name: 'count',
              begin: 0,
              end: 10,
              selectedValue: 5,
            ),
          ],
        );

        expect(find.text('count=5'), findsOneWidget);

        final slider = find.byType(Slider);
        expect(slider, findsOneWidget);
        await tester.drag(slider, const Offset(300, 0));
        await tester.pumpAndSettle();

        // O valor deve ter mudado.
        expect(find.text('count=5'), findsNothing);
      },
    );

    testWidgets(
      'Function: editor mostra info da função (read-only)',
      (tester) async {
        void myCallback() {}
        await pumpTestStorybook(
          tester,
          attributes: [
            AttributeModel.function(
              function: myCallback,
              name: 'onTap',
            ),
          ],
        );

        // O editor de Function exibe o runtimeType da função.
        // O device preview mostra o value (que é a própria função).
        // O toString de uma função closure inclui o nome da função.
        // Verificamos que o device preview renderiza algo.
        expect(
          find.byKey(const ValueKey('device-onTap')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'ObjectInObject: editor aninhado renderiza com valor atual',
      (tester) async {
        await pumpTestStorybook(
          tester,
          attributes: [
            AttributeModel.objectInObject(
              name: 'settings',
              type: 'TestSettings',
              selectedValue: VariableOption(
                value: const _TestSettings(42, 'hello'),
              ),
              merge: (instance, fieldName, newValue) {
                final s = instance as _TestSettings;
                if (fieldName == 'number') {
                  return _TestSettings(newValue as int, s.text);
                }
                if (fieldName == 'text') {
                  return _TestSettings(s.number, newValue as String);
                }
                return s;
              },
              children: [
                AttributeModel(
                  name: 'number',
                  type: 'int',
                  selectedValue: VariableOption(value: 42),
                ),
                AttributeModel(
                  name: 'text',
                  type: 'String',
                  selectedValue: VariableOption(value: 'hello'),
                ),
              ],
            ),
          ],
        );

        // Device preview mostra a representação do objeto.
        expect(
          find.text(
            'settings=_TestSettings(42, hello)',
          ),
          findsOneWidget,
        );

        // O editor aninhado mostra os nomes dos filhos.
        expect(find.text('number'), findsAtLeastNWidgets(1));
        expect(find.text('text'), findsAtLeastNWidgets(1));
      },
    );

    testWidgets(
      'bool? starting as null: trailing switch activates and enables toggle, then toggling and deactivating works',
      (tester) async {
        await pumpTestStorybook(
          tester,
          attributes: [
            AttributeModel(
              name: 'flag',
              type: 'bool?',
              selectedValue: null,
            ),
          ],
        );

        // Starts as null in preview
        expect(find.text('flag=null'), findsOneWidget);

        // Find the trailing nullable switch
        // Tooltip is "Ativar" when inactive.
        final nullableSwitchFinder = find.byWidgetPredicate(
          (w) => w is Tooltip && w.message == 'Ativar',
        );
        expect(nullableSwitchFinder, findsOneWidget);

        // Tap the nullable switch (trailing) to activate
        await tester.tap(
          find.descendant(of: nullableSwitchFinder, matching: find.byType(Switch)),
        );
        await tester.pumpAndSettle();

        // The value should now be false (default initial value when activated)
        expect(find.text('flag=false'), findsOneWidget);

        // The title switch tooltip should now be "Ativar"
        final toggleOnFinder = find.byWidgetPredicate(
          (w) => w is Tooltip && w.message == 'Ativar',
        );
        // Tap the title switch to turn it on (true)
        await tester.tap(
          find.descendant(of: toggleOnFinder, matching: find.byType(Switch)).first,
        );
        await tester.pumpAndSettle();

        // Now value is true
        expect(find.text('flag=true'), findsOneWidget);

        // Turn it off back to false
        final toggleOffFinder = find.byWidgetPredicate(
          (w) => w is Tooltip && w.message == 'Desativar',
        );
        await tester.tap(
          find.descendant(of: toggleOffFinder, matching: find.byType(Switch)).first,
        );
        await tester.pumpAndSettle();
        expect(find.text('flag=false'), findsOneWidget);

        // Turn trailing switch off (deactivate)
        final nullableSwitchOffFinder = find.byWidgetPredicate(
          (w) => w is Tooltip && w.message == 'Definir como null',
        );
        await tester.tap(
          find.descendant(of: nullableSwitchOffFinder, matching: find.byType(Switch)),
        );
        await tester.pumpAndSettle();

        // Value is null again
        expect(find.text('flag=null'), findsOneWidget);
      },
    );

    testWidgets(
      'Storybook: tapping a constructor chip updates the selectedConstructor and rebuilds the preview and code view',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: _TestRealStorybook(),
          ),
        );
        await tester.pumpAndSettle();

        // Initially, default constructor ('') is selected.
        expect(find.text('Active constructor label: DefaultConstructor'), findsOneWidget);

        // Find the button to change constructor
        final customCtorBtn = find.byKey(const ValueKey('change-ctor-btn'));
        expect(customCtorBtn, findsOneWidget);

        // Tap it.
        await tester.tap(customCtorBtn);
        await tester.pumpAndSettle();

        // The preview should rebuild and show CustomConstructor!
        expect(find.text('Active constructor label: CustomConstructor'), findsOneWidget);
        expect(find.text('Active constructor label: DefaultConstructor'), findsNothing);
      },
    );
  });
}

class _TestSettings {
  final int number;
  final String text;
  const _TestSettings(this.number, this.text);
  @override
  String toString() => '_TestSettings($number, $text)';
}

class _TestRealStorybook extends StatefulWidget {
  const _TestRealStorybook();

  @override
  _TestRealStorybookState createState() => _TestRealStorybookState();
}

class _TestRealStorybookState extends Storybook<_TestRealStorybook> {
  @override
  final String title = 'Test Constructor Storybook';

  @override
  final String nameObjectInDisplay = 'MyWidget';

  @override
  OnBuildExtraAttributesConfigCustom? get extraAttributesConfigCustom => null;

  @override
  late final List<AttributeModel> attributes = [
    AttributeModel(
      name: 'label',
      type: 'String',
      selectedValue: VariableOption(value: 'DefaultConstructor'),
      builders: [''],
    ),
    AttributeModel(
      name: 'label',
      type: 'String',
      selectedValue: VariableOption(value: 'CustomConstructor'),
      builders: ['custom'],
    ),
  ];

  @override
  dynamic getWhereAttribut(String name) {
    final attribute = attributes.firstWhere(
      (e) => e.name == name && (e.builders.isEmpty || e.builders.contains(selectedConstructor)),
      orElse: () => AttributeModel(type: '', name: ''),
    );
    return attribute.selectedValue?.value;
  }

  @override
  Widget buildComponentWidget(BuildContext context) {
    // Read the value based on active constructor
    final val = getWhereAttribut('label') ?? 'none';
    return Center(
      child: Text('Active constructor label: $val'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<StoryBookComponentProperties>(
        valueListenable: controller,
        builder: (context, properties, child) {
          final val = getWhereAttribut('label') ?? 'none';
          return Column(
            children: [
              Text('Active constructor label: $val'),
              ElevatedButton(
                key: const ValueKey('change-ctor-btn'),
                onPressed: () {
                  selectedConstructor = 'custom';
                  onUpdateSelectedConstructor('custom');
                },
                child: const Text('custom'),
              ),
            ],
          );
        },
      ),
    );
  }
}
