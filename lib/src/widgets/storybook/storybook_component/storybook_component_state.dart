import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

class StoryBookComponentState extends StatefulWidget {
  const StoryBookComponentState({
    super.key,
    required this.title,
    required this.description,
    required this.attributes,
    required this.nameObjectInDisplay,
    this.child,
    this.builder,
    this.controller,
    this.multipleThemeSettings,
    this.backgroundColor,
    this.onUpdateTheme,
    this.extraAttributesConfigCustom,
    this.onSelectedConstructor,
    this.storybookTheme,
  }) : assert(child != null || builder != null, 'child or builder is required');
  final Widget? child;
  final WidgetBuilder? builder;
  final String title;
  final String description;
  final List<AttributeModel> attributes;
  final String nameObjectInDisplay;
  final StoryBookComponentController? controller;
  final MultipleThemeSettings? multipleThemeSettings;
  final Color? backgroundColor;
  final void Function(
    MultipleThemeSettings multipleThemeSettings,
  )? onUpdateTheme;
  final OnBuildExtraAttributesConfigCustom? extraAttributesConfigCustom;
  final Function(String constructor)? onSelectedConstructor;

  /// Tema customizável do storybook.
  /// Se null, usa [StorybookTheme.defaults].
  final StorybookTheme? storybookTheme;

  @override
  Storybook<StoryBookComponentState> createState() =>
      // ignore: no_logic_in_create_state
      _StoryBookComponentStateState(
        child: child,
        title: title,
        description: description,
        attributes: attributes,
        nameObjectInDisplay: nameObjectInDisplay,
        controller: controller,
        multipleThemeSettings: multipleThemeSettings,
        backgroundColor: backgroundColor,
        extraAttributesConfigCustom: extraAttributesConfigCustom,
        builder: builder,
        onSelectedConstructor: onSelectedConstructor,
        storybookTheme: storybookTheme,
      );
}

class _StoryBookComponentStateState extends Storybook<StoryBookComponentState> {
  final Widget? child;
  final WidgetBuilder? builder;

  @override
  final String title;
  @override
  final String description;
  @override
  final List<AttributeModel> attributes;
  @override
  final String nameObjectInDisplay;

  @override
  // ignore: overridden_fields
  final MultipleThemeSettings? multipleThemeSettings;

  @override
  OnBuildExtraAttributesConfigCustom? extraAttributesConfigCustom;

  final Color? backgroundColor;
  final Function(String constructor)? onSelectedConstructor;
  @override
  final StorybookTheme? storybookTheme;

  _StoryBookComponentStateState({
    required this.title,
    required this.description,
    required this.attributes,
    required this.nameObjectInDisplay,
    required StoryBookComponentController? controller,
    required this.multipleThemeSettings,
    required this.backgroundColor,
    this.child,
    this.builder,
    this.extraAttributesConfigCustom,
    this.onSelectedConstructor,
    this.storybookTheme,
  }) {
    internalController = controller;
  }

  @override
  void onUpdateSelectedConstructor(String constructor) {
    super.onUpdateSelectedConstructor(constructor);
    if (widget.onSelectedConstructor != null) {
      widget.onSelectedConstructor!(constructor);
    }
  }

  @override
  void onUpdateTheme(MultipleThemeSettings multipleThemeSettings) {
    if (widget.onUpdateTheme != null) {
      widget.onUpdateTheme!(multipleThemeSettings);
    }
  }

  @override
  Widget buildComponentWidget(BuildContext context) {
    return builder?.call(context) ?? child ?? const Placeholder();
  }
}
