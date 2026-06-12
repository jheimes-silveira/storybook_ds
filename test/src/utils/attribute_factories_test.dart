import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/utils/attribute_factories.dart';
import 'package:storybook_ds/src/models/model/attribute_model.dart';

void main() {
  group('StorybookAttributeFactories', () {
    test('factoryAttributeModelString creates attribute with correct type', () {
      final attribute = StorybookAttributeFactories.factoryAttributeModelString(
        name: 'description',
      );

      expect(attribute.name, 'description');
      expect(attribute.type, 'String');
      expect(attribute.required, false);
      expect(attribute.builders, ['']);
    });

    test('factoryAttributeModelString with canBeNull adds ? to type', () {
      final attribute = StorybookAttributeFactories.factoryAttributeModelString(
        name: 'nullableField',
        canBeNull: true,
      );

      expect(attribute.type, 'String?');
    });

    test('factoryAttributeModelString with required sets required flag', () {
      final attribute = StorybookAttributeFactories.factoryAttributeModelString(
        name: 'requiredField',
        required: true,
      );

      expect(attribute.required, true);
    });

    test('factoryAttributeModelString with selectedValue', () {
      final attribute = StorybookAttributeFactories.factoryAttributeModelString(
        name: 'selectedField',
        selectedValue: 'Custom value',
      );

      expect(attribute.selectedValue?.value, 'Custom value');
    });

    test('factoryAttributeModelString with custom builders', () {
      final attribute = StorybookAttributeFactories.factoryAttributeModelString(
        name: 'customBuilders',
        builders: ['builder1', 'builder2'],
      );

      expect(attribute.builders, ['builder1', 'builder2']);
    });

    test('factoryAttributeModelString provides predefined variable options', () {
      final attribute = StorybookAttributeFactories.factoryAttributeModelString(
        name: 'predefinedOptions',
      );

      expect(attribute.variableOptions, isNotNull);
      expect(attribute.variableOptions!.length, 7);
    });

    test('factoryAttributeDtoString is deprecated and delegates to factoryAttributeModelString', () {
      // ignore: deprecated_member_use
      final attribute = StorybookAttributeFactories.factoryAttributeDtoString(
        name: 'deprecatedField',
        selectedValue: 'Test value',
        canBeNull: true,
        required: true,
        builders: ['builder1'],
      );

      expect(attribute.name, 'deprecatedField');
      expect(attribute.type, 'String?');
      expect(attribute.required, true);
      expect(attribute.selectedValue?.value, 'Test value');
      expect(attribute.builders, ['builder1']);
    });
  });
}
