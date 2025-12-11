import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/dto/attribute_dto.dart';

import '../custom_chip_selected.dart';

/// Constants for string attribute item styling
class _ItemAttributeStringConstants {
  static const double rightPadding = 16.0;
  static const double bottomPadding = 16.0;
  static const double topPadding = 8.0;
  static const double borderRadius = 8.0;
  static const double chipSpacing = 8.0;
}

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
  late final TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(
      text: widget.attribute.selectedValue?.value ?? '',
    );
    _inputController.selection = TextSelection.fromPosition(
      TextPosition(offset: _inputController.text.length),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildChangeAction(),
        ),
        _buildNullableSwitch(),
      ],
    );
  }

  /// Builds the change action widget with text field and options.
  Widget _buildChangeAction() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: _ItemAttributeStringConstants.bottomPadding,
        right: _ItemAttributeStringConstants.rightPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(_ItemAttributeStringConstants.borderRadius),
                ),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            key: Key(widget.attribute.name),
            controller: _inputController,
            enabled: widget.attribute.selectedValue?.value != null,
            onChanged: (text) => _handleTextChange(text),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: _ItemAttributeStringConstants.bottomPadding,
              top: _ItemAttributeStringConstants.topPadding,
            ),
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: _ItemAttributeStringConstants.chipSpacing,
              runAlignment: WrapAlignment.start,
              runSpacing: _ItemAttributeStringConstants.chipSpacing,
              children: widget.attribute.variableOptions!
                  .map(
                    (option) => CustomChipSelected(
                      label: option.textInSelectedOptions,
                      selected: widget.attribute.selectedValue?.value == option.value,
                      onTap: () => _handleOptionTap(option),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the nullable switch widget if the attribute is nullable.
  Widget _buildNullableSwitch() {
    if (widget.attribute.variableOptionType is HtmlType) {
      return const SizedBox.shrink();
    }
    
    if (widget.attribute.type.contains('?')) {
      return Switch(
        value: widget.attribute.selectedValue?.value != null,
        onChanged: (value) => _handleNullableSwitchChange(value),
      );
    }

    return const SizedBox.shrink();
  }

  /// Handles text field value change.
  void _handleTextChange(String text) {
    if (widget.onAttributes == null) return;

    widget.attribute.selectedValue = widget.attribute.selectedValue?.copyWith(
      value: text,
    );
    setState(() {
      widget.onAttributes!(widget.attributes, widget.attribute);
      widget.attribute.onChangeValue?.call(widget.attribute);
      _inputController.selection = TextSelection.fromPosition(
        TextPosition(offset: _inputController.selection.baseOffset),
      );
    });
  }

  /// Handles option chip tap.
  void _handleOptionTap(VariableOption option) {
    if (widget.onAttributes == null) return;

    widget.attribute.selectedValue = option;
    _inputController.text = option.value;
    setState(() {
      widget.onAttributes!(widget.attributes, widget.attribute);
      widget.attribute.onChangeValue?.call(widget.attribute);
    });
  }

  /// Handles nullable switch change.
  void _handleNullableSwitchChange(bool value) {
    widget.attribute.selectedValue = value 
        ? widget.attribute.variableOptions!.first 
        : null;
    setState(() {
      widget.onAttributes!(widget.attributes, widget.attribute);
      widget.attribute.onChangeValue?.call(widget.attribute);
    });
  }
}
