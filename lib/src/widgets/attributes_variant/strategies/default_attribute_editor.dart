import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/model/attribute_model.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/item_attribute_default.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_editor_strategy.dart';

/// Estratégia **fallback** para qualquer [AttributeModel]. Aceita
/// qualquer atributo e delega ao widget [ItemAttributeDefault] (chips).
///
/// Como `priority = 0`, ela só é escolhida quando nenhuma estratégia
/// mais específica reivindicar o atributo.
class DefaultAttributeEditor implements AttributeEditorStrategy {
  const DefaultAttributeEditor();

  @override
  String get id => 'default';

  @override
  int get priority => 0;

  @override
  bool handles(AttributeModel attribute) => true;

  @override
  Widget build(EditorContext context) {
    return ItemAttributeDefault(
      key: context.widgetKey,
      attribute: context.attribute,
      attributes: context.attributes,
      onAttributes: context.onChanged,
    );
  }
}
