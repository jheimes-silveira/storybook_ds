import 'package:flutter/material.dart';

class CustomChipSelected extends StatelessWidget {
  final String label;
  final bool selected;
  final Function() onTap;
  const CustomChipSelected({
    Key? key,
    required this.label,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        avatar: selected
            ? CircleAvatar(
                backgroundColor: Colors.green[100],
                foregroundColor: Colors.green,
                child: const Icon(
                  Icons.check,
                  size: 13,
                ),
              )
            : null,
      ),
    );
  }
}
