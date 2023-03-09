import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

import 'custom_button.dart';

class ButtonPage extends StatefulWidget {
  const ButtonPage({Key? key}) : super(key: key);

  @override
  Storybook<ButtonPage> createState() => _ButtonPageState();
}

class _ButtonPageState extends Storybook<ButtonPage> {
  @override
  List<AtributeDto> atributs = [
    AtributeDto(
      type: 'Function()',
      name: 'onPressed',
      required: true,
      builders: ['elevated', 'outline', 'text'],
    ),
    AtributeDto(
      type: 'String',
      name: 'text',
      required: true,
      selectedValue: VariableOption(value: 'Custom Buttom'),
      builders: ['elevated', 'outline', 'text'],
    ),
    AtributeDto(
      type: 'bool',
      name: 'loading',
      selectedValue: VariableOption(value: false),
      builders: ['elevated', 'outline', 'text'],
    ),
    AtributeDto.rangeDoubleInterval(
      type: 'double?',
      name: 'borderRadius',
      selectedValue: 0,
      builders: ['elevated', 'outline'],
      begin: 0,
      end: 20,
    ),
    AtributeDto(
      type: 'Color?',
      name: 'color',
      builders: ['elevated'],
      selectedValue: VariableOption(value: null),
      variableOptions: [
        VariableOption(
          value: Colors.amber,
          textInDisplay: 'Colors.amber',
          textInSelectedOptions: 'amber',
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
          value: Colors.green,
          textInDisplay: 'Colors.green',
          textInSelectedOptions: 'green',
        ),
      ],
    ),
    AtributeDto(
      type: 'Color?',
      name: 'borderSideColor',
      builders: ['outline'],
      selectedValue: VariableOption(value: null),
      variableOptions: [
        VariableOption(
          value: Colors.amber,
          textInDisplay: 'Colors.amber',
          textInSelectedOptions: 'amber',
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
          value: Colors.green,
          textInDisplay: 'Colors.green',
          textInSelectedOptions: 'green',
        ),
      ],
    ),
    AtributeDto(
      type: 'Color?',
      name: 'textColor',
      builders: ['text'],
      selectedValue: VariableOption(value: null),
      variableOptions: [
        VariableOption(
          value: Colors.amber,
          textInDisplay: 'Colors.amber',
          textInSelectedOptions: 'amber',
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
          value: Colors.green,
          textInDisplay: 'Colors.green',
          textInSelectedOptions: 'green',
        ),
      ],
    ),
  ];

  @override
  Widget buildComponentWidget(BuildContext context) {
    Widget child;
    if (selectedConstructor == 'elevated') {
      child = _buildElevated();
    } else if (selectedConstructor == 'outline') {
      child = _buildOutline();
    } else {
      child = _buildText();
    }
    return Scaffold(
      body: Center(
        child: child,
      ),
    );
  }

  Widget _buildElevated() {
    return CustomButton.elevated(
      text: getWhereAtribut('text'),
      loading: getWhereAtribut('loading'),
      color: getWhereAtribut('color'),
      borderRadius: getWhereAtribut('borderRadius'),
      onPressed: () {},
    );
  }

  Widget _buildOutline() {
    return CustomButton.outline(
      text: getWhereAtribut('text'),
      loading: getWhereAtribut('loading'),
      borderSideColor: getWhereAtribut('borderSideColor'),
      borderRadius: getWhereAtribut('borderRadius'),
      onPressed: () {},
    );
  }

  Widget _buildText() {
    return CustomButton.text(
      text: getWhereAtribut('text'),
      loading: getWhereAtribut('loading'),
      textColor: getWhereAtribut('textColor'),
      onPressed: () {},
    );
  }

  @override
  String description =
      'Magna et nonumy dolor duo sanctus sed est stet voluptua, dolor ipsum et et aliquyam amet et. Sed diam et.';

  @override
  String nameObjectInDisplay = 'CustomButton';

  @override
  String title = 'DS Button';
}
