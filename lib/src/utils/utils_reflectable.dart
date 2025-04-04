import 'package:reflectable/reflectable.dart';

class AppReflectable extends Reflectable {
  const AppReflectable()
      : super(
          invokingCapability,
          declarationsCapability,
          typeCapability,
          instanceInvokeCapability,
          reflectedTypeCapability,
          metadataCapability,
          typeRelationsCapability,
          metadataCapability,
          typeRelationsCapability,
          instanceInvokeCapability,
        );
}

const reflectable = AppReflectable();

class UtilsReflectable {
  static dynamic getFieldValue(dynamic obj, String fieldName) {
    try {
      var instanceMirror = reflectable.reflect(obj);
      var fieldValue = instanceMirror.invokeGetter(fieldName);
      return fieldValue;
    } catch (e) {
      return null;
    }
  }

  static String? getFieldType(dynamic obj, String fieldName) {
    var instanceMirror = reflectable.reflect(obj);
    var classMirror = instanceMirror.type;
    var variableMirror = classMirror.declarations[fieldName];
    if (variableMirror is VariableMirror) {
      var fieldType = variableMirror.dynamicReflectedType;

      return fieldType.toString();
    } else {
      return null;
    }
  }

  static dynamic updateValue<T>(
    dynamic obj, {
    required String nameVariavel,
    required dynamic novoValor,
  }) {
    var instanceMirror = reflectable.reflect(obj);
    var classMirror = instanceMirror.type;

    // Obtenha os parâmetros do construtor
    var constructor =
        classMirror.declarations[classMirror.simpleName] as MethodMirror;
    var parameters = constructor.parameters;

    // Crie um mapa para os valores dos parâmetros
    var parameterValues = <Symbol, dynamic>{};

    for (var parameter in parameters) {
      var fieldName = parameter.simpleName;
      var fieldValue = instanceMirror.invokeGetter(fieldName);
      if (fieldName == nameVariavel) {
        fieldValue = novoValor;
      }
      parameterValues[Symbol(fieldName)] = fieldValue;
    }

    // Crie uma nova instância com os valores atualizados
    var newInstance = classMirror.newInstance('', [], parameterValues);

    return newInstance;
  }
}
