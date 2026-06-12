import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

/// Widget de input de texto (String) com type-safety robusta e suporte a
/// descrição/hint via `attribute.description` ou `variableOptions`.
class ItemAttributeString extends StatefulWidget {
  final AttributeModel attribute;
  final List<AttributeModel> attributes;
  final Function(
    List<AttributeModel> attributes,
    AttributeModel currentAtribute,
  )? onAttributes;
  const ItemAttributeString({
    super.key,
    required this.attribute,
    required this.attributes,
    this.onAttributes,
  });

  @override
  State<ItemAttributeString> createState() => _ItemAttributeStringState();
}

class _ItemAttributeStringState extends State<ItemAttributeString> {
  late final TextEditingController _inputController;
  final FocusNode _focusNode = FocusNode();

  String _safeStringValue(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(
      text: _safeStringValue(widget.attribute.selectedValue?.value),
    );
    _inputController.selection = TextSelection.fromPosition(
      TextPosition(offset: _inputController.text.length),
    );
  }

  @override
  void didUpdateWidget(ItemAttributeString oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sincronizar controller apenas se o widget não estiver focado
    if (_focusNode.hasFocus) return;
    final newText = _safeStringValue(widget.attribute.selectedValue?.value);
    if (_inputController.text != newText) {
      _inputController.text = newText;
      _inputController.selection = TextSelection.fromPosition(
        TextPosition(offset: _inputController.text.length),
      );
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // O switch de "pode ser null" é renderizado pelo
    // `_NullableTrailingSwitch` no trailing do `AttributeVariant`
    // (ao lado do nome e tipo), para evitar duplicação.
    return _buildChangeAction();
  }

  /// Builds the change action widget with text field and options.
  Widget _buildChangeAction() {
    final options = widget.attribute.variableOptions;
    final hint = widget.attribute.description;
    final isEnabled = widget.attribute.selectedValue?.value != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: hint ?? 'Digite o valor de ${widget.attribute.name}',
            child: TextField(
              key: ValueKey('string-${widget.attribute.name}'),
              controller: _inputController,
              focusNode: _focusNode,
              textInputAction: TextInputAction.done,
              enabled: isEnabled,
              decoration: InputDecoration(
                isDense: true,
                hintText: hint,
                helperText: hint,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              onChanged: (text) => _handleTextChange(text),
              onSubmitted: (_) => _focusNode.unfocus(),
            ),
          ),
          if (options != null && options.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 8,
              runAlignment: WrapAlignment.start,
              runSpacing: 8,
              children: options.asMap().entries.map((entry) {
                final option = entry.value;
                final isSelected = widget.attribute.selectedValue?.value ==
                    option.value;
                return Tooltip(
                  message: isSelected ? 'Selecionado' : 'Selecionar',
                  child: KeyedSubtree(
                    key: ValueKey(
                        'chip-${widget.attribute.name}-${entry.key}'),
                    child: _Chip(
                      label: option.textInSelectedOptions,
                      selected: isSelected,
                      onTap: () => _handleOptionTap(option),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// Handles text field value change.
  void _handleTextChange(String text) {
    if (widget.onAttributes == null) return;
    if (widget.attribute.selectedValue == null) {
      widget.attribute.selectedValue = VariableOption(value: text);
    } else {
      widget.attribute.selectedValue =
          widget.attribute.selectedValue!.copyWith(value: text);
    }
    widget.onAttributes!(widget.attributes, widget.attribute);
    widget.attribute.onChangeValue?.call(widget.attribute);
  }

  /// Handles option chip tap.
  void _handleOptionTap(VariableOption option) {
    if (widget.onAttributes == null) return;
    widget.attribute.selectedValue = option;
    _inputController.text = _safeStringValue(option.value);
    _inputController.selection = TextSelection.fromPosition(
      TextPosition(offset: _inputController.text.length),
    );
    widget.onAttributes!(widget.attributes, widget.attribute);
    widget.attribute.onChangeValue?.call(widget.attribute);
  }
}

/// Chip simplificado com feedback de toque e estilo consistente.
class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: selected
          ? theme.colorScheme.primary.withValues(alpha: 0.15)
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                Icon(
                  Icons.check,
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
