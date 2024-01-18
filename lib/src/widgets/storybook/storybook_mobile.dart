import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

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

  @protected
  @mustCallSuper
  void onUpdateAttributes(List<AttributeDto> attributes) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
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
              child: buildComponentWidget(context),
            ),
            Center(
              child: _buildPreviewCode(),
            ),
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
                e.builders.contains(selectedConstructor);
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
}
