import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

import '../custom_chip_selected.dart';

/// Widget de input para atributos do tipo `Function` (callbacks).
///
/// Exibe o nome/tipo do callback, uma lista de chips com cenários
/// pré-configurados (declarados em [AttributeModel.function.scenarios]),
/// um botão "Disparar" que invoca a função e um histórico inline das
/// últimas 3 chamadas.
///
/// ## Comportamento (RN-01, RN-09)
/// - **Sem `setState` para reatividade global**: mudanças no atributo
///   são propagadas via `onAttributes` e o widget é reconstruído pelo
///   `AttributeVariant` (que ouve o `AttributeChangeBus`).
/// - **`setState` local** é usado apenas para interações puramente
///   visuais deste widget (seleção de chip, histórico, expansão do
///   histórico) — nunca dispara rebuilds globais.
/// - Aplica o [StorybookTheme] lido via [StorybookThemeScope.of] (RN-05).
/// - O histórico é local ao widget (perde-se ao desmontar).
class ItemAttributeFunction extends StatefulWidget {
  final AttributeModel attribute;
  final List<AttributeModel> attributes;
  final Function(
    List<AttributeModel> attributes,
    AttributeModel currentAtribute,
  )? onAttributes;

  const ItemAttributeFunction({
    super.key,
    required this.attribute,
    required this.attributes,
    this.onAttributes,
  });

  @override
  State<ItemAttributeFunction> createState() => _ItemAttributeFunctionState();
}

class _ItemAttributeFunctionState extends State<ItemAttributeFunction> {
  /// Índice do cenário selecionado ou `null` = "Não disparar".
  int? _selectedScenarioIndex;

  /// Histórico local das últimas 3 chamadas (mais recente primeiro).
  final List<_CallRecord> _history = <_CallRecord>[];

  static const int _maxHistory = 3;

  FunctionType get _functionType =>
      widget.attribute.variableOptionType as FunctionType;

  List<FunctionCallbackScenario> get _scenarios => _functionType.scenarios;

  @override
  Widget build(BuildContext context) {
    final functionType = _functionType;
    final scenarios = functionType.scenarios;
    final function = functionType.function;

    return Padding(
      key: ValueKey('function-${widget.attribute.name}'),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context, function),
          if (widget.attribute.description != null &&
              widget.attribute.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.attribute.description!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          if (scenarios.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildScenarioChips(context, scenarios),
          ],
          const SizedBox(height: 8),
          _buildDispatchButton(context, function),
          if (_history.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildHistory(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic function) {
    final typeLabel = widget.attribute.type;
    final runtimeName = function == null ? 'null' : function.runtimeType.toString();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.functions,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.attribute.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '$typeLabel · $runtimeName',
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScenarioChips(
    BuildContext context,
    List<FunctionCallbackScenario> scenarios,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Chip "Não disparar" (default)
        CustomChipSelected(
          key: ValueKey('function-scenario-${widget.attribute.name}-none'),
          label: 'Não disparar',
          leadingIcon: Icons.block,
          selected: _selectedScenarioIndex == null,
          onTap: () {
            setState(() => _selectedScenarioIndex = null);
          },
        ),
        // Chips dos cenários declarados
        for (var i = 0; i < scenarios.length; i++)
          CustomChipSelected(
            key: ValueKey('function-scenario-${widget.attribute.name}-$i'),
            label: scenarios[i].label,
            leadingIcon: scenarios[i].icon ?? Icons.play_arrow,
            selected: _selectedScenarioIndex == i,
            onTap: () {
              setState(() => _selectedScenarioIndex = i);
            },
          ),
      ],
    );
  }

  Widget _buildDispatchButton(BuildContext context, dynamic function) {
    final scenarios = _functionType.scenarios;
    final hasScenarios = scenarios.isNotEmpty;
    // Quando nenhum cenário é selecionado, só permitimos disparar
    // diretamente (sem args) — caso contrário o consumidor deve
    // escolher um cenário que declare os argumentos esperados.
    final canDispatch =
        function != null && (_selectedScenarioIndex != null || !hasScenarios);

    final buttonLabel = _selectedScenarioIndex != null && hasScenarios
        ? 'Disparar "${scenarios[_selectedScenarioIndex!].label}"'
        : 'Disparar';

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            key: ValueKey('function-dispatch-${widget.attribute.name}'),
            onPressed: canDispatch ? () => _dispatch() : null,
            icon: const Icon(Icons.play_arrow, size: 18),
            label: Text(buttonLabel),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistory(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, size: 14),
              const SizedBox(width: 4),
              Text(
                'Histórico',
                style: theme.textTheme.labelSmall,
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    _history.clear();
                  });
                },
                child: Tooltip(
                  message: 'Limpar histórico',
                  child: Icon(
                    Icons.delete_outline,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          for (final record in _history)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Text(
                record.toLine(),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  fontFamilyFallback: const ['Courier'],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  /// Dispara a função com os args do cenário selecionado, ou com
  /// args vazios se nenhum cenário foi selecionado. Em caso de args
  /// incompatíveis com a assinatura do callback, captura a exceção e
  /// adiciona o erro ao histórico (não propaga para o console).
  void _dispatch() {
    final function = _functionType.function;
    if (function == null) return;

    final List<Object?> args;
    if (_selectedScenarioIndex != null) {
      args = _scenarios[_selectedScenarioIndex!].args;
    } else {
      args = const [];
    }

    Object? result;
    Object? error;
    try {
      // Fast path: evita o `Invocation` alocado por `Function.apply`
      // para o caso comum (sem args — `VoidCallback` etc.).
      // O caminho variádico cobre `void Function(int)` e
      // `void Function(String, bool)` etc.
      final fn = function as Function;
      if (args.isEmpty) {
        fn();
      } else {
        result = Function.apply(fn, args);
      }
    } catch (e) {
      error = e;
    }

    _addHistoryRecord(args, result: result, error: error);

    // Notifica o bus para que o `Storybook` saiba que o atributo
    // "foi tocado" (e.g., para highlight do último evento).
    widget.onAttributes?.call(widget.attributes, widget.attribute);
    widget.attribute.onChangeValue?.call(widget.attribute);
  }

  void _addHistoryRecord(
    List<Object?> args, {
    Object? result,
    Object? error,
  }) {
    setState(() {
      _history.insert(
        0,
        _CallRecord(
          timestamp: DateTime.now(),
          args: args,
          result: result,
          error: error,
        ),
      );
      if (_history.length > _maxHistory) {
        _history.removeLast();
      }
    });
  }
}

/// Registro imutável de uma chamada do callback.
class _CallRecord {
  final DateTime timestamp;
  final List<Object?> args;
  final Object? result;
  final Object? error;

  _CallRecord({
    required this.timestamp,
    required this.args,
    this.result,
    this.error,
  });

  String toLine() {
    final hh = timestamp.hour.toString().padLeft(2, '0');
    final mm = timestamp.minute.toString().padLeft(2, '0');
    final ss = timestamp.second.toString().padLeft(2, '0');
    final time = '$hh:$mm:$ss';
    if (error != null) {
      return '[$time] ERR ${error.runtimeType}: $error';
    }
    final argsStr = args.isEmpty ? '()' : '(${args.join(', ')})';
    final resStr = result == null ? '' : ' → $result';
    return '[$time] $argsStr$resStr';
  }
}
