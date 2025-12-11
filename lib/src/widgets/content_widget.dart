import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/multiple_theme_settings.dart';
import 'package:storybook_ds/src/utils/typedef_storybook.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/attributes_variant_widget.dart';

import '../models/dto/attribute_dto.dart';
import 'attributes_theme_widget.dart';
import 'custom_chip_selected.dart';

/// Constants for spacing and layout
class _ContentWidgetConstants {
  static const double topMargin = 48.0;
  static const double horizontalMargin = 24.0;
  static const double titleTopPadding = 24.0;
  static const double buildersTopPadding = 16.0;
  static const double extraAttributesSpacing = 12.0;
  static const int delayedConstructorMs = 50;
}

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
          left: _ContentWidgetConstants.horizontalMargin,
          right: _ContentWidgetConstants.horizontalMargin,
          top: _ContentWidgetConstants.topMargin,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTitle(context),
            _buildDescription(context),
            _buildBuilders(context, attributes),
            if (extraAttributesConfigCustom != null) ...[
              const SizedBox(height: _ContentWidgetConstants.extraAttributesSpacing),
              extraAttributesConfigCustom!(context),
            ],
            _buildAttributesTheme(multipleThemeSettings),
            _buildAttributesVariant(attributes),
          ],
        ),
      ),
    );
  }

  /// Builds the description widget.
  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: _ContentWidgetConstants.titleTopPadding,
      ),
      child: SelectableText(
        description,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  /// Builds the title widget.
  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  /// Builds the constructors selection widget.
  Widget _buildBuilders(BuildContext context, List<AttributeDto> attributes) {
    final builders = _extractUniqueBuilders(attributes);

    if (builders.isNotEmpty && constructor == null) {
      Future.delayed(
        const Duration(
          milliseconds: _ContentWidgetConstants.delayedConstructorMs,
        ),
      ).then((_) => onSelectedConstructor(builders.first));
    }

    return Builders(
      builders: builders,
      attributes: attributes,
      initConstructor: constructor,
      onAttributes: onAttributes,
      onSelectedConstructor: onSelectedConstructor,
    );
  }

  /// Extracts unique builders from attributes list.
  List<String> _extractUniqueBuilders(List<AttributeDto> attributes) {
    final builders = <String>{};
    
    for (final attribute in attributes) {
      if (attribute.builders.isNotEmpty) {
        builders.addAll(attribute.builders);
      } else {
        builders.add('');
      }
    }
    
    final result = builders.toList();
    if (result.contains('')) {
      result.remove('');
      result.insert(0, '');
    }
    
    return result;
  }

  /// Builds the attributes variant widget.
  Widget _buildAttributesVariant(List<AttributeDto> attributes) {
    return AttributesVariantWidget(
      attributes: attributes,
      onAttributes: onAttributes,
      constructor: constructor,
      title: '',
    );
  }

  /// Builds the attributes theme widget if themes are available.
  Widget _buildAttributesTheme(MultipleThemeSettings? multipleThemeSettings) {
    if (multipleThemeSettings == null ||
        multipleThemeSettings.selectableThemes.isEmpty ||
        onUpdateTheme == null) {
      return const SizedBox.shrink();
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
    super.initState();
    _constructor = widget.initConstructor;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: _ContentWidgetConstants.buildersTopPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Construtores',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: _ContentWidgetConstants.buildersTopPadding),
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
                    onTap: () => _handleConstructorTap(e2),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  /// Handles constructor chip tap.
  void _handleConstructorTap(String constructor) {
    if (widget.onAttributes == null) return;

    setState(() {
      _constructor = constructor;
      widget.onSelectedConstructor(constructor);

      final attribute = widget.attributes.firstWhere(
        (element) => element.builders.contains(constructor),
        orElse: () => widget.attributes.first,
      );
      attribute.onChangeValue?.call(attribute);
      widget.onAttributes!(widget.attributes, attribute);
    });
  }
}
