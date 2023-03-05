import 'package:flutter/material.dart';
import 'package:storybook_ds/src/widgets/custom_chip_selected.dart';

import '../../ds/dropdown/ds_dropdown_button.dart';
import '../../storybook_ds.dart';

class AtributsVariantWidget extends StatelessWidget {
  final List<AtributeDto> atributs;
  final Function(List<AtributeDto> atributs)? onAtributs;
  final String? constructor;
  const AtributsVariantWidget({
    Key? key,
    required this.atributs,
    required this.onAtributs,
    this.constructor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];

    widgets.add(_buildTitle(context));

    for (var e in atributs) {
      if (_canBuildVariableOption(e)) {
        if (e.builders != null && !e.builders!.contains(constructor)) {
          continue;
        }

        widgets.add(
          _optionsVariants(context, e, atributs),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Padding _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
      ),
      child: Text(
        "Configurações de variantes",
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _optionsVariants(
    BuildContext context,
    AtributeDto e,
    List<AtributeDto> atributs,
  ) {
    double padding = 16.0;
    if (_canBuildVariableOptionTypeBool(e)) {
      return Container(
        margin: const EdgeInsets.only(top: 8.0),
        padding: EdgeInsets.only(left: padding, top: 3, bottom: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTypeDescription(e, context),
            _buildChangeAction(context, e, atributs),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),

        childrenPadding: EdgeInsets.only(left: padding),
        tilePadding: EdgeInsets.only(left: padding, right: padding),
        expandedAlignment: Alignment.centerLeft,
        title: _buildTypeDescription(e, context), //header title
        children: [
          _buildChangeAction(context, e, atributs),
        ],
      ),
    );
  }

  Widget _buildTypeDescription(AtributeDto e, BuildContext context) {
    return RichText(
      text: TextSpan(
        text: e.type,
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          const TextSpan(text: '  '),
          TextSpan(
            text: e.name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
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
              textInDisplay: e.selectedValue?.textInSelectedOptions,
            );
            onAtributs!(atributs);
          }
        },
      );
    }

    if (e.type == 'String' || e.type == 'String?') {
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
            child: Container(
              height: 40,
              margin: const EdgeInsets.only(bottom: 16, right: 16.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
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

    if (e.variableOptionType is WrapType) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 8,
                runAlignment: WrapAlignment.start,
                runSpacing: 8,
                children: e.variableOptions!
                    .map(
                      (e2) => CustomChipSelected(
                          label: e2.textInSelectedOptions,
                          selected: e.selectedValue?.value == e2.value,
                          onTap: () {
                            if (onAtributs != null) {
                              e.selectedValue = e2;

                              onAtributs!(atributs);
                            }
                          }),
                    )
                    .toList(),
              ),
            ),
            if (e.type.contains('?'))
              Switch(
                value: e.selectedValue?.value == null ? false : true,
                onChanged: (value) {
                  e.selectedValue = e.selectedValue?.copyWith(value: null);
                  onAtributs!(atributs);
                },
              ),
          ],
        ),
      );
    }

    if (e.variableOptionType is RangeDoubleIntervalType ||
        e.variableOptionType is RangeIntIntervalType) {
      dynamic va = e.variableOptionType;
      return Row(
        children: [
          Text('${e.selectedValue?.value}'),
          const SizedBox(width: 16),
          const Text('Variação'),
          const SizedBox(width: 16),
          Text('${va.begin}'),
          Expanded(
            child: IgnorePointer(
              ignoring: e.selectedValue?.value == null,
              child: Opacity(
                opacity: e.selectedValue?.value == null ? 0.5 : 1,
                child: Slider(
                  max: double.parse('${va.end}'),
                  min: double.parse('${va.begin}'),
                  value: e.selectedValue?.value ?? va.begin,
                  onChanged: (v) {
                    if (e.variableOptionType is RangeDoubleIntervalType) {
                      e.selectedValue?.value =
                          double.parse(v.toStringAsPrecision(2));
                    } else {
                      e.selectedValue?.value = v.toInt();
                    }

                    onAtributs!(atributs);
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: e.type.contains('?') ? 0.0 : 24.0),
            child: Text('${va.end}'),
          ),
          if (e.type.contains('?'))
            Switch(
              value: e.selectedValue?.value == null ? false : true,
              onChanged: (value) {
                e.selectedValue = VariableOption(
                  value: value ? va.begin : null,
                  textInDisplay: e.selectedValue?.textInDisplay,
                );
                onAtributs!(atributs);
              },
            ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (_, constraints) {
        var children2 = [
          DSDropdownButton<VariableOption>.singleSelection(
            constraints: BoxConstraints(
              minWidth: constraints.minWidth,
              maxWidth: constraints.maxWidth - (e.type.contains('?') ? 60 : 9),
            ),
            buttonHeight: 30,
            onChanged: (value) {
              if (onAtributs != null) {
                e.selectedValue = value;

                onAtributs!(atributs);
              }
            },
            hintText: (e.selectedValue?.textInSelectedOptions ?? ''),
            value: e.selectedValue,
            items: e.variableOptions!
                .map((i) => DSDropdownMenuItem(
                      label: i.textInSelectedOptions,
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
        ];
        return Row(
          children: children2,
        );
      },
    );
  }

  bool _canBuildVariableOption(AtributeDto e) {
    return e.type == 'String' ||
        e.type == 'String?' ||
        e.type == 'bool' ||
        e.type == 'bool?' ||
        e.variableOptionType is RangeIntIntervalType ||
        e.variableOptionType is RangeDoubleIntervalType ||
        e.variableOptions != null;
  }

  bool _canBuildVariableOptionTypeBool(AtributeDto e) {
    return e.type == 'bool' || e.type == 'bool?';
  }
}
