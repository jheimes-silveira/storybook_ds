# Storybook Design System

Biblioteca Flutter para criar um **storybook** do seu Design System: painel de atributos, preview ao vivo do componente e trecho de código gerado automaticamente.

**Demonstração:** [showroom-ds.web.app](https://showroom-ds.web.app/#/)

**Código de referência:** pasta [`example/lib/`](example/lib/) — em especial:

- [`example/lib/main.dart`](example/lib/main.dart) — sobe o app.
- [`example/lib/custom_card_storybook.dart`](example/lib/custom_card_storybook.dart) — a story do `CustomCard`.
- [`example/lib/custom_card.dart`](example/lib/custom_card.dart) — o widget em si (com `@StorybookModel` para objeto aninhado).
- [`example/lib/sample_themes.dart`](example/lib/sample_themes.dart) — temas Material 3 de exemplo.
- [`example/lib/storybook_example_attributes.dart`](example/lib/storybook_example_attributes.dart) — fábrica de `colorPicker` reaproveitável.

> A partir da versão **1.2.5** o pacote **não usa mais `reflectable`** (reflexão não roda em Flutter AOT). A partir da versão **1.3.0**, todas as referências internas a `AttributeDto` foram renomeadas para `AttributeModel`. `AttributeDto` permanece disponível como um alias de tipo (`typedef`) marcado como `@deprecated` para fins de compatibilidade retroativa. Você monta a lista de atributos **na mão** (o que esta documentação mostra) ou usa o gerador opcional `storybook_ds_builder` (com `build_runner`) só para gerar funções `merge*` de objetos aninhados.

---

## 1. Instalação

Em um app Flutter existente:

```bash
flutter pub add storybook_ds
```

No `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  storybook_ds: ^1.3.0
```

**Import único** que você vai usar em todo lugar:

```dart
import 'package:storybook_ds/storybook_ds.dart';
```

Para usar o gerador de `merge*` (objetos aninhados), adicione em `dev_dependencies`:

```yaml
dev_dependencies:
  build_runner: 2.4.13
  storybook_ds_builder: ^1.0.0
```

> Se `pub get` reclamar de conflito entre `build_runner` e o builder, **pine `build_runner` em `2.4.13`** como em [`example/pubspec.yaml`](example/pubspec.yaml).

---

## 2. Visão geral: o que a lib te entrega

A base abstrata é a classe `Storybook<T>`. Você estende ela num `State` e o pacote desenha, em volta do seu widget:

1. Um **preview** (com `DevicePreview` e seleção de tema).
2. Um **painel de atributos** à esquerda com os "knobs" que você declarar.
3. Um **snippet de código** que mostra como instanciar o widget com os valores atuais.

Para isso, o seu `State` precisa implementar:

| Membro | Obrigatório? | Para que serve |
|--------|--------------|----------------|
| `String get title` | sim | Título da story |
| `String get description` | sim | Texto explicativo |
| `String get nameObjectInDisplay` | sim | Nome da classe no snippet (ex.: `CustomCard`) |
| `List<AttributeModel> get attributes` | sim | Os controles do painel |
| `Widget buildComponentWidget(BuildContext)` | sim | O seu widget sendo renderizado |
| `MultipleThemeSettings? multipleThemeSettings` | opcional | Trocar temas no preview |
| `OnBuildExtraAttributesConfigCustom? get extraAttributesConfigCustom` | opcional | UI extra no painel |
| `StorybookTheme? get storybookTheme` | opcional | Cores do chrome do storybook |

Não existe “mágica”: você descreve **uma lista de knobs** e o painel renderiza os editores automaticamente (`String`, `bool`, `int`, `double` com range, `enum`, `Color`, `Function?`, objeto aninhado).

---

## 3. Passo a passo: criar uma tela de story do zero

Vou usar o `CustomCard` do exemplo como referência. A ideia é: ao final destes passos, você vai ter uma story como [`example/lib/custom_card_storybook.dart`](example/lib/custom_card_storybook.dart) e o seu widget (`CustomCard` aqui) como um `StatefulWidget` normal.

### Passo 1 — Hospedar a story no `MaterialApp`

A story precisa estar **dentro de um `MaterialApp`**. Se você quer que o tema global mude quando o usuário troca o tema no painel, guarde o `ThemeData` em estado:

```dart
// example/lib/main.dart
import 'package:flutter/material.dart';

import 'custom_card_storybook.dart';

void main() {
  runApp(const StorybookDemoApp());
}

class StorybookDemoApp extends StatefulWidget {
  const StorybookDemoApp({super.key});

  @override
  State<StorybookDemoApp> createState() => _StorybookDemoAppState();
}

class _StorybookDemoAppState extends State<StorybookDemoApp> {
  ThemeData _appTheme = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storybook DS — exemplo',
      theme: _appTheme,
      debugShowCheckedModeBanner: false,
      home: CustomCardStorybook(
        onThemeChanged: (ThemeData next) {
          setState(() => _appTheme = next);
        },
      ),
    );
  }
}
```

> **Detalhe importante:** o `CustomCardStorybook` recebe um `ValueChanged<ThemeData>` por construtor. Esse callback é chamado pela base `Storybook` toda vez que o usuário escolhe outro tema no painel.

### Passo 2 — O `StatefulWidget` da story

```dart
class CustomCardStorybook extends StatefulWidget {
  const CustomCardStorybook({
    super.key,
    required this.onThemeChanged,
  });

  final ValueChanged<ThemeData> onThemeChanged;

  @override
  Storybook<CustomCardStorybook> createState() => _CustomCardStorybookState();
}
```

Pontos:

- A classe é um `StatefulWidget` comum.
- `createState` retorna `State<...>` que **estende `Storybook<...>`** (a base da lib).
- `onThemeChanged` é o que conecta o tema escolhido no painel ao `MaterialApp`.

### Passo 3 — O `State` estende `Storybook<T>`

```dart
class _CustomCardStorybookState extends Storybook<CustomCardStorybook> {
  @override
  String get description =>
      'Magna et nonumy dolor duo sanctus sed est stet voluptua...';

  @override
  String get nameObjectInDisplay => 'CustomCard';

  @override
  String get title => 'Custom Card';

  @override
  Widget buildComponentWidget(BuildContext context) {
    return const Center(child: Text('em construção'));
  }
}
```

Quatro getters obrigatórios por enquanto. No passo 6 a gente preenche `buildComponentWidget` de verdade e no passo 4 a gente declara os atributos.

### Passo 4 — Declarar `attributes`

Cada `AttributeModel` é **um knob** no painel. O `name` é a chave que você usa depois em `getWhereAttribut('name')`.

Os tipos mais usados (todos são *factories* de `AttributeModel`):

| Factory | Tipo de controle no painel |
|---------|---------------------------|
| `AttributeModel(name:..., type:'String', ...)` | Texto livre |
| `StorybookAttributeFactories.factoryAttributeDtoString(...)` | Texto longo com presets de 5, 10, 20, 40, 80, 120 palavras (ótimo para `description`) |
| `AttributeModel(name:..., type:'bool', ...)` | Switch on/off |
| `AttributeModel.enumType(values: ...)` | Dropdown de enum |
| `AttributeModel.rangeIntInterval(begin, end, ...)` | Slider de inteiro |
| `AttributeModel.rangeDoubleInterval(begin, end, ...)` | Slider de double |
| `AttributeModel.color(...)` | Seletor de cor |
| `AttributeModel.function(...)` | Callback (botão) |
| `AttributeModel.objectInObject(...)` | Sub-painel para objeto aninhado (precisa de `merge`) |

Exemplo real (trecho de [`example/lib/custom_card_storybook.dart`](example/lib/custom_card_storybook.dart)):

```dart
late final List<AttributeModel> attributes = [
  // String obrigatória, com presets de texto longo
  StorybookAttributeFactories.factoryAttributeDtoString(
    name: 'title',
    selectedValue: 'Lorem justo clita tempor labore',
    required: true,
    builders: _cardBuildersAll, // ['', 'inline', 'outline']
  ),

  // Booleano
  AttributeModel(
    name: 'hidden',
    type: 'bool',
    selectedValue: VariableOption(value: false),
    builders: _cardBuildersAll,
  ),

  // Enum
  AttributeModel.enumType(
    name: 'imageDisplay',
    selectedValue: CardImageDisplay.image,
    values: CardImageDisplay.values,
    builders: _cardImageBuildersAll,
  ),

  // Range de double
  AttributeModel.rangeDoubleInterval(
    name: 'width',
    begin: 220,
    end: 400,
    canBeNull: true,
    selectedValue: null,
    builders: _cardBuildersAll,
  ),

  // Callback (botão de ação)
  AttributeModel(
    name: 'onPositive',
    type: 'Function()?',
    selectedValue: VariableOption(value: '(){}'),
    builders: _cardBuildersAll,
  ),
];
```

Duas dicas valiosas:

1. **`builders: const ['']`** (string vazia) é o construtor **padrão** (não nomeado). Use `''` no default, nunca `null`.
2. Para reaproveitar combinações, declare constantes no topo do arquivo:

```dart
const _cardBuildersAll = <String>['', 'inline', 'outline'];
const _cardBuilderDefaultOnly = <String>[''];
```

### Passo 5 — O campo `builders` em detalhe

O `builders` é uma `List<String>` que diz em **quais construtores / fábricas** aquele atributo aparece no painel. Você compara essa string com **`selectedConstructor`** no `buildComponentWidget`.

| Valor em `builders` | Significado |
|---------------------|-------------|
| `''` (string vazia) | Construtor **padrão** (não nomeado) |
| `'inline'`, `'outline'`, ... | Fábrica nomeada — use o mesmo rótulo que você testa em `selectedConstructor == 'inline'` |

Exemplo mental para o `CustomCard`:

- O widget tem o construtor padrão `CustomCard(...)` e duas fábricas: `CustomCard.inline(...)` e `CustomCard.outline(...)`.
- O parâmetro `variant` **só existe no construtor padrão** (as fábricas fixam a variante internamente). Logo: `builders: _cardBuilderDefaultOnly` (ou seja, `['']`).
- O parâmetro `imageDisplay` existe em **todos** os construtores. Logo: `builders: _cardImageBuildersAll` (ou seja, `['', 'inline', 'outline']`).
- Todo o resto (`title`, `description`, `width`, `height`, `hidden`, `enabled`, `borderEnabled`, `settings`, `onPositive`, `onNegative`, `textPositive`, `textNegative`) também existe em todos → `builders: _cardBuildersAll`.

### Passo 6 — Implementar `buildComponentWidget`

Aqui você **lê os knobs** com `getWhereAttribut('nome')` e decide qual construtor usar com `selectedConstructor`.

Padrão recomendado (helper para legibilidade):

```dart
T? _knob<T>(String name) => getWhereAttribut(name) as T?;
```

Três builders (um por construtor), cada um montando o widget:

```dart
CustomCard _cardDefaultConstructor() {
  return CustomCard(
    title: _knob<String>('title') ?? '',
    variant: _knob<CustomCardVariant>('variant') ?? CustomCardVariant.inline,
    description: _knob<String>('description'),
    settings: _knob<CustomCardSettings>('settings'),
    onNegative: _knob<dynamic>('onNegative') != null ? () {} : null,
    textNegative: _knob<String>('textNegative'),
    onPositive: _knob<dynamic>('onPositive') != null ? () {} : null,
    textPositive: _knob<String>('textPositive'),
    height: _knob<double>('height'),
    width: _knob<double>('width'),
    hidden: _knob<bool>('hidden') ?? false,
    enabled: _knob<bool>('enabled') ?? true,
    imageDisplay: _knob<CardImageDisplay>('imageDisplay') ?? CardImageDisplay.image,
    imageUrl: _kDefaultImageUrl,
    borderEnabled: _knob<bool>('borderEnabled') ?? false,
  );
}

CustomCard _cardInlineFactory() { /* CustomCard.inline(...) */ }
CustomCard _cardOutlineFactory() { /* CustomCard.outline(...) */ }
```

E o `buildComponentWidget` ramificando por `selectedConstructor`:

```dart
@override
Widget buildComponentWidget(BuildContext context) {
  final canvasColor = Theme.of(context).scaffoldBackgroundColor;

  return Scaffold(
    backgroundColor: canvasColor,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedConstructor.isEmpty) _cardDefaultConstructor(),
            if (selectedConstructor == 'inline') _cardInlineFactory(),
            if (selectedConstructor == 'outline') _cardOutlineFactory(),
          ],
        ),
      ),
    ),
  );
}
```

Pontos importantes:

- **`selectedConstructor.isEmpty` = construtor padrão** (igual a `''` no `builders`).
- **`selectedConstructor == 'inline'`** = a fábrica `CustomCard.inline(...)`.
- Para atributos do tipo `Function?` (`onPositive`, `onNegative`), o painel só manda um valor quando o usuário ativa o knob. Verifique `_knob<dynamic>('onPositive') != null` antes de passar um `() {}` real, evitando callbacks nulos acidentais.

### Passo 7 — Temas opcionais (`MultipleThemeSettings`)

Se quiser troca de tema **dentro do preview**, atribua o campo **`multipleThemeSettings`** no `initState` (a base `Storybook` já declara esse campo):

```dart
@override
void initState() {
  super.initState();
  multipleThemeSettings = MultipleThemeSettings(
    selectableThemes: [
      ThemeSettings(
        title: 'Sistema (Material padrão)',
        light: ThemeData.light(useMaterial3: true),
        dark: ThemeData.dark(useMaterial3: true),
      ),
      ThemeSettings(
        title: 'M3 — Sálvia (claro / escuro)',
        light: buildSampleM3Theme(seedColor: sampleSeedSage, brightness: Brightness.light),
        dark: buildSampleM3Theme(seedColor: sampleSeedSage, brightness: Brightness.dark),
      ),
      // ...outros temas
    ],
  );
}
```

E repasse o tema escolhido para o `MaterialApp` em `onUpdateTheme`:

```dart
@override
void onUpdateTheme(MultipleThemeSettings settings) {
  widget.onThemeChanged(settings.selectedThemes.currentTheme());
}
```

`currentTheme()` retorna o `ThemeData` correto (light ou dark) do tema que o usuário escolheu no painel.

---

## 4. Objetos aninhados no painel (`AttributeModel.objectInObject`)

Quando o seu widget recebe um **objeto de configuração** (ex.: `CustomCardSettings`), você quer que o painel deixe o usuário editar cada campo desse objeto separadamente. Para isso:

1. Anote a classe de configuração com `@StorybookModel()`.
2. Adicione `part 'minha_classe.storybook.g.dart';` no arquivo dela.
3. Rode o gerador (gera uma função `mergeNomeDaClasse`).
4. Use `AttributeModel.objectInObject(...)` com `merge: mergeNomeDaClasse`.

### 4.1. Anotar o modelo

```dart
// example/lib/custom_card.dart
import 'package:flutter/material.dart';
import 'package:storybook_ds/annotations.dart';

part 'custom_card.storybook.g.dart';

@StorybookModel()
class CustomCardSettings {
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const CustomCardSettings({
    this.textColor,
    this.backgroundColor,
    this.borderColor,
  });
}
```

**Requisitos** para a classe ser válida:

- Construtor **não nomeado**, com todos os campos como parâmetros **nomeados**.
- Todos os campos **públicos** (sem `_` na frente).

### 4.2. Configurar `build_runner`

Em `build.yaml` (raiz do seu app / exemplo), limite o gerador aos arquivos anotados para não varrer o projeto inteiro:

```yaml
# example/build.yaml
targets:
  $default:
    builders:
      storybook_ds_builder|storybookModelBuilder:
        generate_for:
          - lib/custom_card.dart
```

Em `pubspec.yaml`, garanta a `dev_dependency`:

```yaml
dev_dependencies:
  build_runner: 2.4.13
  storybook_ds_builder: ^1.0.0
```

Rode:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Isso gera `custom_card.storybook.g.dart` com a função `mergeCustomCardSettings(current, fieldName, newValue)`.

### 4.3. Usar no painel

```dart
AttributeModel.objectInObject(
  name: 'settings',
  type: 'CustomCardSettings?',
  merge: (instance, fieldName, newValue) => mergeCustomCardSettings(
    instance as CustomCardSettings,
    fieldName,
    newValue,
  ),
  children: [
    StorybookExampleAttributes.colorPicker(
      name: 'backgroundColor',
      canBeNull: true,
      builders: _cardBuildersAll,
    ),
    StorybookExampleAttributes.colorPicker(
      name: 'textColor',
      canBeNull: true,
      builders: _cardBuildersAll,
    ),
    StorybookExampleAttributes.colorPicker(
      name: 'borderColor',
      canBeNull: true,
      builders: _cardBuildersAll,
    ),
  ],
  builders: _cardBuildersAll,
  selectedValue: VariableOption(
    value: const CustomCardSettings(
      backgroundColor: null,
      textColor: null,
      borderColor: null,
    ),
  ),
),
```

No `buildComponentWidget`, basta repassar o objeto como `settings: _knob<CustomCardSettings>('settings')`. O gerador garante que **a cada edição de um sub-campo**, o objeto é re-montado com `copyWith` manual.

### 4.4. Sem o gerador (opcional, manual)

Se você não quiser usar `build_runner`, pode escrever o `merge` à mão:

```dart
CustomCardSettings mergeCustomCardSettings(
  CustomCardSettings current,
  String fieldName,
  Object? newValue,
) {
  switch (fieldName) {
    case 'backgroundColor':
      return CustomCardSettings(
        backgroundColor: newValue as Color?,
        textColor: current.textColor,
        borderColor: current.borderColor,
      );
    case 'textColor':
      return CustomCardSettings(
        backgroundColor: current.backgroundColor,
        textColor: newValue as Color?,
        borderColor: current.borderColor,
      );
    case 'borderColor':
      return CustomCardSettings(
        backgroundColor: current.backgroundColor,
        textColor: current.textColor,
        borderColor: newValue as Color?,
      );
    default:
      return current;
  }
}
```

E usar exatamente da mesma forma em `AttributeModel.objectInObject(merge: ...)`.

---

## 5. Receitas rápidas

### 5.1. Atributo `String` com presets úteis (ex.: descrição)

```dart
StorybookAttributeFactories.factoryAttributeDtoString(
  name: 'description',
  selectedValue: 'Lorem ipsum dolor sit amet...',
  canBeNull: true,
  builders: _cardBuildersAll,
)
```

### 5.2. Atributo `enum`

```dart
AttributeModel.enumType(
  name: 'variant',
  selectedValue: CustomCardVariant.outline,
  values: CustomCardVariant.values,
  builders: const [''], // só construtor padrão
)
```

### 5.3. Atributo `bool`

```dart
AttributeModel(
  name: 'borderEnabled',
  type: 'bool',
  selectedValue: VariableOption(value: false),
  builders: _cardBuildersAll,
)
```

### 5.4. Atributo `double` com slider (e `null` permitido)

```dart
AttributeModel.rangeDoubleInterval(
  name: 'height',
  begin: 160,
  end: 600,
  canBeNull: true,
  selectedValue: null,
  builders: _cardBuildersAll,
)
```

### 5.5. Atributo `Color` reaproveitável (fábrica sua)

Em vez de repetir o mesmo `AttributeModel` com lista de cores, crie um helper:

```dart
// example/lib/storybook_example_attributes.dart
class StorybookExampleAttributes {
  StorybookExampleAttributes._();

  static AttributeModel colorPicker({
    required String name,
    bool canBeNull = false,
    VariableOption? selectedValue,
    List<String> builders = const [''],
  }) {
    return AttributeModel(
      type: 'Color${canBeNull ? '?' : ''}',
      name: name,
      builders: builders,
      selectedValue: selectedValue ?? VariableOption(value: null),
      variableOptions: [
        VariableOption(value: Colors.lime, textInDisplay: 'Colors.lime', textInSelectedOptions: 'lime'),
        VariableOption(value: Colors.black, textInDisplay: 'Colors.black', textInSelectedOptions: 'black'),
        VariableOption(value: Colors.red, textInDisplay: 'Colors.red', textInSelectedOptions: 'red'),
        VariableOption(value: Colors.white, textInDisplay: 'Colors.white', textInSelectedOptions: 'white'),
      ],
    );
  }
}
```

Uso:

```dart
StorybookExampleAttributes.colorPicker(
  name: 'textColor',
  canBeNull: true,
  builders: _cardBuildersAll,
)
```

### 5.6. Atributo `Function?` (callback / botão)

```dart
AttributeModel(
  name: 'onPositive',
  type: 'Function()?',
  selectedValue: VariableOption(value: '(){}'),
  builders: _cardBuildersAll,
)
```

No builder:

```dart
onPositive: _knob<dynamic>('onPositive') != null ? () {} : null,
```

---

## 6. Cheat sheet

1. `StatefulWidget` → `State extends Storybook<T>`.
2. Implemente: `title`, `description`, `nameObjectInDisplay`, `attributes`, `buildComponentWidget`.
3. `builders`: `''` = construtor padrão; demais strings = rótulos comparados em `selectedConstructor`.
4. `getWhereAttribut('nome')` para ler o valor de um knob.
5. `selectedConstructor.isEmpty` → padrão; `selectedConstructor == 'inline'` → fábrica `inline`.
6. Objetos aninhados: `@StorybookModel()` + `part '*.storybook.g.dart';` + `dart run build_runner build`.
7. Temas: `initState` (atribuir `multipleThemeSettings`) + `onUpdateTheme` (repassar para o app).
8. **Sem `reflectable`**: a lista de `AttributeModel` é explícita (você escreve), sem magia em runtime.

---

## 7. Troubleshooting

- **O atributo não aparece no painel?** Confirme o `builders`. Se você criou um knob com `builders: const ['']`, ele só aparece para o construtor padrão.
- **O objeto aninhado não atualiza?** Você esqueceu o `merge` em `AttributeModel.objectInObject`. Sem ele, o `StateError` é lançado ao tentar editar um sub-campo.
- **`pub get` reclamando de `build_runner`?** Pine em `2.4.13`, como em [`example/pubspec.yaml`](example/pubspec.yaml).
- **O snippet de código mostra parâmetros que não existem no construtor atual?** Verifique se os `builders` dos atributos batem com o `selectedConstructor` que está ativo.
