import 'package:flutter/material.dart';
import 'package:storybook_ds/src/models/model/attribute_model.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_change_bus.dart';

/// Callback invocado quando o valor de um [AttributeModel] é alterado pelo
/// editor no menu lateral. Deve ser propagado até o `Storybook` para que o
/// device preview seja reconstruído em tempo real.
typedef OnAttributeChanged = void Function(
  List<AttributeModel> attributes,
  AttributeModel currentAttribute,
);

/// Contexto imutável fornecido para cada [AttributeEditorStrategy].
///
/// Centraliza todas as dependências que o widget de edição precisa para
/// construir a si mesmo e propagar mudanças, sem que cada estratégia precise
/// conhecer detalhes de quão o painel é montado.
@immutable
class EditorContext {
  /// Atributo sendo editado.
  final AttributeModel attribute;

  /// Lista completa de atributos (necessária para o callback de propagação).
  final List<AttributeModel> attributes;

  /// Callback que deve ser invocado sempre que o valor do atributo mudar.
  /// Já encapsula a propagação via [AttributeChangeBus] — estratégias
  /// e widgets de edição só precisam chamá-lo.
  final OnAttributeChanged? onChanged;

  /// Nome do construtor selecionado (ex.: `''`, `'inline'`, `'outline'`).
  final String? constructor;

  /// Chave estável do widget (PageStorageKey/ValueKey) para preservar estado
  /// entre rebuilds.
  final Key widgetKey;

  /// `BuildContext` do widget que está construindo o editor. Necessário
  /// para que as estratégias possam usar `Theme.of(context)`,
  /// `Localizations.of(context)` etc.
  final BuildContext buildContext;

  /// Barramento de mudanças da `Storybook` dona deste editor. Necessário
  /// para widgets aninhados (ex.: `ItemAttributeObject` que renderiza
  /// um `AttributesVariantWidget` interno) propagarem mudanças em
  /// tempo real para o device preview.
  final AttributeChangeBus changeBus;

  const EditorContext({
    required this.attribute,
    required this.attributes,
    required this.onChanged,
    required this.widgetKey,
    required this.buildContext,
    required this.changeBus,
    this.constructor,
  });
}

/// Contrato do padrão **Strategy** para construção dos widgets de edição
/// exibidos no menu lateral do storybook.
///
/// Cada implementação concreta é responsável por:
/// 1. Decidir se consegue lidar com um dado [AttributeModel] ([handles]).
/// 2. Construir o widget de edição ([build]).
///
/// O registro e a seleção ficam a cargo do
/// [AttributeEditorRegistry] (papel de *Context* no Strategy).
abstract class AttributeEditorStrategy {
  /// Identificador único da estratégia (útil para debug e para o registry).
  String get id;

  /// Prioridade de seleção: quando múltiplas estratégias aceitam o mesmo
  /// atributo, a de maior prioridade vence. Permite que estratégias
  /// genéricas (ex.: `Default`) sirvam como fallback de baixa prioridade.
  int get priority => 0;

  /// Retorna `true` se esta estratégia sabe editar o atributo recebido.
  bool handles(AttributeModel attribute);

  /// Constrói o widget de edição. **Não** deve mutar o `attribute`
  /// diretamente sem disparar [EditorContext.onChanged].
  Widget build(EditorContext context);
}
