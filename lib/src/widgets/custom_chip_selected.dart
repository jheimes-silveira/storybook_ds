import 'package:flutter/material.dart';

/// Constants for chip styling
class _CustomChipSelectedConstants {
  static const double borderRadius = 24.0;
  static const double borderWidth = 1.0;
  static const double iconSize = 13.0;
  static const String defaultLabel = 'default';
}

/// A customizable chip widget with selection state.
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
          borderRadius: BorderRadius.circular(
            _CustomChipSelectedConstants.borderRadius,
          ),
          side: const BorderSide(
            color: Colors.grey,
            width: _CustomChipSelectedConstants.borderWidth,
          ),
        ),
        avatar: selected
            ? const CircleAvatar(
                child: Icon(
                  Icons.check,
                  size: _CustomChipSelectedConstants.iconSize,
                ),
              )
            : null,
      ),
    );
  }
}
