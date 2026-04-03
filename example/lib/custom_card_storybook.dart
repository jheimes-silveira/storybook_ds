import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

import 'custom_card.dart';
import 'sample_themes.dart';
import 'storybook_example_attributes.dart';

/// Nomes dos construtores expostos no storybook, alinhados a [CustomCard]:
/// - `''` → `CustomCard(...)` (construtor padrão)
/// - `'inline'` → `CustomCard.inline(...)`
/// - `'outline'` → `CustomCard.outline(...)`
const _cardBuildersAll = <String>['', 'inline', 'outline'];

/// Só o construtor padrão (ex.: parâmetro ausente nas fábricas `inline` / `outline`).
const _cardBuilderDefaultOnly = <String>[''];

/// Página de story do [CustomCard].
class CustomCardStorybook extends StatefulWidget {
  const CustomCardStorybook({
    super.key,
    required this.onThemeChanged,
  });

  final ValueChanged<ThemeData> onThemeChanged;

  @override
  Storybook<CustomCardStorybook> createState() => _CustomCardStorybookState();
}

class _CustomCardStorybookState extends Storybook<CustomCardStorybook> {
  @override
  void initState() {
    super.initState();
    multipleThemeSettings = MultipleThemeSettings(
      selectableThemes: [
        ThemeSettings(
          title: 'Sistema (Material padrão)',
          light: ThemeData.light(useMaterial3: true),
          dark: ThemeData.dark(useMaterial3: true),
        ),
        ThemeSettings(
          title: 'M3 — Sálvia (claro / escuro)',
          light: buildSampleM3Theme(
            seedColor: sampleSeedSage,
            brightness: Brightness.light,
          ),
          dark: buildSampleM3Theme(
            seedColor: sampleSeedSage,
            brightness: Brightness.dark,
          ),
        ),
        ThemeSettings(
          title: 'M3 — Oceano (claro / escuro)',
          light: buildSampleM3Theme(
            seedColor: sampleSeedOcean,
            brightness: Brightness.light,
          ),
          dark: buildSampleM3Theme(
            seedColor: sampleSeedOcean,
            brightness: Brightness.dark,
          ),
        ),
        ThemeSettings(
          title: 'M3 — Uva (somente claro)',
          light: buildSampleM3Theme(
            seedColor: sampleSeedPlum,
            brightness: Brightness.light,
          ),
        ),
      ],
    );
  }

  T? _knob<T>(String name) => getWhereAttribut(name) as T?;

  @override
  late final List<AttributeDto> attributes = [
    StorybookAttributeFactories.factoryAttributeDtoString(
      name: 'title',
      selectedValue: 'Lorem justo clita tempor labore',
      required: true,
      builders: _cardBuildersAll,
    ),
    AttributeDto(
      name: 'hidden',
      type: 'bool',
      selectedValue: VariableOption(value: false),
      builders: _cardBuildersAll,
    ),
    AttributeDto(
      name: 'enabled',
      type: 'bool',
      selectedValue: VariableOption(value: true),
      builders: _cardBuildersAll,
    ),
    StorybookAttributeFactories.factoryAttributeDtoString(
      name: 'description',
      selectedValue:
          'Est diam aliquyam dolores et est takimata et, dolore dolores sed dolores vero diam justo stet nonumy',
      canBeNull: true,
      builders: _cardBuildersAll,
    ),
    AttributeDto.enumType(
      name: 'variant',
      selectedValue: CustomCardVariant.inline,
      values: CustomCardVariant.values,
      builders: _cardBuilderDefaultOnly,
    ),
    AttributeDto(
      name: 'onPositive',
      type: 'Function()?',
      selectedValue: VariableOption(value: '(){}'),
      builders: _cardBuildersAll,
    ),
    AttributeDto(
      name: 'textPositive',
      type: 'String?',
      variableOptions: [
        VariableOption(value: 'Continuar'),
      ],
      builders: _cardBuildersAll,
    ),
    AttributeDto(
      name: 'onNegative',
      type: 'Function()?',
      selectedValue: VariableOption(value: '(){}'),
      builders: _cardBuildersAll,
    ),
    AttributeDto.objectInObject(
      name: 'settings',
      type: 'CustomCardSettings?',
      merge: (instance, fieldName, newValue) => mergeCustomCardSettings(
        instance as CustomCardSettings,
        fieldName,
        newValue,
      ),
      children: [
        StorybookExampleAttributes.colorPicker(
          name: 'backgroundColor',
          canBeNull: true,
          builders: _cardBuildersAll,
        ),
        StorybookExampleAttributes.colorPicker(
          name: 'textColor',
          builders: _cardBuildersAll,
        ),
      ],
      builders: _cardBuildersAll,
      selectedValue: VariableOption(
        value: const CustomCardSettings(
          backgroundColor: null,
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
      builders: _cardBuildersAll,
    ),
    AttributeDto.rangeDoubleInterval(
      name: 'width',
      begin: 220,
      end: 400,
      canBeNull: true,
      selectedValue: null,
      builders: _cardBuildersAll,
    ),
    AttributeDto.rangeDoubleInterval(
      name: 'height',
      begin: 160,
      end: 600,
      canBeNull: true,
      selectedValue: null,
      builders: _cardBuildersAll,
    ),
  ];

  @override
  String get description =>
      'Magna et nonumy dolor duo sanctus sed est stet voluptua, dolor ipsum et et aliquyam amet et. Sed diam et.';

  @override
  String get nameObjectInDisplay => 'CustomCard';

  @override
  String get title => 'Custom Card';

  @override
  OnBuildExtraAttributesConfigCustom? get extraAttributesConfigCustom => null;

  @override
  void onUpdateTheme(MultipleThemeSettings settings) {
    widget.onThemeChanged(settings.selectedThemes.currentTheme());
  }

  CustomCard _cardDefaultConstructor() {
    return CustomCard(
      title: _knob<String>('title') ?? '',
      variant: _knob<CustomCardVariant>('variant') ?? CustomCardVariant.inline,
      description: _knob<String>('description'),
      settings: _knob<CustomCardSettings>('settings'),
      onNegative: _knob<dynamic>('onNegative') != null ? () {} : null,
      textNegative: _knob<String>('textNegative'),
      onPositive: _knob<dynamic>('onPositive') != null ? () {} : null,
      textPositive: _knob<String>('textPositive'),
      height: _knob<double>('height'),
      width: _knob<double>('width'),
      hidden: _knob<bool>('hidden') ?? false,
      enabled: _knob<bool>('enabled') ?? true,
    );
  }

  CustomCard _cardInlineFactory() {
    return CustomCard.inline(
      title: _knob<String>('title') ?? '',
      description: _knob<String>('description'),
      settings: _knob<CustomCardSettings>('settings'),
      onNegative: _knob<dynamic>('onNegative') != null ? () {} : null,
      textNegative: _knob<String>('textNegative'),
      onPositive: _knob<dynamic>('onPositive') != null ? () {} : null,
      textPositive: _knob<String>('textPositive'),
      height: _knob<double>('height'),
      width: _knob<double>('width'),
      hidden: _knob<bool>('hidden') ?? false,
      enabled: _knob<bool>('enabled') ?? true,
    );
  }

  CustomCard _cardOutlineFactory() {
    return CustomCard.outline(
      title: _knob<String>('title') ?? '',
      description: _knob<String>('description'),
      settings: _knob<CustomCardSettings>('settings'),
      onNegative: _knob<dynamic>('onNegative') != null ? () {} : null,
      textNegative: _knob<String>('textNegative'),
      onPositive: _knob<dynamic>('onPositive') != null ? () {} : null,
      textPositive: _knob<String>('textPositive'),
      height: _knob<double>('height'),
      width: _knob<double>('width'),
      hidden: _knob<bool>('hidden') ?? false,
      enabled: _knob<bool>('enabled') ?? true,
    );
  }

  @override
  Widget buildComponentWidget(BuildContext context) {
    final canvasColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: canvasColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selectedConstructor.isEmpty) _cardDefaultConstructor(),
              if (selectedConstructor == 'inline') _cardInlineFactory(),
              if (selectedConstructor == 'outline') _cardOutlineFactory(),
            ],
          ),
        ),
      ),
    );
  }
}
