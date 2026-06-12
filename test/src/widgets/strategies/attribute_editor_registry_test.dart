import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_editor_registry.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_editor_strategy.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_change_bus.dart';
import 'package:storybook_ds/src/models/model/attribute_model.dart';

/// Test strategy implementation
class TestStrategy implements AttributeEditorStrategy {
  const TestStrategy({
    this.id = 'test',
    this.priority = 0,
    this.handlesReturn = true,
  });

  @override
  final String id;

  @override
  final int priority;

  final bool handlesReturn;

  @override
  bool handles(AttributeModel attribute) => handlesReturn;

  @override
  Widget build(EditorContext context) => const SizedBox();
}

void main() {
  group('SafeNoOpFallback', () {
    test('has correct id', () {
      const fallback = SafeNoOpFallback();

      expect(fallback.id, '__safe_fallback__');
    });

    test('has priority 0', () {
      const fallback = SafeNoOpFallback();

      expect(fallback.priority, 0);
    });

    test('handles any attribute', () {
      const fallback = SafeNoOpFallback();
      final attribute = AttributeModel(
        type: 'Unknown',
        name: 'test',
      );

      expect(fallback.handles(attribute), true);
    });

    testWidgets('builds help text widget', (tester) async {
      const fallback = SafeNoOpFallback();
      final attribute = AttributeModel(
        type: 'Unknown',
        name: 'testAttribute',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) {
                return fallback.build(EditorContext(
                  attribute: attribute,
                  attributes: [],
                  onChanged: null,
                  widgetKey: const Key('test'),
                  buildContext: ctx,
                  changeBus: AttributeChangeBus(),
                ));
              },
            ),
          ),
        ),
      );

      expect(find.textContaining('testAttribute'), findsOneWidget);
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
    });
  });

  group('AttributeEditorRegistry', () {
    late AttributeEditorRegistry registry;

    setUp(() {
      registry = AttributeEditorRegistry();
    });

    test('has default fallback', () {
      expect(registry.pick(AttributeModel(type: 'String', name: 'test')),
          isA<SafeNoOpFallback>());
    });

    test('register adds strategy', () {
      const strategy = TestStrategy(id: 'new-strategy');

      registry.register(strategy);

      expect(registry.pick(AttributeModel(type: 'String', name: 'test')).id,
          'new-strategy');
    });

    test('register replaces existing strategy with same id', () {
      const strategy1 = TestStrategy(id: 'same-id', priority: 1);
      const strategy2 = TestStrategy(id: 'same-id', priority: 2);

      registry.register(strategy1);
      registry.register(strategy2);

      final picked = registry.pick(AttributeModel(type: 'String', name: 'test'));
      expect((picked as TestStrategy).priority, 2);
    });

    test('strategies are ordered by priority descending', () {
      const lowPriority = TestStrategy(id: 'low', priority: 1);
      const highPriority = TestStrategy(id: 'high', priority: 10);
      const mediumPriority = TestStrategy(id: 'medium', priority: 5);

      registry.register(lowPriority);
      registry.register(highPriority);
      registry.register(mediumPriority);

      final picked = registry.pick(AttributeModel(type: 'String', name: 'test'));
      expect((picked as TestStrategy).id, 'high');
    });

    test('setFallback changes fallback strategy', () {
      const customFallback = TestStrategy(id: 'custom-fallback');

      registry.setFallback(customFallback);

      expect(registry.pick(AttributeModel(type: 'Unknown', name: 'test')).id,
          'custom-fallback');
    });

    test('pick returns first matching strategy', () {
      const strategy1 = TestStrategy(id: 'strat1', handlesReturn: false);
      const strategy2 = TestStrategy(id: 'strat2', handlesReturn: true);

      registry.register(strategy1);
      registry.register(strategy2);

      expect(registry.pick(AttributeModel(type: 'String', name: 'test')).id,
          'strat2');
    });

    testWidgets('buildFor delegates to pick and build', (tester) async {
      const strategy = TestStrategy(id: 'test-strategy');
      registry.register(strategy);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (buildCtx) {
              final attribute = AttributeModel(type: 'String', name: 'test');
              final editorContext = EditorContext(
                attribute: attribute,
                attributes: [],
                onChanged: null,
                widgetKey: const Key('test'),
                buildContext: buildCtx,
                changeBus: AttributeChangeBus(),
              );

              final widget = registry.buildFor(editorContext);

              expect(widget, isA<SizedBox>());
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
