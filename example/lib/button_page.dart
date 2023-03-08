import 'package:ds_button/ds_button.dart';
import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

class ButtonPage extends StatefulWidget {
  const ButtonPage({Key? key}) : super(key: key);

  @override
  Storybook<ButtonPage> createState() => _ButtonPageState();
}

class _ButtonPageState extends Storybook<ButtonPage> {
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
      type: 'String?',
      name: 'text4',
      required: true,
      selectedValue: VariableOption(value: 'Custom Buttom'),
      builders: ['elevated', 'outline', 'text'],
    ),
    AtributeDto(
      type: 'bool',
      name: 'loading',
      selectedValue: VariableOption(value: false),
      builders: ['elevated', 'outline', 'text'],
    ),
    AtributeDto(
      type: 'bool?',
      name: 'loading2',
      selectedValue: VariableOption(value: false),
      builders: ['elevated', 'outline', 'text'],
    ),
    AtributeDto.rangeDoubleInterval(
      type: 'double?',
      name: 'valor2',
      selectedValue: 0,
      builders: ['elevated', 'outline', 'text'],
      begin: 0,
      end: 30,
    ),
    AtributeDto.wrap(
      type: 'CrossAxisAlignment?',
      name: 'spacer',
      selectedValue: VariableOption(value: CrossAxisAlignment.center),
      builders: ['elevated', 'outline', 'text'],
      variableOptions: CrossAxisAlignment.values
          .map((e) => VariableOption(
                value: e,
                textInSelectedOptions: e.name,
              ))
          .toList(),
    ),
  ];

  @override
  Widget buildComponentWidget(BuildContext context) {
    Widget child;
    if (selectedConstructor == 'elevated') {
      child = _buildElevated();
    } else if (selectedConstructor == 'outline') {
      child = _buildOutline();
    } else {
      child = _buildText();
    }
    return Scaffold(
      body: Center(
        child: child,
      ),
    );
  }

  Widget _buildElevated() {
    return DSButton.elevated(
      text: getWhereAtribut('text'),
      loading: getWhereAtribut('loading'),
      onPressed: () {},
    );
  }

  Widget _buildOutline() {
    return DSButton.outline(
      text: getWhereAtribut('text'),
      loading: getWhereAtribut('loading'),
      onPressed: () {},
    );
  }

  Widget _buildText() {
    return DSButton.text(
      text: getWhereAtribut('text'),
      loading: getWhereAtribut('loading'),
      onPressed: () {},
    );
  }

  @override
  String description =
      'Takimata sanctus amet dolores accusam dolores stet nonumy dolore sea, tempor voluptua elitr invidunt duo takimata erat. Consetetur lorem diam et tempor dolores est nonumy dolor. Et dolor ea amet diam, et eirmod et labore sea et rebum elitr. Magna diam no takimata et amet justo eos erat. Dolor erat ipsum diam diam sed duo stet, diam lorem clita lorem ut sanctus sit eos, duo est duo elitr diam et diam magna sit erat. Magna nonumy elitr clita takimata, elitr sit nonumy ipsum et sit vero, lorem est dolor sanctus sed et amet dolor. Et amet amet ea amet erat amet diam ea ut, invidunt ipsum dolor consetetur sit ipsum tempor, no et est sea voluptua tempor et, accusam dolores est accusam ea magna lorem ea gubergren sit. Clita dolores diam nonumy et et sit tempor, amet accusam at stet lorem kasd labore. Erat rebum gubergren clita stet. Stet et diam lorem eos sanctus ipsum, est ipsum et clita dolor dolor, est sea ea et amet lorem est sit. At dolore diam magna at vero dolor magna sit diam. Dolores sit gubergren eos voluptua ea, gubergren voluptua vero sea eos ipsum elitr. Ipsum dolore kasd stet rebum est amet erat.';

  @override
  String nameObjectInDisplay = 'DSButton';

  @override
  String title = 'DS Button';
}
