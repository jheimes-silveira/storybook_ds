import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:storybook_ds/src/widgets/attributes_variant_table_widget.dart';

import 'models/dto/attribute_dto.dart';
import 'utils/utils.dart';
import 'widgets/content_widget.dart';

abstract class Storybook<T extends StatefulWidget> extends State {
  String? selectedConstructor;

  String get title;

  String get description => '';

  ThemeData get light => ThemeData.light();

  ThemeData get dark => ThemeData.dark();

  List<AttributeDto> get attributes;

  String get nameObjectInDisplay;

  Widget buildComponentWidget(BuildContext context);

  getWhereAttribut(String name) {
    final attribute = attributes.where((e) => e.name == name).first;
    return attribute.selectedValue?.value;
  }

  @protected
  @mustCallSuper
  void onUpdateAttributes(List<AttributeDto> attributes) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.8;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
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
                    child: _buildDevice(height),
                  ),
                ),
              ],
            ),
            _buildPreviewCode(),
            // AttributesVariantTableWidget(
            //   attributes: attributes,
            //   onAttributes: (attributes) {
            //     onUpdateAttributes(attributes);
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ContentWidget(
      attributes: attributes,
      onAttributes: (attributes) {
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
      padding: const EdgeInsets.all(32.0),
      child: Stack(
        children: [
          Card(
            elevation: 0,
            color: Colors.grey[800],
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
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                    ),
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
    final atributes = attributes
        .where(
          (e) {
            final constructor = e.builders.isEmpty ||
                e.builders.contains(this.selectedConstructor);
            final ignoreInDisplay = e.selectedValue?.ignoreInDisplay ?? true;
            return constructor && !ignoreInDisplay;
          },
        )
        .map((e) => "\n    ${e.name}: ${e.toStringValue},")
        .join();
    final constructor =
        this.selectedConstructor == null ? '' : '.${this.selectedConstructor}';
    final nameClass = nameObjectInDisplay;
    return "$nameClass$constructor($atributes\n)";
  }

  Widget _buildDevice(double height) {
    return SizedBox(
      height: height,
      child: DeviceFrame(
        isFrameVisible: true,
        device: Devices.android.samsungGalaxyNote20Ultra,
        screen: Builder(
          builder: (deviceContext) => buildComponentWidget(deviceContext),
        ),
      ),
    );
  }
}
