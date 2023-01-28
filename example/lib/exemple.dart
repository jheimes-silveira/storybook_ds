import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

class ExemplePage extends StatefulWidget {
  const ExemplePage({Key? key}) : super(key: key);

  @override
  ComponentBasePage<ExemplePage> createState() => _ExemplePageState();
}

class _ExemplePageState extends ComponentBasePage<ExemplePage> {
  List<AtributeDto> listAtributs = [
    AtributeDto(
      type: 'Function()',
      name: 'onPressed',
      required: true,
      builders: [null, 'construtor1', 'construtor2'],
    ),
    AtributeDto(
      type: 'String',
      name: 'text',
      required: true,
      selectedValue: VariableOption(value: 'Buttom'),
      builders: [null, 'construtor1', 'construtor2'],
    ),
    AtributeDto(
      type: 'String?',
      name: 'outroArgumentoOpcional',
      selectedValue: VariableOption(value: 'Teste'),
      // builders: [null, 'construtor1', 'construtor2'],
    ),
    AtributeDto(
        type: 'IconData',
        name: 'icon',
        selectedValue: VariableOption(value: Icons.abc_outlined),
        builders: [
          'construtor2',
          'construtor3',
          'construtor4',
          'construtor5',
        ],
        variableOptions: [
          VariableOption(value: Icons.abc_outlined),
          VariableOption(value: Icons.abc),
          VariableOption(value: Icons.ac_unit_outlined),
          VariableOption(value: Icons.adb_outlined),
        ]),
  ];

  @override
  List<AtributeDto> atributs() {
    return listAtributs;
  }

  @override
  Widget buildComponentWidget(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text(getWhereAtribut(atributs(), 'text')),
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  String description() {
    return 'O componente de alerta permite mostrar mensagens de alerta para o usuário';
  }

  @override
  String nameObjectInDisplay() {
    return 'CCAlert';
  }

  @override
  String title() {
    return 'CCAlert';
  }

  @override
  void onUpdateAtributs(List<AtributeDto> atributs) {
    setState(() {
      listAtributs = atributs;
    });
  }
}
