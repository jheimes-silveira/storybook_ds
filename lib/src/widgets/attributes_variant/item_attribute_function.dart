import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/dto/attribute_dto.dart';

class ItemAttributeFunction extends StatefulWidget {
  final AttributeDto attribute;
  final List<AttributeDto> attributes;
  final Function(
    List<AttributeDto> attributes,
    AttributeDto currentAtribute,
  )? onAttributes;
  const ItemAttributeFunction({
    super.key,
    required this.attribute,
    required this.attributes,
    this.onAttributes,
  });

  @override
  State<ItemAttributeFunction> createState() => _ItemAttributeFunctionState();
}

class _ItemAttributeFunctionState extends State<ItemAttributeFunction> {
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
      child: Text((e.variableOptionType as FunctionType)
          .function
          .runtimeType
          .toString()),
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
