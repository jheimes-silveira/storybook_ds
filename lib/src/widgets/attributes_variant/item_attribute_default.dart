import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/model/attribute_model.dart';

import '../custom_chip_selected.dart';

class ItemAttributeDefault extends StatefulWidget {
  final AttributeModel attribute;
  final List<AttributeModel> attributes;
  final Function(
    List<AttributeModel> attributes,
    AttributeModel currentAtribute,
  )? onAttributes;
  const ItemAttributeDefault({
    super.key,
    required this.attribute,
    required this.attributes,
    this.onAttributes,
  });

  @override
  State<ItemAttributeDefault> createState() => _ItemAttributeDefaultState();
}

class _ItemAttributeDefaultState extends State<ItemAttributeDefault> {

  @override
  Widget build(BuildContext context) {
    // O switch de "pode ser null" é renderizado pelo
    // `_NullableTrailingSwitch` no trailing do `AttributeVariant`
    // (ao lado do nome e tipo), para evitar duplicação.
    return _buildChangeAction(
      context,
      widget.attribute,
      widget.attributes,
    );
  }

  Widget _buildChangeAction(
    BuildContext context,
    AttributeModel e,
    List<AttributeModel> attributes,
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
}
