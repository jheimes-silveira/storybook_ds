import 'package:flutter/material.dart';
import 'package:storybook_ds/src/utils/typedef_storybook.dart';
import 'package:storybook_ds/storybook_ds.dart';

class StoryBookComponentState extends StatefulWidget {
  const StoryBookComponentState({
    super.key,
    required this.child,
    required this.title,
    required this.description,
    required this.attributes,
    required this.nameObjectInDisplay,
    this.controller,
    this.multipleThemeSettings,
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
      );
}

class _StoryBookComponentStateState extends Storybook<StoryBookComponentState> {
  final Widget child;
  @override
  final String title;
  @override
  final String description;
  @override
  final List<AttributeDto> attributes;
  @override
  final String nameObjectInDisplay;

  @override
  final MultipleThemeSettings? multipleThemeSettings;

  @override
  OnBuildExtraAttributesConfigCustom? extraAttributesConfigCustom;

  final Color? backgroundColor;
  final StoryBookComponentController? controller;

  _StoryBookComponentStateState({
    required this.child,
    required this.title,
    required this.description,
    required this.attributes,
    required this.nameObjectInDisplay,
    required this.controller,
    required this.multipleThemeSettings,
    required this.backgroundColor,
    this.extraAttributesConfigCustom,
  });

  @override
  void onUpdateTheme(MultipleThemeSettings multipleThemeSettings) {
    if (widget.onUpdateTheme != null) {
      widget.onUpdateTheme!(multipleThemeSettings);
    }
  }

  @override
  Widget buildComponentWidget(BuildContext context) {
    return child;
  }
}
