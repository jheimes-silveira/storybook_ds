import 'package:flutter/material.dart';

class CustomChipSelected extends StatelessWidget {
  final String label;
  final bool selected;
  final Function() onTap;
  const CustomChipSelected({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        avatar: selected
            ? const CircleAvatar(
                child: Icon(
                  Icons.check,
                  size: 13,
                ),
              )
            : null,
      ),
    );
  }
}
