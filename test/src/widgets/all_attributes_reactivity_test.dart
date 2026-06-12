// Garante que cada TIPO de editor de atributo, ao expandir o tile
// (estado contraído, idêntico ao do exemplo) e editar o valor, reflete
// a mudança no "device preview". O bug original crashava ao expandir
// o tile de "String title *" com `type 'bool' is not a subtype of
// type 'double?' in type cast` em `ScrollPosition.restoreScrollOffset`.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/attribute_variant.dart';
import 'package:storybook_ds/storybook_ds.dart';

void main() {
  setUp(() {
    registerStandardAttributeStrategies(AttributeEditorRegistry.instance);
  });

  // Cada teste monta um painel com UM atributo do tipo correspondente
  // e verifica o ciclo: render inicial -> expande -> edita -> device
  // preview reflete.

  Future<void> pumpOne(
    WidgetTester tester, {
    required List<AttributeModel> attributes,
    required AttributeChangeBus bus,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: _Harness(attributes: attributes, bus: bus),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('String com chips: expandir não crasha e reatividade funciona', (tester) async {
    final bus = AttributeChangeBus();
    final attr = StorybookAttributeFactories.factoryAttributeDtoString(
      name: 'title',
      selectedValue: 'Inicial',
      required: true,
    );
    await pumpOne(tester, attributes: [attr], bus: bus);

    // Expande o tile (estado contraído).
    await tester.tap(find.text('title'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);

    // Edita o texto.
    await tester.enterText(find.byType(TextField).first, 'Novo');
    await tester.pumpAndSettle();
    expect(find.text('device-title=Novo'), findsOneWidget);
    expect(find.text('device-title=Inicial'), findsNothing);

    // Toca numa chip de opção.
    await tester.tap(find.text('5 palavras'));
    await tester.pumpAndSettle();
    expect(
      find.text('device-title=Sadipscing gubergren ea eos stet'),
      findsOneWidget,
    );
  });

  testWidgets('bool: expandir não crasha e toggle reflete no device', (tester) async {
    final bus = AttributeChangeBus();
    final attr = AttributeModel(
      name: 'hidden',
      type: 'bool',
      selectedValue: VariableOption(value: false),
    );
    await pumpOne(tester, attributes: [attr], bus: bus);

    await tester.tap(find.text('hidden'));
    await tester.pumpAndSettle();
    expect(find.text('device-hidden=false'), findsOneWidget);

    // Toca no switch (no _BoolToggle do título).
    final switchFinder = find
        .descendant(
          of: find.ancestor(
            of: find.text('hidden'),
            matching: find.byType(AttributeVariant),
          ),
          matching: find.byType(Switch),
        )
        .first;
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();
    expect(find.text('device-hidden=true'), findsOneWidget);
  });

  testWidgets('bool nullable: trailing switch null<->false<->true', (tester) async {
    final bus = AttributeChangeBus();
    final attr = AttributeModel(
      name: 'flag',
      type: 'bool?',
      selectedValue: null,
    );
    await pumpOne(tester, attributes: [attr], bus: bus);
    expect(find.text('device-flag=null'), findsOneWidget);

    // Expande
    await tester.tap(find.text('flag'));
    await tester.pumpAndSettle();

    // Ativa via trailing switch
    final trailing = find
        .descendant(
          of: find.ancestor(
            of: find.text('flag'),
            matching: find.byType(AttributeVariant),
          ),
          matching: find.byType(Switch),
        )
        .last;
    await tester.tap(trailing);
    await tester.pumpAndSettle();
    expect(find.text('device-flag=false'), findsOneWidget);

    // Toca no switch do título (agora _BoolToggle) para virar true.
    final titleSwitch = find
        .descendant(
          of: find.ancestor(
            of: find.text('flag'),
            matching: find.byType(AttributeVariant),
          ),
          matching: find.byType(Switch),
        )
        .first;
    await tester.tap(titleSwitch);
    await tester.pumpAndSettle();
    expect(find.text('device-flag=true'), findsOneWidget);

    // Desativa via trailing (vira null).
    final trailing2 = find
        .descendant(
          of: find.ancestor(
            of: find.text('flag'),
            matching: find.byType(AttributeVariant),
          ),
          matching: find.byType(Switch),
        )
        .last;
    await tester.tap(trailing2);
    await tester.pumpAndSettle();
    expect(find.text('device-flag=null'), findsOneWidget);
  });

  testWidgets('String nullable: trailing switch null<->valor', (tester) async {
    final bus = AttributeChangeBus();
    final attr = AttributeModel(
      name: 'description',
      type: 'String?',
      selectedValue: VariableOption(value: 'Hello'),
    );
    await pumpOne(tester, attributes: [attr], bus: bus);
    expect(find.text('device-description=Hello'), findsOneWidget);

    await tester.tap(find.text('description'));
    await tester.pumpAndSettle();

    // Trailing switch -> null
    final trailing = find
        .descendant(
          of: find.ancestor(
            of: find.text('description'),
            matching: find.byType(AttributeVariant),
          ),
          matching: find.byType(Switch),
        )
        .last;
    await tester.tap(trailing);
    await tester.pumpAndSettle();
    expect(find.text('device-description=null'), findsOneWidget);
  });

  testWidgets('Enum: expandir não crasha e seleção de chip reflete', (tester) async {
    final bus = AttributeChangeBus();
    final attr = AttributeModel.enumType(
      name: 'variant',
      selectedValue: _SampleEnum.a,
      values: _SampleEnum.values,
    );
    await pumpOne(tester, attributes: [attr], bus: bus);
    expect(find.text('device-variant=_SampleEnum.a'), findsOneWidget);

    await tester.tap(find.text('variant'));
    await tester.pumpAndSettle();
    expect(find.byType(AttributeVariant), findsWidgets);

    // Toca no chip 'b'
    await tester.tap(find.text('b'));
    await tester.pumpAndSettle();
    expect(find.text('device-variant=_SampleEnum.b'), findsOneWidget);
  });

  testWidgets('Function: expandir não crasha e mostra valor', (tester) async {
    final bus = AttributeChangeBus();
    void myCallback() {}
    final attr = AttributeModel.function(function: myCallback, name: 'onTap');
    await pumpOne(tester, attributes: [attr], bus: bus);
    expect(find.text('onTap'), findsOneWidget);

    await tester.tap(find.text('onTap'));
    await tester.pumpAndSettle();
    // Function não tem editor interativo; só garante que não crashou.
    expect(find.byType(AttributeVariant), findsWidgets);
  });

  testWidgets('RangeInt: expandir não crasha', (tester) async {
    final bus = AttributeChangeBus();
    final attr = AttributeModel.rangeIntInterval(
      name: 'count',
      begin: 0,
      end: 10,
      selectedValue: 5,
    );
    await pumpOne(tester, attributes: [attr], bus: bus);
    expect(find.text('device-count=5'), findsOneWidget);

    await tester.tap(find.text('count'));
    await tester.pumpAndSettle();
    expect(find.byType(Slider), findsOneWidget);
  });

  testWidgets('RangeDouble: expandir não crasha', (tester) async {
    final bus = AttributeChangeBus();
    final attr = AttributeModel.rangeDoubleInterval(
      name: 'width',
      begin: 100,
      end: 500,
      selectedValue: 200.0,
    );
    await pumpOne(tester, attributes: [attr], bus: bus);
    expect(find.text('device-width=200.0'), findsOneWidget);

    await tester.tap(find.text('width'));
    await tester.pumpAndSettle();
    expect(find.byType(Slider), findsOneWidget);
  });

  testWidgets('ObjectInObject: expandir não crasha e renderiza filhos', (tester) async {
    final bus = AttributeChangeBus();
    final attr = AttributeModel.objectInObject(
      name: 'settings',
      type: 'TestSettings',
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
      selectedValue: VariableOption(
        value: const _TestSettings(42, 'hello'),
      ),
    );
    await pumpOne(tester, attributes: [attr], bus: bus);

    await tester.tap(find.text('settings'));
    await tester.pumpAndSettle();
    // Filhos renderizam quando o pai expande.
    expect(find.text('number'), findsWidgets);
    expect(find.text('text'), findsWidgets);
  });
}

enum _SampleEnum { a, b, c }

class _TestSettings {
  final int number;
  final String text;
  const _TestSettings(this.number, this.text);
  @override
  String toString() => '_TestSettings($number, $text)';
}

class _Harness extends StatefulWidget {
  const _Harness({required this.attributes, required this.bus});

  final List<AttributeModel> attributes;
  final AttributeChangeBus bus;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final attr in widget.attributes)
            Text(
              'device-${attr.name}=${attr.selectedValue?.value ?? 'null'}',
            ),
          for (final attr in widget.attributes)
            AttributeVariant(
              key: ValueKey('av-${attr.name}'),
              attribute: attr,
              attributes: widget.attributes,
              onAttributes: (attrs, changed) {
                widget.bus.notifyChanged(attrs, changed);
                setState(() {});
              },
              changeBus: widget.bus,
            ),
        ],
      ),
    );
  }
}
