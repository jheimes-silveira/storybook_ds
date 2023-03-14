# Storybook Design System

Um storybook para apresentação de Widgets de Design System.

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
  storybook:
```

## Uso
Importe o projeto dentro do seu arquivo:

```dart
import 'package:storybook_ds/storybook_ds.dart';
```

Crie um **StatefulWidget** para o componente que deseja apresentar. <br> Em seguida, substitua a classe **State** por **Storybook**:

```dart
class ButtonPage extends StatefulWidget {
  const ButtonPage({super.key});

  @override
  Storybook<ButtonPage> createState() => _ButtonPageState();
}

class _ButtonPageState extends Storybook<ButtonPage> {...
```

Remova a classe **build** da sua classe Storybook. <br> Adicione os overrides:

**Title**: título da tela. Obs: use o nome do componente de preferência.
```dart
@override
String get title => "DS Button";
```

**NameObjectInDisplay**: nome da classe do componente que será chamado no código e que será apresentado no display do storybook. <br> Display é a parte do storybook onde é mostrado o código do componente.
```dart
@override
String get nameObjectInDisplay => "DSButton";
```

**Atributs**: Adicione os atributos do seu componente. Esses são representados pela classe **AtributeDto** (mais detalhes a seguir).
```dart
@override
List<AtributeDto> atributs = [
    AtributeDto(
      type: 'Function()',
      name: 'onPressed',
      required: true,
      builders: ['elevated', 'outline', 'text'],
    ),
    AtributeDto(
      type: 'String',
      name: 'text',
      required: true,
      selectedValue: VariableOption(value: 'Custom Buttom'),
      builders: ['elevated', 'outline', 'text'],
    ),
    AtributeDto(
      type: 'Color?',
      name: 'color',
      builders: ['elevated'],
      selectedValue: VariableOption(value: null),
      variableOptions: [
        VariableOption(
          value: Colors.amber,
          textInDisplay: 'Colors.amber',
          textInSelectedOptions: 'amber',
        ),
        VariableOption(
          value: Colors.black,
          textInDisplay: 'Colors.black',
          textInSelectedOptions: 'black',
        ),
      ],
    ),
  ];
```

### AtributeDto:
**AtributeDto** é a classe usada para mapear cada um dos atributos do seu componente. Suas principais funcionalidades são:
* *Type* define qual o tipo do atributo ("String", "Function()", "bool", "double", "dynamic", etc). Caso o atributo seja *nullable*, adicione a interrogação (ex: "double?").
* *Name* define o nome do atributo, e será usado pela classe Storybook para mapear os atributos da classe. (Ex: "isLoading", "value", "onPressed", etc).
* *Required* define se o atributo é obrigatório.
* *SelectedValue* define qual o valor inicial do seu componente no storybook. É definido pela classe **VariableOption**.
* *VariableOptions* é uma lista de elementos "**VariableOption**" que permite ao usuário do storybook interagir com o componente, alternando entre as opções de valores para aquele atributo. Usado para exemplificar ao usuário a funcionalidade daquele atributo, e como ele afeta o estado do componente.
* *Builders* é uma lista de Strings que define a quais construtores o seu componente está presente.
  * Por exemplo, um botão cujos construtores são "DSButton.elevated(...)" e "DSButton.outlined(...)", caso seu elemento pertença aos dois construtores, defina builders como: ["elevated", "outlined"].
  * Caso seu componente tenha um construtor default, e seu atributo esteja presente nesse construtor, adicione *null* à lista: [null, "elevated", "outlined"];

### buildComponentWidget:
Ainda na classe **Storybook** do seu componente, retorne uma classe *Scaffold* com seu componente como filho, para que ele seja apresentado no storybook ao usuário. <br> 
Utilize a função **getWhereAtribut()** para recuperar o valor de um atributo de acordo com o nome dele (*name*), e atribua ao seu componente. Assim, conforme o usuário manipular o storybook, as mudanças irão se aplicar ao componente automaticamente. <br>
Verifique qual o construtor selecionado por meio da variável **selectedConstructor** e retorne o componente com o construtor correspondente.
```dart
@override
Widget buildComponentWidget(BuildContext context) {
  Widget child;
  if (selectedConstructor == 'elevated') {
    child = DSButton.elevated(
      text: getWhereAtribut('text'),
      loading: getWhereAtribut('loading'),
      color: getWhereAtribut('color'),
      onPressed: () {},
    );
  }
  else if (selectedConstructor == 'outline') {
    child = DSButton.outline(
      text: getWhereAtribut('text'),
      loading: getWhereAtribut('loading'),
      onPressed: () {},
    );
  }
  else {
    child = DSButton(
      text: getWhereAtribut('text'),
      onPressed: () {},
    );
  }

  return Scaffold(
    body: Center(
      child: child,
    ),
  );
}
```