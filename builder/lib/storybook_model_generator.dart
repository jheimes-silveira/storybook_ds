import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:storybook_ds/annotations.dart';

/// Gera `mergeNomeDaClasse` para atualizar um campo por nome (sem reflexão).
class StorybookModelGenerator extends GeneratorForAnnotation<StorybookModel> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@StorybookModel applies only to classes.',
        element: element,
      );
    }

    if (element.isAbstract) {
      throw InvalidGenerationSourceError(
        '@StorybookModel cannot be used on abstract classes.',
        element: element,
      );
    }

    final className = element.name;
    final fields = element.fields
        .where((f) => !f.isStatic && !f.name.startsWith('_'))
        .toList();

    if (fields.isEmpty) {
      throw InvalidGenerationSourceError(
        '@StorybookModel requires at least one public instance field.',
        element: element,
      );
    }

    final buffer = StringBuffer();
    final mergeName = 'merge$className';

    buffer.writeln('$className $mergeName(');
    buffer.writeln('  $className current,');
    buffer.writeln('  String fieldName,');
    buffer.writeln('  Object? newValue,');
    buffer.writeln(') {');
    buffer.writeln('  switch (fieldName) {');

    for (int i = 0; i < fields.length; i++) {
      final f = fields[i];
      final typeStr = f.type.getDisplayString(withNullability: true);
      buffer.writeln("    case '${f.name}':");
      buffer.writeln('      return $className(');
      for (int j = 0; j < fields.length; j++) {
        final g = fields[j];
        final comma = j < fields.length - 1 ? ',' : '';
        if (g.name == f.name) {
          buffer.writeln('        ${g.name}: newValue as $typeStr$comma');
        } else {
          buffer.writeln('        ${g.name}: current.${g.name}$comma');
        }
      }
      buffer.writeln('      );');
    }

    buffer.writeln('    default:');
    buffer.writeln('      return current;');
    buffer.writeln('  }');
    buffer.writeln('}');

    return buffer.toString();
  }
}
