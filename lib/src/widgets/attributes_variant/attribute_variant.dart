import 'package:flutter/material.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/item_attribute_number.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/item_attribute_string.dart';

import '../../../storybook_ds.dart';
import 'item_attribute_default.dart';
import 'item_attribute_function.dart';
import 'item_attribute_object.dart';

class AttributeVariant extends StatefulWidget {
  final List<AttributeDto> attributes;
  final AttributeDto attribute;
  final Function(List<AttributeDto> attributes, AttributeDto attribute)?
      onAttributes;
  final String? constructor;

  const AttributeVariant({
    super.key,
    required this.attribute,
    required this.attributes,
    required this.onAttributes,
    this.constructor,
  });

  @override
  State<AttributeVariant> createState() => _AttributeVariantState();
}

class _AttributeVariantState extends State<AttributeVariant> {
// create some values
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.only(left: 8),
      tilePadding: const EdgeInsets.only(left: 8, right: 8),
      expandedAlignment: Alignment.centerLeft,
      onExpansionChanged: (value) async {
        if (widget.attribute.variableOptionType is HtmlType) {
          final html = (widget.attribute.variableOptionType as HtmlType);
          html.canUpdateOnChange = false;
        }
      },
      title: Row(
        children: [
          _buildTypeDescription(widget.attribute, context),
          const SizedBox(width: 8),
          _buildNameDescription(widget.attribute, context),
          const SizedBox(width: 8),
          _buildIsRequired(widget.attribute, context),
          const SizedBox(width: 8),
          if (_canBuildVariableOptionTypeBool(widget.attribute))
            _buildVariableOptionTypeBool(widget.attribute, widget.attributes),
        ],
      ),
      // leading: Container(),
      trailing: _canBuildVariableOptionTypeBool(widget.attribute)
          ? _isVariableNubable(widget.attribute, widget.attributes)
          : (_canBuildVariableOption(widget.attribute)
              ? null
              : const SizedBox()),

      children: [
        _buildChangeAction(context, widget.attribute, widget.attributes),
      ],
    );
  }

  Widget _buildIsRequired(AttributeDto e, BuildContext context) {
    return e.required
        ? Text(
            'Obrigatório *',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold, color: Colors.redAccent),
          )
        : const SizedBox();
  }

  Widget _buildNameDescription(AttributeDto e, BuildContext context) {
    return Text(
      e.name,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildTypeDescription(AttributeDto e, BuildContext context) {
    return Text(
      e.type,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildChangeAction(
    BuildContext context,
    AttributeDto e,
    List<AttributeDto> attributes,
  ) {
    if (widget.attribute.variableOptionType is StringType ||
        widget.attribute.type.contains('String')) {
      return ItemAttributeString(
        attribute: widget.attribute,
        attributes: widget.attributes,
        onAttributes: widget.onAttributes,
      );
    }

    if (widget.attribute.type.contains('bool')) {
      return Container();
    }

    if (e.variableOptionType is RangeDoubleIntervalType ||
        e.variableOptionType is RangeIntIntervalType) {
      return ItemAttributeNumber(
        attribute: widget.attribute,
        attributes: widget.attributes,
        onAttributes: widget.onAttributes,
      );
    }

    if (e.variableOptionType is FunctionType) {
      return ItemAttributeFunction(
        attribute: widget.attribute,
        attributes: widget.attributes,
        onAttributes: widget.onAttributes,
      );
    }

    if (widget.attribute.variableOptionType is ObjectInObjectType) {
      return ItemAttributeObject(
        attribute: widget.attribute,
        attributes: widget.attributes,
        onAttributes: widget.onAttributes,
      );
    }

    return ItemAttributeDefault(
      attribute: widget.attribute,
      attributes: widget.attributes,
      onAttributes: widget.onAttributes,
    );
  }

  bool _canBuildVariableOption(AttributeDto e) {
    return e.type == 'String' ||
        e.type == 'String?' ||
        e.type == 'bool' ||
        e.type == 'bool?' ||
        e.variableOptionType is RangeIntIntervalType ||
        e.variableOptionType is RangeDoubleIntervalType ||
        e.variableOptions != null;
  }

  bool _canBuildVariableOptionTypeBool(AttributeDto e) {
    return e.type == 'bool' || e.type == 'bool?';
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

  Widget _buildVariableOptionTypeBool(
    AttributeDto e,
    List<AttributeDto> attributes,
  ) {
    return Opacity(
      opacity: e.selectedValue?.value == null ? 0.5 : 1,
      child: IgnorePointer(
        ignoring: e.selectedValue?.value == null,
        child: Switch(
          value: e.selectedValue?.value ?? false,
          onChanged: (value) {
            e.selectedValue?.value = value;
            setState(() {
              widget.onAttributes!(attributes, e);
              e.onChangeValue?.call(e);
            });
          },
        ),
      ),
    );
  }
}
