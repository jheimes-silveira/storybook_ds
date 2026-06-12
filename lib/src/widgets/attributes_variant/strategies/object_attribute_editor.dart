import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/model/attribute_model.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/item_attribute_object.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_editor_strategy.dart';

/// Estratégia para atributos aninhados (objetos em objetos).
/// Delega ao widget [ItemAttributeObject].
class ObjectAttributeEditor implements AttributeEditorStrategy {
  const ObjectAttributeEditor();

  @override
  String get id => 'object';

  @override
  int get priority => 100;

  @override
  bool handles(AttributeModel attribute) {
    return attribute.variableOptionType is ObjectInObjectType;
  }

  @override
  Widget build(EditorContext context) {
    return ItemAttributeObject(
      key: context.widgetKey,
      attribute: context.attribute,
      attributes: context.attributes,
      onAttributes: context.onChanged,
      changeBus: context.changeBus,
    );
  }
}
