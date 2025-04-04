import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

class UtilsAttribute {
  static AttributeDto color({
    required String name,
    bool canBeNull = false,
  }) {
    return AttributeDto(
      type: 'Color${canBeNull ? '?' : ''}',
      name: name,
      selectedValue: VariableOption(
        value: Colors.black,
        textInDisplay: 'Colors.black',
        textInSelectedOptions: 'black',
      ),
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

  static String getEmail(String email) {
    return email;
  }

  static String getPhone(String phone) {
    return phone;
  }
}
