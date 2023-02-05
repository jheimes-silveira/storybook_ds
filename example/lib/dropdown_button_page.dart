import 'package:flutter/material.dart';
import 'package:storybook_ds/ds/dropdown/ds_dropdown_button.dart';
import 'package:storybook_ds/storybook_ds.dart';

class DropdownButtonPage extends StatefulWidget {
  const DropdownButtonPage({Key? key}) : super(key: key);

  @override
  Storybook<DropdownButtonPage> createState() => _DropdownButtonPageState();
}

class _DropdownButtonPageState extends Storybook<DropdownButtonPage> {
  String? _value = 'Alagoas';

  List<AtributeDto> listAtributs = [
    AtributeDto(
      type: 'bool',
      name: 'search',
      builders: [null, 'singleSelection'],
      selectedValue: VariableOption(value: false),
    ),
    AtributeDto(
      required: true,
      type: 'List<DSDropdownButton<T>>',
      name: 'items',
      builders: [null, 'singleSelection'],
    ),
    AtributeDto(
      type: 'String?',
      name: 'label',
      builders: [null, 'singleSelection'],
      selectedValue: VariableOption(value: 'Cidades'),
    ),
    AtributeDto(
      type: 'String?',
      name: 'prefixText',
      builders: [null, 'singleSelection'],
      selectedValue: VariableOption(value: null),
    ),
  ];

  @override
  List<AtributeDto> atributs() {
    return listAtributs;
  }

  @override
  Widget buildComponentWidget(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 130.0),
              child: DSDropdownButton<String>.singleSelection(
                onChanged: (item) {
                  setState(() {
                    _value = item;
                  });
                },
                prefixText: getWhereAtribut(atributs(), 'prefixText'),
                search: getWhereAtribut(atributs(), 'search'),
                label: getWhereAtribut(atributs(), 'label'),
                value: _value,
                items: const [
                  DSDropdownMenuItem(label: 'Acre'),
                  DSDropdownMenuItem(label: 'Alagoas'),
                  DSDropdownMenuItem(label: 'Amapá'),
                  DSDropdownMenuItem(label: 'Amazonas'),
                  DSDropdownMenuItem(label: 'Bahia'),
                  DSDropdownMenuItem(label: 'Ceará'),
                  DSDropdownMenuItem(label: 'Distrito Federal'),
                  DSDropdownMenuItem(label: 'Espirito Santo'),
                  DSDropdownMenuItem(label: 'Goiás'),
                  DSDropdownMenuItem(label: 'Maranhão'),
                  DSDropdownMenuItem(label: 'Mato Grosso do Sul'),
                  DSDropdownMenuItem(label: 'Mato Grosso'),
                  DSDropdownMenuItem(label: 'Minas Gerais'),
                  DSDropdownMenuItem(label: 'Pará'),
                  DSDropdownMenuItem(label: 'Paraíba'),
                  DSDropdownMenuItem(label: 'Paraná'),
                  DSDropdownMenuItem(label: 'Pernambuco'),
                  DSDropdownMenuItem(label: 'Piauí'),
                  DSDropdownMenuItem(label: 'Rio de Janeiro'),
                  DSDropdownMenuItem(label: 'Rio Grande do Norte'),
                  DSDropdownMenuItem(label: 'Rio Grande do Sul'),
                  DSDropdownMenuItem(label: 'Rondônia'),
                  DSDropdownMenuItem(label: 'Roraima'),
                  DSDropdownMenuItem(label: 'Santa Catarina'),
                  DSDropdownMenuItem(label: 'São Paulo'),
                  DSDropdownMenuItem(label: 'Sergipe'),
                  DSDropdownMenuItem(label: 'Tocantins'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  String description() {
    return 'Takimata sanctus amet dolores accusam dolores stet nonumy dolore sea, tempor voluptua elitr invidunt duo takimata erat. Consetetur lorem diam et tempor dolores est nonumy dolor. Et dolor ea amet diam, et eirmod et labore sea et rebum elitr. Magna diam no takimata et amet justo eos erat. Dolor erat ipsum diam diam sed duo stet, diam lorem clita lorem ut sanctus sit eos, duo est duo elitr diam et diam magna sit erat. Magna nonumy elitr clita takimata, elitr sit nonumy ipsum et sit vero, lorem est dolor sanctus sed et amet dolor. Et amet amet ea amet erat amet diam ea ut, invidunt ipsum dolor consetetur sit ipsum tempor, no et est sea voluptua tempor et, accusam dolores est accusam ea magna lorem ea gubergren sit. Clita dolores diam nonumy et et sit tempor, amet accusam at stet lorem kasd labore. Erat rebum gubergren clita stet. Stet et diam lorem eos sanctus ipsum, est ipsum et clita dolor dolor, est sea ea et amet lorem est sit. At dolore diam magna at vero dolor magna sit diam. Dolores sit gubergren eos voluptua ea, gubergren voluptua vero sea eos ipsum elitr. Ipsum dolore kasd stet rebum est amet erat.';
  }

  @override
  String nameObjectInDisplay() {
    return 'DSDropdown';
  }

  @override
  String title() {
    return 'DS Dropdown';
  }

  @override
  void onUpdateAtributs(List<AtributeDto> atributs) {
    setState(() {
      listAtributs = atributs;
    });
  }
}
