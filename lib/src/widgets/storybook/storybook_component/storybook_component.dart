import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

import 'storybook_component_state.dart';

class StoryBookComponentProperties {
  StoryBookComponentProperties({
    this.attributes = const [],
    this.selectedConstructor,
  });

  final List<AttributeModel> attributes;
  String? selectedConstructor;

  /// Comparação por conteúdo para que o [ValueListenableBuilder] da
  /// `Storybook` reconstrua quando o usuário alterar um atributo.
  ///
  /// Os atributos são mutados in-place pelos editores (ex.: um `bool`
  /// toggle muda `attribute.selectedValue!.value`). Sem este `==`, o
  /// `ValueListenableBuilder` veria a mesma referência de `attributes`
  /// no `properties`, compararia por identidade (que é `true` para o
  /// mesmo objeto) e **não** reconstruiria — o device preview ficaria
  /// congelado.
  ///
  /// A comparação é delegada para [AttributeModel.==], que cobre todos
  /// os campos relevantes (incluindo `selectedValue`).
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! StoryBookComponentProperties) return false;
    if (other.selectedConstructor != selectedConstructor) return false;
    if (other.attributes.length != attributes.length) return false;
    for (var i = 0; i < attributes.length; i++) {
      if (attributes[i] != other.attributes[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    // Consistente com `==`: hash do conteúdo para satisfazer o
    // contrato `a == b ⇒ a.hashCode == b.hashCode` do `Object`.
    // O conteúdo é mutável (em particular `selectedValue`), então
    // o hash pode mudar ao longo da vida do objeto — isso é
    // aceitável para o caso de uso atual (`ValueListenableBuilder`
    // só usa `==` para decidir se reconstrói). Se esta classe for
    // usada como chave em `Set`/`Map` *após* uma mutação, a busca
    // pode falhar — o caller é responsável por evitar isso.
    return Object.hash(
      selectedConstructor,
      Object.hashAll(attributes),
    );
  }
}

class StoryBookComponentController
    extends ValueNotifier<StoryBookComponentProperties> {
  StoryBookComponentController(this.properties) : super(properties);
  final StoryBookComponentProperties properties;

  List<AttributeModel> get attributes => properties.attributes;

  set attributes(List<AttributeModel> value) {
    properties.attributes.clear();
    properties.attributes.addAll(value);
    onUpdateAttributes(value);
  }

  String? get selectedConstructor => properties.selectedConstructor;

  set selectedConstructor(String? value) {
    properties.selectedConstructor = value;
    notifyListeners();
  }

  dynamic getWhereAttribute(String name) {
    for (final e in attributes) {
      if (e.name == name) return e.selectedValue?.value;
    }
    return null;
  }

  void onUpdateAttributes(List<AttributeModel> attributes) {
    notifyListeners();
  }
}

class StoryBookComponent extends StatefulWidget {
  const StoryBookComponent({
    super.key,
    required this.title,
    required this.nameObjectInDisplay,
    this.child,
    this.builder,
    this.attributes = const [],
    this.description = '',
    this.multipleThemeSettings,
    this.controller,
    this.backgroundColor,
    this.onUpdateTheme,
    this.extraAttributesConfigCustom,
    this.onSelectedConstructor,
    this.storybookTheme,
  }) : assert(child != null || builder != null, 'child or builder is required');

  final Widget? child;
  final WidgetBuilder? builder;
  final String title;
  final String description;
  final List<AttributeModel> attributes;
  final String nameObjectInDisplay;
  final StoryBookComponentController? controller;
  final MultipleThemeSettings? multipleThemeSettings;
  final Color? backgroundColor;
  final void Function(
    MultipleThemeSettings multipleThemeSettings,
  )? onUpdateTheme;
  final OnBuildExtraAttributesConfigCustom? extraAttributesConfigCustom;
  final Function(String constructor)? onSelectedConstructor;

  /// Tema customizável do storybook.
  /// Se null, usa [StorybookTheme.defaults].
  final StorybookTheme? storybookTheme;

  @override
  State<StoryBookComponent> createState() => _StoryBookComponenState();
}

class _StoryBookComponenState extends State<StoryBookComponent> {
  late final StoryBookComponentController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = StoryBookComponentController(
        StoryBookComponentProperties(
          attributes: widget.attributes,
        ),
      );
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StoryBookComponentState(
        title: widget.title,
        description: widget.description,
        attributes: widget.attributes,
        nameObjectInDisplay: widget.nameObjectInDisplay,
        controller: _controller,
        multipleThemeSettings: widget.multipleThemeSettings,
        backgroundColor: widget.backgroundColor,
        onUpdateTheme: widget.onUpdateTheme,
        extraAttributesConfigCustom: widget.extraAttributesConfigCustom,
        builder: widget.builder,
        onSelectedConstructor: widget.onSelectedConstructor,
        storybookTheme: widget.storybookTheme,
        child: widget.child,
      );
}
