import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

/// ExpansionTile que renderiza o controle de edição de um único [AttributeModel].
///
/// - O título mostra: tipo, nome, indicador de obrigatório, e switch de ativação.
/// - O conteúdo (corpo da expansão) é construído pela **Strategy** selecionada
///   pelo [AttributeEditorRegistry] para o tipo do atributo.
///
/// ### Strategy Pattern
/// A escolha do widget de edição (String, Bool, Number, Function, Object,
/// Default) é feita pelo registry, não por uma cadeia de `if/else`. Para
/// adicionar um novo tipo de editor, basta:
/// 1. Criar uma classe que implemente [AttributeEditorStrategy].
/// 2. Registrá-la no [AttributeEditorRegistry] (ver
///    [registerStandardAttributeStrategies] como exemplo).
///
/// ### Reatividade em tempo real
/// Cada mudança em um editor propaga via [AttributeChangeBus] (e via o
/// callback `onAttributes` recebido) para que o `Storybook` reconstrua o
/// device preview sem `setState(() {})` cego.
class AttributeVariant extends StatefulWidget {
  final List<AttributeModel> attributes;
  final AttributeModel attribute;
  final Function(List<AttributeModel> attributes, AttributeModel attribute)?
      onAttributes;
  final String? constructor;

  /// Barramento de mudanças da `Storybook` dona deste widget. Usado
  /// para reatividade em tempo real: o `Storybook.onUpdateAttributes`
  /// consulta `hasChanges` antes de chamar `setState`.
  final AttributeChangeBus changeBus;

  /// Se `true`, o `ExpansionTile` inicia expandido. Útil para
  /// testes e para o `Storybook` quando o painel é mostrado lado
  /// a lado com o device preview.
  final bool initiallyExpanded;

  const AttributeVariant({
    super.key,
    required this.attribute,
    required this.attributes,
    required this.onAttributes,
    required this.changeBus,
    this.constructor,
    this.initiallyExpanded = false,
  });

  @override
  State<AttributeVariant> createState() => _AttributeVariantState();
}

class _AttributeVariantState extends State<AttributeVariant> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    // Ouve o barramento de mudanças para reconstruir quando o
    // usuário edita um atributo. Necessário porque o `AttributeVariant`
    // é construído uma única vez dentro de uma `MaterialPageRoute`
    // (no `Navigator` do `ToolPanel` do `DevicePreview`), e o
    // framework não tem como detectar mutações in-place de
    // `attribute.selectedValue`.
    widget.changeBus.addListener(_onChangeBusNotify);
  }

  @override
  void dispose() {
    widget.changeBus.removeListener(_onChangeBusNotify);
    super.dispose();
  }

  void _onChangeBusNotify() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = StorybookThemeScope.of(context);
    final e = widget.attribute;

    return ExpansionTile(
      // Usa `ValueKey` (e não `PageStorageKey`) para evitar que o
      // estado de `PageStorage` do subtree (em particular o offset de
      // scroll do `TextField` do `ItemAttributeString`) colida com o
      // `bool` que o `ExpansionTile` salva internamente na mesma key
      // quando contraído. Isso causava `type 'bool' is not a subtype
      // of type 'double?' in type cast` em
      // `ScrollPosition.restoreScrollOffset` ao expandir o tile pela
      // primeira vez.
      key: ValueKey('attribute-${e.name}'),
      initiallyExpanded: _isExpanded,
      onExpansionChanged: (expanded) {
        setState(() => _isExpanded = expanded);
        _onExpansionChanged(expanded);
      },
      childrenPadding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      tilePadding: const EdgeInsets.only(left: 8, right: 8),
      expandedAlignment: Alignment.centerLeft,
      iconColor: theme.expansionTileIconColor,
      collapsedIconColor: theme.expansionTileIconColor,
      title: _buildTitle(context, e, theme),
      trailing: _buildTrailing(context, e),
      children: [
        if (_shouldShowNullHint(e))
          const _NullValueHintBanner()
        else
          _buildChangeAction(e, widget.attributes),
      ],
    );
  }

  void _onExpansionChanged(bool value) {
    if (widget.attribute.variableOptionType is HtmlType) {
      final html = widget.attribute.variableOptionType as HtmlType;
      html.canUpdateOnChange = false;
    }
  }

  Widget _buildTitle(BuildContext context, AttributeModel e, StorybookTheme theme) {
    return Row(
      children: [
        _TypeChip(type: e.type),
        const SizedBox(width: 8),
        Flexible(
          child: Tooltip(
            message: e.description ?? e.name,
            child: Text(
              e.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (e.required) const _RequiredBadge(),
        if (_canBuildBoolToggle(e)) ...[
          const SizedBox(width: 8),
          _BoolToggle(
            attribute: e,
            attributes: widget.attributes,
            onAttributes: widget.onAttributes,
            changeBus: widget.changeBus,
          ),
        ],
      ],
    );
  }

  /// Constrói o widget de trailing. O ExpansionTile aceita `Widget?` mas
  /// em algumas combinações causa `ParentDataWidget` — usamos sempre um
  /// widget válido (`SizedBox` quando vazio).
  Widget? _buildTrailing(BuildContext context, AttributeModel e) {
    // Se o título já tem o switch de bool e não é nullable, não duplicar no trailing.
    if (e.type == 'bool') return null;

    if (_isNullable(e)) {
      return _NullableTrailingSwitch(
        attribute: e,
        attributes: widget.attributes,
        onAttributes: widget.onAttributes,
        changeBus: widget.changeBus,
      );
    }
    if (_hasVariableOptions(e)) {
      return null; // sem trailing extra, o conteúdo mostra as opções
    }
    return const SizedBox(width: 24, height: 24);
  }

  /// Constrói o widget de edição do atributo via **Strategy Pattern**.
  ///
  /// Substitui a cadeia de `if (e.variableOptionType is XType)` que existia
  /// aqui antes. A seleção é responsabilidade do
  /// [AttributeEditorRegistry].
  Widget _buildChangeAction(
    AttributeModel e,
    List<AttributeModel> attributes,
  ) {
    final ctx = EditorContext(
      attribute: e,
      attributes: attributes,
      onChanged: (attrs, attr) {
        // Importante: notificar o bus **antes** do callback do `Storybook`,
        // para que `onUpdateAttributes` encontre `hasChanges == true` e
        // dispare o `setState` que reconstrói o device preview em tempo
        // real.
        widget.changeBus.notifyChanged(attrs, attr);
        widget.onAttributes?.call(attrs, attr);
      },
      constructor: widget.constructor,
      widgetKey: ValueKey('editor-${e.name}'),
      buildContext: context,
      changeBus: widget.changeBus,
    );

    return AttributeEditorRegistry.instance.buildFor(ctx);
  }

  bool _canBuildBoolToggle(AttributeModel e) =>
      e.type == 'bool' || e.type == 'bool?';

  bool _isNullable(AttributeModel e) =>
      e.type.contains('?') && e.variableOptionType is! HtmlType;

  bool _hasVariableOptions(AttributeModel e) =>
      e.variableOptions != null && e.variableOptions!.isNotEmpty;

  /// Mostra o hint "Ative o switch acima para definir um valor..." quando
  /// o atributo é nullable, não é `bool` (que tem tratamento próprio via
  /// `_BoolToggle` + trailing), não é HTML, e o switch "pode ser null"
  /// está atualmente selecionado para `null` (i.e. `selectedValue` é
  /// `null` ou tem `value == null`).
  bool _shouldShowNullHint(AttributeModel e) {
    if (!_isNullable(e)) return false;
    if (e.variableOptionType is HtmlType) return false;
    // Para `bool?` a UX do switch é diferente (toggle true/false no
    // título + trailing) — manter o comportamento anterior (sem hint
    // duplicado).
    if (_canBuildBoolToggle(e)) return false;
    return e.selectedValue == null || e.selectedValue?.value == null;
  }
}

class _TypeChip extends StatelessWidget {
  final String type;
  const _TypeChip({required this.type});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class _RequiredBadge extends StatelessWidget {
  const _RequiredBadge();
  @override
  Widget build(BuildContext context) {
    final theme = StorybookThemeScope.of(context);
    return Text(
      '*',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.requiredAsteriskColor,
          ),
    );
  }
}

class _BoolToggle extends StatelessWidget {
  final AttributeModel attribute;
  final List<AttributeModel> attributes;
  final Function(List<AttributeModel>, AttributeModel)? onAttributes;
  final AttributeChangeBus changeBus;
  const _BoolToggle({
    required this.attribute,
    required this.attributes,
    required this.onAttributes,
    required this.changeBus,
  });

  @override
  Widget build(BuildContext context) {
    final isNull = attribute.selectedValue == null ||
        attribute.selectedValue?.value == null;
    final value = isNull ? false : (attribute.selectedValue?.value == true);

    return Opacity(
      opacity: isNull ? 0.5 : 1,
      child: IgnorePointer(
        ignoring: isNull,
        child: Tooltip(
          message: isNull
              ? 'Ative o switch à direita para definir o valor'
              : (value ? 'Desativar' : 'Ativar'),
          child: Switch(
            value: value,
            onChanged: (newValue) {
              if (attribute.selectedValue == null) {
                attribute.selectedValue = VariableOption(value: newValue);
              } else {
                attribute.selectedValue!.value = newValue;
              }
              // Notificar o bus **antes** do callback para garantir que
              // `onUpdateAttributes` encontre `hasChanges == true`.
              changeBus.notifyChanged(attributes, attribute);
              onAttributes?.call(attributes, attribute);
              attribute.onChangeValue?.call(attribute);
            },
          ),
        ),
      ),
    );
  }
}

class _NullableTrailingSwitch extends StatelessWidget {
  final AttributeModel attribute;
  final List<AttributeModel> attributes;
  final Function(List<AttributeModel>, AttributeModel)? onAttributes;
  final AttributeChangeBus changeBus;
  const _NullableTrailingSwitch({
    required this.attribute,
    required this.attributes,
    required this.onAttributes,
    required this.changeBus,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = attribute.selectedValue?.value != null;
    return Tooltip(
      message: isActive ? 'Definir como null' : 'Ativar',
      child: Switch(
        value: isActive,
        onChanged: (newValue) {
          if (newValue) {
            // Tenta extrair um valor inicial do tipo correto
            final opts = attribute.variableOptions;
            if (opts != null && opts.isNotEmpty && opts.any((o) => o.value is bool)) {
              attribute.selectedValue = opts.firstWhere((o) => o.value is bool);
            } else if (attribute.type.contains('bool')) {
              attribute.selectedValue = VariableOption(value: false);
            } else if (opts != null && opts.isNotEmpty && opts.first.value != '') {
              attribute.selectedValue = opts.first;
            } else {
              attribute.selectedValue = VariableOption(value: null);
            }
          } else {
            attribute.selectedValue = null;
          }
          // Notificar o bus **antes** do callback.
          changeBus.notifyChanged(attributes, attribute);
          onAttributes?.call(attributes, attribute);
          attribute.onChangeValue?.call(attribute);
        },
      ),
    );
  }
}

/// Banner de hint mostrado no corpo de um [AttributeVariant] quando
/// o campo é nullable e o switch "pode ser null" está atualmente
/// selecionado para `null`.
///
/// Incentiva o usuário a ativar o switch no trailing do tile (logo
/// acima) para que o editor volte a permitir interação.
class _NullValueHintBanner extends StatelessWidget {
  const _NullValueHintBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Ative o switch acima para definir um valor e poder editar os filhos.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
