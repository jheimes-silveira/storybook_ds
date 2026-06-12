import '../models/model/attribute_model.dart';

/// Fábricas auxiliares para [AttributeModel] (sem reflexão em tempo de execução).
class StorybookAttributeFactories {
  StorybookAttributeFactories._();

  /// [AttributeModel] para texto longo com opções de exemplo pré-definidas.
  static AttributeModel factoryAttributeModelString({
    required String name,
    String? selectedValue,
    bool canBeNull = false,
    bool required = false,
    List<String> builders = const [''],
  }) {
    return AttributeModel(
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

  /// [AttributeModel] para texto longo com opções de exemplo pré-definidas.
  @Deprecated('Use factoryAttributeModelString instead.')
  static AttributeModel factoryAttributeDtoString({
    required String name,
    String? selectedValue,
    bool canBeNull = false,
    bool required = false,
    List<String> builders = const [''],
  }) {
    return factoryAttributeModelString(
      name: name,
      selectedValue: selectedValue,
      canBeNull: canBeNull,
      required: required,
      builders: builders,
    );
  }
}
