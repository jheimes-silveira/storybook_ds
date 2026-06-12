import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/models/model/attribute_model.dart';
import 'package:storybook_ds/src/models/multiple_theme_settings.dart';
import 'package:storybook_ds/src/theme/storybook_theme.dart';
import 'package:storybook_ds/src/theme/storybook_theme_scope.dart';
import 'package:storybook_ds/src/utils/typedef_storybook.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_change_bus.dart';
import 'package:storybook_ds/src/widgets/content_widget.dart';

void main() {
  group('ContentWidget', () {
    Widget createTestWidget({
      required List<AttributeModel> attributes,
      required String title,
      String description = '',
      String? constructor,
      String nameObjectInDisplay = 'TestWidget',
      Function(List<AttributeModel>, AttributeModel)? onAttributes,
      Function(MultipleThemeSettings)? onUpdateTheme,
      required Function(String) onSelectedConstructor,
      required String Function(List<AttributeModel>) updatePreviewCode,
      OnBuildExtraAttributesConfigCustom? extraAttributesConfigCustom,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: StorybookThemeScope(
            theme: StorybookTheme.defaults(),
            child: ContentWidget(
              attributes: attributes,
              title: title,
              description: description,
              nameObjectInDisplay: nameObjectInDisplay,
              onAttributes: onAttributes,
              onUpdateTheme: onUpdateTheme,
              onSelectedConstructor: onSelectedConstructor,
              updatePreviewCode: updatePreviewCode,
              extraAttributesConfigCustom: extraAttributesConfigCustom,
              constructor: constructor,
              changeBus: AttributeChangeBus(),
            ),
          ),
        ),
      );
    }

    testWidgets('renders title correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          attributes: [],
          title: 'Test Title',
          onSelectedConstructor: (_) {},
          updatePreviewCode: (_) => '',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('renders description when provided', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          attributes: [],
          title: 'Test Title',
          description: 'Test Description',
          onSelectedConstructor: (_) {},
          updatePreviewCode: (_) => '',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('renders attributes list with names visible', (tester) async {
      final attributes = [
        AttributeModel(
          type: 'String',
          name: 'label',
          selectedValue: VariableOption(value: 'Hello'),
        ),
        AttributeModel(
          type: 'int',
          name: 'count',
          selectedValue: VariableOption(value: 42),
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          attributes: attributes,
          title: 'Test Title',
          onSelectedConstructor: (_) {},
          updatePreviewCode: (_) => '',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('label'), findsOneWidget);
      expect(find.text('count'), findsOneWidget);
    });

    testWidgets('uses StorybookTheme from scope', (tester) async {
      final customTheme = StorybookThemePresets.dark;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StorybookThemeScope(
              theme: customTheme,
              child: ContentWidget(
                attributes: const [],
                title: 'Test Title',
                description: '',
                nameObjectInDisplay: 'Test',
                onSelectedConstructor: (_) {},
                updatePreviewCode: (_) => '',
                changeBus: AttributeChangeBus(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(ContentWidget));
      final theme = StorybookThemeScope.of(context);
      expect(theme, customTheme);
    });

    testWidgets('renders with empty attributes list', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          attributes: [],
          title: 'Test Title',
          onSelectedConstructor: (_) {},
          updatePreviewCode: (_) => '',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('renders attribute with null selectedValue', (tester) async {
      final attributes = [
        AttributeModel(
          type: 'String?',
          name: 'nullableLabel',
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          attributes: attributes,
          title: 'Test Title',
          onSelectedConstructor: (_) {},
          updatePreviewCode: (_) => '',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('nullableLabel'), findsOneWidget);
    });

    testWidgets('renders attributes with required flag', (tester) async {
      final attributes = [
        AttributeModel(
          type: 'String',
          name: 'requiredLabel',
          required: true,
          selectedValue: VariableOption(value: 'Required'),
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          attributes: attributes,
          title: 'Test Title',
          onSelectedConstructor: (_) {},
          updatePreviewCode: (_) => '',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('requiredLabel'), findsOneWidget);
    });

    testWidgets('renders attributes with name visible', (tester) async {
      final attributes = [
        AttributeModel(
          type: 'String',
          name: 'labeledAttribute',
          description: 'This is a description',
          selectedValue: VariableOption(value: 'Value'),
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          attributes: attributes,
          title: 'Test Title',
          onSelectedConstructor: (_) {},
          updatePreviewCode: (_) => '',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('labeledAttribute'), findsOneWidget);
    });

    testWidgets('calls onSelectedConstructor callback', (tester) async {
      String? selectedConstructor;

      await tester.pumpWidget(
        createTestWidget(
          attributes: [],
          title: 'Test Title',
          onSelectedConstructor: (c) {
            selectedConstructor = c;
          },
          updatePreviewCode: (_) => '',
        ),
      );
      await tester.pumpAndSettle();

      expect(selectedConstructor, isNull);
    });

    testWidgets('renders with custom constructor', (tester) async {
      final attributes = [
        AttributeModel(
          type: 'String',
          name: 'label',
          selectedValue: VariableOption(value: 'Hello'),
          builders: ['', 'default', 'outlined'],
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          attributes: attributes,
          title: 'Test Title',
          constructor: 'default',
          onSelectedConstructor: (_) {},
          updatePreviewCode: (_) => '',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Title'), findsOneWidget);
    });
  });
}