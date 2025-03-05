import 'package:flutter/material.dart';

class DSCheckboxListTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final EdgeInsets? padding;

  const DSCheckboxListTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Row(
          children: [
            Padding(
              padding: padding ?? const EdgeInsets.only(right: 8.0),
              child: AbsorbPointer(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: Checkbox(
                    value: value,
                    onChanged: (newValue) => onChanged(newValue!),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                label,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
