import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

/// Widget de input numérico (Slider) com type-safety robusta.
///
/// Usa [AttributeValue] para conversões seguras, evitando `TypeError` quando
/// o `selectedValue.value` não é numérico (ex.: `bool` após toggle do switch).
class ItemAttributeNumber extends StatefulWidget {
  final AttributeModel attribute;
  final List<AttributeModel> attributes;
  final Function(
    List<AttributeModel> attributes,
    AttributeModel currentAtribute,
  )? onAttributes;
  const ItemAttributeNumber({
    super.key,
    required this.attribute,
    required this.attributes,
    this.onAttributes,
  });

  @override
  State<ItemAttributeNumber> createState() => _ItemAttributeNumberState();
}

class _ItemAttributeNumberState extends State<ItemAttributeNumber> {
  // RN-04.2: Valor local para debounce visual durante o arrasto
  double? _localValue;

  @override
  Widget build(BuildContext context) {
    // O switch de "pode ser null" é renderizado pelo
    // `_NullableTrailingSwitch` no trailing do `AttributeVariant`
    // (ao lado do nome e tipo), para evitar duplicação.
    return _buildChangeAction(
      widget.attribute,
      widget.attributes,
    );
  }

  Widget _buildChangeAction(
    AttributeModel e,
    List<AttributeModel> attributes,
  ) {
    final variableType = e.variableOptionType;
    final double begin;
    final double end;
    final bool isIntRange;

    if (variableType is RangeDoubleIntervalType) {
      begin = variableType.begin;
      end = variableType.end;
      isIntRange = false;
    } else if (variableType is RangeIntIntervalType) {
      begin = variableType.begin.toDouble();
      end = variableType.end.toDouble();
      isIntRange = true;
    } else {
      return const _InvalidRangeHint();
    }

    // Garante que currentValue é sempre um double válido dentro do range
    final storedValue = AttributeValue.toDouble(
      e.selectedValue,
      fallback: begin,
    );
    final currentValue = (_localValue ?? storedValue).clamp(begin, end);
    final isNull = e.selectedValue == null || e.selectedValue?.value == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 48,
              child: Text(
                currentValue.toStringAsFixed(isIntRange ? 0 : 2),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              e.description ?? 'Variação',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Spacer(),
            SizedBox(
              width: 32,
              child: Text(
                '$begin',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Tooltip(
          message: e.description ?? '${e.name}: $begin – $end',
          child: IgnorePointer(
            ignoring: isNull,
            child: Opacity(
              opacity: isNull ? 0.5 : 1,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                ),
                child: Slider(
                  key: ValueKey('number-${e.name}'),
                  max: end,
                  min: begin,
                  value: currentValue,
                  onChanged: isNull
                      ? null
                      : (v) {
                          setState(() {
                            _localValue =
                                isIntRange ? v.roundToDouble() : v;
                          });
                        },
                  onChangeEnd: isNull
                      ? null
                      : (v) {
                          setState(() {
                            _localValue = null;
                          });
                          // Garante tipo correto ao gravar
                          if (e.selectedValue == null) {
                            e.selectedValue = VariableOption(
                              value: isIntRange ? v.round() : v,
                            );
                          } else {
                            e.selectedValue!.value =
                                isIntRange ? v.round() : v;
                          }
                          widget.onAttributes?.call(attributes, e);
                          e.onChangeValue?.call(e);
                        },
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$end',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

/// Hint visual mostrado quando o range não é de um tipo suportado.
class _InvalidRangeHint extends StatelessWidget {
  const _InvalidRangeHint();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Colors.orange, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tipo de range inválido. Use RangeIntIntervalType ou RangeDoubleIntervalType.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
