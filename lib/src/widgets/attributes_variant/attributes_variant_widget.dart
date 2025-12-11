import 'package:flutter/material.dart';

import '../../../storybook_ds.dart';
import 'attribute_variant.dart';

/// Constants for attributes variant widget styling
class _AttributesVariantWidgetConstants {
  static const double topPadding = 16.0;
  static const double bottomPadding = 16.0;
  static const double itemTopPadding = 8.0;
  static const double bottomSpacing = 16.0;
  static const double borderRadius = 8.0;
  static const double borderWidth = 1.0;
}

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
                padding: const EdgeInsets.only(
                  top: _AttributesVariantWidgetConstants.itemTopPadding,
                ),
                child: Container(
                  decoration: widget.enabledBorder
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            _AttributesVariantWidgetConstants.borderRadius,
                          ),
                          border: Border.all(
                            width: _AttributesVariantWidgetConstants.borderWidth,
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
        const SizedBox(
          height: _AttributesVariantWidgetConstants.bottomSpacing,
        ),
      ],
    );
  }

  /// Builds the title widget.
  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: _AttributesVariantWidgetConstants.topPadding,
        bottom: _AttributesVariantWidgetConstants.bottomPadding,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
