import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/dto/attribute_dto.dart';

class ItemAttributeNumber extends StatefulWidget {
  final AttributeDto attribute;
  final List<AttributeDto> attributes;
  final Function(
    List<AttributeDto> attributes,
    AttributeDto currentAtribute,
  )? onAttributes;
  const ItemAttributeNumber({
    super.key,
    required this.attribute,
    required this.attributes,
    this.onAttributes,
  });

  @override
  State<ItemAttributeNumber> createState() => _ItemAttributeNumberState();
}

class _ItemAttributeNumberState extends State<ItemAttributeNumber> {
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
    dynamic va = e.variableOptionType;
    return Row(
      children: [
        Text('${e.selectedValue?.value}'),
        const SizedBox(width: 16),
        const Text('Variação'),
        const SizedBox(width: 16),
        Text('${va.begin}'),
        Expanded(
          child: IgnorePointer(
            ignoring: e.selectedValue?.value == null,
            child: Opacity(
              opacity: e.selectedValue?.value == null ? 0.5 : 1,
              child: Slider(
                max: double.parse('${va.end}'),
                min: double.parse('${va.begin}'),
                value: e.selectedValue?.value ?? va.begin,
                onChanged: (v) {
                  if (e.variableOptionType is RangeDoubleIntervalType) {
                    e.selectedValue?.value =
                        double.parse(v.toStringAsPrecision(2));
                  } else {
                    e.selectedValue?.value = v.toInt();
                  }
                  setState(() {
                    widget.onAttributes!(attributes, e);
                    e.onChangeValue?.call(e);
                  });
                },
              ),
            ),
          ),
        ),
        Text('${va.end}'),
      ],
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
