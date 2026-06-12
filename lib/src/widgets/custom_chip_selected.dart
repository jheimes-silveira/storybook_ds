import 'package:flutter/material.dart';
import 'package:storybook_ds/src/theme/storybook_theme.dart';
import 'package:storybook_ds/src/theme/storybook_theme_scope.dart';

/// A customizable chip widget with selection state.
///
/// Uses [StorybookTheme] for styling when no explicit values are provided.
class CustomChipSelected extends StatelessWidget {
  const CustomChipSelected({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.checkColor,
    this.checkBackgroundColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.leadingIcon,
  });

  final String label;
  final bool selected;
  final Function() onTap;

  /// Optional border radius override.
  final BorderRadius? borderRadius;

  /// Optional border color override.
  final Color? borderColor;

  /// Optional border width override.
  final double? borderWidth;

  /// Optional selected background color override.
  final Color? selectedBackgroundColor;

  /// Optional unselected background color override.
  final Color? unselectedBackgroundColor;

  /// Optional check icon color override.
  final Color? checkColor;

  /// Optional check background color override.
  final Color? checkBackgroundColor;

  /// Optional selected text color override.
  final Color? selectedTextColor;

  /// Optional unselected text color override.
  final Color? unselectedTextColor;

  /// Ícone exibido à esquerda do label em **todos** os estados
  /// (selecionado ou não). Quando fornecido, sobrescreve o
  /// [Icons.check] padrão de "selecionado".
  ///
  /// Útil para o editor de callback (`ItemAttributeFunction`), onde
  /// cada chip de cenário precisa mostrar o ícone do cenário
  /// (ex.: `Icons.send` para "Submit") mesmo antes de ser escolhido.
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final theme = StorybookThemeScope.of(context);

    final resolvedBorderRadius = borderRadius ?? theme.chipBorderRadius;
    final resolvedBorderColor = borderColor ?? theme.chipBorderColor;
    final resolvedBorderWidth = borderWidth ?? theme.chipBorderWidth;
    final resolvedSelectedBg = selectedBackgroundColor ?? theme.chipSelectedBackgroundColor;
    final resolvedUnselectedBg = unselectedBackgroundColor ?? theme.chipUnselectedBackgroundColor;
    final resolvedCheckColor = checkColor ?? theme.checkColor;
    final resolvedCheckBg = checkBackgroundColor ?? theme.checkBackgroundColor;
    final resolvedSelectedTextColor = selectedTextColor ?? theme.chipSelectedTextColor;
    final resolvedUnselectedTextColor = unselectedTextColor ?? theme.chipUnselectedTextColor;

    final Widget? avatar;
    if (leadingIcon != null) {
      avatar = Icon(
        leadingIcon,
        size: 14,
        color: selected ? resolvedCheckColor : resolvedUnselectedTextColor,
      );
    } else if (selected) {
      avatar = CircleAvatar(
        backgroundColor: resolvedCheckBg,
        child: Icon(
          Icons.check,
          size: 13,
          color: resolvedCheckColor,
        ),
      );
    } else {
      avatar = null;
    }

    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: selected ? resolvedSelectedTextColor : resolvedUnselectedTextColor,
          ),
        ),
        backgroundColor: selected ? resolvedSelectedBg : resolvedUnselectedBg,
        shape: RoundedRectangleBorder(
          borderRadius: resolvedBorderRadius,
          side: BorderSide(
            color: resolvedBorderColor,
            width: resolvedBorderWidth,
          ),
        ),
        avatar: avatar,
      ),
    );
  }
}
