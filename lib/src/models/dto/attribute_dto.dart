import '../model/attribute_model.dart';

export '../model/attribute_model.dart' show
  VariableOption,
  VariableOptionType,
  FunctionCallbackScenario,
  FunctionType,
  StringType,
  EnumType,
  ColorType,
  RangeIntIntervalType,
  RangeDoubleIntervalType,
  HtmlType,
  WrapType,
  DefaultType,
  StorybookNestedMerge,
  ObjectInObjectType;

@Deprecated('Use AttributeModel instead. This will be removed in a future version.')
typedef AttributeDto = AttributeModel;
