import 'package:flutter/material.dart';
import 'package:storybook_ds/src/widgets/custom_chip_selected.dart';

import '../../storybook_ds.dart';

class AttributesThemeWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTitle(context),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                child: ExpansionTile(
                  childrenPadding: const EdgeInsets.only(left: 8),
                  tilePadding: const EdgeInsets.only(left: 8, right: 8),
                  expandedAlignment: Alignment.centerLeft,
                  title: _buildNameTheme(
                    themeSettings.selectedThemes.title,
                    context,
                  ),
                  trailing: themeSettings.selectedThemes.switchThemeMode
                      ? _buildVariableOptionTypeBool(
                          themeSettings,
                          onUpdateTheme,
                        )
                      : null,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildChangeAction(
                            context,
                            themeSettings,
                            onUpdateTheme,
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

  Padding _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
      ),
      child: Text(
        "Thema",
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildNameTheme(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildChangeAction(
    BuildContext context,
    MultipleThemeSettings themeSettings,
    void Function(MultipleThemeSettings multipleThemeSettings) onUpdateTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 8,
        runAlignment: WrapAlignment.start,
        runSpacing: 8,
        children: themeSettings.selectableThemes
            .map(
              (e2) => CustomChipSelected(
                label: e2.title,
                selected: themeSettings.selectedThemes.title == e2.title,
                onTap: () {
                  e2.setCurrentTheme(themeSettings.selectedThemes.isDarkMode);
                  themeSettings.selectedThemes = e2;
                  onUpdateTheme(themeSettings);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildVariableOptionTypeBool(
    MultipleThemeSettings themeSettings,
    void Function(MultipleThemeSettings multipleThemeSettings) onUpdateTheme,
  ) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 8,
      runAlignment: WrapAlignment.start,
      runSpacing: 8,
      children: [
        CustomChipSelected(
          label: 'light',
          selected: !themeSettings.selectedThemes.isDarkMode,
          onTap: () {
            themeSettings.selectedThemes.setCurrentTheme(false);
            onUpdateTheme(themeSettings);
          },
        ),
        CustomChipSelected(
          label: 'dark',
          selected: themeSettings.selectedThemes.isDarkMode,
          onTap: () {
            themeSettings.selectedThemes.setCurrentTheme(true);
            onUpdateTheme(themeSettings);
          },
        ),
      ],
    );
  }
}
