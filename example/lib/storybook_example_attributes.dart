import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

/// Atributos de exemplo reutilizáveis nas stories deste app.
class StorybookExampleAttributes {
  StorybookExampleAttributes._();

  /// Seletor de [Color] com opções fixas para o painel do storybook.
  static AttributeModel colorPicker({
    required String name,
    bool canBeNull = false,
    VariableOption? selectedValue,
    List<String> builders = const [''],
  }) {
    return AttributeModel(
      type: 'Color${canBeNull ? '?' : ''}',
      name: name,
      builders: builders,
      selectedValue: selectedValue ?? VariableOption(value: null),
      variableOptions: [
        VariableOption(
          value: Colors.lime,
          textInDisplay: 'Colors.lime',
          textInSelectedOptions: 'lime',
        ),
        VariableOption(
          value: Colors.black,
          textInDisplay: 'Colors.black',
          textInSelectedOptions: 'black',
        ),
        VariableOption(
          value: Colors.red,
          textInDisplay: 'Colors.red',
          textInSelectedOptions: 'red',
        ),
        VariableOption(
          value: Colors.white,
          textInDisplay: 'Colors.white',
          textInSelectedOptions: 'white',
        ),
      ],
    );
  }
}
