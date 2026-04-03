# Storybook Design System

Biblioteca Flutter para montar um **storybook** do seu Design System: painel de atributos, preview do componente e trecho de código gerado.

**Demonstração:** [showroom-ds.web.app](https://showroom-ds.web.app/#/)

**Código de referência:** pasta [`example/lib/`](example/lib/) — em especial [`custom_card_storybook.dart`](example/lib/custom_card_storybook.dart) e [`main.dart`](example/lib/main.dart).

---

## Instalação

```bash
flutter pub add storybook_ds
```

No `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  storybook_ds: ^1.2.5
```

**Import:**

```dart
import 'package:storybook_ds/storybook_ds.dart';
```

---

## Passo a passo: criar uma tela de story

O fluxo abaixo espelha o exemplo do `CustomCard`.

### 1. Colocar a story na árvore do app

O `MaterialApp` precisa envolver a página de story. Se você trocar o tema global quando o usuário mudar o tema no storybook, guarde o `ThemeData` no estado (como em `main.dart`):

```dart
home: MeuComponenteStorybook(
  onThemeChanged: (ThemeData next) {
    setState(() => _appTheme = next);
  },
),
```

### 2. Criar o `StatefulWidget` da story

```dart
class MeuComponenteStorybook extends StatefulWidget {
  const MeuComponenteStorybook({super.key, required this.onThemeChanged});

  final ValueChanged<ThemeData> onThemeChanged;

  @override
  Storybook<MeuComponenteStorybook> createState() => _MeuComponenteStorybookState();
}
```

### 3. O `State` deve estender `Storybook<...>`

Implemente os pontos obrigatórios:

| O quê | Para que serve |
|--------|----------------|
| `String get title` | Título no painel |
| `String get description` | Texto explicativo |
| `String get nameObjectInDisplay` | Nome da classe no snippet de código (ex.: `CustomCard`) |
| `List<AttributeDto> attributes` | Controles do painel (tipos, nomes, valores iniciais) |
| `Widget buildComponentWidget(BuildContext)` | O widget real no preview |

Exemplo mínimo de getters:

```dart
@override
String get title => 'Meu componente';

@override
String get description => 'Breve descrição para quem usa o DS.';

@override
String get nameObjectInDisplay => 'MeuWidget';
```

### 4. Definir `attributes`

Cada `AttributeDto` descreve um “knob”. O **nome** (`name`) é a chave usada em `getWhereAttribut('nome')`.

Use fábricas quando fizer sentido: `AttributeDto.enumType`, `AttributeDto.rangeDoubleInterval`, `AttributeDto.objectInObject`, `StorybookAttributeFactories.factoryAttributeDtoString`, etc.

### 5. Campo `builders`

Lista de **strings** que diz em quais construtores/fábricas o atributo aparece:

| Valor | Significado |
|--------|-------------|
| `''` | Construtor **padrão** (não nomeado) |
| `'inline'`, `'outline'`, … | Identificador que você compara em `selectedConstructor` |

**Regra:** use **`''`**, não `null`, para o padrão.  
Se omitir `builders`, muitas fábricas assumem `['']` (só padrão).

**Dica:** constantes no arquivo da story evitam erro de digitação, como no exemplo:

```dart
const _all = ['', 'inline', 'outline'];
const _somentePadrao = [''];
```

Um atributo que **só existe no construtor padrão** (ex.: `variant` quando as fábricas já fixam a variante) usa `builders: _somentePadrao`.

### 6. Implementar `buildComponentWidget`

1. Leia valores com **`getWhereAttribut('nomeDoAtributo')`** (e faça cast se precisar).
2. Use **`selectedConstructor`** para escolher qual construtor/fábrica montar:
   - **`selectedConstructor.isEmpty`** → construtor padrão (equivalente a `''` em `builders`).
   - **`selectedConstructor == 'inline'`** → fábrica `inline`, etc.

Padrão igual ao exemplo:

```dart
@override
Widget buildComponentWidget(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (selectedConstructor.isEmpty) _buildPadrao(),
          if (selectedConstructor == 'inline') _buildInline(),
          if (selectedConstructor == 'outline') _buildOutline(),
        ],
      ),
    ),
  );
}
```

Opcional: método auxiliar `T? _knob<T>(String name) => getWhereAttribut(name) as T?;` para deixar o código mais legível.

### 7. Temas opcionais (`MultipleThemeSettings`)

Se quiser troca de tema no storybook, atribua **`multipleThemeSettings`** no **`initState`** (o campo já existe na classe base `Storybook`):

```dart
@override
void initState() {
  super.initState();
  multipleThemeSettings = MultipleThemeSettings(
    selectableThemes: [
      ThemeSettings(
        title: 'Claro / escuro',
        light: ThemeData.light(useMaterial3: true),
        dark: ThemeData.dark(useMaterial3: true),
      ),
    ],
  );
}
```

Repasse o tema escolhido para o app em **`onUpdateTheme`**:

```dart
@override
void onUpdateTheme(MultipleThemeSettings settings) {
  widget.onThemeChanged(settings.selectedThemes.currentTheme());
}
```

---

## Objetos aninhados no painel

Para `AttributeDto.objectInObject`, informe **`merge`**: uma função `(instância, nomeDoCampo, novoValor)` que devolve o objeto atualizado. Pode ser escrita à mão ou gerada com **`@StorybookModel()`** e o pacote **`storybook_ds_builder`** (veja [`example/build.yaml`](example/build.yaml) e pasta [`builder/`](builder/)).

---

## Sem `reflectable`

O pacote **não usa** `reflectable`. Monte a lista de `AttributeDto` manualmente (ou gere só o `merge` com o builder). Detalhes: [`CHANGELOG.md`](CHANGELOG.md).

---

## Resumo rápido

1. `StatefulWidget` → `State extends Storybook<T>`.
2. `title`, `description`, `nameObjectInDisplay`, `attributes`, `buildComponentWidget`.
3. `builders`: `''` = padrão; demais strings = mesmos rótulos que você testa em `selectedConstructor`.
4. `getWhereAttribut` + `selectedConstructor.isEmpty` / `== 'nome'`.
5. Temas: `initState` + `onUpdateTheme` se necessário.
