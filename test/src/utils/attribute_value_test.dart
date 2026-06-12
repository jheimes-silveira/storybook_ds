import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/utils/attribute_value.dart';
import 'package:storybook_ds/src/models/model/attribute_model.dart';

void main() {
  group('AttributeValue', () {
    group('toDouble', () {
      test('converts num to double', () {
        final option = VariableOption(value: 42);
        expect(AttributeValue.toDouble(option, fallback: 0.0), 42.0);
      });

      test('converts double directly', () {
        final option = VariableOption(value: 3.14);
        expect(AttributeValue.toDouble(option, fallback: 0.0), 3.14);
      });

      test('returns fallback for null option', () {
        expect(AttributeValue.toDouble(null, fallback: 1.0), 1.0);
      });

      test('returns fallback for null value', () {
        final option = VariableOption(value: null);
        expect(AttributeValue.toDouble(option, fallback: 2.0), 2.0);
      });

      test('returns fallback for non-numeric value', () {
        final option = VariableOption(value: 'not a number');
        expect(AttributeValue.toDouble(option, fallback: 3.0), 3.0);
      });

      test('returns fallback for bool value', () {
        final option = VariableOption(value: true);
        expect(AttributeValue.toDouble(option, fallback: 4.0), 4.0);
      });
    });

    group('toInt', () {
      test('converts num to int', () {
        final option = VariableOption(value: 42.7);
        expect(AttributeValue.toInt(option, fallback: 0), 42);
      });

      test('converts int directly', () {
        final option = VariableOption(value: 100);
        expect(AttributeValue.toInt(option, fallback: 0), 100);
      });

      test('returns fallback for null option', () {
        expect(AttributeValue.toInt(null, fallback: 1), 1);
      });

      test('returns fallback for null value', () {
        final option = VariableOption(value: null);
        expect(AttributeValue.toInt(option, fallback: 2), 2);
      });

      test('returns fallback for non-numeric value', () {
        final option = VariableOption(value: 'not a number');
        expect(AttributeValue.toInt(option, fallback: 3), 3);
      });
    });

    group('toBool', () {
      test('returns true for true value', () {
        final option = VariableOption(value: true);
        expect(AttributeValue.toBool(option, fallback: false), true);
      });

      test('returns false for false value', () {
        final option = VariableOption(value: false);
        expect(AttributeValue.toBool(option, fallback: true), false);
      });

      test('returns fallback for null option', () {
        expect(AttributeValue.toBool(null, fallback: true), true);
      });

      test('returns fallback for non-bool value', () {
        final option = VariableOption(value: 'not a bool');
        expect(AttributeValue.toBool(option, fallback: false), false);
      });
    });

    group('valueToString', () {
      test('converts value to string', () {
        final option = VariableOption(value: 'hello');
        expect(AttributeValue.valueToString(option), 'hello');
      });

      test('converts number to string', () {
        final option = VariableOption(value: 123);
        expect(AttributeValue.valueToString(option), '123');
      });

      test('returns empty string for null option', () {
        expect(AttributeValue.valueToString(null), '');
      });

      test('returns empty string for null value', () {
        final option = VariableOption(value: null);
        expect(AttributeValue.valueToString(option), '');
      });
    });

    group('createForType', () {
      test('creates option for RangeDoubleIntervalType with num value', () {
        final type = RangeDoubleIntervalType(0.0, 1.0);
        final option = AttributeValue.createForType(type, 0.5);

        expect(option?.value, 0.5);
      });

      test('creates option for RangeDoubleIntervalType with fallback', () {
        final type = RangeDoubleIntervalType(0.0, 1.0);
        final option = AttributeValue.createForType(type, 'not a number');

        expect(option?.value, 0.0);
      });

      test('creates option for RangeIntIntervalType with num value', () {
        final type = RangeIntIntervalType(0, 100);
        final option = AttributeValue.createForType(type, 50);

        expect(option?.value, 50);
      });

      test('creates option for RangeIntIntervalType with fallback', () {
        final type = RangeIntIntervalType(0, 100);
        final option = AttributeValue.createForType(type, 'not a number');

        expect(option?.value, 0);
      });

      test('creates option for any type with non-null value', () {
        final option = AttributeValue.createForType(null, 'any value');

        expect(option?.value, 'any value');
      });

      test('returns null for null type and null value', () {
        final option = AttributeValue.createForType(null, null);

        expect(option, isNull);
      });
    });

    group('isPresent', () {
      test('returns true for non-null value', () {
        final option = VariableOption(value: 'present');
        expect(AttributeValue.isPresent(option), true);
      });

      test('returns false for null option', () {
        expect(AttributeValue.isPresent(null), false);
      });

      test('returns false for null value', () {
        final option = VariableOption(value: null);
        expect(AttributeValue.isPresent(option), false);
      });
    });
  });
}
