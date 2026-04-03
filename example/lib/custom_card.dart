import 'package:flutter/material.dart';
import 'package:storybook_ds/annotations.dart';

part 'custom_card.storybook.g.dart';

/// Variante visual do card (layout / borda).
enum CustomCardVariant {
  outline,
  inline,
}

extension CustomCardVariantTheming on CustomCardVariant {
  /// Cor de fundo do card conforme variante e tema.
  Color? backgroundFill(BuildContext context) {
    if (this == CustomCardVariant.inline) {
      return Theme.of(context).colorScheme.surface;
    }
    return Theme.of(context).colorScheme.primary.withValues(alpha: 0.1);
  }

  /// Cor do texto do conteúdo.
  Color contentTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  /// Borda apenas na variante [inline].
  BoxBorder? borderForInline(BuildContext context) {
    if (this != CustomCardVariant.inline) return null;
    final brightness = Theme.of(context).brightness;
    final borderColor = brightness == Brightness.dark
        ? const Color(0xFF4CAF50).withValues(alpha: 0.3)
        : const Color(0xFF2E7D32).withValues(alpha: 0.2);
    return Border.all(color: borderColor, width: 1.5);
  }
}

/// Cores opcionais do card (story: objeto aninhado).
@StorybookModel()
class CustomCardSettings {
  final Color? backgroundColor;
  final Color? textColor;

  const CustomCardSettings({
    this.textColor,
    this.backgroundColor,
  });
}

class CustomCard extends StatefulWidget {
  final String title;
  final String? description;
  final CustomCardVariant variant;
  final CustomCardSettings? settings;
  final VoidCallback? onPositive;
  final VoidCallback? onNegative;
  final String? textPositive;
  final String? textNegative;
  final double? width;
  final double? height;
  final bool hidden;
  final bool enabled;

  const CustomCard({
    super.key,
    required this.title,
    this.description,
    this.variant = CustomCardVariant.outline,
    this.onPositive,
    this.onNegative,
    this.textPositive,
    this.textNegative,
    this.width,
    this.height,
    this.settings,
    this.hidden = false,
    this.enabled = true,
  });

  factory CustomCard.outline({
    required String title,
    String? description,
    CustomCardSettings? settings,
    VoidCallback? onPositive,
    VoidCallback? onNegative,
    String? textPositive,
    String? textNegative,
    double? width,
    double? height,
    bool hidden = false,
    bool enabled = true,
  }) {
    return CustomCard(
      title: title,
      variant: CustomCardVariant.outline,
      description: description,
      settings: settings,
      onPositive: onPositive,
      onNegative: onNegative,
      textPositive: textPositive,
      textNegative: textNegative,
      width: width,
      height: height,
      hidden: hidden,
      enabled: enabled,
    );
  }

  factory CustomCard.inline({
    required String title,
    String? description,
    CustomCardSettings? settings,
    VoidCallback? onPositive,
    VoidCallback? onNegative,
    String? textPositive,
    String? textNegative,
    double? width,
    double? height,
    bool hidden = false,
    bool enabled = true,
  }) {
    return CustomCard(
      title: title,
      variant: CustomCardVariant.inline,
      description: description,
      settings: settings,
      onPositive: onPositive,
      onNegative: onNegative,
      textPositive: textPositive,
      textNegative: textNegative,
      width: width,
      height: height,
      hidden: hidden,
      enabled: enabled,
    );
  }

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    final cardColor = widget.settings?.backgroundColor ??
        widget.variant.backgroundFill(context);
    final border = widget.variant.borderForInline(context);

    Widget cardContent = Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: widget.variant == CustomCardVariant.inline && border != null
            ? (border as Border).top
            : BorderSide.none,
      ),
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(20),
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
            if (!widget.hidden) _buildActionsRow(),
          ],
        ),
      ),
    );

    if (!widget.enabled) {
      cardContent = Opacity(opacity: 0.5, child: cardContent);
    }

    return cardContent;
  }

  Widget _buildTitle() {
    final textColor = widget.settings?.textColor ??
        widget.variant.contentTextColor(context);
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
    final textColor = widget.settings?.textColor ??
        widget.variant.contentTextColor(context);
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

  Widget _buildActionsRow() {
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
