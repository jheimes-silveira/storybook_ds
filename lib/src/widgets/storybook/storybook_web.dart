import 'package:flutter/material.dart';
import 'package:storybook_ds/src/device_preview/device_preview.dart';
import 'package:storybook_ds/src/device_preview/model/tools_panel_model.dart';
import 'package:storybook_ds/src/device_preview/views/tool_panel/sections/accessibility.dart';
import 'package:storybook_ds/src/device_preview/views/tool_panel/sections/device.dart';
import 'package:storybook_ds/src/device_preview/views/tool_panel/sections/section.dart';
import 'package:storybook_ds/src/device_preview/views/tool_panel/sections/settings.dart';
import 'package:storybook_ds/src/models/multiple_theme_settings.dart';
import 'package:storybook_ds/src/utils/typedef_storybook.dart';

import '../../models/dto/attribute_dto.dart';
import '../../utils/utils.dart';
import '../content_widget.dart';

abstract class Storybook<T extends StatefulWidget> extends State<T> {
  /// Construtor selecionado, porem quando não possui nenhum construtor selecionado o padão é null
  String? selectedConstructor;

  /// Título do Storybook.
  String get title;

  /// Descrição do Storybook.
  String get description => '';

  /// Multiplos themas
  MultipleThemeSettings? multipleThemeSettings;

  /// Lista de atributos do Storybook.
  List<AttributeDto> get attributes;

  /// Nome do objeto em exibição.
  String get nameObjectInDisplay;

  /// Constrói o widget do componente.
  Widget buildComponentWidget(BuildContext context);

  OnBuildExtraAttributesConfigCustom? get extraAttributesConfigCustom;

  @protected
  @mustCallSuper
  void onUpdateAttributes(List<AttributeDto> attributes) {
    setState(() {});
  }

  void onUpdateTheme(MultipleThemeSettings multipleThemeSettings) {}

  dynamic getWhereAttribut(String name) {
    final attribute = attributes.firstWhere((e) => e.name == name);
    return attribute.selectedValue?.value;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.97;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildDevice(context, height),
                  ),
                ),
              ],
            ),
            _buildPreviewCode(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ContentWidget(
      multipleThemeSettings: multipleThemeSettings,
      onUpdateTheme: (MultipleThemeSettings multipleThemeSettings) {
        this.multipleThemeSettings = multipleThemeSettings;
        onUpdateTheme(multipleThemeSettings);
      },
      attributes: attributes,
      onAttributes: (attributes, attribute) {
        onUpdateAttributes(attributes);
      },
      description: description,
      title: title,
      constructor: selectedConstructor,
      nameObjectInDisplay: nameObjectInDisplay,
      onSelectedConstructor: (String? constructor) {
        setState(() {
          selectedConstructor = constructor;
        });
      },
      updatePreviewCode: (att) {
        return updatePreviewCode(
          att,
          selectedConstructor: selectedConstructor,
        );
      },
      extraAttributesConfigCustom: this.extraAttributesConfigCustom,
    );
  }

  Widget _buildPreviewCode() {
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
                            updatePreviewCode(
                              attributes,
                              selectedConstructor: selectedConstructor,
                            ),
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
              onPressed: () {
                Utils.copyClipboard(updatePreviewCode(
                  attributes,
                  selectedConstructor: selectedConstructor,
                ));
              },
              icon: const Icon(Icons.copy, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  @protected
  @mustCallSuper
  String updatePreviewCode(
    List<AttributeDto> attributes, {
    String? newNameClass,
    String? selectedConstructor,
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
    final constructor =
        selectedConstructor == null ? '' : '.$selectedConstructor';
    final nameClass = newNameClass ?? nameObjectInDisplay;
    return "$nameClass$constructor($attributesString\n${breakSpaceLevel(level)})";
  }

  String toStringValue(AttributeDto attribute, int level) {
    if (attribute.type.contains('String') &&
        attribute.selectedValue?.value != null) {
      return '\'${attribute.selectedValue?.textInDisplay ?? attribute.selectedValue?.value}\'';
    }
    if (attribute.variableOptionType is ObjectInObjectType) {
      return updatePreviewCode(
        (attribute.variableOptionType as ObjectInObjectType).children,
        newNameClass: attribute.selectedValue?.value.runtimeType.toString(),
        level: level + 1,
        selectedConstructor: null, //TODO obter um construtor de sub object
      );
    }
    return '${attribute.selectedValue?.textInDisplay ?? attribute.selectedValue?.value}';
  }

  Widget _buildDevice(BuildContext context, double height) {
    return Center(
      child: SizedBox(
        height: height,
        child: DevicePreview(
          enabled: true,
          isToolbarVisible: true,
          toolsPanelRight: ToolsPanelModel(
            tools: [
              const DeviceSection(),
              const AccessibilitySection(),
              const SettingsSection(),
            ],
          ),
          toolsPanelLeft: ToolsPanelModel(
            tools: [
              ToolPanelSection(
                title: '',
                children: [_buildContent()],
              ),
            ],
            panelWidth: 400,
          ),
          builder: (context2) => MaterialApp(
            useInheritedMediaQuery: true,
            builder: DevicePreview.appBuilder,
            theme: Theme.of(context),
            debugShowCheckedModeBanner: false,
            home: buildComponentWidget(context2),
          ),
        ),
      ),
    );
  }

  String breakSpaceLevel(int level) {
    String space = '';
    for (int i = 0; i < level; i++) {
      space += '    ';
    }
    return space;
  }
}
