import 'package:flutter/material.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'package:storybook_ds/src/widgets/custom_chip_selected.dart';

import '../../storybook_ds.dart';

class AttributesVariantTableWidget extends StatelessWidget {
  final List<AttributeDto> attributes;
  final Function(List<AttributeDto> attributes)? onAttributes;
  final String? constructor;
  const AttributesVariantTableWidget({
    Key? key,
    required this.attributes,
    required this.onAttributes,
    this.constructor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];

    widgets.add(_buildTitle(context));

    for (var e in attributes) {
      if (_canBuildVariableOption(e)) {
        if (e.builders.isNotEmpty && !e.builders.contains(constructor)) {
          continue;
        }

        widgets.add(
          _optionsVariants(context, e, attributes),
        );
      }
    }
    return LayoutBuilder(
      builder: (_, constraints) {
        return SizedBox(
          height: 700,
          child: ScrollableTableView(
            columns: [
              TableViewColumn(
                label: "Nome",
                width: constraints.maxWidth / 5,
              ),
              TableViewColumn(
                label: "Tipo",
                width: constraints.maxWidth / 5,
              ),
              TableViewColumn(
                label: "Obrigatório",
                width: constraints.maxWidth / 5,
              ),
              TableViewColumn(
                label: "Default",
                width: constraints.maxWidth / 5,
              ),
              TableViewColumn(
                label: "Pode ser null?",
                width: constraints.maxWidth / 5,
              ),
            ],
            rows: attributes.map((e) {
              return TableViewRow(
                height: 60,
                cells: [
                  TableViewCell(
                    child: _buildNameDescription(e, context),
                  ),
                  TableViewCell(
                    child: _buildTypeDescription(e, context),
                  ),
                  TableViewCell(
                    child: _buildRequired(context, e.required),
                  ),
                  TableViewCell(
                    child: Text(e.defaultValue?.value ?? ''),
                  ),
                  TableViewCell(
                    child: _buildRequired(context, e.type.contains('?')),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: widgets,
    // );
  }

  Text _buildRequired(BuildContext context, bool required) {
    return Text(
      '$required',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: required ? Colors.green : Colors.redAccent),
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
    AttributeDto e,
    List<AttributeDto> attributes,
  ) {
    double padding = 16.0;

    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: EdgeInsets.only(left: padding, top: 3, bottom: 3),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(8),
      //   border: Border.all(
      //     color: Colors.grey,
      //     width: 1,
      //   ),
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTypeDescription(e, context),
          Expanded(child: _buildChangeAction(context, e, attributes)),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ExpansionTile(
        childrenPadding: EdgeInsets.only(left: padding),
        tilePadding: EdgeInsets.only(left: padding, right: padding),
        expandedAlignment: Alignment.centerLeft,
        title: _buildTypeDescription(e, context), //header title
        children: [
          _buildChangeAction(context, e, attributes),
        ],
      ),
    );
  }

  Widget _buildNameDescription(AttributeDto e, BuildContext context) {
    return Text(
      e.name,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildTypeDescription(AttributeDto e, BuildContext context) {
    return Text(
      e.type,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildChangeAction(
    BuildContext context,
    AttributeDto e,
    List<AttributeDto> attributes,
  ) {
    if (e.type == 'bool' || e.type == 'bool?') {
      return Switch(
        value: e.selectedValue?.value,
        onChanged: (value) {
          if (onAttributes != null) {
            e.selectedValue = VariableOption(
              value: value,
              textInDisplay: e.selectedValue?.textInSelectedOptions,
            );
            onAttributes!(attributes);
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

      return Container(
        height: 40,
        width: 360,
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
            if (onAttributes != null) {
              e.selectedValue = e.selectedValue?.copyWith(
                value: text,
              );
              onAttributes!(attributes);
              c.selection = TextSelection.fromPosition(
                TextPosition(offset: c.selection.baseOffset),
              );
            }
          },
        ),
      );
    }

    if (e.variableOptionType is WrapType) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 8),
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
                      if (onAttributes != null) {
                        e.selectedValue = e2;

                        onAttributes!(attributes);
                      }
                    }),
              )
              .toList(),
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

                    onAttributes!(attributes);
                  },
                ),
              ),
            ),
          ),
          Text('${va.end}'),
        ],
      );
    }

    return Container();
  }

  bool _canBuildVariableOption(AttributeDto e) {
    return e.type == 'String' ||
        e.type == 'String?' ||
        e.type == 'bool' ||
        e.type == 'bool?' ||
        e.variableOptionType is RangeIntIntervalType ||
        e.variableOptionType is RangeDoubleIntervalType ||
        e.variableOptions != null;
  }

  bool _canBuildVariableOptionTypeBool(AttributeDto e) {
    return e.type == 'bool' || e.type == 'bool?';
  }

  _isVariableNubable(
    BuildContext context,
    AttributeDto e,
    List<AttributeDto> attributes,
  ) {
    if (e.type.contains('?')) {
      return Switch(
        value: e.selectedValue?.value == null ? false : true,
        onChanged: (value) {
          e.selectedValue = value ? e.variableOptions![0] : null;
          onAttributes!(attributes);
        },
      );
    }

    return Container();
  }
}
