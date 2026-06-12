import 'package:flutter/material.dart';

import '../../../storybook_ds.dart';
import 'attribute_variant.dart';

class AttributesVariantWidget extends StatelessWidget {
  final List<AttributeModel> attributes;
  final bool enabledBorder;
  final String? title;
  final Function(
    List<AttributeModel> attributes,
    AttributeModel attribute,
  )? onAttributes;
  final String? constructor;

  /// Barramento de mudanças da `Storybook` dona deste widget, propagado
  /// para cada [AttributeVariant] para reatividade em tempo real.
  final AttributeChangeBus changeBus;

  const AttributesVariantWidget({
    super.key,
    required this.attributes,
    required this.onAttributes,
    required this.changeBus,
    this.enabledBorder = true,
    this.title,
    this.constructor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = StorybookThemeScope.of(context);
    final filteredAttributes = attributes
        .where(
          (e) => e.builders.isEmpty || e.builders.contains(constructor ?? ''),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (title != null) _buildTitle(context, title!),
        ...filteredAttributes.asMap().entries.map(
              (entry) => Padding(
                key: ValueKey(entry.value.name),
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  decoration: enabledBorder
                      ? BoxDecoration(
                          borderRadius: theme.panelBorderRadius,
                          border: Border.all(
                            width: theme.panelBorderWidth,
                            color: theme.panelBorderColor,
                          ),
                        )
                      : null,
                  child: AttributeVariant(
                    key: ValueKey('attribute-variant-${entry.value.name}'),
                    attribute: entry.value,
                    attributes: attributes,
                    onAttributes: onAttributes,
                    constructor: constructor,
                    changeBus: changeBus,
                  ),
                ),
              ),
            ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Builds the title widget.
  Widget _buildTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
