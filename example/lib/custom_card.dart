import 'package:flutter/material.dart';
import 'package:storybook_ds/storybook_ds.dart';

extension EStyleCustomCard on StyleCustomCard {
  /// Retorna a cor de fundo baseada no tema atual
  Color? color(BuildContext context) {
    if (this == StyleCustomCard.inline) {
      // Para inline, usa a cor de superfície do tema
      return Theme.of(context).colorScheme.surface;
    }
    // Para outline, usa a cor primária com opacidade
    return Theme.of(context).colorScheme.primary.withOpacity(0.1);
  }

  /// Retorna a cor do texto baseada no tema atual
  Color? textColor(BuildContext context) {
    if (this == StyleCustomCard.inline) {
      // Para inline, usa a cor de texto sobre superfície
      return Theme.of(context).colorScheme.onSurface;
    }
    // Para outline, usa a cor de texto sobre superfície
    return Theme.of(context).colorScheme.onSurface;
  }

  /// Retorna a borda baseada no tema atual
  BoxBorder? border(BuildContext context) {
    if (this == StyleCustomCard.inline) {
      final brightness = Theme.of(context).brightness;
      final borderColor = brightness == Brightness.dark
          ? const Color(0xFF4CAF50)
              .withOpacity(0.3) // Verde suave no tema escuro
          : const Color(0xFF2E7D32)
              .withOpacity(0.2); // Verde suave no tema claro
      return Border.all(
        color: borderColor,
        width: 1.5,
      );
    }
    return null;
  }
}

@reflectable
enum StyleCustomCard {
  outline,
  inline,
}

@reflectable
class SettingCustomCard {
  final Color? color;
  final Color? textColor;

  SettingCustomCard({
    this.textColor,
    this.color,
  });
}

@reflectable
class CustomCard extends StatefulWidget {
  final String title;
  final String? description;

  final StyleCustomCard style;
  final SettingCustomCard? settings;

  final Function()? onPositive;
  final Function()? onNegative;
  final String? textPositive;
  final String? textNegative;
  final double? width;
  final double? height;

  const CustomCard({
    required this.title,
    this.description,
    this.style = StyleCustomCard.outline,
    this.onPositive,
    this.onNegative,
    this.textPositive,
    this.textNegative,
    this.width,
    this.height,
    this.settings,
    Key? key,
  }) : super(key: key);

  factory CustomCard.outline({
    required String title,
    final String? description,
    final String? tag,
    final Function()? onPositive,
    final Function()? onNegative,
    final String? textPositive,
    final String? textNegative,
    final double? width,
    final double? height,
  }) {
    return CustomCard(
      title: title,
      style: StyleCustomCard.outline,
      description: description,
      onPositive: onPositive,
      onNegative: onNegative,
      textPositive: textPositive,
      textNegative: textNegative,
      width: width,
      height: height,
    );
  }
  factory CustomCard.inline({
    required String title,
    final String? description,
    final String? tag,
    final Function()? onPositive,
    final Function()? onNegative,
    final String? textPositive,
    final String? textNegative,
    final double? width,
    final double? height,
  }) {
    return CustomCard(
      title: title,
      style: StyleCustomCard.inline,
      description: description,
      onPositive: onPositive,
      onNegative: onNegative,
      textPositive: textPositive,
      textNegative: textNegative,
      width: width,
      height: height,
    );
  }

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    final cardColor = widget.style.color(context);
    final border = widget.style.border(context);

    return Card(
      color: cardColor,
      elevation: 0, // Remove elevação padrão para usar a do tema
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Alinhado com os temas
        side: widget.style == StyleCustomCard.inline && border != null
            ? (border as Border).top
            : BorderSide.none,
      ),
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(20), // Padding maior para mais respiro
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            if (widget.description != null && widget.height != null)
              Expanded(child: _buildDescription()),
            if (widget.description != null && widget.height == null)
              _buildDescription(),
            _buildButtonAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final textColor = widget.style.textColor(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        widget.title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
      ),
    );
  }

  Widget _buildDescription() {
    final textColor = widget.style.textColor(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        widget.description!,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
            ),
      ),
    );
  }

  Widget _buildButtonAction() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          if (widget.onNegative != null)
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onNegative,
                child: Text(widget.textNegative ?? 'Fechar'),
              ),
            ),
          if (widget.onNegative != null && widget.onPositive != null)
            const SizedBox(width: 16),
          if (widget.onPositive != null)
            Expanded(
              child: ElevatedButton(
                onPressed: widget.onPositive,
                child: Text(widget.textPositive ?? 'Continuar'),
              ),
            ),
        ],
      ),
    );
  }
}
