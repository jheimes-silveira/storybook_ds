import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/device_preview/model/tools_panel_model.dart';

void main() {
  group('ToolsPanelModel', () {
    test('creates instance with required parameters', () {
      final model = ToolsPanelModel(
        tools: [
          Container(),
          Container(),
        ],
      );

      expect(model.tools.length, 2);
      expect(model.panelWidth, 320);
    });

    test('creates instance with custom panelWidth', () {
      final model = ToolsPanelModel(
        tools: [Container()],
        panelWidth: 400,
      );

      expect(model.panelWidth, 400);
    });

    test('tools list is accessible', () {
      final tool1 = Container(key: const Key('tool1'));
      final tool2 = Container(key: const Key('tool2'));

      final model = ToolsPanelModel(
        tools: [tool1, tool2],
      );

      expect(model.tools[0], tool1);
      expect(model.tools[1], tool2);
    });
  });
}
