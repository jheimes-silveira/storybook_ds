import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

import 'models/dto/atribute_dto.dart';
import 'utils/utils.dart';
import 'widgets/content_widget.dart';

abstract class Storybook<T extends StatefulWidget> extends State {
  String? selectedConstructor;

  String get title;

  String get description => '';

  ThemeData get light => ThemeData.light();

  ThemeData get dark => ThemeData.dark();

  List<AtributeDto> get atributs;

  String get nameObjectInDisplay;

  Widget buildComponentWidget(BuildContext context);

  getWhereAtribut(String name) {
    final atribute = atributs.where((e) => e.name == name).first;
    return atribute.selectedValue?.value;
  }

  @protected
  @mustCallSuper
  void onUpdateAtributs(List<AtributeDto> atributs) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 450,
                minWidth: 450,
              ),
              child: _buildContent(),
            ),
          ),
          Expanded(
            flex: 70,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDevice(),
                  _buildPreviewCode(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ContentWidget(
      atributs: atributs,
      onAtributs: (atributs) {
        onUpdateAtributs(atributs);
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
      padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
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
    final atributes = atributs
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

  Widget _buildDevice() {
    const height = 750.0;

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
