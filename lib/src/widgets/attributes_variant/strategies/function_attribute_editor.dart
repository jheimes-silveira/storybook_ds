import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/model/attribute_model.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/item_attribute_function.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_editor_strategy.dart';

/// Estratégia para atributos do tipo `Function?` (callbacks).
///
/// Aceita **apenas** atributos cujo [VariableOptionType] materializado
/// seja [FunctionType]. Tipos cujo `type` (string) contém a palavra
/// "Function" mas cujo `variableOptionType` não é [FunctionType] caem
/// no editor default (chips genéricos) — em vez de exibir a mensagem
/// "Tipo inválido para atributo de função".
///
/// RN-09.2: `handles` é restrito a `variableOptionType is FunctionType`.
class FunctionAttributeEditor implements AttributeEditorStrategy {
  const FunctionAttributeEditor();

  @override
  String get id => 'function';

  @override
  int get priority => 100;

  @override
  bool handles(AttributeModel attribute) {
    return attribute.variableOptionType is FunctionType;
  }

  @override
  Widget build(EditorContext context) {
    return ItemAttributeFunction(
      key: context.widgetKey,
      attribute: context.attribute,
      attributes: context.attributes,
      onAttributes: context.onChanged,
    );
  }
}
