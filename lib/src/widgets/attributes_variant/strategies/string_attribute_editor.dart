import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/model/attribute_model.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/item_attribute_string.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_editor_strategy.dart';

/// Estratégia para atributos do tipo `String` / `String?`.
///
/// Delega ao widget [ItemAttributeString], que já contém toda a lógica
/// robusta de edição (TextField com sincronização, chips de opções,
/// switch de nulidade).
class StringAttributeEditor implements AttributeEditorStrategy {
  const StringAttributeEditor();

  @override
  String get id => 'string';

  @override
  int get priority => 100;

  @override
  bool handles(AttributeModel attribute) {
    if (attribute.variableOptionType is StringType) return true;
    return attribute.type.contains('String');
  }

  @override
  Widget build(EditorContext context) {
    return ItemAttributeString(
      key: context.widgetKey,
      attribute: context.attribute,
      attributes: context.attributes,
      onAttributes: context.onChanged,
    );
  }
}
