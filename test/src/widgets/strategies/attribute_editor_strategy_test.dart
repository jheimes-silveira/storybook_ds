import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_editor_strategy.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_change_bus.dart';
import 'package:storybook_ds/src/models/model/attribute_model.dart';

void main() {
  group('EditorContext', () {
    testWidgets('creates instance with required parameters', (tester) async {
      final attribute = AttributeModel(
        type: 'String',
        name: 'test',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final editorContext = EditorContext(
                attribute: attribute,
                attributes: [attribute],
                onChanged: null,
                widgetKey: const Key('test-key'),
                buildContext: context,
                changeBus: AttributeChangeBus(),
              );

              expect(editorContext.attribute, attribute);
              expect(editorContext.attributes, [attribute]);
              expect(editorContext.onChanged, isNull);
              expect(editorContext.widgetKey, const Key('test-key'));
              expect(editorContext.constructor, isNull);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('creates instance with optional parameters', (tester) async {
      final attribute = AttributeModel(
        type: 'String',
        name: 'test',
      );

      void onChanged(List<AttributeModel> attrs, AttributeModel attr) {}

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final editorContext = EditorContext(
                attribute: attribute,
                attributes: [attribute],
                onChanged: onChanged,
                widgetKey: const Key('test-key'),
                buildContext: context,
                changeBus: AttributeChangeBus(),
                constructor: 'inline',
              );

              expect(editorContext.onChanged, isNotNull);
              expect(editorContext.constructor, 'inline');
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('AttributeEditorStrategy', () {
    test('priority defaults to 0', () {
      const strategy = _TestStrategyImpl();

      expect(strategy.priority, 0);
    });

    test('id is set correctly', () {
      const strategy = _TestStrategyImpl(id: 'custom-id');

      expect(strategy.id, 'custom-id');
    });
  });
}

/// Test implementation of AttributeEditorStrategy
class _TestStrategyImpl implements AttributeEditorStrategy {
  const _TestStrategyImpl({
    this.id = 'test',
    this.priority = 0,
  });

  @override
  final String id;

  @override
  final int priority;

  @override
  bool handles(AttributeModel attribute) => true;

  @override
  Widget build(EditorContext context) => const SizedBox();
}
