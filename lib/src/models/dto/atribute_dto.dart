// ignore_for_file: public_member_api_docs, sort_constructors_first
class AtributeDto {
  final String type;
  final String name;
  final String? description;
  final List<VariableOption>? variableOptions;
  final List<String?>? builders;
  late VariableOptionType variableOptionType;
  final bool required;

  VariableOption? selectedValue;

  AtributeDto({
    required this.type,
    required this.name,
    this.variableOptions,
    this.selectedValue,
    this.builders,
    this.description,
    this.required = false,
    final VariableOptionType? variableOptionType,
  }) : variableOptionType = variableOptionType ?? DefaultType();

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

class DefaultType extends VariableOptionType {}

class VariableOption {
  dynamic value;
  String? textInDisplay;
  String? textInSelectedOptions;
  bool ignoreInDisplay;
  bool ignoreInSelectedOptions;

  VariableOption({
    required this.value,
    this.textInDisplay,
    this.textInSelectedOptions,
    this.ignoreInDisplay = false,
    this.ignoreInSelectedOptions = false,
  });

  VariableOption copyWith({
    dynamic value,
    String? textInDisplay,
    String? textInSelectedOptions,
  }) {
    return VariableOption(
      value: value ?? this.value,
      textInDisplay: textInDisplay ?? this.textInDisplay,
      textInSelectedOptions:
          textInSelectedOptions ?? this.textInSelectedOptions,
    );
  }
}
