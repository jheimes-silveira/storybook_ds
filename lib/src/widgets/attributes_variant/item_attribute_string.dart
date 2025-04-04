import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/dto/attribute_dto.dart';

import '../custom_chip_selected.dart';

class ItemAttributeString extends StatefulWidget {
  final AttributeDto attribute;
  final List<AttributeDto> attributes;
  final Function(
    List<AttributeDto> attributes,
    AttributeDto currentAtribute,
  )? onAttributes;
  const ItemAttributeString({
    super.key,
    required this.attribute,
    required this.attributes,
    this.onAttributes,
  });

  @override
  State<ItemAttributeString> createState() => _ItemAttributeStringState();
}

class _ItemAttributeStringState extends State<ItemAttributeString> {
  final input = TextEditingController();
  @override
  void initState() {
    super.initState();

    input.text = widget.attribute.selectedValue?.value ?? '';

    input.selection = TextSelection.fromPosition(
      TextPosition(
        offset: input.text.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildChangeAction(),
        ),
        _isVariableNubable(widget.attribute, widget.attributes),
      ],
    );
  }

  Widget _buildChangeAction() {
    final e = widget.attribute;
    final attributes = widget.attributes;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            key: Key(e.name),
            controller: input,
            enabled: e.selectedValue?.value == null ? false : true,
            onChanged: (text) {
              if (widget.onAttributes != null) {
                e.selectedValue = e.selectedValue?.copyWith(
                  value: text,
                );
                setState(() {
                  widget.onAttributes!(attributes, e);
                  e.onChangeValue?.call(e);
                  input.selection = TextSelection.fromPosition(
                    TextPosition(offset: input.selection.baseOffset),
                  );
                });
              }
            },
          ),
          Padding(
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
                            input.text = e2.value;
                            setState(() {
                              widget.onAttributes!(attributes, e);
                              e.onChangeValue?.call(e);
                            });
                          }
                        }),
                  )
                  .toList(),
            ),
          ),
        ],
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
