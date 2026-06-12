import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/model/attribute_model.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_editor_strategy.dart';

/// Estratégia para atributos do tipo `bool` / `bool?`.
///
/// Para bools, o switch já está integrado ao **título** do `AttributeVariant`
/// (ver [_BoolToggle] lá). Esta estratégia renderiza apenas um hint textual
/// indicando o valor atual, evitando duplicar a UI de toggle.
class BoolAttributeEditor implements AttributeEditorStrategy {
  const BoolAttributeEditor();

  @override
  String get id => 'bool';

  @override
  int get priority => 100;

  @override
  bool handles(AttributeModel attribute) {
    return attribute.type == 'bool' || attribute.type == 'bool?';
  }

  @override
  Widget build(EditorContext context) {
    final value = context.attribute.selectedValue?.value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        value == null ? 'Valor: null' : 'Valor: $value',
        style: Theme.of(context.buildContext).textTheme.bodySmall,
      ),
    );
  }
}
