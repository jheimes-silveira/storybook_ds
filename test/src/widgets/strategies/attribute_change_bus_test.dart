import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_change_bus.dart';
import 'package:storybook_ds/src/models/model/attribute_model.dart';

void main() {
  group('AttributeChangeBus', () {
    test('creates instance with hasChanges as false', () {
      final bus = AttributeChangeBus();

      expect(bus.hasChanges, false);
    });

    test('notifyChanged adds attribute name to changed set', () {
      final bus = AttributeChangeBus();
      final attribute = AttributeModel(
        type: 'String',
        name: 'testAttribute',
        selectedValue: VariableOption(value: 'value'),
      );

      bus.notifyChanged([], attribute);

      expect(bus.hasChanges, true);
    });

    test('notifyChanged ignores empty name', () {
      final bus = AttributeChangeBus();
      final attribute = AttributeModel(
        type: 'String',
        name: '',
        selectedValue: VariableOption(value: 'value'),
      );

      bus.notifyChanged([], attribute);

      expect(bus.hasChanges, false);
    });

    test('clear removes all changes', () {
      final bus = AttributeChangeBus();
      final attribute = AttributeModel(
        type: 'String',
        name: 'testAttribute',
        selectedValue: VariableOption(value: 'value'),
      );

      bus.notifyChanged([], attribute);
      expect(bus.hasChanges, true);

      bus.clear();
      expect(bus.hasChanges, false);
    });

    test('multiple notifyChanged calls accumulate names', () {
      final bus = AttributeChangeBus();
      final attribute1 = AttributeModel(
        type: 'String',
        name: 'attr1',
        selectedValue: VariableOption(value: 'value'),
      );
      final attribute2 = AttributeModel(
        type: 'String',
        name: 'attr2',
        selectedValue: VariableOption(value: 'value'),
      );

      bus.notifyChanged([], attribute1);
      bus.notifyChanged([], attribute2);

      expect(bus.hasChanges, true);
    });

    test('listeners are notified on notifyChanged', () {
      final bus = AttributeChangeBus();
      bool notified = false;

      bus.addListener(() {
        notified = true;
      });

      final attribute = AttributeModel(
        type: 'String',
        name: 'testAttribute',
        selectedValue: VariableOption(value: 'value'),
      );

      bus.notifyChanged([], attribute);

      expect(notified, true);
    });

    test('clear does not notify listeners', () {
      final bus = AttributeChangeBus();
      bool notified = false;

      bus.addListener(() {
        notified = true;
      });

      bus.clear();

      expect(notified, false);
    });
  });
}
