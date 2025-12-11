import 'package:flutter/material.dart';
import 'package:storybook_ds/src/widgets/custom_chip_selected.dart';

import '../../storybook_ds.dart';

/// Constants for spacing and layout
class _AttributesThemeWidgetConstants {
  static const double titleTopPadding = 16.0;
  static const double titleBottomPadding = 16.0;
  static const double changeActionTopPadding = 8.0;
  static const double changeActionBottomPadding = 16.0;
  static const double expansionTilePadding = 8.0;
  static const double borderRadius = 8.0;
  static const double borderWidth = 1.0;
  static const double chipSpacing = 8.0;
  static const String lightModeLabel = 'light';
  static const String darkModeLabel = 'dark';
  static const String themeTitle = 'Thema';
}

class AttributesThemeWidget extends StatefulWidget {
  final MultipleThemeSettings themeSettings;
  final void Function(
    MultipleThemeSettings multipleThemeSettings,
  ) onUpdateTheme;

  const AttributesThemeWidget({
    super.key,
    required this.themeSettings,
    required this.onUpdateTheme,
  });

  @override
  State<AttributesThemeWidget> createState() => _AttributesThemeWidgetState();
}

class _AttributesThemeWidgetState extends State<AttributesThemeWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTitle(context),
            Padding(
              padding: const EdgeInsets.only(
                top: _AttributesThemeWidgetConstants.expansionTilePadding,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    _AttributesThemeWidgetConstants.borderRadius,
                  ),
                  border: Border.all(
                    width: _AttributesThemeWidgetConstants.borderWidth,
                    color: Colors.grey,
                  ),
                ),
                child: ExpansionTile(
                  childrenPadding: const EdgeInsets.only(
                    left: _AttributesThemeWidgetConstants.expansionTilePadding,
                  ),
                  tilePadding: const EdgeInsets.only(
                    left: _AttributesThemeWidgetConstants.expansionTilePadding,
                    right: _AttributesThemeWidgetConstants.expansionTilePadding,
                  ),
                  expandedAlignment: Alignment.centerLeft,
                  title: _buildNameTheme(
                    widget.themeSettings.selectedThemes.title,
                    context,
                  ),
                  trailing: widget.themeSettings.selectedThemes.switchThemeMode
                      ? _buildVariableOptionTypeBool(
                          widget.themeSettings,
                          widget.onUpdateTheme,
                        )
                      : null,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildChangeAction(
                            context,
                            widget.themeSettings,
                            widget.onUpdateTheme,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds the title widget.
  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: _AttributesThemeWidgetConstants.titleTopPadding,
        bottom: _AttributesThemeWidgetConstants.titleBottomPadding,
      ),
      child: Text(
        _AttributesThemeWidgetConstants.themeTitle,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  /// Builds the theme name widget.
  Widget _buildNameTheme(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  /// Builds the theme selection action widget.
  Widget _buildChangeAction(
    BuildContext context,
    MultipleThemeSettings themeSettings,
    void Function(MultipleThemeSettings multipleThemeSettings) onUpdateTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: _AttributesThemeWidgetConstants.changeActionBottomPadding,
        top: _AttributesThemeWidgetConstants.changeActionTopPadding,
      ),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: _AttributesThemeWidgetConstants.chipSpacing,
        runAlignment: WrapAlignment.start,
        runSpacing: _AttributesThemeWidgetConstants.chipSpacing,
        children: themeSettings.selectableThemes
            .map(
              (e2) => CustomChipSelected(
                label: e2.title,
                selected: themeSettings.selectedThemes.title == e2.title,
                onTap: () => _handleThemeSelection(
                  e2,
                  themeSettings,
                  onUpdateTheme,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  /// Builds the theme mode toggle widget (light/dark).
  Widget _buildVariableOptionTypeBool(
    MultipleThemeSettings themeSettings,
    void Function(MultipleThemeSettings multipleThemeSettings) onUpdateTheme,
  ) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: _AttributesThemeWidgetConstants.chipSpacing,
      runAlignment: WrapAlignment.start,
      runSpacing: _AttributesThemeWidgetConstants.chipSpacing,
      children: [
        CustomChipSelected(
          label: _AttributesThemeWidgetConstants.lightModeLabel,
          selected: !themeSettings.selectedThemes.isDarkMode,
          onTap: () => _handleThemeModeChange(
            false,
            themeSettings,
            onUpdateTheme,
          ),
        ),
        CustomChipSelected(
          label: _AttributesThemeWidgetConstants.darkModeLabel,
          selected: themeSettings.selectedThemes.isDarkMode,
          onTap: () => _handleThemeModeChange(
            true,
            themeSettings,
            onUpdateTheme,
          ),
        ),
      ],
    );
  }

  /// Handles theme selection change.
  void _handleThemeSelection(
    ThemeSettings theme,
    MultipleThemeSettings themeSettings,
    void Function(MultipleThemeSettings) onUpdateTheme,
  ) {
    theme.setCurrentTheme(themeSettings.selectedThemes.isDarkMode);
    themeSettings.selectedThemes = theme;
    setState(() {
      onUpdateTheme(themeSettings);
    });
  }

  /// Handles theme mode change (light/dark).
  void _handleThemeModeChange(
    bool isDarkMode,
    MultipleThemeSettings themeSettings,
    void Function(MultipleThemeSettings) onUpdateTheme,
  ) {
    themeSettings.selectedThemes.setCurrentTheme(isDarkMode);
    setState(() {
      onUpdateTheme(themeSettings);
    });
  }
}
