import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

import 'custom_card.dart';

final ThemeData customThemeDark = ThemeData.dark().copyWith(
  buttonTheme: const ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Cantos quadrados para botões
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Cantos quadrados para ElevatedButton
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Cantos quadrados para TextButton
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Cantos quadrados para OutlinedButton
      ),
    ),
  ),
  cardTheme: const CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Cantos quadrados para Cards
    ),
  ),
);
final ThemeData customThemeLight = ThemeData.light().copyWith(
  buttonTheme: const ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Cantos quadrados para botões
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Cantos quadrados para ElevatedButton
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Cantos quadrados para TextButton
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Cantos quadrados para OutlinedButton
      ),
    ),
  ),
  cardTheme: const CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Cantos quadrados para Cards
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
  List<AttributeDto> attributes = UtilsAttributeReflectable.generateAttributes(
    CustomCard(
      title: 'meu titulo',
      description: 'Uma descrição',
      height: null,
      width: null,
      onNegative: () {},
      onPositive: () {},
      settings: SettingCustomCard(
        color: Colors.red,
        textColor: Colors.black,
      ),
    ),
    attributesReplace: [
      AttributeDto.rangeDoubleInterval(
        name: 'height',
        begin: 100,
        end: 1000,
        selectedValue: null,
        canBeNull: true,
      ),
      AttributeDto.rangeDoubleInterval(
        name: 'width',
        begin: 100,
        end: 1000,
        selectedValue: null,
        canBeNull: true,
      ),
    ],
  );
  // @override
  // List<AttributeDto> attributes = [
  //   _factoryAttributeDtoString(
  //     name: 'title',
  //     selectedValue: 'Lorem justo clita tempor labore',
  //     required: true,
  //   ),
  //   AttributeDto(
  //     name: 'hidden',
  //     type: 'bool?',
  //     selectedValue: VariableOption(value: false),
  //   ),
  //   AttributeDto(
  //     name: 'enabled',
  //     type: 'bool',
  //     selectedValue: VariableOption(value: true),
  //   ),
  //   _factoryAttributeDtoString(
  //     name: 'description',
  //     selectedValue:
  //         'Est diam aliquyam dolores et est takimata et, dolore dolores sed dolores vero diam justo stet nonumy',
  //     canBeNull: true,
  //   ),
  //   AttributeDto.enumType(
  //     name: 'style',
  //     selectedValue: StyleCustomCard.inline,
  //     values: StyleCustomCard.values,
  //   ),

  //   AttributeDto(
  //     name: 'onPositive',
  //     type: 'Function()?',
  //     selectedValue: VariableOption(value: '(){}'),
  //     builders: [
  //       null,
  //       'inline',
  //       'outline',
  //     ],
  //   ),
  //   AttributeDto(
  //     name: 'textPositive',
  //     type: 'String?',
  //     variableOptions: [
  //       VariableOption(value: 'Continuar'),
  //     ],
  //     builders: [
  //       null,
  //       'inline',
  //       'outline',
  //     ],
  //   ),
  //   AttributeDto(
  //     name: 'onNegative',
  //     type: 'Function()?',
  //     selectedValue: VariableOption(value: '(){}'),
  //     builders: [
  //       null,
  //       'inline',
  //       'outline',
  //     ],
  //   ),
  //   AttributeDto.objectInObject(
  //     name: 'setting',
  //     type: 'SettingCustomCard?',
  //     children: [
  //       UtilsAttribute.color(
  //         name: 'color',
  //         canBeNull: true,
  //       ),
  //       UtilsAttribute.color(
  //         name: 'textColor',
  //       ),
  //     ],
  //     builders: [
  //       null,
  //       'inline',
  //       'outline',
  //     ],
  //     selectedValue: VariableOption(
  //       value: SettingCustomCard(
  //         color: Colors.red,
  //         textColor: Colors.black,
  //       ),
  //     ),
  //   ),
  //   AttributeDto(
  //     name: 'textNegative',
  //     type: 'String?',
  //     variableOptions: [
  //       VariableOption(value: 'Fechar'),
  //     ],
  //     builders: [
  //       null,
  //       'inline',
  //       'outline',
  //     ],
  //   ),
  //   AttributeDto.rangeDoubleInterval(
  //     name: 'width',
  //     begin: 220,
  //     end: 400,
  //     canBeNull: true,
  //     selectedValue: null,
  //     builders: [
  //       null,
  //       'inline',
  //       'outline',
  //     ],
  //   ),
  //   AttributeDto.rangeDoubleInterval(
  //     name: 'height',
  //     begin: 160,
  //     end: 600,
  //     canBeNull: true,
  //     selectedValue: null,
  //     builders: [
  //       null,
  //       'inline',
  //       'outline',
  //     ],
  //   ),
  // ];
  @override
  void onUpdateTheme(MultipleThemeSettings multipleThemeSettings) {
    widget.onChangeTheme(multipleThemeSettings.selectedThemes.currentTheme());
  }

  @override
  Widget buildComponentWidget(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selectedConstructor.isEmpty)
                CustomCard(
                  title: getWhereAttribut('title'),
                  style: getWhereAttribut('style'),
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
