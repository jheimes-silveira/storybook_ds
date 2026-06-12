import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/model/attribute_model.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/item_attribute_number.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_editor_strategy.dart';

/// Estratégia para atributos cujo `variableOptionType` é um range
/// (int ou double). Delega ao widget [ItemAttributeNumber].
class NumberAttributeEditor implements AttributeEditorStrategy {
  const NumberAttributeEditor();

  @override
  String get id => 'number';

  @override
  int get priority => 100;

  @override
  bool handles(AttributeModel attribute) {
    return attribute.variableOptionType is RangeDoubleIntervalType ||
        attribute.variableOptionType is RangeIntIntervalType;
  }

  @override
  Widget build(EditorContext context) {
    return ItemAttributeNumber(
      key: context.widgetKey,
      attribute: context.attribute,
      attributes: context.attributes,
      onAttributes: context.onChanged,
    );
  }
}
