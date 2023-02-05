import 'package:flutter/material.dart';
import 'package:storybook_ds/ds/dropdown/ds_dropdown_button.dart';
import '../models/dto/atribute_dto.dart';
import '../utils/utils.dart';

class ContentWidget extends StatelessWidget {
  final String title;
  final String description;
  final String? constructor;
  final String nameObjectInDisplay;
  final List<AtributeDto> atributs;
  final Function(List<AtributeDto> atributs)? onAtributs;
  final Function(String? constructor) onSelectedConstructor;

  const ContentWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.atributs,
    required this.nameObjectInDisplay,
    required this.onSelectedConstructor,
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
            _buildAtributes(context, atributs),
            _buildAtributsVariant(context, atributs),
            _buildPreviewCode(context),
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
                            _generateWidgetToString(),
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
                Utils.copyClipboard(_generateWidgetToString());
              },
              icon: const Icon(Icons.copy, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  String _generateWidgetToString() {
    final atributes = atributs
        .where(
            (e) => e.builders == null || e.builders!.contains(this.constructor))
        .map((e) => "\n    ${e.name}: ${e.toStringValue},")
        .join();
    final constructor = this.constructor == null ? '' : '.${this.constructor}';
    return "$nameObjectInDisplay$constructor($atributes\n)";
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

  Widget _buildAtributsVariant(
    BuildContext context,
    List<AtributeDto> atributs,
  ) {
    final List<Widget> widgets = [];

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
          bottom: 16.0,
        ),
        child: Text(
          "Configurações de variante",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );

    for (var e in atributs) {
      if (e.type.contains('String') ||
          e.type.contains('bool') ||
          e.variableOptions != null) {
        if (e.builders != null && !e.builders!.contains(constructor)) {
          continue;
        }

        widgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _optionsVariants(context, e, atributs),
              const Divider(),
            ],
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _optionsVariants(
    BuildContext context,
    AtributeDto e,
    List<AtributeDto> atributs,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: e.type,
            style: Theme.of(context).textTheme.bodySmall,
            children: [
              const TextSpan(text: '  '),
              TextSpan(
                text: e.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: _buildChangeAction(context, e, atributs),
        ),
      ],
    );
  }

  Widget _buildChangeAction(
    BuildContext context,
    AtributeDto e,
    List<AtributeDto> atributs,
  ) {
    if (e.type == 'bool' || e.type == 'bool?') {
      return Switch(
        value: e.selectedValue?.value,
        onChanged: (value) {
          if (onAtributs != null) {
            e.selectedValue = VariableOption(
              value: value,
              textInDisplay: e.selectedValue?.textInDisplay,
            );
            onAtributs!(atributs);
          }
        },
      );
    }

    if (e.type.contains('String')) {
      final c = TextEditingController(
        text: e.selectedValue?.value ?? '',
      );

      c.selection = TextSelection.fromPosition(
        TextPosition(
          offset: c.text.length,
        ),
      );

      return Row(
        children: [
          Expanded(
            child: TextField(
              key: Key(e.name),
              controller: c,
              enabled: e.selectedValue?.value == null ? false : true,
              onChanged: (text) {
                if (onAtributs != null) {
                  e.selectedValue = e.selectedValue?.copyWith(
                    value: text,
                  );
                  onAtributs!(atributs);
                  c.selection = TextSelection.fromPosition(
                    TextPosition(offset: c.selection.baseOffset),
                  );
                }
              },
            ),
          ),
          if (e.type.contains('?'))
            Switch(
              value: e.selectedValue?.value == null ? false : true,
              onChanged: (value) {
                e.selectedValue = VariableOption(
                  value: value ? '' : null,
                  textInDisplay: e.selectedValue?.textInDisplay,
                );
                onAtributs!(atributs);
              },
            ),
        ],
      );
    }

    return Row(
      children: [
        DSDropdownButton<VariableOption>.singleSelection(
          onChanged: (value) {
            if (onAtributs != null) {
              e.selectedValue = value;

              onAtributs!(atributs);
            }
          },
          hintText: (e.selectedValue?.textInSelectedOptions ??
              e.selectedValue?.textInDisplay ??
              e.selectedValue?.value.toString() ??
              ''),
          value: e.selectedValue,
          items: e.variableOptions!
              .map((i) => DSDropdownMenuItem(
                    label: i.textInSelectedOptions ??
                        i.textInDisplay ??
                        i.value.toString(),
                    value: i,
                  ))
              .toList(),
        ),
        if (e.type.contains('?'))
          Switch(
            value: e.selectedValue?.value == null ? false : true,
            onChanged: (value) {
              if (value) {
                e.selectedValue = e.variableOptions?[0];
              } else {
                e.selectedValue = VariableOption(
                  value: null,
                  textInDisplay: e.selectedValue?.textInDisplay,
                );
              }
              onAtributs!(atributs);
            },
          ),
      ],
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
      child: DSDropdownButton<String>.singleSelection(
        onChanged: (value) {
          onSelectedConstructor(value);
        },
        value: constructor ?? 'default',
        hintText: constructor ?? 'default',
        label: 'Construtores',
        items: builders
            .map((i) => DSDropdownMenuItem(
                  label: i ?? 'default',
                  value: i,
                ))
            .toList(),
      ),
    );
  }
}
