import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

import 'package:storybook_ds/src/widgets/attributes_variant/attribute_variant.dart';

/// `Storybook` simplificado usado pelos testes de reatividade.
///
/// Renderiza dois painéis lado a lado:
/// * **Esquerda**: o "device preview" — uma lista de `Text(name=value)`
///   para cada atributo, com o valor atual.
/// * **Direita**: o painel de atributos, com [AttributeVariant]s
///   diretamente (sem `ContentWidget`) para permitir controle total
///   sobre o estado de expansão nos testes.
class TestStorybook extends StatefulWidget {
  const TestStorybook({
    super.key,
    required this.attributes,
    this.onStateReady,
  });

  final List<AttributeModel> attributes;
  final void Function(TestStorybookState state)? onStateReady;

  @override
  TestStorybookState createState() => TestStorybookState();
}

class TestStorybookState extends State<TestStorybook> {
  late List<AttributeModel> _attributes;
  final AttributeChangeBus _bus = AttributeChangeBus();

  @override
  void initState() {
    super.initState();
    _attributes = List<AttributeModel>.from(widget.attributes);
    widget.onStateReady?.call(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Device preview: lê os valores atuais e renderiza como texto.
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              child: ListView(
                key: const ValueKey('device-preview'),
                children: _attributes.map((attr) {
                  final value = attr.selectedValue?.value;
                  final valueStr = value == null ? 'null' : '$value';
                  return ListTile(
                    key: ValueKey('device-${attr.name}'),
                    title: Text('${attr.name}=$valueStr'),
                  );
                }).toList(),
              ),
            ),
          ),
          // Painel lateral de atributos.
          SizedBox(
            width: 400,
            child: Material(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildAttributePanel(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributePanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _attributes.map((attr) {
        // Usa um ExpansionTile com initiallyExpanded=true para que
        // os testes não precisem simular o tap de expansão.
        // O AttributeVariant já é um ExpansionTile internamente,
        // então envolvendo-o em Theme/Provider.
        return AttributeVariant(
          key: ValueKey('test-attr-${attr.name}'),
          attribute: attr,
          attributes: _attributes,
          onAttributes: (attrs, changed) {
            _bus.notifyChanged(attrs, changed);
            setState(() {});
          },
          changeBus: _bus,
          initiallyExpanded: true,
        );
      }).toList(),
    );
  }
}


