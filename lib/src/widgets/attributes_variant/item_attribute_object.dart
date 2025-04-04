import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

import '../custom_chip_selected.dart';
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
            final value = UtilsReflectable.updateValue(
              widget.attribute.selectedValue?.value,
              nameVariavel: ettribute.name,
              novoValor: ettribute.selectedValue?.value,
            );

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

    return Row(
      children: [
        Expanded(
          child: _buildChangeAction(
            context,
            widget.attribute,
            widget.attributes,
          ),
        ),
        _isVariableNubable(widget.attribute, widget.attributes),
      ],
    );
  }

  Widget _buildChangeAction(
    BuildContext context,
    AttributeDto e,
    List<AttributeDto> attributes,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 8,
        runAlignment: WrapAlignment.start,
        runSpacing: 8,
        children: e.variableOptions!
            .map(
              (e2) => CustomChipSelected(
                  label: e2.textInSelectedOptions,
                  selected: e.selectedValue?.value == e2.value,
                  onTap: () {
                    if (widget.onAttributes != null) {
                      e.selectedValue = e2;

                      setState(() {
                        widget.onAttributes!(attributes, e);
                        e.onChangeValue?.call(e);
                      });
                    }
                  }),
            )
            .toList(),
      ),
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
