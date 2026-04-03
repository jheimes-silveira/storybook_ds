import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

import 'attributes_variant_widget.dart';

class ItemAttributeObject extends StatefulWidget {
  final AttributeDto attribute;
  final List<AttributeDto> attributes;
  final Function(
    List<AttributeDto> attributes,
    AttributeDto currentAtribute,
  )? onAttributes;
  const ItemAttributeObject({
    super.key,
    required this.attribute,
    required this.attributes,
    this.onAttributes,
  });

  @override
  State<ItemAttributeObject> createState() => _ItemAttributeObjectState();
}

class _ItemAttributeObjectState extends State<ItemAttributeObject> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _isVariableNubable(widget.attribute, widget.attributes),
        AttributesVariantWidget(
          attributes:
              (widget.attribute.variableOptionType as ObjectInObjectType)
                  .children,
          onAttributes: (attributes, ettribute) {
            final objectType = widget.attribute.variableOptionType
                as ObjectInObjectType;
            final merge = objectType.merge;
            final current = widget.attribute.selectedValue?.value;
            if (merge == null || current == null) {
              throw StateError(
                'AttributeDto.objectInObject exige `merge` para editar filhos. '
                'Gere com @StorybookModel + build_runner ou informe merge manualmente.',
              );
            }
            final value = merge(current, ettribute.name, ettribute.selectedValue?.value);

            widget.attribute.selectedValue =
                widget.attribute.selectedValue?.copyWith(value: value);

            widget.onAttributes!(
              widget.attributes,
              widget.attribute,
            );
          },
          enabledBorder: false,
        ),
      ],
    );
  }

  Widget _isVariableNubable(
    AttributeDto e,
    List<AttributeDto> attributes,
  ) {
    if (e.type.contains('?')) {
      return Row(
        children: [
          const Expanded(child: Text('Pode ser null')),
          const SizedBox(width: 16),
          Switch(
            value: e.selectedValue?.value == null ? false : true,
            onChanged: (value) {
              e.selectedValue = value ? (e.variableOptions![0]) : null;
              setState(() {
                widget.onAttributes!(attributes, e);
                e.onChangeValue?.call(e);
              });
            },
          ),
        ],
      );
    }

    return const SizedBox();
  }
}
