import 'package:storybook_ds/src/models/theme_settings.dart';

class MultipleThemeSettings {
  final List<ThemeSettings> _selectableThemes;
  ThemeSettings selectedThemes;

  MultipleThemeSettings({
    required List<ThemeSettings> selectableThemes,
    ThemeSettings? initSelectedTheme,
  })  : _selectableThemes = selectableThemes,
        selectedThemes = initSelectedTheme ?? selectableThemes.first;

  List<ThemeSettings> get selectableThemes => _selectableThemes;
}
