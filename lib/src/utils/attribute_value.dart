import 'package:storybook_ds/src/models/model/attribute_model.dart';

/// Helpers para conversão segura de valores de [AttributeModel].
///
/// Estes helpers evitam `TypeError` em tempo de execução (ex.: `bool is not
/// a subtype of double?`) ao ler/gravar `selectedValue.value` em widgets
/// que assumem um tipo específico do range.
class AttributeValue {
  const AttributeValue._();

  /// Converte o valor de [option] para [double], retornando [fallback] se:
  /// - a option for nula
  /// - o valor for nulo
  /// - o valor não for numérico (bool, String, etc.)
  static double toDouble(VariableOption? option, {required double fallback}) {
    final value = option?.value;
    if (value is num) return value.toDouble();
    return fallback;
  }

  /// Converte o valor de [option] para [int], retornando [fallback] se:
  /// - a option for nula
  /// - o valor for nulo
  /// - o valor não for numérico
  static int toInt(VariableOption? option, {required int fallback}) {
    final value = option?.value;
    if (value is num) return value.toInt();
    return fallback;
  }

  /// Converte o valor de [option] para [bool], retornando [fallback] se
  /// o valor não for booleano.
  static bool toBool(VariableOption? option, {required bool fallback}) {
    final value = option?.value;
    if (value is bool) return value;
    return fallback;
  }

  /// Converte o valor de [option] para [String], retornando '' se nulo.
  static String valueToString(VariableOption? option) {
    final value = option?.value;
    if (value == null) return '';
    return value.toString();
  }

  /// Cria uma [VariableOption] com [value] do tipo correto para o [variableType].
  /// Retorna `null` se não conseguir criar uma option válida.
  static VariableOption? createForType(
    VariableOptionType? variableType,
    dynamic initialValue,
  ) {
    if (variableType is RangeDoubleIntervalType) {
      if (initialValue is num) {
        return VariableOption(value: initialValue.toDouble());
      }
      return VariableOption(value: variableType.begin);
    }
    if (variableType is RangeIntIntervalType) {
      if (initialValue is num) {
        return VariableOption(value: initialValue.toInt());
      }
      return VariableOption(value: variableType.begin);
    }
    if (initialValue != null) {
      return VariableOption(value: initialValue);
    }
    return null;
  }

  /// Verifica se a option tem um valor utilizável (não-nulo e não-vazio para
  /// tipos nullable).
  static bool isPresent(VariableOption? option) {
    return option?.value != null;
  }
}
