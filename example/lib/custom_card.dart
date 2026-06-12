import 'package:flutter/material.dart';
import 'package:storybook_ds/annotations.dart';

part 'custom_card.storybook.g.dart';

/// Variante visual do card (layout / borda).
enum CustomCardVariant {
  outline,
  inline,
}

/// Como o card exibe a área de imagem no topo.
///
/// - [none] → sem imagem
/// - [image] → renderiza `Image.network(imageUrl)` (ou placeholder se vazio)
/// - [emptyState] → renderiza um placeholder visual (ícone + texto)
enum CardImageDisplay {
  none,
  image,
  emptyState,
}

extension CardImageDisplayX on CardImageDisplay {
  bool get showsImage => this == CardImageDisplay.image;
  bool get showsEmptyState => this == CardImageDisplay.emptyState;
  bool get showsNothing => this == CardImageDisplay.none;
}

extension CustomCardVariantTheming on CustomCardVariant {
  /// Cor de fundo do card conforme variante e tema.
  ///
  /// - `inline` → `colorScheme.surfaceContainerHighest` (alto contraste)
  /// - `outline` → `colorScheme.primary` com 12% alpha (acento suave)
  Color? backgroundFill(BuildContext context) {
    if (this == CustomCardVariant.inline) {
      return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
    return Theme.of(context).colorScheme.primary.withValues(alpha: 0.12);
  }

  /// Cor do texto do conteúdo. Usa `onSurface` do tema, que garante
  /// contraste em ambos os modos (light/dark).
  Color contentTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  /// Borda apenas na variante [inline]. A cor baseia-se no `outline` do tema
  /// para garantir visibilidade em light/dark.
  BoxBorder? borderForInline(BuildContext context) {
    if (this != CustomCardVariant.inline) return null;
    return Border.all(
      color: Theme.of(context).colorScheme.outline,
      width: 1.5,
    );
  }
}

/// Cores opcionais do card (story: objeto aninhado).
///
/// Inclui `borderColor` para que o usuário possa personalizar a borda
/// exibida quando `borderEnabled` é `true` no [CustomCard].
@StorybookModel()
class CustomCardSettings {
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const CustomCardSettings({
    this.textColor,
    this.backgroundColor,
    this.borderColor,
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

  /// Como a área de imagem é renderizada. Veja [CardImageDisplay].
  final CardImageDisplay imageDisplay;

  /// URL da imagem exibida quando [imageDisplay] é
  /// [CardImageDisplay.image].
  final String? imageUrl;

  /// Quando `true`, o card renderiza uma borda (independente da variante).
  final bool borderEnabled;

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
    this.imageDisplay = CardImageDisplay.image,
    this.imageUrl,
    this.borderEnabled = false,
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
    CardImageDisplay imageDisplay = CardImageDisplay.image,
    String? imageUrl,
    bool borderEnabled = false,
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
      imageDisplay: imageDisplay,
      imageUrl: imageUrl,
      borderEnabled: borderEnabled,
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
    CardImageDisplay imageDisplay = CardImageDisplay.image,
    String? imageUrl,
    bool borderEnabled = false,
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
      imageDisplay: imageDisplay,
      imageUrl: imageUrl,
      borderEnabled: borderEnabled,
    );
  }

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final cardColor = widget.settings?.backgroundColor ??
        widget.variant.backgroundFill(context);

    // Borda: prioriza `settings.borderColor` quando o usuário optou por uma
    // borda. Caso contrário, usa a borda padrão da variante `inline` ou
    // uma borda sutíl no `outline` (apenas se `borderEnabled` for true).
    final BorderSide borderSide = widget.borderEnabled
        ? BorderSide(
            color: widget.settings?.borderColor ?? colorScheme.outline,
            width: 1.5,
          )
        : (widget.variant == CustomCardVariant.inline
            ? (widget.variant.borderForInline(context) as Border?)?.top ??
                BorderSide.none
            : BorderSide.none);

    Widget cardContent = Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: borderSide,
      ),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.imageDisplay.showsImage) _buildImage(),
            if (widget.imageDisplay.showsEmptyState) _buildEmptyState(),
            Padding(
              padding: const EdgeInsets.all(20),
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
          ],
        ),
      ),
    );

    if (!widget.enabled) {
      cardContent = Opacity(opacity: 0.5, child: cardContent);
    }

    return cardContent;
  }

  /// Imagem no topo do card, com cantos superiores arredondados para
  /// acompanhar o `clipBehavior: Clip.antiAlias` do `Card`.
  Widget _buildImage() {
    final url = widget.imageUrl;
    if (url == null || url.isEmpty) {
      return _buildEmptyState();
    }
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Image.network(
        url,
        width: double.infinity,
        height: 160,
        fit: BoxFit.cover,
        // Placeholder enquanto a imagem carrega.
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: double.infinity,
            height: 160,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            alignment: Alignment.center,
            child: const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        // Em caso de erro de carregamento, mostra um empty state.
        errorBuilder: (context, error, stackTrace) => _buildEmptyState(),
      ),
    );
  }

  /// Empty state visual para quando `imageDisplay == emptyState` ou a
  /// imagem falha ao carregar.
  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Container(
        width: double.infinity,
        height: 160,
        color: colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'Sem imagem',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final textColor = widget.settings?.textColor ??
        widget.variant.contentTextColor(context);
    return Text(
      widget.title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
    );
  }

  Widget _buildDescription() {
    final textColor = widget.settings?.textColor ??
        widget.variant.contentTextColor(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
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
