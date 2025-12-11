import 'package:example/utils_attribute.dart';
import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

import 'custom_card.dart';

// Tema escuro inspirado na Petlove - Design acolhedor e suave
final ThemeData customThemeDark = ThemeData.dark().copyWith(
  // Cores principais inspiradas na Petlove - tons suaves e acolhedores
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF4CAF50), // Verde Petlove suave
    secondary: Color(0xFF81C784), // Verde secundário claro
    surface: Color(0xFF2C2C2C), // Superfície escura suave
    background: Color(0xFF1A1A1A), // Fundo escuro acolhedor
    error: Color(0xFFE57373), // Vermelho suave
    onPrimary: Colors.white, // Texto sobre primária
    onSecondary: Colors.white, // Texto sobre secundária
    onSurface: Color(0xFFE0E0E0), // Texto claro sobre superfície
    onBackground: Color(0xFFE0E0E0), // Texto claro sobre fundo
    onError: Colors.white, // Texto sobre erro
  ),
  scaffoldBackgroundColor: const Color(0xFF1A1A1A), // Fundo da tela
  cardColor: const Color(0xFF2C2C2C), // Cor dos cards
  cardTheme: CardThemeData(
    color: const Color(0xFF2C2C2C),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Bordas arredondadas suaves
    ),
  ),
  // Estilos de botões com design Petlove
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Bordas arredondadas
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4CAF50), // Verde Petlove
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF81C784), // Verde claro
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF4CAF50),
      side: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    ),
  ),
  // Tipografia limpa e moderna
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Color(0xFFE0E0E0),
      fontWeight: FontWeight.w700,
      fontSize: 22,
    ),
    titleMedium: TextStyle(
      color: Color(0xFFE0E0E0),
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
    bodyLarge: TextStyle(
      color: Color(0xFFBDBDBD),
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFFBDBDBD),
      fontSize: 14,
    ),
  ),
);

// Tema claro inspirado na Petlove - Design limpo, acolhedor e profissional
final ThemeData customThemeLight = ThemeData.light().copyWith(
  // Cores principais inspiradas na Petlove - tons neutros e acolhedores
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2E7D32), // Verde Petlove principal
    secondary: Color(0xFF4CAF50), // Verde secundário
    surface: Colors.white, // Superfície branca limpa
    background: Color(0xFFFAFAFA), // Fundo cinza muito claro (acolhedor)
    error: Color(0xFFD32F2F), // Vermelho
    onPrimary: Colors.white, // Texto sobre primária
    onSecondary: Colors.white, // Texto sobre secundária
    onSurface: Color(0xFF212121), // Texto escuro sobre superfície
    onBackground: Color(0xFF212121), // Texto escuro sobre fundo
    onError: Colors.white, // Texto sobre erro
  ),
  scaffoldBackgroundColor: const Color(0xFFFAFAFA), // Fundo da tela acolhedor
  cardColor: Colors.white, // Cor dos cards
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 1,
    shadowColor: Colors.black.withOpacity(0.05), // Sombra suave
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Bordas arredondadas suaves
    ),
  ),
  // Estilos de botões com design Petlove
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Bordas arredondadas
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2E7D32), // Verde Petlove
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF2E7D32), // Verde Petlove
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF2E7D32),
      side: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    ),
  ),
  // Tipografia limpa e moderna
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Color(0xFF212121),
      fontWeight: FontWeight.w700,
      fontSize: 22,
    ),
    titleMedium: TextStyle(
      color: Color(0xFF212121),
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
    bodyLarge: TextStyle(
      color: Color(0xFF424242),
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFF616161),
      fontSize: 14,
    ),
  ),
);

class CustomCardStorybook extends StatefulWidget {
  final Function(ThemeData theme) onChangeTheme;
  const CustomCardStorybook({
    Key? key,
    required this.onChangeTheme,
  }) : super(key: key);

  @override
  Storybook<CustomCardStorybook> createState() => _CustomCardStorybookState();
}

class _CustomCardStorybookState extends Storybook<CustomCardStorybook> {
  @override
  MultipleThemeSettings? multipleThemeSettings = MultipleThemeSettings(
    selectableThemes: [
      ThemeSettings(
        title: 'Principal',
        light: ThemeData.light(),
        dark: ThemeData.dark(),
      ),
      ThemeSettings(
        title: 'Custom theme 1',
        light: customThemeLight,
        dark: customThemeDark,
      ),
      ThemeSettings(
        title: 'Custom theme 2',
        light: ThemeData.light(),
      ),
    ],
  );

  @override
  List<AttributeDto> attributes = [
    UtilsAttributeReflectable.factoryAttributeDtoString(
      name: 'title',
      selectedValue: 'Lorem justo clita tempor labore',
      required: true,
    ),
    AttributeDto(
      name: 'hidden',
      type: 'bool?',
      selectedValue: VariableOption(value: false),
    ),
    AttributeDto(
      name: 'enabled',
      type: 'bool',
      selectedValue: VariableOption(value: true),
    ),
    UtilsAttributeReflectable.factoryAttributeDtoString(
      name: 'description',
      selectedValue:
          'Est diam aliquyam dolores et est takimata et, dolore dolores sed dolores vero diam justo stet nonumy',
      canBeNull: true,
    ),
    AttributeDto.enumType(
      name: 'style',
      selectedValue: StyleCustomCard.inline,
      values: StyleCustomCard.values,
    ),
    AttributeDto(
      name: 'onPositive',
      type: 'Function()?',
      selectedValue: VariableOption(value: '(){}'),
      builders: [''],
    ),
    AttributeDto(
      name: 'textPositive',
      type: 'String?',
      variableOptions: [
        VariableOption(value: 'Continuar'),
      ],
      builders: [''],
    ),
    AttributeDto(
      name: 'onNegative',
      type: 'Function()?',
      selectedValue: VariableOption(value: '(){}'),
      builders: [''],
    ),
    AttributeDto.objectInObject(
      name: 'setting',
      type: 'SettingCustomCard?',
      children: [
        UtilsAttribute.color(
          name: 'color',
          canBeNull: true,
        ),
        UtilsAttribute.color(
          name: 'textColor',
        ),
      ],
      builders: [''],
      selectedValue: VariableOption(
        value: SettingCustomCard(
          color: Colors.red,
          textColor: Colors.black,
        ),
      ),
    ),
    AttributeDto(
      name: 'textNegative',
      type: 'String?',
      variableOptions: [
        VariableOption(value: 'Fechar'),
      ],
      builders: [''],
    ),
    AttributeDto.rangeDoubleInterval(
      name: 'width',
      begin: 220,
      end: 400,
      canBeNull: true,
      selectedValue: null,
      builders: [''],
    ),
    AttributeDto.rangeDoubleInterval(
      name: 'height',
      begin: 160,
      end: 600,
      canBeNull: true,
      selectedValue: null,
      builders: [''],
    ),
  ];
  @override
  void onUpdateTheme(MultipleThemeSettings multipleThemeSettings) {
    widget.onChangeTheme(multipleThemeSettings.selectedThemes.currentTheme());
  }

  @override
  Widget buildComponentWidget(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selectedConstructor.isEmpty)
                CustomCard(
                  title: getWhereAttribut('title'),
                  style: getWhereAttribut('style') ?? StyleCustomCard.inline,
                  description: getWhereAttribut('description'),
                  onNegative:
                      getWhereAttribut('onNegative') != null ? () {} : null,
                  textNegative: getWhereAttribut('textNegative'),
                  onPositive:
                      getWhereAttribut('onPositive') != null ? () {} : null,
                  textPositive: getWhereAttribut('textPositive'),
                  height: getWhereAttribut('height'),
                  width: getWhereAttribut('width'),
                ),
              if (selectedConstructor == 'inline')
                CustomCard.inline(
                  title: getWhereAttribut('title'),
                  description: getWhereAttribut('description'),
                  onNegative:
                      getWhereAttribut('onNegative') != null ? () {} : null,
                  textNegative: getWhereAttribut('textNegative'),
                  onPositive:
                      getWhereAttribut('onPositive') != null ? () {} : null,
                  textPositive: getWhereAttribut('textPositive'),
                  height: getWhereAttribut('height'),
                  width: getWhereAttribut('width'),
                ),
              if (selectedConstructor == 'outline')
                CustomCard.outline(
                  title: getWhereAttribut('title'),
                  description: getWhereAttribut('description'),
                  onNegative:
                      getWhereAttribut('onNegative') != null ? () {} : null,
                  textNegative: getWhereAttribut('textNegative'),
                  onPositive:
                      getWhereAttribut('onPositive') != null ? () {} : null,
                  textPositive: getWhereAttribut('textPositive'),
                  height: getWhereAttribut('height'),
                  width: getWhereAttribut('width'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  String description =
      'Magna et nonumy dolor duo sanctus sed est stet voluptua, dolor ipsum et et aliquyam amet et. Sed diam et.';

  @override
  String nameObjectInDisplay = 'CustomCard';

  @override
  String title = 'Custom Card';

  @override
  OnBuildExtraAttributesConfigCustom? get extraAttributesConfigCustom => null;
}
