import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/multiple_theme_settings.dart';
import 'package:storybook_ds/src/utils/typedef_storybook.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/attributes_variant_widget.dart';

import '../models/dto/attribute_dto.dart';
import 'attributes_theme_widget.dart';
import 'custom_chip_selected.dart';

class ContentWidget extends StatelessWidget {
  final String title;
  final String description;
  final String? constructor;
  final String nameObjectInDisplay;
  final List<AttributeDto> attributes;
  final MultipleThemeSettings? multipleThemeSettings;

  final void Function(
    MultipleThemeSettings multipleThemeSettings,
  )? onUpdateTheme;

  final Function(
    List<AttributeDto> attributes,
    AttributeDto currentAtribute,
  )? onAttributes;

  final Function(String constructor) onSelectedConstructor;
  final String Function(List<AttributeDto> attributes) updatePreviewCode;
  final OnBuildExtraAttributesConfigCustom? extraAttributesConfigCustom;

  const ContentWidget({
    super.key,
    required this.title,
    required this.description,
    required this.attributes,
    required this.nameObjectInDisplay,
    required this.onSelectedConstructor,
    required this.updatePreviewCode,
    this.onAttributes,
    this.constructor,
    this.multipleThemeSettings,
    this.onUpdateTheme,
    this.extraAttributesConfigCustom,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 48,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTitle(context),
            _buildDescription(context),
            _buildBuilders(context, attributes),
            if (extraAttributesConfigCustom != null) ...[
              const SizedBox(height: 12),
              extraAttributesConfigCustom!(context)
            ],
            _buildAttributesTheme(multipleThemeSettings),
            _buildAttributesVariant(attributes),
            // _buildPreviewCode(context),
          ],
        ),
      ),
    );
  }

  Padding _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: SelectableText(
        description,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Text _buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  _buildBuilders(BuildContext context, List<AttributeDto> attributes) {
    List<String> builders = [];
    for (var e in attributes) {
      if (e.builders.isNotEmpty) {
        for (var e2 in e.builders) {
          if (!builders.contains(e2)) {
            builders.add(e2);
          }
        }
      } else if (!builders.contains('')) {
        builders.insert(0, '');
      }
    }

    if (builders.isNotEmpty &&
        !builders.contains(null) &&
        constructor == null) {
      Future.delayed(const Duration(milliseconds: 50))
          .then((_) => onSelectedConstructor(builders[0]));
    }

    return Builders(
      builders: builders,
      attributes: attributes,
      initConstructor: constructor,
      onAttributes: onAttributes,
      onSelectedConstructor: onSelectedConstructor,
    );
  }

  Widget _buildAttributesVariant(List<AttributeDto> attributes) {
    return AttributesVariantWidget(
      attributes: attributes,
      onAttributes: onAttributes,
      constructor: constructor,
      title: '',
    );
  }

  Widget _buildAttributesTheme(MultipleThemeSettings? multipleThemeSettings) {
    if (multipleThemeSettings == null ||
        multipleThemeSettings.selectableThemes.isEmpty ||
        onUpdateTheme == null) {
      return const SizedBox();
    }

    return AttributesThemeWidget(
      themeSettings: multipleThemeSettings,
      onUpdateTheme: onUpdateTheme!,
    );
  }
}

class Builders extends StatefulWidget {
  const Builders({
    super.key,
    required this.builders,
    required this.initConstructor,
    required this.onAttributes,
    required this.attributes,
    required this.onSelectedConstructor,
  });

  final List<String> builders;
  final String? initConstructor;
  final Function(List<AttributeDto> attributes, AttributeDto currentAtribute)?
      onAttributes;
  final List<AttributeDto> attributes;
  final Function(String constructor) onSelectedConstructor;

  @override
  State<Builders> createState() => _BuildersState();
}

class _BuildersState extends State<Builders> {
  late String? _constructor;

  @override
  void initState() {
    _constructor = widget.initConstructor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Construtores",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 8,
            runAlignment: WrapAlignment.start,
            runSpacing: 8,
            children: widget.builders
                .map(
                  (e2) => CustomChipSelected(
                    label: e2.isEmpty ? 'default' : e2,
                    selected: _constructor == e2,
                    onTap: () {
                      if (widget.onAttributes != null) {
                        setState(() {
                          _constructor = e2;
                          widget.onSelectedConstructor(e2);

                          final attribute = widget.attributes.firstWhere(
                            (element) => element.builders.contains(e2),
                            orElse: () => widget.attributes.first,
                          );
                          attribute.onChangeValue?.call(attribute);
                          widget.onAttributes!(widget.attributes, attribute);
                        });
                      }
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
