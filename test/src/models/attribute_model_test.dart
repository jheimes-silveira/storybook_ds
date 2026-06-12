// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/models/model/attribute_model.dart';

void main() {
  group('AttributeModel', () {
    test('creates instance with factory constructor', () {
      final attribute = AttributeModel(
        type: 'String',
        name: 'label',
        selectedValue: VariableOption(value: 'Hello'),
      );

      expect(attribute.type, 'String');
      expect(attribute.name, 'label');
      expect(attribute.selectedValue?.value, 'Hello');
      expect(attribute.required, false);
      expect(attribute.builders, ['']);
    });

    test('creates instance with rangeIntInterval factory', () {
      final attribute = AttributeModel.rangeIntInterval(
        begin: 0,
        end: 100,
        name: 'count',
        selectedValue: 50,
      );

      expect(attribute.type, 'int');
      expect(attribute.name, 'count');
      expect(attribute.selectedValue?.value, 50);
      expect(attribute.variableOptionType, isA<RangeIntIntervalType>());
      expect((attribute.variableOptionType as RangeIntIntervalType).begin, 0);
      expect((attribute.variableOptionType as RangeIntIntervalType).end, 100);
    });

    test('creates nullable instance with canBeNull', () {
      final attribute = AttributeModel.rangeIntInterval(
        begin: 0,
        end: 100,
        canBeNull: true,
        name: 'count',
      );

      expect(attribute.type, 'int?');
      expect(attribute.selectedValue?.value, isNull);
    });

    test('creates objectInObject instance', () {
      final childAttribute = AttributeModel(
        type: 'String',
        name: 'childName',
        selectedValue: VariableOption(value: 'Child'),
      );

      final attribute = AttributeModel.objectInObject(
        type: 'User',
        name: 'user',
        selectedValue: VariableOption(value: 'John'),
        children: [childAttribute],
      );

      expect(attribute.type, 'User');
      expect(attribute.name, 'user');
      expect(attribute.selectedValue?.value, 'John');
      expect(attribute.variableOptionType, isA<ObjectInObjectType>());
      expect(
        (attribute.variableOptionType as ObjectInObjectType).children.length,
        1,
      );
    });

    test('onChangeValue callback is preserved', () {
      bool callbackCalled = false;
      final attribute = AttributeModel(
        type: 'String',
        name: 'label',
        onChangeValue: (attr) {
          callbackCalled = true;
        },
      );

      attribute.onChangeValue?.call(attribute);
      expect(callbackCalled, isTrue);
    });

    test('variableOptions are initialized when selectedValue is provided', () {
      final attribute = AttributeModel(
        type: 'String',
        name: 'label',
        selectedValue: VariableOption(value: 'Hello'),
      );

      expect(attribute.variableOptions, isNotNull);
      expect(attribute.variableOptions!.length, 1);
      expect(attribute.variableOptions![0].value, 'Hello');
    });
  });

  group('VariableOption', () {
    test('creates instance with value', () {
      final option = VariableOption(value: 'test');

      expect(option.value, 'test');
      // textInDisplay returns value.toString() when _textInDisplay is null
      expect(option.textInDisplay, 'test');
      expect(option.ignoreInDisplay, false);
    });

    test('creates instance with display text', () {
      final option = VariableOption(
        value: 'test',
        textInDisplay: 'Test Display',
      );

      expect(option.value, 'test');
      expect(option.textInDisplay, 'Test Display');
    });

    test('creates instance with ignoreInDisplay flag', () {
      final option = VariableOption(
        value: 'test',
        ignoreInDisplay: false,
      );

      expect(option.ignoreInDisplay, false);
    });
  });

  group('VariableOptionType', () {
    test('DefaultType is created correctly', () {
      final type = DefaultType();
      expect(type, isA<VariableOptionType>());
    });

    test('RangeIntIntervalType stores begin and end', () {
      final type = RangeIntIntervalType(0, 100);

      expect(type.begin, 0);
      expect(type.end, 100);
    });

    test('RangeDoubleIntervalType stores begin and end', () {
      final type = RangeDoubleIntervalType(0.0, 1.0);

      expect(type.begin, 0.0);
      expect(type.end, 1.0);
    });

    test('HtmlType canUpdateOnChange defaults to false', () {
      final type = HtmlType();

      expect(type.canUpdateOnChange, false);
    });

    test('WrapType is created correctly', () {
      final type = WrapType();
      expect(type, isA<VariableOptionType>());
    });

    test('ObjectInObjectType stores children', () {
      final child = AttributeModel(
        type: 'String',
        name: 'child',
        selectedValue: VariableOption(value: 'test'),
      );

      final type = ObjectInObjectType(children: [child]);

      expect(type.children.length, 1);
      expect(type.children[0].name, 'child');
    });

    test('ObjectInObjectType accepts merge function', () {
      final child = AttributeModel(
        type: 'String',
        name: 'child',
        selectedValue: VariableOption(value: 'test'),
      );

      String? capturedFieldName;
      StorybookNestedMerge mergeFn = (instance, fieldName, newValue) {
        capturedFieldName = fieldName;
        return newValue;
      };

      final type = ObjectInObjectType(
        children: [child],
        merge: mergeFn,
      );

      expect(type.merge, isNotNull);
      type.merge!('instance', 'field', 'newValue');
      expect(capturedFieldName, 'field');
    });
  });

  group('StorybookNestedMerge', () {
    test('merge function is called with correct parameters', () {
      String? capturedInstance;
      String? capturedFieldName;
      dynamic capturedNewValue;

      StorybookNestedMerge mergeFn = (instance, fieldName, newValue) {
        capturedInstance = instance as String;
        capturedFieldName = fieldName;
        capturedNewValue = newValue;
        return newValue;
      };

      mergeFn('testInstance', 'testField', 'testValue');

      expect(capturedInstance, 'testInstance');
      expect(capturedFieldName, 'testField');
      expect(capturedNewValue, 'testValue');
    });
  });
}
