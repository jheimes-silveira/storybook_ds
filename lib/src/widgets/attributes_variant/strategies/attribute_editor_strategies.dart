import 'package:storybook_ds/src/widgets/attributes_variant/strategies/attribute_editor_registry.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/bool_attribute_editor.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/default_attribute_editor.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/function_attribute_editor.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/number_attribute_editor.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/object_attribute_editor.dart';
import 'package:storybook_ds/src/widgets/attributes_variant/strategies/string_attribute_editor.dart';

/// Função que registra as estratégias padrão no [registry].
///
/// Implementação idempotente: pode ser chamada múltiplas vezes sem
/// duplicar entradas (o registry deduz por [AttributeEditorStrategy.id]).
void registerStandardAttributeStrategies(AttributeEditorRegistry registry) {
  registry
    ..register(const StringAttributeEditor())
    ..register(const BoolAttributeEditor())
    ..register(const NumberAttributeEditor())
    ..register(const FunctionAttributeEditor())
    ..register(const ObjectAttributeEditor())
    ..setFallback(const DefaultAttributeEditor());
}
