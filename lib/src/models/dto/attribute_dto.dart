// ignore_for_file: public_member_api_docs, sort_constructors_first
class AttributeDto {
  final String type;
  final String name;
  final String? description;
  final List<VariableOption>? variableOptions;
  final List<String?> builders;
  final VariableOptionType variableOptionType;
  final bool required;
  final VariableOption? defaultValue;

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
    );
  }

  factory AttributeDto.rangeIntInterval({
    required int begin,
    required int end,
    required String type,
    required String name,
    String? description,
    List<String?> builders = const [],
    bool required = false,
    int? selectedValue,
    int? defaultValue,
  }) {
    return AttributeDto._raw(
      type: type,
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
    );
  }
  factory AttributeDto.rangeDoubleInterval({
    required double begin,
    required double end,
    required String type,
    required String name,
    String? description,
    List<String?> builders = const [],
    bool required = false,
    double? selectedValue,
    double? defaultValue,
  }) {
    return AttributeDto._raw(
      type: type,
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
  });

  String get toStringValue {
    if (type.contains('String') && selectedValue?.value != null) {
      return '\'${selectedValue?.textInDisplay ?? selectedValue?.value}\'';
    }
    return '${selectedValue?.textInDisplay ?? selectedValue?.value}';
  }
}

abstract class VariableOptionType {}

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
