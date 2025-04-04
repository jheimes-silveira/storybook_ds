import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/dto/attribute_dto.dart';

import '../custom_chip_selected.dart';

class ItemAttributeDefault extends StatefulWidget {
  final AttributeDto attribute;
  final List<AttributeDto> attributes;
  final Function(
    List<AttributeDto> attributes,
    AttributeDto currentAtribute,
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
    if (e.variableOptionType is HtmlType) {
      return const SizedBox();
    }
    if (e.type.contains('?')) {
      return Switch(
        value: e.selectedValue?.value == null ? false : true,
        onChanged: (value) {
          e.selectedValue = value ? (e.variableOptions![0]) : null;
          setState(() {
            widget.onAttributes!(attributes, e);
            e.onChangeValue?.call(e);
          });
        },
      );
    }

    return const SizedBox();
  }
}
