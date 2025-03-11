import 'package:flutter/material.dart';
import 'package:storybook_ds/src/utils/typedef_storybook.dart';
import 'package:storybook_ds/storybook_ds.dart';

import 'storybook_component_state.dart';

class StoryBookComponentProperties {
  StoryBookComponentProperties({
    this.attributes = const [],
    this.selectedConstructor,
  });

  final List<AttributeDto> attributes;
  String? selectedConstructor;
}

class StoryBookComponentController
    extends ValueNotifier<StoryBookComponentProperties> {
  StoryBookComponentController(this.properties) : super(properties);
  final StoryBookComponentProperties properties;

  List<AttributeDto> get attributes => properties.attributes;

  set attributes(List<AttributeDto> value) {
    properties.attributes.clear();
    properties.attributes.addAll(value);
    onUpdateAttributes(value);
  }

  String? get selectedConstructor => properties.selectedConstructor;

  set selectedConstructor(String? value) {
    properties.selectedConstructor = value;
    notifyListeners();
  }

  dynamic getWhereAttribute(String name) {
    final attribute = attributes.where((e) => e.name == name).first;
    return attribute.selectedValue?.value;
  }

  void onUpdateAttributes(List<AttributeDto> attributes) {
    notifyListeners();
  }
}

class StoryBookComponent extends StatefulWidget {
  const StoryBookComponent({
    super.key,
    required this.child,
    required this.title,
    required this.nameObjectInDisplay,
    this.attributes = const [],
    this.description = '',
    this.multipleThemeSettings,
    this.controller,
    this.backgroundColor,
    this.onUpdateTheme,
    this.extraAttributesConfigCustom,
  });

  final Widget child;
  final String title;
  final String description;
  final List<AttributeDto> attributes;
  final String nameObjectInDisplay;
  final StoryBookComponentController? controller;
  final MultipleThemeSettings? multipleThemeSettings;
  final Color? backgroundColor;
  final void Function(
    MultipleThemeSettings multipleThemeSettings,
  )? onUpdateTheme;
  final OnBuildExtraAttributesConfigCustom? extraAttributesConfigCustom;

  @override
  State<StoryBookComponent> createState() => _StoryBookComponenState();
}

class _StoryBookComponenState extends State<StoryBookComponent> {
  late final StoryBookComponentController controller = widget.controller ??
      StoryBookComponentController(
        StoryBookComponentProperties(
          attributes: widget.attributes,
        ),
      );

  @override
  Widget build(BuildContext context) => StoryBookComponentState(
        title: widget.title,
        description: widget.description,
        attributes: widget.attributes,
        nameObjectInDisplay: widget.nameObjectInDisplay,
        controller: widget.controller,
        multipleThemeSettings: widget.multipleThemeSettings,
        backgroundColor: widget.backgroundColor,
        onUpdateTheme: widget.onUpdateTheme,
        extraAttributesConfigCustom: widget.extraAttributesConfigCustom,
        child: widget.child,
      );
}
