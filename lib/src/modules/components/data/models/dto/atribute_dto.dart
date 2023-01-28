class AtributeDto {
  final String type;
  final String name;
  final String? description;
  final List<VariableOption>? variableOptions;
  final List<String?>? builders;


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
  });

  String get toStringValue {
      if (type.contains('String') && selectedValue?.value != null) {
        return '\'${selectedValue?.textInDisplay ?? selectedValue?.value}\'';
      }
      return '${selectedValue?.textInDisplay ?? selectedValue?.value}';
  }
}

class VariableOption {
  dynamic value;
  String? textInDisplay;
  String? textInSelectedOptions;

  VariableOption({
    required this.value,
    this.textInDisplay,
    this.textInSelectedOptions,
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
