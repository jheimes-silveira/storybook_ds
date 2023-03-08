import 'package:flutter/material.dart';
import 'package:storybook_ds/src/widgets/atributs_variant_widget.dart';

import '../models/dto/atribute_dto.dart';
import '../utils/utils.dart';
import 'atributs_variant_table_widget.dart';
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
            // _buildDescription(context),
            _buildBuilders(context, atributs),
            // _buildAtributes(context, atributs),
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

  Widget _buildPreviewCode(BuildContext context) {
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

  Widget _buildAtributes(BuildContext context, List<AtributeDto> atributes) {
    List<Widget> widgets = [];

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          'Atributos',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );

    for (var e in atributes) {
      if (e.builders == null || e.builders!.contains(constructor)) {
        widgets.add(
          Container(
            padding: const EdgeInsets.only(top: 4),
            child: RichText(
              text: TextSpan(
                children: [
                  if (e.required)
                    TextSpan(
                      text: 'Obrigatório *   ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  TextSpan(
                    text: e.type,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const TextSpan(text: '  '),
                  TextSpan(
                    text: e.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  _buildBuilders(BuildContext context, List<AtributeDto> atributs) {
    List<String?> builders = [];
    for (var e in atributs) {
      if (e.builders != null) {
        for (var e2 in e.builders!) {
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

    if (builders.isEmpty || (builders.length == 1 && builders[0] == null)) {
      return const SizedBox();
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
      // child: DSDropdownButton<String>.singleSelection(
      //   onChanged: (value) {
      //     onSelectedConstructor(value);
      //   },
      //   value: constructor ?? 'default',
      //   hintText: constructor ?? 'default',
      //   label: 'Construtores',
      //   items: builders
      //       .map((i) => DSDropdownMenuItem(
      //             label: i ?? 'default',
      //             value: i,
      //           ))
      //       .toList(),
      // ),
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
