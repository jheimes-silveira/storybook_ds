import 'package:flutter/material.dart';
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
    for (final e in attributes) {
      if (e.name == name) return e.selectedValue?.value;
    }
    return null;
  }

  void onUpdateAttributes(List<AttributeDto> attributes) {
    notifyListeners();
  }
}

class StoryBookComponent extends StatefulWidget {
  const StoryBookComponent({
    super.key,
    required this.title,
    required this.nameObjectInDisplay,
    this.child,
    this.builder,
    this.attributes = const [],
    this.description = '',
    this.multipleThemeSettings,
    this.controller,
    this.backgroundColor,
    this.onUpdateTheme,
    this.extraAttributesConfigCustom,
    this.onSelectedConstructor,
  }) : assert(child != null || builder != null, 'child or builder is required');

  final Widget? child;
  final WidgetBuilder? builder;
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
  final Function(String constructor)? onSelectedConstructor;
  @override
  State<StoryBookComponent> createState() => _StoryBookComponenState();
}

class _StoryBookComponenState extends State<StoryBookComponent> {
  late final StoryBookComponentController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = StoryBookComponentController(
        StoryBookComponentProperties(
          attributes: widget.attributes,
        ),
      );
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StoryBookComponentState(
        title: widget.title,
        description: widget.description,
        attributes: widget.attributes,
        nameObjectInDisplay: widget.nameObjectInDisplay,
        controller: _controller,
        multipleThemeSettings: widget.multipleThemeSettings,
        backgroundColor: widget.backgroundColor,
        onUpdateTheme: widget.onUpdateTheme,
        extraAttributesConfigCustom: widget.extraAttributesConfigCustom,
        builder: widget.builder,
        onSelectedConstructor: widget.onSelectedConstructor,
        child: widget.child,
      );
}
