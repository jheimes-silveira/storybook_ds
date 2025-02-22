import 'package:device_frame/device_frame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:input_slider/input_slider.dart';
import 'package:input_slider/input_slider_form.dart';
import 'package:storybook_ds/src/utils/utils.dart';
import 'package:storybook_ds/src/widgets/content_widget.dart';
import 'package:storybook_ds/storybook_ds.dart';

class StoryBookComponentProperties {
  StoryBookComponentProperties({
    this.attributes = const [],
    this.selectedConstructor,
  });

  final List<AttributeDto> attributes;
  String? selectedConstructor;
}

class StoryBookComponentController
    extends ValueNotifier<StoryBookComponentProperties> {
  StoryBookComponentController(this.properties) : super(properties);
  final StoryBookComponentProperties properties;

  List<AttributeDto> get attributes => properties.attributes;

  set attributes(List<AttributeDto> value) {
    properties.attributes.clear();
    properties.attributes.addAll(value);
    onUpdateAttributes(value);
  }

  String? get selectedConstructor => properties.selectedConstructor;

  set selectedConstructor(String? value) {
    properties.selectedConstructor = value;
    notifyListeners();
  }

  dynamic getWhereAttribute(String name) {
    final attribute = attributes.where((e) => e.name == name).first;
    return attribute.selectedValue?.value;
  }

  void onUpdateAttributes(List<AttributeDto> attributes) {
    notifyListeners();
  }
}

class StoryBookComponent extends StatefulWidget {
  const StoryBookComponent({
    super.key,
    required this.child,
    required this.title,
    required this.nameObjectInDisplay,
    this.attributes = const [],
    this.description = '',
    this.controller,
    this.backgroundColor,
  });

  final Widget child;
  final String title;
  final String description;
  final List<AttributeDto> attributes;
  final String nameObjectInDisplay;
  final StoryBookComponentController? controller;
  final Color? backgroundColor;

  @override
  // ignore: no_logic_in_create_state
  State<StoryBookComponent> createState() =>
      kIsWeb ? _StoryBookComponentWebState() : _StoryBookComponentMobileState();
}

class _StoryBookComponentMobileState extends State<StoryBookComponent> {
  late final StoryBookComponentController controller = widget.controller ??
      StoryBookComponentController(
        StoryBookComponentProperties(
          attributes: widget.attributes,
        ),
      );

  Widget get child => widget.child;
  late final String title = widget.title;
  late final String description = widget.description;
  late final String nameObjectInDisplay = widget.nameObjectInDisplay;

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          backgroundColor: widget.backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            bottom: const TabBar(
              labelColor: Colors.black,
              tabs: <Widget>[
                Tab(
                  text: 'Atributos',
                ),
                Tab(
                  text: 'Componente',
                ),
                Tab(
                  text: 'Código',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Center(
                child: _buildContent(),
              ),
              Center(
                child: child,
              ),
              Center(
                child: _buildPreviewCode(),
              ),
            ],
          ),
        ),
      );

  Widget _buildContent() {
    return ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, child) {
          return ContentWidget(
            attributes: controller.attributes,
            onAttributes: (attributes, attribute) {
              if (attribute.onChangeValue != null) {
                attribute.onChangeValue!(attribute);
              } else {
                controller.onUpdateAttributes(attributes);
              }
            },
            description: description,
            title: title,
            constructor: controller.selectedConstructor,
            nameObjectInDisplay: nameObjectInDisplay,
            onSelectedConstructor: (String? constructor) {
              setState(() {
                controller.selectedConstructor = constructor;
              });
            },
            updatePreviewCode: updatePreviewCode,
          );
        });
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
    final atributes = controller.attributes
        .where(
          (e) {
            final constructor = e.builders.isEmpty ||
                e.builders.contains(controller.selectedConstructor);
            final ignoreInDisplay = e.selectedValue?.ignoreInDisplay ?? true;
            return constructor && !ignoreInDisplay;
          },
        )
        .map((e) => "\n    ${e.name}: ${e.toStringValue},")
        .join();
    final constructor = controller.selectedConstructor == null
        ? ''
        : '.${controller.selectedConstructor}';
    final nameClass = nameObjectInDisplay;
    return "$nameClass$constructor($atributes\n)";
  }
}

class _StoryBookComponentWebState extends State<StoryBookComponent> {
  late final StoryBookComponentController controller = widget.controller ??
      StoryBookComponentController(
        StoryBookComponentProperties(
          attributes: widget.attributes,
        ),
      );

  Widget get child => widget.child;
  late final String title = widget.title;
  late final String description = widget.description;
  late final String nameObjectInDisplay = widget.nameObjectInDisplay;

  bool _showSettings = false;
  double _displayWidth = 412;
  double _displayHeight = 732;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.8;

    return Scaffold(
      backgroundColor: widget.backgroundColor,
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
    return ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, child) {
          return ContentWidget(
            attributes: controller.attributes,
            onAttributes: (attributes, attribute) {
              if (attribute.onChangeValue != null) {
                attribute.onChangeValue!(attribute);
              } else {
                controller.onUpdateAttributes(attributes);
              }
            },
            description: description,
            title: title,
            constructor: controller.selectedConstructor,
            nameObjectInDisplay: nameObjectInDisplay,
            onSelectedConstructor: (String? constructor) {
              setState(() {
                controller.selectedConstructor = constructor;
              });
            },
            updatePreviewCode: updatePreviewCode,
          );
        });
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
    final atributes = controller.attributes
        .where(
          (e) {
            final constructor = e.builders.isEmpty ||
                e.builders.contains(controller.selectedConstructor);
            final ignoreInDisplay = e.selectedValue?.ignoreInDisplay ?? true;
            return constructor && !ignoreInDisplay;
          },
        )
        .map((e) => "\n    ${e.name}: ${e.toStringValue},")
        .join();
    final constructor = controller.selectedConstructor == null
        ? ''
        : '.${controller.selectedConstructor}';
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
          screen: child,
        ),
      ),
    );
  }
}
