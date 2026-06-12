// Reproduz o crash do exemplo ao expandir o atributo "String title *"
// criado por `factoryAttributeDtoString`. O test_helpers inicia expandido,
// então aqui usamos o widget real com `initiallyExpanded: false` (default).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/attribute_variant.dart';
import 'package:storybook_ds/storybook_ds.dart';

void main() {
  setUp(() {
    registerStandardAttributeStrategies(AttributeEditorRegistry.instance);
  });

  testWidgets(
    'Reproduz: expandir AttributeVariant a partir do estado contraído, '
    'alterar valor e ver device preview refletir',
    (tester) async {
      final titleAttr = StorybookAttributeFactories.factoryAttributeDtoString(
        name: 'title',
        selectedValue: 'Lorem justo clita tempor labore',
        required: true,
      );

      final bus = AttributeChangeBus();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _ReproHarness(
              titleAttr: titleAttr,
              bus: bus,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Confirma render inicial
      expect(find.text('title'), findsOneWidget);

      // Expande o tile
      await tester.tap(find.text('title'));
      await tester.pumpAndSettle();

      // Após expandir, o TextField deve aparecer
      expect(find.byType(TextField), findsOneWidget);

      // Confirma que o device preview mostra o valor inicial
      expect(
        find.text('device-title=Lorem justo clita tempor labore'),
        findsOneWidget,
      );

      // Digita novo valor
      await tester.enterText(find.byType(TextField).first, 'Atualizado');
      await tester.pumpAndSettle();

      // O device preview deve refletir o novo valor
      expect(find.text('device-title=Atualizado'), findsOneWidget);
      expect(
        find.text('device-title=Lorem justo clita tempor labore'),
        findsNothing,
      );

      // Toca numa chip de opção para garantir que também reflete
      await tester.tap(find.text('10 palavras'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'device-title=Justo elitr sed accusam accusam diam stet, diam est elitr',
        ),
        findsOneWidget,
      );
    },
  );
}

class _ReproHarness extends StatefulWidget {
  const _ReproHarness({required this.titleAttr, required this.bus});

  final AttributeModel titleAttr;
  final AttributeChangeBus bus;

  @override
  State<_ReproHarness> createState() => _ReproHarnessState();
}

class _ReproHarnessState extends State<_ReproHarness> {
  @override
  Widget build(BuildContext context) {
    final value = widget.titleAttr.selectedValue?.value;
    return Column(
      children: [
        // "Device preview" simplificado.
        Text('device-title=$value'),
        Expanded(
          child: SingleChildScrollView(
            child: AttributeVariant(
              attribute: widget.titleAttr,
              attributes: [widget.titleAttr],
              onAttributes: (attrs, attr) {
                widget.bus.notifyChanged(attrs, attr);
                setState(() {});
              },
              changeBus: widget.bus,
            ),
          ),
        ),
      ],
    );
  }
}


