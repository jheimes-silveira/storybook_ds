import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/multiple_theme_settings.dart';

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
    final height = MediaQuery.of(context).size.height * 0.85;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 450,
                        minWidth: 450,
                      ),
                      child: _buildContent(),
                    ),
                  ),
                ),
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
        setState(() {
          this.multipleThemeSettings = multipleThemeSettings;
          onUpdateTheme(multipleThemeSettings);
        });
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
      updatePreviewCode: updatePreviewCode,
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
                            updatePreviewCode(),
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
                Utils.copyClipboard(updatePreviewCode());
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
  String updatePreviewCode() {
    final attributesString = attributes
        .where((e) {
          final constructor =
              e.builders.isEmpty || e.builders.contains(selectedConstructor);
          final ignoreInDisplay = e.selectedValue?.ignoreInDisplay ?? true;
          return constructor && !ignoreInDisplay;
        })
        .map((e) => "\n    ${e.name}: ${e.toStringValue},")
        .join();
    final constructor =
        selectedConstructor == null ? '' : '.$selectedConstructor';
    final nameClass = nameObjectInDisplay;
    return "$nameClass$constructor($attributesString\n)";
  }

  Widget _buildDevice(BuildContext context, double height) {
    return Center(
      child: SizedBox(
        height: height,
        child: DevicePreview(
          enabled: true,
          isToolbarVisible: true,
          tools: [
            DeviceSection(),
            AccessibilitySection(),
            SettingsSection(),
          ],
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
}
