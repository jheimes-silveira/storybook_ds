import 'package:flutter/material.dart';

import '../../../storybook_ds.dart';
import 'attribute_variant.dart';

class AttributesVariantWidget extends StatefulWidget {
  final List<AttributeDto> attributes;
  final bool enabledBorder;
  final String? title;
  final Function(
    List<AttributeDto> attributes,
    AttributeDto attribute,
  )? onAttributes;
  final String? constructor;

  const AttributesVariantWidget({
    super.key,
    required this.attributes,
    required this.onAttributes,
    this.enabledBorder = true,
    this.title,
    this.constructor,
  });

  @override
  State<AttributesVariantWidget> createState() =>
      _AttributesVariantWidgetState();
}

class _AttributesVariantWidgetState extends State<AttributesVariantWidget> {
// create some values
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (widget.title != null) _buildTitle(widget.title!),
        ...widget.attributes
            .where(
              (e) =>
                  e.builders.isEmpty ||
                  e.builders.contains(widget.constructor ?? ''),
            )
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  decoration: widget.enabledBorder
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                  child: AttributeVariant(
                    attribute: e,
                    attributes: widget.attributes,
                    onAttributes: widget.onAttributes,
                  ),
                ),
              ),
            ),
        const SizedBox(height: 16),
      ],
    );
  }

  Padding _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
