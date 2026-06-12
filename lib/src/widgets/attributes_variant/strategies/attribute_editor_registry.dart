import 'package:flutter/material.dart';

import 'package:storybook_ds/src/models/model/attribute_model.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_editor_strategy.dart';

/// Fallback seguro padrão: nunca lança, sempre renderiza um hint
/// informativo. Pode ser substituído por uma estratégia de fallback
/// customizada via [AttributeEditorRegistry.setFallback].
class SafeNoOpFallback implements AttributeEditorStrategy {
  const SafeNoOpFallback();

  @override
  String get id => '__safe_fallback__';

  @override
  int get priority => 0;

  @override
  bool handles(AttributeModel attribute) => true;

  @override
  Widget build(EditorContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          const Icon(Icons.help_outline, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Nenhuma estratégia de editor registrada para o atributo '
              '"${context.attribute.name}" (tipo: ${context.attribute.type}).',
              style: Theme.of(context.buildContext).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// Registry (papel de *Context* no padrão **Strategy**) que seleciona a
/// [AttributeEditorStrategy] correta para um dado [AttributeModel].
///
/// Vantagens em relação à cadeia `if/else is XType` original em
/// `attribute_variant.dart`:
/// * **Aberto/Fechado**: novas estratégias (ex.: `ColorStrategy`,
///   `DateStrategy`) podem ser registradas sem alterar o `AttributeVariant`.
/// * **Sem ordem implícita**: a seleção usa `priority` (maior vence) e
///   [AttributeEditorStrategy.handles], eliminando fragilidade contra a
///   ordem dos `if`s.
/// * **Fallback explícito**: a estratégia de fallback (configurável)
///   sempre cobre atributos não tratados por estratégias mais específicas.
/// * **Performante**: a lista interna é mantida ordenada por `priority`
///   decrescente no momento do `register`, então `pick()` é um único
///   passe O(n) sem alocação.
///
/// ## Uso típico
/// ```dart
/// // 1) Registrar estratégias (uma vez no app).
/// AttributeEditorRegistry.instance
///   ..register(const StringAttributeEditor())
///   ..register(const BoolAttributeEditor())
///   ..setFallback(const DefaultAttributeEditor());
///
/// // 2) Construir o widget:
/// final editor = AttributeEditorRegistry.instance.pick(attribute);
/// final widget = editor.build(EditorContext(
///   attribute: attribute,
///   attributes: attributes,
///   onChanged: onChanged,
///   widgetKey: ValueKey('editor-${attribute.name}'),
///   buildContext: context,
/// ));
/// ```
class AttributeEditorRegistry {
  /// Estratégias registradas, **mantidas em ordem decrescente de
  /// `priority`** para que `pick()` seja um único passe.
  final List<AttributeEditorStrategy> _strategies = <AttributeEditorStrategy>[];

  /// Estratégia usada como fallback quando nenhuma outra aceita o
  /// atributo. Padrão: [SafeNoOpFallback] (nunca lança).
  AttributeEditorStrategy _fallback = const SafeNoOpFallback();

  /// Instância global (singleton). As estratégias devem ser
  /// registradas uma única vez na inicialização do app (ver
  /// `registerStandardAttributeStrategies` em
  /// `attribute_editor_strategies.dart`).
  static final AttributeEditorRegistry instance = AttributeEditorRegistry();

  /// Adiciona uma estratégia ao registro. Se já existir uma com mesmo
  /// [AttributeEditorStrategy.id], ela é substituída. A lista é
  /// mantida ordenada por `priority` decrescente para que `pick()`
  /// seja O(n) sem ordenação em tempo de execução.
  void register(AttributeEditorStrategy strategy) {
    if (strategy is SafeNoOpFallback) {
      _fallback = strategy;
      return;
    }
    _strategies.removeWhere((e) => e.id == strategy.id);
    // Insert em ordem decrescente de priority. Para listas pequenas
    // (<20 estratégias) a busca linear é mais rápida que binarySearch.
    var i = 0;
    while (i < _strategies.length && _strategies[i].priority > strategy.priority) {
      i++;
    }
    _strategies.insert(i, strategy);
  }

  /// Define a estratégia de fallback. A estratégia deve ser capaz de
  /// renderizar **qualquer** [AttributeModel].
  void setFallback(AttributeEditorStrategy fallback) {
    _fallback = fallback;
  }

  /// Seleciona a estratégia mais adequada para [attribute].
  ///
  /// A lista interna já está ordenada por `priority` decrescente,
  /// então esta função é um único passe: a primeira estratégia cuja
  /// `handles` retorne `true` é a vencedora. Se nenhuma aceitar,
  /// retorna o fallback configurado.
  AttributeEditorStrategy pick(AttributeModel attribute) {
    for (final s in _strategies) {
      if (s.handles(attribute)) return s;
    }
    return _fallback;
  }

  /// Atalho para construir o widget de edição de [context.attribute].
  Widget buildFor(EditorContext context) {
    return pick(context.attribute).build(context);
  }
}
