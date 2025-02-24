import 'package:example/themes.dart';
import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

import 'custom_card.dart';

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
    _factoryAttributeDtoString(
      name: 'title',
      selectedValue: 'Lorem justo clita tempor labore',
      required: true,
    ),
    AttributeDto(
      name: 'hidden',
      type: 'bool?',
      selectedValue: VariableOption(value: false),
    ),
    _factoryAttributeDtoString(
      name: 'description',
      selectedValue:
          'Est diam aliquyam dolores et est takimata et, dolore dolores sed dolores vero diam justo stet nonumy',
      canBeNull: true,
    ),
    AttributeDto(
      name: 'style',
      type: 'StyleCustomCard',
      selectedValue: VariableOption(value: StyleCustomCard.inline),
      variableOptions: StyleCustomCard.values
          .map((e) => VariableOption(
                value: e,
                textInSelectedOptions: e.name,
              ))
          .toList(),
      builders: [
        null,
      ],
    ),
    AttributeDto(
      name: 'onPositive',
      type: 'Function()?',
      selectedValue: VariableOption(value: '(){}'),
      builders: [
        null,
        'inline',
        'outline',
      ],
    ),
    AttributeDto(
      name: 'textPositive',
      type: 'String?',
      variableOptions: [
        VariableOption(value: 'Continuar'),
      ],
      builders: [
        null,
        'inline',
        'outline',
      ],
    ),
    AttributeDto(
      name: 'onNegative',
      type: 'Function()?',
      selectedValue: VariableOption(value: '(){}'),
      builders: [
        null,
        'inline',
        'outline',
      ],
    ),
    AttributeDto(
      name: 'textNegative',
      type: 'String?',
      variableOptions: [
        VariableOption(value: 'Fechar'),
      ],
      builders: [
        null,
        'inline',
        'outline',
      ],
    ),
    AttributeDto.rangeDoubleInterval(
      name: 'width',
      begin: 220,
      end: 400,
      canBeNull: true,
      selectedValue: null,
      builders: [
        null,
        'inline',
        'outline',
      ],
    ),
    AttributeDto.rangeDoubleInterval(
      name: 'height',
      begin: 160,
      end: 600,
      canBeNull: true,
      selectedValue: null,
      builders: [
        null,
        'inline',
        'outline',
      ],
    ),
  ];
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
              if (selectedConstructor == null)
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

  static _factoryAttributeDtoString({
    required String name,
    String? selectedValue,
    bool canBeNull = false,
    bool required = false,
  }) {
    return AttributeDto(
      name: name,
      type: 'String${canBeNull ? "?" : ""}',
      required: required,
      selectedValue: VariableOption(value: selectedValue),
      variableOptions: [
        VariableOption(
          value: 'Sadipscing gubergren ea eos stet',
          textInDisplay: '5 palavras',
        ),
        VariableOption(
          value: 'Justo elitr sed accusam accusam diam stet, diam est elitr',
          textInDisplay: '10 palavras',
        ),
        VariableOption(
          value:
              'Sanctus gubergren at duo lorem et gubergren aliquyam, sed sed no invidunt gubergren eos aliquyam, no et magna clita rebum',
          textInDisplay: '20 palavras',
        ),
        VariableOption(
          value:
              'Et gubergren invidunt tempor ipsum diam dolor diam et, gubergren lorem tempor sed ut diam magna ipsum tempor sanctus, clita kasd nonumy nonumy vero sanctus sit, ut accusam et dolores',
          textInDisplay: '30 palavras',
        ),
        VariableOption(
          value:
              'Invidunt diam eos sed sea sit takimata, justo sit sit erat stet ea, stet dolor eirmod duo takimata dolore sit. Sanctus dolor duo et eirmod clita sed, magna et aliquyam sea lorem takimata, sanctus kasd amet voluptua clita elitr. At',
          textInDisplay: '40 palavras',
        ),
        VariableOption(
          value:
              'Sit eirmod rebum sea stet diam, voluptua consetetur justo amet no ea sit, no et et lorem ut sadipscing nonumy at aliquyam et. Eirmod no vero sit amet sed, duo clita sit erat accusam sanctus dolor, elitr at amet erat et. Sadipscing est erat labore diam takimata gubergren amet kasd, stet duo sit gubergren amet dolor sanctus dolor no labore, sit accusam diam eos diam labore dolor rebum sit, dolor kasd ut dolor labore dolores diam eirmod ipsum, lorem magna',
          textInDisplay: '80 palavras',
        ),
        VariableOption(
          value:
              'Amet gubergren et justo ipsum consetetur at eos. Elitr eos lorem aliquyam sea nonumy, invidunt amet lorem et amet. Ipsum stet elitr accusam ut voluptua labore gubergren est. Takimata sadipscing stet lorem lorem, amet lorem amet et dolor erat accusam sed, et rebum ut sed duo ut sed. Justo ipsum magna lorem sed accusam et sea aliquyam, sea eos eos elitr rebum sanctus voluptua dolore sit. Justo magna dolore magna amet lorem accusam, at ipsum diam consetetur diam nonumy magna diam eirmod. Dolor ut tempor lorem dolores. Dolor at sit amet dolor elitr tempor. Lorem dolor rebum amet voluptua erat lorem vero ipsum. Et amet et erat elitr amet sit ut, kasd elitr diam et invidunt sit sadipscing, rebum lorem',
          textInDisplay: '120 palavras',
        ),
      ],
      builders: [
        null,
        'inline',
        'outline',
      ],
    );
  }

  @override
  String description =
      'Magna et nonumy dolor duo sanctus sed est stet voluptua, dolor ipsum et et aliquyam amet et. Sed diam et.';

  @override
  String nameObjectInDisplay = 'CustomCard';

  @override
  String title = 'Custom Card';
}
