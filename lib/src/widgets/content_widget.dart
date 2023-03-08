import 'package:flutter/material.dart';
import 'package:storybook_ds/src/widgets/atributs_variant_widget.dart';

import '../models/dto/atribute_dto.dart';
import '../utils/utils.dart';
import 'custom_chip_selected.dart';

class ContentWidget extends StatelessWidget {
  final String title;
  final String description;
  final String? constructor;
  final String nameObjectInDisplay;
  final List<AtributeDto> atributs;
  final Function(List<AtributeDto> atributs)? onAtributs;
  final Function(String? constructor) onSelectedConstructor;
  final String Function() updatePreviewCode;

  const ContentWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.atributs,
    required this.nameObjectInDisplay,
    required this.onSelectedConstructor,
    required this.updatePreviewCode,
    this.onAtributs,
    this.constructor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(
          right: 32,
          left: 32,
          top: 48,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTitle(context),
            _buildDescription(context),
            _buildBuilders(context, atributs),
            _buildAtributsVariant(atributs),
            // _buildPreviewCode(context),
          ],
        ),
      ),
    );
  }

  Padding _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: SelectableText(
        description,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Text _buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  _buildBuilders(BuildContext context, List<AtributeDto> atributs) {
    List<String?> builders = [];
    for (var e in atributs) {
      if (e.builders.isNotEmpty) {
        for (var e2 in e.builders) {
          if (!builders.contains(e2)) {
            builders.add(e2);
          }
        }
      } else if (!builders.contains(null)) {
        builders.insert(0, null);
      }
    }

    if (builders.isNotEmpty &&
        !builders.contains(null) &&
        constructor == null) {
      Future.delayed(const Duration(milliseconds: 50))
          .then((_) => onSelectedConstructor(builders[0]));
    }


    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Construtores",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 8,
            runAlignment: WrapAlignment.start,
            runSpacing: 8,
            children: builders
                .map(
                  (e2) => CustomChipSelected(
                      label: e2 ?? 'default',
                      selected: constructor == e2,
                      onTap: () {
                        if (onAtributs != null) {
                          onSelectedConstructor(e2);

                          onAtributs!(atributs);
                        }
                      }),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAtributsVariant(List<AtributeDto> atributs) {
    return AtributsVariantWidget(
      atributs: atributs,
      onAtributs: onAtributs,
      constructor: constructor,
    );
  }
}
