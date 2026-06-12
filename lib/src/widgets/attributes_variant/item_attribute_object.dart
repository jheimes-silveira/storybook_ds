import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

import 'attributes_variant_widget.dart';

/// Widget de input para atributos do tipo objeto (ObjectInObjectType).
///
/// Renderiza um [AttributesVariantWidget] aninhado para editar os filhos.
/// Mostra um hint amigável caso a função `merge` não esteja configurada
/// (em vez de lançar [StateError] que crasharia o painel).
class ItemAttributeObject extends StatefulWidget {
  final AttributeModel attribute;
  final List<AttributeModel> attributes;
  final Function(
    List<AttributeModel> attributes,
    AttributeModel currentAtribute,
  )? onAttributes;
  final AttributeChangeBus? changeBus;
  const ItemAttributeObject({
    super.key,
    required this.attribute,
    required this.attributes,
    this.onAttributes,
    this.changeBus,
  });

  @override
  State<ItemAttributeObject> createState() => _ItemAttributeObjectState();
}

class _ItemAttributeObjectState extends State<ItemAttributeObject> {
  @override
  Widget build(BuildContext context) {
    final variableType = widget.attribute.variableOptionType;
    if (variableType is! ObjectInObjectType) {
      return const _InvalidTypeHint();
    }

    final hasMerge = variableType.merge != null;
    final hasCurrent = widget.attribute.selectedValue?.value != null;
    final bus = widget.changeBus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!hasMerge)
          const _MissingMergeHint()
        else if (bus != null && hasCurrent)
          AttributesVariantWidget(
            attributes: variableType.children,
            onAttributes: (attributes, child) =>
                _handleChildChange(variableType, child, attributes),
            enabledBorder: false,
            changeBus: bus,
          )
        else
          // Sem bus ou sem valor atual, renderiza um placeholder
          // seguro (não quebra o painel). O hint de "Ative o switch
          // acima..." para o caso de valor null é mostrado de forma
          // centralizada pelo `AttributeVariant`.
          const _NestedBusMissingHint(),
      ],
    );
  }

  void _handleChildChange(
    ObjectInObjectType objectType,
    AttributeModel child,
    List<AttributeModel> _,
  ) {
    final merge = objectType.merge;
    final current = widget.attribute.selectedValue?.value;
    if (merge == null || current == null) return;

    final newValue = merge(current, child.name, child.selectedValue?.value);
    if (widget.attribute.selectedValue == null) {
      widget.attribute.selectedValue = VariableOption(value: newValue);
    } else {
      widget.attribute.selectedValue =
          widget.attribute.selectedValue!.copyWith(value: newValue);
    }
    widget.onAttributes?.call(widget.attributes, widget.attribute);
    widget.attribute.onChangeValue?.call(widget.attribute);
  }
}

class _InvalidTypeHint extends StatelessWidget {
  const _InvalidTypeHint();

  @override
  Widget build(BuildContext context) {
    return const _HintBanner(
      icon: Icons.error_outline,
      color: Colors.red,
      message: 'Tipo de atributo inválido para objeto aninhado.',
    );
  }
}

class _MissingMergeHint extends StatelessWidget {
  const _MissingMergeHint();

  @override
  Widget build(BuildContext context) {
    return const _HintBanner(
      icon: Icons.code,
      color: Colors.orange,
      message:
          'Função `merge` ausente. Use a anotação @StorybookModel + build_runner '
          'ou forneça `merge` manualmente no AttributeModel.objectInObject.',
    );
  }
}

class _HintBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;
  const _HintBanner({
    required this.icon,
    required this.color,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _NestedBusMissingHint extends StatelessWidget {
  const _NestedBusMissingHint();
  @override
  Widget build(BuildContext context) {
    return const _HintBanner(
      icon: Icons.info_outline,
      color: Colors.grey,
      message:
          'Editor aninhado indisponível: bus de mudanças ausente no contexto.',
    );
  }
}
