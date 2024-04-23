import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:input_slider/input_slider.dart';
import 'package:input_slider/input_slider_form.dart';

import '../../models/dto/attribute_dto.dart';
import '../../utils/utils.dart';
import '../content_widget.dart';

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

  bool _showSettings = false;
  double _displayWidth = 412;
  double _displayHeight = 732;

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
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showSettings = !_showSettings;
              });
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 32),
        ],
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
                Column(
                  children: [
                    AnimatedContainer(
                        padding: const EdgeInsets.only(right: 32, top: 32),
                        height: _showSettings
                            ? MediaQuery.of(context).size.height * 0.4
                            : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: InputSliderForm(
                          leadingWeight: 1,
                          sliderWeight: 20,
                          filled: true,
                          vertical: true,
                          children: [
                            InputSlider(
                              onChange: (value) {
                                setState(() {
                                  _displayWidth = value;
                                });
                              },
                              min: 150.0,
                              max: 3000.0,
                              defaultValue: 412,
                              leading: const Icon(Icons.width_normal_rounded),
                              leadingWeight: 2,
                            ),
                            InputSlider(
                              onChange: (value) {
                                setState(() {
                                  _displayHeight = value;
                                });
                              },
                              leading: const Icon(Icons.height_rounded),
                              leadingWeight: 2,
                              min: 250.0,
                              max: 3000.0,
                              defaultValue: 732,
                            ),
                          ],
                        )),
                  ],
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
    final atributes = attributes
        .where(
          (e) {
            final constructor =
                e.builders.isEmpty || e.builders.contains(selectedConstructor);
            final ignoreInDisplay = e.selectedValue?.ignoreInDisplay ?? true;
            return constructor && !ignoreInDisplay;
          },
        )
        .map((e) => "\n    ${e.name}: ${e.toStringValue},")
        .join();
    final constructor =
        selectedConstructor == null ? '' : '.$selectedConstructor';
    final nameClass = nameObjectInDisplay;
    return "$nameClass$constructor($atributes\n)";
  }

  Widget _buildDevice(double height) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: SizedBox(
        height: height,
        child: DeviceFrame(
          isFrameVisible: true,
          device: DeviceInfo.genericPhone(
            screenSize: Size(
              _displayWidth,
              _displayHeight,
            ),
            name: 'Medium',
            id: 'medium',
            platform: TargetPlatform.windows,
          ),
          screen: Builder(
            builder: (deviceContext) => buildComponentWidget(deviceContext),
          ),
        ),
      ),
    );
  }
}
