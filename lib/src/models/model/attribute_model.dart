// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:storybook_ds/src/utils/utils.dart';

typedef OnChangeValue = void Function(AttributeModel value);

class AttributeModel {
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

  factory AttributeModel({
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

    return AttributeModel._raw(
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

  factory AttributeModel.rangeIntInterval({
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
    return AttributeModel._raw(
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

  factory AttributeModel.objectInObject({
    required String type,
    required String name,
    required VariableOption selectedValue,
    String? description,
    bool canBeNull = false,
    List<String> builders = const [''],
    bool required = false,
    VariableOption? defaultValue,
    OnChangeValue? onChangeValue,
    List<AttributeModel> children = const [],
    List<VariableOption>? variableOptions,
    StorybookNestedMerge? merge,
  }) {
    variableOptions ??= [selectedValue];
    return AttributeModel._raw(
      type: '$type${canBeNull ? '?' : ''}',
      name: name,
      variableOptions: variableOptions,
      selectedValue: selectedValue,
      defaultValue: defaultValue,
      builders: builders,
      description: description,
      required: required,
      variableOptionType: ObjectInObjectType(children: children, merge: merge),
      onChangeValue: onChangeValue,
    );
  }

  factory AttributeModel.string({
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
    return AttributeModel._raw(
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

  factory AttributeModel.enumType({
    required String name,
    required List<Enum> values,
    bool canBeNull = false,
    String? description,
    List<String> builders = const [''],
    bool required = false,
    void Function(AttributeModel)? onChangeValue,
    Enum? selectedValue,
    Enum? defaultValue,
  }) {
    return AttributeModel._raw(
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

  factory AttributeModel.function({
    required dynamic function,
    required String name,
    bool canBeNull = false,
    String? description,
    List<FunctionCallbackScenario> scenarios = const [],
    List<String> builders = const [''],
    bool required = false,
    OnChangeValue? onChangeValue,
  }) {
    return AttributeModel._raw(
      type: 'Function${canBeNull ? '?' : ''}',
      name: name,
      variableOptions: [],
      selectedValue: VariableOption(value: null),
      defaultValue: VariableOption(value: null),
      builders: builders,
      description: description,
      required: required,
      variableOptionType: FunctionType(
        function: function,
        scenarios: scenarios,
      ),
      onChangeValue: onChangeValue,
    );
  }

  factory AttributeModel.rangeDoubleInterval({
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
    return AttributeModel._raw(
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

  factory AttributeModel.color({
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
    return AttributeModel._raw(
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

  AttributeModel._raw({
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

  /// Comparação por conteúdo para permitir que o `ValueListenableBuilder`
  /// da `Storybook` reconstrua quando o usuário altera um atributo.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AttributeModel) return false;
    if (type != other.type) return false;
    if (name != other.name) return false;
    if (description != other.description) return false;
    if (required != other.required) return false;
    if (variableOptionType != other.variableOptionType) return false;
    if (builders.length != other.builders.length) return false;
    for (var i = 0; i < builders.length; i++) {
      if (builders[i] != other.builders[i]) return false;
    }
    if (variableOptions?.length != other.variableOptions?.length) {
      return false;
    }
    for (var i = 0; i < (variableOptions?.length ?? 0); i++) {
      if (variableOptions![i] != other.variableOptions![i]) return false;
    }
    if (defaultValue != other.defaultValue) return false;
    if (selectedValue != other.selectedValue) return false;
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      name,
      description,
      required,
      variableOptionType,
      Object.hashAll(builders),
      Object.hashAll(variableOptions ?? const []),
      defaultValue,
      selectedValue,
    );
  }
}

abstract class VariableOptionType {}

class FunctionCallbackScenario {
  final String label;
  final IconData? icon;
  final List<Object?> args;

  const FunctionCallbackScenario({
    required this.label,
    this.icon,
    this.args = const [],
  });
}

class FunctionType extends VariableOptionType {
  dynamic function;
  List<FunctionCallbackScenario> scenarios;

  FunctionType({
    required this.function,
    this.scenarios = const [],
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

typedef StorybookNestedMerge = Object? Function(
  Object instance,
  String fieldName,
  dynamic newValue,
);

class ObjectInObjectType extends VariableOptionType {
  List<AttributeModel> children;
  final StorybookNestedMerge? merge;

  ObjectInObjectType({
    required this.children,
    this.merge,
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VariableOption) return false;
    return value == other.value;
  }

  @override
  int get hashCode => Object.hash(value, runtimeType);
}
