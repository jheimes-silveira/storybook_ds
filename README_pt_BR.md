# Storybook Design System

Storybook para apresentação de Widgets de Design System.

Confira no [Exemplo](https://showroom-ds.web.app/#/).

## Começar
Execute o comando:

```bash
flutter pub add storybook_ds
```

Ou adicione manualmente:

```yaml
dependencies:
  flutter:
    sdk: flutter
  storybook: {{version}}
```

## Uso
Importe o projeto dentro do seu arquivo:

```dart
import 'package:storybook_ds/storybook_ds.dart';
```

Crie um StatefulWidget para o componente que deseja apresentar e substitua a classe **State** por **Storybook**: 

```dart
class ButtonPage extends StatefulWidget {
  const ButtonPage({super.key});

  @override
  Storybook<ButtonPage> createState() => _ButtonPageState();
}

class _ButtonPageState extends Storybook<ButtonPage> {...
```

Adicione os overrides *obrigatorios*:

Título da tela com o nome do componente.
```dart
@override
String get title => 'DS Button';
```

Descrição explicativa do componente.
```dart
@override
String get description => 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.';
```

Nome da classe do componente que será chamado no código. Display é a parte do storybook onde é mostrado o código do componente.
```dart
@override
String get nameObjectInDisplay => "DSButton";
```

Adicione os atributos do componente, que são representados pela classe AtributeDto (mais detalhes a seguir).
Em builders, defina em quais construtores da classe o atributo estará presente, sendo null o construtor padrão.
```dart
@override
List<AtributeDto> atributs() {
  return [
    AtributeDto(
      type: 'Function()',
      name: 'onPressed',
      required: true,
      builders: [null, 'elevated', 'outline'],
    ),
    AtributeDto(
      type: 'String',
      name: 'text',
      required: true,
      selectedValue: VariableOption(value: 'Custom Buttom'),
      builders: ['elevated', 'outline'],
    ),
    AtributeDto(
      type: 'bool',
      name: 'loading',
      selectedValue: VariableOption(value: false),
      builders: ['elevated', 'outline'],
    ),
  ];
}
```

Configurações de Tema Múltiplo
Visão Geral
Podemos lidar com múltiplos temas dentro do projeto de apresentação. Você pode instanciar as configurações de tema múltiplo conforme mostrado abaixo.

Exemplo de Uso
```dart
  @override
  MultipleThemeSettings? multipleThemeSettings = MultipleThemeSettings(
    selectableThemes: [
      ThemeSettings(
        title: 'Thema 1',
        light: ThemeData.light(),
        dark: ThemeData.dark(),
      ),
    ],
  );
```
Ao incluir este trecho, você pode selecionar qual tema aplicar no projeto. O tema selecionado é retornado na função onUpdateTheme.

Função de Atualização de Tema
```dart
  @override
  void onUpdateTheme(MultipleThemeSettings multipleThemeSettings) {
    // TODO: implement
  }
```
## Detalhes das Configurações

- **MultipleThemeSettings**: Classe que gerencia múltiplos temas.
  - **selectableThemes**: Lista de temas disponíveis para seleção.
- **ThemeSettings**: Classe que define as configurações de um tema específico.
  - **title**: Título do tema.
  - **light**: Configuração do tema claro.
  - **dark**: Configuração do tema escuro.

 **ThemeSettings**
 
| Nome                | Tipo          | Descrição                                                                 |
|---------------------|---------------|---------------------------------------------------------------------------|
| `ThemeSettings`     | `Constructor` | Construtor para inicializar as configurações de tema.                     |
| `switchThemeMode`   | `bool`        | Retorna `true` se o tema escuro estiver disponível.                       |
| `data`              | `dynamic`     | Retorna os dados adicionais associados ao tema.                           |
| `title`             | `String`      | Retorna o título do tema.                                                 |
| `light`             | `ThemeData`   | Retorna o tema claro.                                                     |
| `dark`              | `ThemeData`   | Retorna o tema escuro, ou o tema claro se o escuro não estiver definido.  |
| `isDarkMode`        | `bool`        | Retorna `true` se o modo escuro estiver ativado, caso contrário `false`.  |
| `currentTheme()`    | `ThemeData`   | Retorna o tema atual com base no estado do modo escuro.                   |
| `setCurrentTheme()` | `void`        | Define o tema atual com base no valor de `isDarkMode`.                    |

Função chamada ao atualizar algum atributo.
```dart
@override
void onUpdateAtributs(List<AtributeDto> atributs) {
    setState(() {
        listAtributs = atributs;
    });
}
```

Retorne o componente, e utilize a função getWhereAtribut() para recuperar o valor daquele atributo e atribuí-lo ao componente de forma dinâmica, assim a cada atualização de valores o componente será recarregado.
Verifique qual o construtor selecionado por meio da variável selectedConstructor e retorne o componente por meio do construtor correspondente.
```dart
@override
Widget buildComponentWidget(BuildContext context) {
  if (selectedConstructor == 'elevated') {
    return DSButton.elevated(
      text: getWhereAttribut('text'),
      loading: getWhereAttribut('loading'),
      onPressed: () {},
    );
  }

  if (selectedConstructor == 'outline') {
    return DSButton.outline(
      text: getWhereAttribut('text'),
      loading: getWhereAttribut('loading'),
      onPressed: () {},
    );
  }

  return DSButton(
    onPressed: () {},
  );
}
```