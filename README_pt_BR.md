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
  storybook:
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

Adicione os overrides:

Título da tela com o nome do componente.
```dart
@override
String title() => "DS Button";
```

Descrição explicativa do componente.
```dart
@override
String description() => "Lorem Ipsum is simply dummy text of the printing and typesetting industry.";
```

Nome da classe do componente que será chamado no código. Display é a parte do storybook onde é mostrado o código do componente.
```dart
@override
String nameObjectInDisplay() => "DSButton";
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
      text: getWhereAtribut(atributs(), 'text'),
      loading: getWhereAtribut(atributs(), 'loading'),
      onPressed: () {},
    );
  }

  if (selectedConstructor == 'outline') {
    return DSButton.outline(
      text: getWhereAtribut(atributs(), 'text'),
      loading: getWhereAtribut(atributs(), 'loading'),
      onPressed: () {},
    );
  }

  return DSButton(
    onPressed: () {},
  );
}
```