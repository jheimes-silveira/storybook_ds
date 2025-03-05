import 'package:flutter/material.dart';
import 'package:storybook_ds/ds/dropdown/ds_dropdown_container.dart';
import 'package:storybook_ds/ds/dropdown/ds_dropdown_controller.dart';

import 'ds_checkbox_list_tile.dart';

class DSDropdownButton<T> extends StatefulWidget {
  final String hintText;
  final List<DSDropdownMenuItem<T?>> items;
  final List<T?> initSelected;
  final void Function(List<T?>) onChanged;
  final String? prefixText;
  final Widget? prefix;
  final bool isMultiSelection;
  final bool search;
  final double buttonHeight;
  final double dropdownMaxHeight;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? disabledBorder;
  final DSDropdownController? controller;
  final BoxConstraints? constraints;
  final String? error;
  final String? label;

  const DSDropdownButton({
    super.key,
    this.hintText = '',
    this.items = const [],
    this.initSelected = const [],
    required this.onChanged,
    this.prefixText,
    this.prefix,
    this.isMultiSelection = false,
    this.buttonHeight = 40,
    this.dropdownMaxHeight = 400,
    this.enabledBorder,
    this.focusedBorder,
    this.disabledBorder,
    this.controller,
    this.constraints,
    this.search = false,
    this.error,
    this.label,
  });

  factory DSDropdownButton.singleSelection({
    required List<DSDropdownMenuItem<T?>> items,
    required void Function(T?) onChanged,
    String hintText = '',
    T? value,
    String? prefixText,
    Widget? prefix,
    double buttonHeight = 40,
    double dropdownMaxHeight = 400,
    InputBorder? enabledBorder,
    InputBorder? focusedBorder,
    InputBorder? disabledBorder,
    DSDropdownController? controller,
    BoxConstraints? constraints,
    bool search = false,
    String? error,
    String? label,
  }) {
    return DSDropdownButton(
      hintText: hintText,
      items: items,
      initSelected: value == null ? [] : [value],
      onChanged: (value) {
        if (value.isNotEmpty) {
          onChanged(value[0]);
        }
      },
      prefixText: prefixText,
      prefix: prefix,
      buttonHeight: buttonHeight,
      dropdownMaxHeight: dropdownMaxHeight,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      disabledBorder: disabledBorder,
      controller: controller,
      isMultiSelection: false,
      constraints: constraints,
      search: search,
      error: error,
      label: label,
    );
  }

  factory DSDropdownButton.multiSelection({
    String hintText = '',
    required List<DSDropdownMenuItem<T?>> items,
    List<T?> values = const [],
    required void Function(List<T?>) onChanged,
    String? prefixText,
    Widget? prefix,
    double buttonHeight = 40,
    double dropdownMaxHeight = 400,
    InputBorder? enabledBorder,
    InputBorder? focusedBorder,
    InputBorder? disabledBorder,
    DSDropdownController? controller,
    BoxConstraints? constraints,
    String? error,
    String? label,
  }) {
    return DSDropdownButton(
      hintText: hintText,
      items: items,
      initSelected: values,
      onChanged: onChanged,
      prefixText: prefixText,
      prefix: prefix,
      buttonHeight: buttonHeight,
      dropdownMaxHeight: dropdownMaxHeight,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      disabledBorder: disabledBorder,
      controller: controller,
      isMultiSelection: true,
      constraints: constraints,
      error: error,
      label: label,
    );
  }

  @override
  State<DSDropdownButton> createState() => _DSDropdownButtonState<T>();
}

class _DSDropdownButtonState<T> extends State<DSDropdownButton<T>> {
  late DSDropdownController _controller;
  List<DSDropdownMenuItem<T?>> _selected = [];
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? DSDropdownController();
  }

  @override
  Widget build(BuildContext context) {
    final child = _DropdownContent<T>(
      initSelected: _selected,
      isMultiSelection: widget.isMultiSelection,
      onChanged: (value) {
        _selected = value;
        widget.onChanged(_selected.map((e) => e.value).toList());
      },
      items: widget.items,
      prefixText: widget.prefixText,
      prefix: widget.prefix,
      search: widget.search,
      dropdownMaxHeight: widget.dropdownMaxHeight,
      controller: _controller,
    );

    return DSDropdownContainer(
      hintText: widget.hintText,
      text: getText(),
      controller: _controller,
      buttonHeight: widget.buttonHeight,
      label: widget.label,
      enabledBorder: widget.enabledBorder ?? InputBorder.none,
      focusedBorder: widget.focusedBorder ?? InputBorder.none,
      disabledBorder: widget.disabledBorder ?? InputBorder.none,
      constraints: widget.constraints,
      error: widget.error,
      child: child,
    );
  }

  String getText() {
    return _selected.map((e) => e.label).toList().join(', ');
  }
}

class _DropdownContent<T> extends StatefulWidget {
  final List<DSDropdownMenuItem<T?>> items;
  final List<DSDropdownMenuItem<T?>> initSelected;
  final DSDropdownController? controller;
  final bool isMultiSelection;
  final String? prefixText;
  final double dropdownMaxHeight;
  final Widget? prefix;
  final bool search;
  final void Function(List<DSDropdownMenuItem<T?>>) onChanged;

  const _DropdownContent({
    super.key,
    this.items = const [],
    this.initSelected = const [],
    this.isMultiSelection = false,
    this.prefixText,
    this.prefix,
    required this.onChanged,
    required this.search,
    required this.dropdownMaxHeight,
    required this.controller,
  });

  @override
  State<_DropdownContent> createState() => _DropdownContentState<T>();
}

class _DropdownContentState<T> extends State<_DropdownContent<T>> {
  final List<DSDropdownMenuItem<T?>> _selected = [];
  List<DSDropdownMenuItem<T?>> _itemsDisplay = [];

  @override
  void initState() {
    super.initState();

    _selected.addAll(widget.initSelected);

    _itemsDisplay.addAll(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.search) _buildSearch(),
          if (widget.prefixText != null && widget.prefixText!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                widget.prefixText!,
              ),
            ),
          if (widget.prefix != null) widget.prefix!,
          if (_itemsDisplay.isNotEmpty)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: widget.dropdownMaxHeight,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _itemsDisplay.length,
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0,
                ),
                itemBuilder: (context, index) {
                  final e = _itemsDisplay[index];
                  return DSCheckboxListTile(
                    padding: const EdgeInsets.only(
                      right: 12.0,
                      left: 12.0,
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    key: e.key,
                    label: e.label,
                    onChanged: (_) {
                      if (e.onTap != null) {
                        e.onTap!();
                      }
                      setState(() {
                        if (widget.isMultiSelection) {
                          if (_selected.contains(e)) {
                            _selected.remove(e);
                          } else {
                            _selected.add(e);
                          }
                        } else {
                          _selected.clear();
                          _selected.add(e);
                          widget.controller?.isOpened = false;
                        }
                      });

                      widget.onChanged(_selected);
                    },
                    value: _selected.contains(e),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _itemsDisplayWhere(String term) {
    _itemsDisplay = widget.items
        .where((element) =>
            element.label.toUpperCase().contains(term.toUpperCase()))
        .toList();
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: TextField(
        onChanged: (text) {
          setState(() {
            _itemsDisplayWhere(text);
          });
        },
      ),
    );
  }
}

class DSDropdownMenuItem<T> {
  final String label;
  final Key? key;
  final T? value;
  final VoidCallback? onTap;
  final bool enabled;

  const DSDropdownMenuItem({
    required this.label,
    this.value,
    this.key,
    this.onTap,
    this.enabled = true,
  });

  @override
  bool operator ==(covariant DSDropdownMenuItem<T> other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode {
    return value.hashCode;
  }
}
