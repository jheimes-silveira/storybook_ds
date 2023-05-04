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
  List<AttributeDto> attributes = [
    AttributeDto.function(
      name: 'onPressed',
      required: true,
      builders: ['elevated', 'outline', 'text'],
      function: (int a, String b) {
        return 0;
      },
    ),
    AttributeDto(
      type: 'String',
      name: 'text',
      required: true,
      selectedValue: VariableOption(value: 'Custom Buttom'),
      builders: ['elevated', 'outline', 'text'],
    ),
    AttributeDto(
      type: 'bool',
      name: 'loading',
      selectedValue: VariableOption(value: false),
      builders: ['elevated', 'outline', 'text'],
    ),
    AttributeDto.rangeDoubleInterval(
      canBeNull: true,
      name: 'borderRadius',
      selectedValue: 0,
      builders: ['elevated', 'outline'],
      begin: 0,
      end: 20,
    ),
    AttributeDto(
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
    AttributeDto(
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
    AttributeDto(
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
      text: getWhereAttribut('text'),
      loading: getWhereAttribut('loading'),
      color: getWhereAttribut('color'),
      borderRadius: getWhereAttribut('borderRadius'),
      onPressed: () {},
    );
  }

  Widget _buildOutline() {
    return CustomButton.outline(
      text: getWhereAttribut('text'),
      loading: getWhereAttribut('loading'),
      borderSideColor: getWhereAttribut('borderSideColor'),
      borderRadius: getWhereAttribut('borderRadius'),
      onPressed: () {},
    );
  }

  Widget _buildText() {
    return CustomButton.text(
      text: getWhereAttribut('text'),
      loading: getWhereAttribut('loading'),
      textColor: getWhereAttribut('textColor'),
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
