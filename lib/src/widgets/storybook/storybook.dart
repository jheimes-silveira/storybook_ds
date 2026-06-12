import 'package:flutter/material.dart';
import 'package:storybook_ds/src/device_preview/device_preview.dart';
import 'package:storybook_ds/src/device_preview/model/tools_panel_model.dart';
import 'package:storybook_ds/src/device_preview/views/tool_panel/sections/accessibility.dart';
import 'package:storybook_ds/src/device_preview/views/tool_panel/sections/device.dart';
import 'package:storybook_ds/src/device_preview/views/tool_panel/sections/section.dart';
import 'package:storybook_ds/src/device_preview/views/tool_panel/sections/settings.dart';
import 'package:storybook_ds/src/models/multiple_theme_settings.dart';
import 'package:storybook_ds/src/theme/storybook_theme.dart';
import 'package:storybook_ds/src/theme/storybook_theme_scope.dart';
import 'package:storybook_ds/src/utils/typedef_storybook.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_change_bus.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_editor_registry.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_editor_strategies.dart';

import '../../models/model/attribute_model.dart';
import '../../utils/utils.dart';
import '../content_widget.dart';

import 'storybook_component/storybook_component.dart';

abstract class Storybook<T extends StatefulWidget> extends State<T> {
  StoryBookComponentController? internalController;
  StoryBookComponentController get controller {
    internalController ??= StoryBookComponentController(
      StoryBookComponentProperties(
        attributes: attributes,
        selectedConstructor: '',
      ),
    );
    return internalController!;
  }

  String get selectedConstructor => controller.selectedConstructor ?? '';
  set selectedConstructor(String value) {
    controller.selectedConstructor = value;
  }

  /// Título do Storybook.
  String get title;

  /// Descrição do Storybook.
  String get description => '';

  /// Multiplos themas
  MultipleThemeSettings? multipleThemeSettings;

  /// Lista de atributos do Storybook.
  List<AttributeModel> get attributes;

  /// Nome do objeto em exibição.
  String get nameObjectInDisplay;

  /// Constrói o widget do componente.
  Widget buildComponentWidget(BuildContext context);

  OnBuildExtraAttributesConfigCustom? get extraAttributesConfigCustom;

  /// Tema customizável do storybook.
  /// Se null, usa [StorybookTheme.defaults].
  StorybookTheme? get storybookTheme => null;

  /// Flag de inicialização: registra as estratégias padrão do
  /// [AttributeEditorRegistry] apenas uma vez por processo.
  static bool _strategiesRegistered = false;

  /// Barramento de mudanças **desta instância** de `Storybook`.
  /// Usado para que `onUpdateAttributes` saiba se há mudanças
  /// pendentes sem chamar `setState(() {})` cegamente. Cada
  /// `Storybook` possui a sua própria instância — não é singleton.
  final AttributeChangeBus _changeBus = AttributeChangeBus();

  @override
  void initState() {
    super.initState();
    // Garante (uma única vez no processo) que as estratégias padrão
    // estão registradas no [AttributeEditorRegistry].
    if (!_strategiesRegistered) {
      _strategiesRegistered = true;
      registerStandardAttributeStrategies(AttributeEditorRegistry.instance);
    }
  }

  @protected
  @mustCallSuper
  void onUpdateAttributes(List<AttributeModel> attributes) {
    _changeBus.clear();
    controller.onUpdateAttributes(attributes);
  }

  void onUpdateTheme(MultipleThemeSettings multipleThemeSettings) {}

  void onUpdateSelectedConstructor(String constructor) {
    controller.selectedConstructor = constructor;
  }

  dynamic getWhereAttribut(String name) {
    final attribute = attributes.firstWhere(
      (e) => e.name == name,
      orElse: () => AttributeModel(type: '', name: ''),
    );
    return attribute.selectedValue?.value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = storybookTheme ?? StorybookTheme.defaults();
    final viewInsets = MediaQuery.of(context).viewInsets;
    final availableHeight =
        (MediaQuery.of(context).size.height - viewInsets.bottom) * 0.97;

    return StorybookThemeScope(
      theme: theme,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: ValueListenableBuilder<StoryBookComponentProperties>(
              valueListenable: controller,
              builder: (context, properties, child) {
                return Column(
                  children: [
                    _StoryPreview(
                      height: availableHeight,
                      buildComponentWidget: buildComponentWidget,
                      multipleThemeSettings: multipleThemeSettings,
                      selectedConstructor: properties.selectedConstructor ?? '',
                      onUpdateTheme: onUpdateTheme,
                      attributes: properties.attributes,
                      onUpdateAttributes: onUpdateAttributes,
                      description: description,
                      title: title,
                      nameObjectInDisplay: nameObjectInDisplay,
                      onSelectedConstructor: (String c) {
                        selectedConstructor = c;
                        onUpdateSelectedConstructor(c);
                      },
                      updatePreviewCode: updatePreviewCode,
                      extraAttributesConfigCustom: extraAttributesConfigCustom,
                      changeBus: _changeBus,
                    ),
                    _StoryCodeView(
                      attributes: properties.attributes,
                      selectedConstructor: properties.selectedConstructor ?? '',
                      nameObjectInDisplay: nameObjectInDisplay,
                      updatePreviewCode: updatePreviewCode,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @protected
  @mustCallSuper
  String updatePreviewCode(
    List<AttributeModel> attributes, {
    required String selectedConstructor,
    String? newNameClass,
    int level = 0,
  }) {
    final attributesString = attributes
        .where((e) {
          final constructor =
              e.builders.isEmpty || e.builders.contains(selectedConstructor);
          final ignoreInDisplay = e.selectedValue?.ignoreInDisplay ?? true;
          return constructor && !ignoreInDisplay;
        })
        .map((e) =>
            "\n${breakSpaceLevel(level + 1)}${e.name}: ${toStringValue(e, level)},")
        .join();
    final constructorSuffix =
        selectedConstructor.isEmpty ? '' : '.$selectedConstructor';
    final nameClass = newNameClass ?? nameObjectInDisplay;

    final att = "$attributesString${attributesString.isNotEmpty ? '\n' : ''}";
    final codeBreak = attributesString.isNotEmpty ? breakSpaceLevel(level) : '';
    return "$nameClass$constructorSuffix($att$codeBreak)";
  }

  String toStringValue(AttributeModel attribute, int level) {
    if (attribute.type.contains('String') &&
        attribute.selectedValue?.value != null) {
      return '\'${attribute.selectedValue?.textInDisplay ?? attribute.selectedValue?.value}\'';
    }
    if (attribute.variableOptionType is ObjectInObjectType) {
      return updatePreviewCode(
        (attribute.variableOptionType as ObjectInObjectType).children,
        newNameClass: attribute.selectedValue?.value.runtimeType.toString(),
        level: level + 1,
        selectedConstructor: '',
      );
    }
    return '${attribute.selectedValue?.textInDisplay ?? attribute.selectedValue?.value}';
  }

  String breakSpaceLevel(int level) {
    if (level <= 0) return '';
    return '    ' * level;
  }
}

/// Preview subtree - renders DevicePreview + buildComponentWidget
class _StoryPreview extends StatelessWidget {
  const _StoryPreview({
    required this.height,
    required this.buildComponentWidget,
    required this.multipleThemeSettings,
    required this.selectedConstructor,
    required this.onUpdateTheme,
    required this.attributes,
    required this.onUpdateAttributes,
    required this.description,
    required this.title,
    required this.nameObjectInDisplay,
    required this.onSelectedConstructor,
    required this.updatePreviewCode,
    required this.extraAttributesConfigCustom,
    required this.changeBus,
  });

  final double height;
  final Widget Function(BuildContext) buildComponentWidget;
  final MultipleThemeSettings? multipleThemeSettings;
  final String selectedConstructor;
  final void Function(MultipleThemeSettings) onUpdateTheme;
  final List<AttributeModel> attributes;
  final void Function(List<AttributeModel>) onUpdateAttributes;
  final String description;
  final String title;
  final String nameObjectInDisplay;
  final void Function(String) onSelectedConstructor;
  final String Function(List<AttributeModel>, {required String selectedConstructor, String? newNameClass, int level}) updatePreviewCode;
  final OnBuildExtraAttributesConfigCustom? extraAttributesConfigCustom;
  final AttributeChangeBus changeBus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: SizedBox(
          height: height,
          child: DevicePreview(
            enabled: true,
            isToolbarVisible: true,
            toolsPanelRight: ToolsPanelModel(
              tools: const [
                DeviceSection(),
                AccessibilitySection(),
                SettingsSection(),
              ],
            ),
            toolsPanelLeft: ToolsPanelModel(
              tools: [
                ToolPanelSection(
                  title: '',
                  children: [
                    ContentWidget(
                      multipleThemeSettings: multipleThemeSettings,
                      onUpdateTheme: onUpdateTheme,
                      attributes: attributes,
                      onAttributes: (attrs, attr) => onUpdateAttributes(attrs),
                      description: description,
                      title: title,
                      constructor: selectedConstructor,
                      nameObjectInDisplay: nameObjectInDisplay,
                      onSelectedConstructor: onSelectedConstructor,
                      updatePreviewCode: (att) => updatePreviewCode(att, selectedConstructor: selectedConstructor),
                      extraAttributesConfigCustom: extraAttributesConfigCustom,
                      changeBus: changeBus,
                    ),
                  ],
                ),
              ],
              panelWidth: 400,
            ),
            builder: (context2) => MaterialApp(
              builder: DevicePreview.appBuilder,
              theme: Theme.of(context),
              debugShowCheckedModeBanner: false,
              home: buildComponentWidget(context2),
            ),
          ),
        ),
      ),
    );
  }
}

/// Code view subtree - renders the generated code snippet
class _StoryCodeView extends StatelessWidget {
  const _StoryCodeView({
    required this.attributes,
    required this.selectedConstructor,
    required this.nameObjectInDisplay,
    required this.updatePreviewCode,
  });

  final List<AttributeModel> attributes;
  final String selectedConstructor;
  final String nameObjectInDisplay;
  final String Function(List<AttributeModel>, {required String selectedConstructor, String? newNameClass, int level}) updatePreviewCode;

  String _generateCode() {
    return updatePreviewCode(
      attributes,
      selectedConstructor: selectedConstructor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final code = _generateCode();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Stack(
        children: [
          Card(
            elevation: 0,
            color: Colors.grey.shade900,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: SelectableText(
                            code,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              color: Colors.white,
              onPressed: () => Utils.copyClipboard(code),
              icon: const Icon(Icons.copy, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
