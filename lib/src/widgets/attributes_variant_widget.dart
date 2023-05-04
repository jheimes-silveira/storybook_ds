import 'package:flutter/material.dart';
import 'package:storybook_ds/src/widgets/custom_chip_selected.dart';

import '../../storybook_ds.dart';

class AttributesVariantWidget extends StatelessWidget {
  final List<AttributeDto> attributes;
  final Function(List<AttributeDto> attributes)? onAttributes;
  final String? constructor;
  const AttributesVariantWidget({
    Key? key,
    required this.attributes,
    required this.onAttributes,
    this.constructor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTitle(context),
            ...attributes
                .where(
                  (e) => e.builders.isEmpty || e.builders.contains(constructor),
                )
                .map(
                  (e) => Padding(
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

                      childrenPadding: const EdgeInsets.only(left: 8),
                      tilePadding: const EdgeInsets.only(left: 8, right: 8),
                      expandedAlignment: Alignment.centerLeft,
                      title: Row(
                        children: [
                          _buildTypeDescription(e, context),
                          const SizedBox(width: 8),
                          _buildNameDescription(e, context),
                          const SizedBox(width: 8),
                          _buildIsRequired(e, context),
                          const SizedBox(width: 8),
                          if (_canBuildVariableOptionTypeBool(e))
                            _buildVariableOptionTypeBool(e, attributes),
                        ],
                      ),
                      // leading: Container(),
                      trailing: _canBuildVariableOptionTypeBool(e)
                          ? _isVariableNubable(e, attributes)
                          : (_canBuildVariableOption(e)
                              ? null
                              : const SizedBox()),

                      children: [
                        if (!_canBuildVariableOptionTypeBool(e))
                          Row(
                            children: [
                              Expanded(
                                child:
                                    _buildChangeAction(context, e, attributes),
                              ),
                              _isVariableNubable(e, attributes),
                            ],
                          ),
                      ],
                    ),
                  ),
                )
                .toList(),
            const SizedBox(height: 150),
          ],
        );
      },
    );
  }

  Widget _buildIsRequired(AttributeDto e, BuildContext context) {
    return e.required
        ? Text(
            'Obrigatório *',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold, color: Colors.redAccent),
          )
        : const SizedBox();
  }

  Padding _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
      ),
      child: Text(
        "Atributos",
        style: Theme.of(context).textTheme.titleLarge,
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
    if (e.type == 'String' || e.type == 'String?') {
      final c = TextEditingController(
        text: e.selectedValue?.value ?? '',
      );

      c.selection = TextSelection.fromPosition(
        TextPosition(
          offset: c.text.length,
        ),
      );

      return Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16.0),
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

    if (e.variableOptionType is FunctionType) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 8),
        child: Text((e.variableOptionType as FunctionType)
            .function
            .runtimeType
            .toString()),
      );
    }

    if (e.variableOptions != null) {
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

  Widget _isVariableNubable(
    AttributeDto e,
    List<AttributeDto> attributes,
  ) {
    if (e.type.contains('?')) {
      return Switch(
        value: e.selectedValue?.value == null ? false : true,
        onChanged: (value) {
          e.selectedValue = value ? (e.variableOptions![0]) : null;
          onAttributes!(attributes);
        },
      );
    }

    return const SizedBox();
  }

  Widget _buildVariableOptionTypeBool(
    AttributeDto e,
    List<AttributeDto> attributes,
  ) {
    return Opacity(
      opacity: e.selectedValue?.value == null ? 0.5 : 1,
      child: IgnorePointer(
        ignoring: e.selectedValue?.value == null,
        child: Switch(
          value: e.selectedValue?.value ?? false,
          onChanged: (value) {
            e.selectedValue?.value = value;
            onAttributes!(attributes);
          },
        ),
      ),
    );
  }
}
