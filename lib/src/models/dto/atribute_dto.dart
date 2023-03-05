// ignore_for_file: public_member_api_docs, sort_constructors_first
class AtributeDto {
  final String type;
  final String name;
  final String? description;
  final List<VariableOption>? variableOptions;
  final List<String?>? builders;
  final VariableOptionType variableOptionType;
  final bool required;

  VariableOption? selectedValue;

  factory AtributeDto({
    required String type,
    required String name,
    String? description,
    List<VariableOption>? variableOptions,
    List<String?>? builders,
    bool required = false,
    VariableOption? selectedValue,
  }) {
    return AtributeDto._raw(
      type: type,
      name: name,
      variableOptions: variableOptions,
      selectedValue: selectedValue,
      builders: builders,
      description: description,
      required: required,
      variableOptionType: DefaultType(),
    );
  }

  factory AtributeDto.rangeIntInterval({
    required int begin,
    required int end,
    required String type,
    required String name,
    String? description,
    List<String?>? builders,
    bool required = false,
    VariableOption? selectedValue,
  }) {
    return AtributeDto._raw(
      type: type,
      name: name,
      variableOptions: null,
      selectedValue: selectedValue,
      builders: builders,
      description: description,
      required: required,
      variableOptionType: RangeIntIntervalType(begin, end),
    );
  }
  factory AtributeDto.rangeDoubleInterval({
    required double begin,
    required double end,
    required String type,
    required String name,
    String? description,
    List<String?>? builders,
    bool required = false,
    VariableOption? selectedValue,
  }) {
    return AtributeDto._raw(
      type: type,
      name: name,
      variableOptions: null,
      selectedValue: selectedValue,
      builders: builders,
      description: description,
      required: required,
      variableOptionType: RangeDoubleIntervalType(begin, end),
    );
  }
  factory AtributeDto.wrap({
    required String type,
    required String name,
    required List<VariableOption> variableOptions,
    String? description,
    List<String?>? builders,
    bool required = false,
    VariableOption? selectedValue,
  }) {
    return AtributeDto._raw(
      type: type,
      name: name,
      variableOptions: variableOptions,
      selectedValue: selectedValue,
      builders: builders,
      description: description,
      required: required,
      variableOptionType: WrapType(),
    );
  }

  AtributeDto._raw({
    required this.type,
    required this.name,
    required this.variableOptions,
    required this.selectedValue,
    required this.builders,
    required this.description,
    required this.required,
    required this.variableOptionType,
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
