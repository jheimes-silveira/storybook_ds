// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:storybook_ds/src/utils/utils.dart';

typedef OnChangeValue = void Function(AttributeDto value);

class AttributeDto {
  final String type;
  final String name;
  final String? description;
  final List<VariableOption>? variableOptions;
  final List<String> builders;
  final VariableOptionType variableOptionType;
  final bool required;
  final VariableOption? defaultValue;
  final OnChangeValue? onChangeValue;

  VariableOption? selectedValue;

  factory AttributeDto({
    required String type,
    required String name,
    String? description,
    List<VariableOption>? variableOptions,
    List<String> builders = const [''],
    bool required = false,
    VariableOption? selectedValue,
    VariableOption? defaultValue,
    OnChangeValue? onChangeValue,
  }) {
    if (variableOptions == null && selectedValue != null) {
      variableOptions = [selectedValue];
    }

    variableOptions ??= [VariableOption(value: '')];

    return AttributeDto._raw(
      type: type,
      name: name,
      variableOptions: variableOptions,
      selectedValue: selectedValue,
      defaultValue: defaultValue,
      builders: builders,
      description: description,
      required: required,
      variableOptionType: DefaultType(),
      onChangeValue: onChangeValue,
    );
  }

  factory AttributeDto.rangeIntInterval({
    required int begin,
    required int end,
    bool canBeNull = false,
    required String name,
    String? description,
    List<String> builders = const [''],
    bool required = false,
    int? selectedValue,
    int? defaultValue,
    OnChangeValue? onChangeValue,
  }) {
    return AttributeDto._raw(
      type: 'int${canBeNull ? '?' : ''}',
      name: name,
      variableOptions: [
        VariableOption(value: begin),
        VariableOption(value: end),
      ],
      selectedValue: VariableOption(value: selectedValue),
      defaultValue: VariableOption(value: defaultValue),
      builders: builders,
      description: description,
      required: required,
      variableOptionType: RangeIntIntervalType(begin, end),
      onChangeValue: onChangeValue,
    );
  }
  factory AttributeDto.objectInObject({
    required String type,
    required String name,
    required VariableOption selectedValue,
    String? description,
    bool canBeNull = false,
    List<String> builders = const [''],
    bool required = false,
    VariableOption? defaultValue,
    OnChangeValue? onChangeValue,
    List<AttributeDto> children = const [],
    List<VariableOption>? variableOptions,
  }) {
    variableOptions ??= [selectedValue];
    return AttributeDto._raw(
      type: '$type${canBeNull ? '?' : ''}',
      name: name,
      variableOptions: variableOptions,
      selectedValue: selectedValue,
      defaultValue: defaultValue,
      builders: builders,
      description: description,
      required: required,
      variableOptionType: ObjectInObjectType(children: children),
      onChangeValue: onChangeValue,
    );
  }
  factory AttributeDto.string({
    required String name,
    bool canBeNull = false,
    String? description,
    List<String> builders = const [''],
    bool required = false,
    String? mask,
    String? selectedValue,
    String? defaultValue,
    OnChangeValue? onChangeValue,
  }) {
    return AttributeDto._raw(
      type: 'String${canBeNull ? '?' : ''}',
      name: name,
      variableOptions: [],
      selectedValue: VariableOption(value: selectedValue),
      defaultValue: VariableOption(value: defaultValue),
      builders: builders,
      description: description,
      required: required,
      variableOptionType: StringType(mask: mask),
      onChangeValue: onChangeValue,
    );
  }
  factory AttributeDto.enumType({
    required String name,
    required List<Enum> values,
    bool canBeNull = false,
    String? description,
    List<String> builders = const [''],
    bool required = false,
    void Function(AttributeDto)? onChangeValue,
    Enum? selectedValue,
    Enum? defaultValue,
  }) {

    return AttributeDto._raw(
      type: '${values[0].runtimeType}${canBeNull ? '?' : ''}',
      name: name,
      variableOptions: values
          .map((e) => VariableOption(
                value: e,
                textInDisplay: '$e',
                textInSelectedOptions: e.name,
              ))
          .toList(),
      selectedValue: selectedValue != null
          ? VariableOption(
              value: selectedValue,
              textInDisplay: '$selectedValue',
              textInSelectedOptions: selectedValue.name,
            )
          : VariableOption(value: null),
      defaultValue: defaultValue != null
          ? VariableOption(
              value: defaultValue,
              textInDisplay: '$defaultValue',
              textInSelectedOptions: defaultValue.name,
            )
          : VariableOption(value: null),
      builders: builders,
      description: description,
      required: required,
      variableOptionType: EnumType(),
      onChangeValue: onChangeValue,
    );
  }

  factory AttributeDto.function({
    required dynamic function,
    required String name,
    bool canBeNull = false,
    String? description,
    List<String> builders = const [''],
    bool required = false,
    OnChangeValue? onChangeValue,
  }) {
    return AttributeDto._raw(
      type: 'Function${canBeNull ? '?' : ''}',
      name: name,
      variableOptions: [],
      selectedValue: VariableOption(value: null),
      defaultValue: VariableOption(value: null),
      builders: builders,
      description: description,
      required: required,
      variableOptionType: FunctionType(function: function),
      onChangeValue: onChangeValue,
    );
  }
  factory AttributeDto.rangeDoubleInterval({
    required double begin,
    required double end,
    required String name,
    bool canBeNull = false,
    String? description,
    List<String> builders = const [''],
    bool required = false,
    double? selectedValue,
    double? defaultValue,
    OnChangeValue? onChangeValue,
  }) {
    return AttributeDto._raw(
      type: 'double${canBeNull ? '?' : ''}',
      name: name,
      variableOptions: [
        VariableOption(value: begin),
        VariableOption(value: end),
      ],
      selectedValue: VariableOption(value: selectedValue),
      defaultValue: VariableOption(value: defaultValue),
      builders: builders,
      description: description,
      required: required,
      variableOptionType: RangeDoubleIntervalType(begin, end),
      onChangeValue: onChangeValue,
    );
  }

  factory AttributeDto.color({
    required String name,
    bool canBeNull = false,
    String? description,
    List<String> builders = const [''],
    bool required = false,
    Color? selectedValue,
    Color? defaultValue,
    List<Color> variableOptions = const [],
    OnChangeValue? onChangeValue,
  }) {
    final options = variableOptions
        .map((e) => VariableOption(
              value: e,
              textInSelectedOptions: Utils.colorToHex(e),
            ))
        .toList();
    if (options.isEmpty && selectedValue != null) {
      options.add(VariableOption(
        value: selectedValue,
        textInSelectedOptions: Utils.colorToHex(selectedValue),
      ));
    }
    return AttributeDto._raw(
      type: 'Color${canBeNull ? '?' : ''}',
      name: name,
      variableOptions: options,
      selectedValue: VariableOption(
        value: selectedValue,
        textInSelectedOptions:
            selectedValue != null ? Utils.colorToHex(selectedValue) : null,
      ),
      defaultValue: VariableOption(value: defaultValue),
      builders: builders,
      description: description,
      required: required,
      variableOptionType: ColorType(),
      onChangeValue: onChangeValue,
    );
  }

  AttributeDto._raw({
    required this.type,
    required this.name,
    required this.variableOptions,
    required this.selectedValue,
    required this.builders,
    required this.description,
    required this.required,
    required this.variableOptionType,
    required this.defaultValue,
    required this.onChangeValue,
  });
}

abstract class VariableOptionType {}

class FunctionType extends VariableOptionType {
  dynamic function;
  FunctionType({
    required this.function,
  });
}

class StringType extends VariableOptionType {
  String? mask;
  StringType({
    this.mask,
  });
}

class EnumType extends VariableOptionType {}

class ColorType extends VariableOptionType {}

class RangeIntIntervalType extends VariableOptionType {
  int begin;
  int end;
  RangeIntIntervalType(
    this.begin,
    this.end,
  );
}

class RangeDoubleIntervalType extends VariableOptionType {
  double begin;
  double end;
  RangeDoubleIntervalType(
    this.begin,
    this.end,
  );
}

class HtmlType extends VariableOptionType {
  bool canUpdateOnChange = false;
}

class WrapType extends VariableOptionType {}

class DefaultType extends VariableOptionType {}

class ObjectInObjectType extends VariableOptionType {
  List<AttributeDto> children;
  ObjectInObjectType({
    required this.children,
  });
}

class VariableOption {
  dynamic value;
  final String? _textInDisplay;
  final String? _textInSelectedOptions;
  bool ignoreInDisplay;
  bool ignoreInSelectedOptions;

  String get textInSelectedOptions {
    return _textInSelectedOptions ?? _textInDisplay ?? value.toString();
  }

  String get textInDisplay {
    return _textInDisplay ?? value.toString();
  }

  VariableOption({
    required this.value,
    this.ignoreInDisplay = false,
    this.ignoreInSelectedOptions = false,
    String? textInDisplay,
    String? textInSelectedOptions,
  })  : _textInDisplay = textInDisplay,
        _textInSelectedOptions = textInSelectedOptions;

  VariableOption copyWith({
    dynamic value,
    String? textInDisplay,
    String? textInSelectedOptions,
  }) {
    return VariableOption(
      value: value,
      textInDisplay: textInDisplay ?? _textInDisplay,
      textInSelectedOptions: textInSelectedOptions ?? _textInSelectedOptions,
    );
  }
}
