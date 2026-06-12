import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/ds/dropdown/ds_dropdown_controller.dart';
import 'package:storybook_ds/ds/dropdown/ds_dropdown_button.dart';
import 'package:storybook_ds/ds/dropdown/ds_checkbox_list_tile.dart';

void main() {
  group('DSDropdownController', () {
    test('creates instance with default values', () {
      final controller = DSDropdownController();

      expect(controller.isOpened, false);
      expect(controller.error, isNull);
    });

    test('creates instance with custom values', () {
      final controller = DSDropdownController(
        isOpened: true,
        error: 'Test error',
      );

      expect(controller.isOpened, true);
      expect(controller.error, 'Test error');
    });

    test('setting isOpened notifies listeners', () {
      final controller = DSDropdownController();
      bool notified = false;

      controller.addListener(() {
        notified = true;
      });

      controller.isOpened = true;

      expect(notified, true);
      expect(controller.isOpened, true);
    });

    test('setting error notifies listeners', () {
      final controller = DSDropdownController();
      bool notified = false;

      controller.addListener(() {
        notified = true;
      });

      controller.error = 'New error';

      expect(notified, true);
      expect(controller.error, 'New error');
    });
  });

  group('DSCheckboxListTile', () {
    testWidgets('displays label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DSCheckboxListTile(
              label: 'Test Label',
              value: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
    });

    testWidgets('displays checkbox with correct value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DSCheckboxListTile(
              label: 'Test',
              value: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true);
    });

    testWidgets('calls onChanged with toggled value on tap', (tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DSCheckboxListTile(
              label: 'Test',
              value: false,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(changedValue, true);
    });
  });

  group('DSDropdownMenuItem', () {
    test('creates instance with required label', () {
      const item = DSDropdownMenuItem<String>(
        label: 'Test Item',
      );

      expect(item.label, 'Test Item');
      expect(item.value, isNull);
      expect(item.key, isNull);
      expect(item.onTap, isNull);
      expect(item.enabled, true);
    });

    test('creates instance with all parameters', () {
      final item = DSDropdownMenuItem<String>(
        label: 'Test Item',
        value: 'value1',
        key: const Key('item-key'),
        onTap: () {},
        enabled: false,
      );

      expect(item.label, 'Test Item');
      expect(item.value, 'value1');
      expect(item.key, const Key('item-key'));
      expect(item.onTap, isNotNull);
      expect(item.enabled, false);
    });

    test('equality based on value', () {
      const item1 = DSDropdownMenuItem<String>(
        label: 'Item 1',
        value: 'value1',
      );

      const item2 = DSDropdownMenuItem<String>(
        label: 'Item 2',
        value: 'value1',
      );

      const item3 = DSDropdownMenuItem<String>(
        label: 'Item 1',
        value: 'value2',
      );

      expect(item1 == item2, true);
      expect(item1 == item3, false);
    });

    test('hashCode based on value', () {
      const item1 = DSDropdownMenuItem<String>(
        label: 'Item 1',
        value: 'value1',
      );

      const item2 = DSDropdownMenuItem<String>(
        label: 'Item 2',
        value: 'value1',
      );

      expect(item1.hashCode, item2.hashCode);
    });
  });

  group('DSDropdownButton', () {
    testWidgets('singleSelection factory creates widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DSDropdownButton<String>.singleSelection(
              items: const [
                DSDropdownMenuItem(label: 'Option 1', value: 'opt1'),
                DSDropdownMenuItem(label: 'Option 2', value: 'opt2'),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(DSDropdownButton<String>), findsOneWidget);
    });

    testWidgets('multiSelection factory creates widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DSDropdownButton<String>.multiSelection(
              items: const [
                DSDropdownMenuItem(label: 'Option 1', value: 'opt1'),
                DSDropdownMenuItem(label: 'Option 2', value: 'opt2'),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(DSDropdownButton<String>), findsOneWidget);
    });
  });
}
