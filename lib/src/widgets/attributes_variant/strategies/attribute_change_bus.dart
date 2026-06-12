import 'package:flutter/foundation.dart';

import 'package:storybook_ds/src/models/model/attribute_model.dart';

/// Barramento de mudanças dos [AttributeModel] usados no menu lateral.
///
/// Centraliza a notificação de mutações para que widgets
/// "cacheados" (ex.: dentro de um `Navigator` / `MaterialPageRoute`)
/// possam reconstruir quando o usuário edita um atributo.
///
/// Esta classe **não** é um singleton: cada `Storybook` deve possuir a
/// sua própria instância.
///
/// O bus combina dois mecanismos:
/// * `addListener` (`ChangeNotifier`) — widgets se inscrevem para
///   receber notificações push e reconstruir (`setState`).
/// * `hasChanges` / `clear` — flag set usado pelo `Storybook` para
///   detectar se há mudanças pendentes que requerem refresh do
///   device preview.
class AttributeChangeBus extends ChangeNotifier {
  AttributeChangeBus();

  /// Conjunto de nomes de atributos alterados desde a última limpeza.
  /// Usado pelo `Storybook` para decidir se o preview precisa de refresh.
  final Set<String> _changedNames = <String>{};

  /// Indica se houve alguma mudança desde a última limpeza.
  bool get hasChanges => _changedNames.isNotEmpty;

  /// Notifica o barramento de que [attribute] foi alterado. Mudanças
  /// com `name` vazio são ignoradas (não identificam um atributo real).
  ///
  /// Dispara `notifyListeners()` para que widgets inscritos
  /// reconstruam. Note que a mutação de `selectedValue` já é in-place
  /// (sem nova referência de lista/atributo) — por isso o bus é
  /// necessário: o framework não tem como detectar a mudança
  /// automaticamente.
  void notifyChanged(
    List<AttributeModel> attributes,
    AttributeModel attribute,
  ) {
    final name = attribute.name;
    if (name.isEmpty) return;
    _changedNames.add(name);
    notifyListeners();
  }

  /// Limpa o histórico. Deve ser chamado pelo `Storybook` após aplicar
  /// as mudanças (rebuild do preview) para evitar re-trabalhos.
  ///
  /// **Não** dispara `notifyListeners()` — `clear()` é housekeeping,
  /// não uma mudança de estado visível.
  void clear() {
    _changedNames.clear();
  }
}
