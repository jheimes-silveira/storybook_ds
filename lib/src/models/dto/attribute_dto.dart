// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

typedef OnChangeValue = void Function(AttributeDto value);

class AttributeDto {
  final String type;
  final String name;
  final String? description;
  final List<VariableOption>? variableOptions;
  final List<String?> builders;
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
    List<String?> builders = const [],
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
    List<String?> builders = const [],
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
  factory AttributeDto.string({
    required String name,
    bool canBeNull = false,
    String? description,
    List<String?> builders = const [],
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
  factory AttributeDto.function({
    required dynamic function,
    required String name,
    bool canBeNull = false,
    String? description,
    List<String?> builders = const [],
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
    List<String?> builders = const [],
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
    List<String?> builders = const [],
    bool required = false,
    Color? selectedValue,
    Color? defaultValue,
    OnChangeValue? onChangeValue,
  }) {
    return AttributeDto._raw(
      type: 'Color${canBeNull ? '?' : ''}',
      name: name,
      variableOptions: [VariableOption(value: Colors.white)],
      selectedValue: VariableOption(value: selectedValue),
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

  String get toStringValue {
    if (type.contains('String') && selectedValue?.value != null) {
      return '\'${selectedValue?.textInDisplay ?? selectedValue?.value}\'';
    }
    return '${selectedValue?.textInDisplay ?? selectedValue?.value}';
  }
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