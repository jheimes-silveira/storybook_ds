import 'package:flutter/material.dart';
import 'package:reflectable/reflectable.dart';
import 'package:storybook_ds/storybook_ds.dart';

class UtilsAttributeReflectable {
  /// Generates a list of attributes from the given instance.
  static List<AttributeDto> generateAttributes(
    Object instance, {
    List<AttributeDto> attributesReplace = const [],
  }) {
    if (!reflectable.canReflect(instance)) {
      throw Exception(
        'A classe ${instance.runtimeType} deve ser anotada com @reflectable',
      );
    }
    List<AttributeDto> attributes = [];
    InstanceMirror instanceMirror = reflectable.reflect(instance);
    ClassMirror classMirror = instanceMirror.type;

    for (var variable in classMirror.declarations.values) {
      if (variable is VariableMirror) {
        String? name = variable.simpleName;

        final item = attributesReplace.where((a) => a.name == name).firstOrNull;

        if (item != null) {
          attributes.add(item);
          continue;
        }

        Type? type = UtilsReflectable.getFieldType(
          instance,
          variable.simpleName,
        );
        dynamic value = UtilsReflectable.getFieldValue(
          instance,
          variable.simpleName,
        );
        final builders = UtilsReflectable.findConstructors(
          instance,
          valiable: variable.simpleName,
        );
        // var isNullable = variable.metadata.any((metadata) => metadata is Nullable);

        if (type == String) {
          attributes.add(
            factoryAttributeDtoString(
              name: name,
              selectedValue: value ?? '',
              builders: builders,
              canBeNull: true,
            ),
          );
        } else if (type == double) {
          attributes.add(
            AttributeDto.rangeDoubleInterval(
              name: name,
              selectedValue: value ?? 5,
              begin: 0,
              end: 100,
              builders: builders,
              canBeNull: true,
            ),
          );
        } else if (isFunctionType(type)) {
          attributes.add(
            AttributeDto.function(
              name: name,
              canBeNull: true,
              builders: builders,
              function: value,
            ),
          );
        } else if (type == int) {
          attributes.add(
            AttributeDto.rangeIntInterval(
              name: name,
              selectedValue: value ?? 5,
              begin: 0,
              end: 100,
              builders: builders,
              canBeNull: true,
            ),
          );
        } else if (value is Enum) {
          List<Enum> enumValues = [];

          try {
            var classMirror = reflectable.reflectType(type!) as ClassMirror;
            enumValues = classMirror.invokeGetter('values') as List<Enum>;
          } catch (e) {
            enumValues = [value];
          }
          if (enumValues.isEmpty) {
            continue;
          }
          attributes.add(
            AttributeDto.enumType(
              name: name,
              selectedValue: value,
              values: enumValues,
              builders: builders,
              canBeNull: true,
            ),
          );
        } else if (type == Color) {
          attributes.add(
            AttributeDto.color(
              name: name,
              canBeNull: true,
              selectedValue: value,
              builders: builders,
            ),
          );
        } else if (type == MaterialColor) {
          attributes.add(
            AttributeDto.color(
              name: name,
              canBeNull: true,
              selectedValue: value,
              builders: builders,
            ),
          );
        } else if (value != null && reflectable.canReflect(value)) {
          attributes.add(
            AttributeDto.objectInObject(
              name: name,
              type: type.toString(),
              selectedValue: VariableOption(value: value),
              builders: builders,
              children: generateAttributes(value),
              canBeNull: true,
            ),
          );
        } else {
          attributes.add(
            AttributeDto(
              name: name,
              type: type.toString(),
              selectedValue: VariableOption(value: value),
              builders: builders,
            ),
          );
        }
      }
    }
    return attributes;
  }

  static bool isFunctionType(Type? type) {
    final typeString = type.toString();
    final functionPattern = RegExp(r'\(.*\)\s*=>');
    return functionPattern.hasMatch(typeString);
  }

  /// Factory method to create an AttributeDto for String type with predefined options.
  ///
  /// Returns an [AttributeDto] configured for String input with various text length options.
  static AttributeDto factoryAttributeDtoString({
    required String name,
    String? selectedValue,
    bool canBeNull = false,
    bool required = false,
    List<String> builders = const [''],
  }) {
    return AttributeDto(
      name: name,
      type: 'String${canBeNull ? "?" : ""}',
      required: required,
      selectedValue: VariableOption(value: selectedValue),
      variableOptions: [
        VariableOption(
          value: 'Sadipscing gubergren ea eos stet',
          textInSelectedOptions: '5 palavras',
        ),
        VariableOption(
          value: 'Justo elitr sed accusam accusam diam stet, diam est elitr',
          textInSelectedOptions: '10 palavras',
        ),
        VariableOption(
          value:
              'Sanctus gubergren at duo lorem et gubergren aliquyam, sed sed no invidunt gubergren eos aliquyam, no et magna clita rebum',
          textInSelectedOptions: '20 palavras',
        ),
        VariableOption(
          value:
              'Et gubergren invidunt tempor ipsum diam dolor diam et, gubergren lorem tempor sed ut diam magna ipsum tempor sanctus, clita kasd nonumy nonumy vero sanctus sit, ut accusam et dolores',
          textInSelectedOptions: '30 palavras',
        ),
        VariableOption(
          value:
              'Invidunt diam eos sed sea sit takimata, justo sit sit erat stet ea, stet dolor eirmod duo takimata dolore sit. Sanctus dolor duo et eirmod clita sed, magna et aliquyam sea lorem takimata, sanctus kasd amet voluptua clita elitr. At',
          textInSelectedOptions: '40 palavras',
        ),
        VariableOption(
          value:
              'Sit eirmod rebum sea stet diam, voluptua consetetur justo amet no ea sit, no et et lorem ut sadipscing nonumy at aliquyam et. Eirmod no vero sit amet sed, duo clita sit erat accusam sanctus dolor, elitr at amet erat et. Sadipscing est erat labore diam takimata gubergren amet kasd, stet duo sit gubergren amet dolor sanctus dolor no labore, sit accusam diam eos diam labore dolor rebum sit, dolor kasd ut dolor labore dolores diam eirmod ipsum, lorem magna',
          textInSelectedOptions: '80 palavras',
        ),
        VariableOption(
          value:
              'Amet gubergren et justo ipsum consetetur at eos. Elitr eos lorem aliquyam sea nonumy, invidunt amet lorem et amet. Ipsum stet elitr accusam ut voluptua labore gubergren est. Takimata sadipscing stet lorem lorem, amet lorem amet et dolor erat accusam sed, et rebum ut sed duo ut sed. Justo ipsum magna lorem sed accusam et sea aliquyam, sea eos eos elitr rebum sanctus voluptua dolore sit. Justo magna dolore magna amet lorem accusam, at ipsum diam consetetur diam nonumy magna diam eirmod. Dolor ut tempor lorem dolores. Dolor at sit amet dolor elitr tempor. Lorem dolor rebum amet voluptua erat lorem vero ipsum. Et amet et erat elitr amet sit ut, kasd elitr diam et invidunt sit sadipscing, rebum lorem',
          textInSelectedOptions: '120 palavras',
        ),
      ],
      builders: builders,
    );
  }
}
