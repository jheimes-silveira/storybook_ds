import 'package:flutter/material.dart';

/// Temas de exemplo seguindo a personalização do **Material Design 3**:
/// partida de uma cor-semente e paleta tonal derivada (`ColorScheme.fromSeed`).
///
/// Referência: [Customizing Material – M3](https://m3.material.io/foundations/customization)

// --- Cores-semente (harmonia visual, bom contraste em claro/escuro) ---

/// Verde-sálvia: neutro, natural, agradável para leitura prolongada.
const Color sampleSeedSage = Color(0xFF3D5A4A);

/// Azul oceano: claro, confiável, bom para dashboards e DS.
const Color sampleSeedOcean = Color(0xFF1565C0);

/// Uva suave: acento sofisticado sem saturar (bom para tema só claro).
const Color sampleSeedPlum = Color(0xFF6B4C6F);

// --- Forma e espaçamento compartilhados (M3: cantos generosos) ---

const double _kStoryCornerRadius = 16;
const double _kStoryButtonCornerRadius = 12;
const EdgeInsets _kStoryButtonPadding =
    EdgeInsets.symmetric(horizontal: 24, vertical: 14);

RoundedRectangleBorder get _storyCardShape => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_kStoryCornerRadius),
    );

/// [ThemeData] Material 3 a partir de [seedColor], com cartões e botões alinhados ao exemplo.
ThemeData buildSampleM3Theme({
  required Color seedColor,
  required Brightness brightness,
}) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surfaceContainerLowest,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: colorScheme.surfaceContainerLow,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
    ),
    cardTheme: CardThemeData(
      color: colorScheme.surfaceContainerLow,
      elevation: brightness == Brightness.light ? 0.5 : 1.5,
      surfaceTintColor: colorScheme.surfaceTint.withValues(alpha: 0.35),
      shadowColor: Colors.black.withValues(alpha: 0.12),
      shape: _storyCardShape,
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: brightness == Brightness.light ? 0 : 1,
        padding: _kStoryButtonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_kStoryButtonCornerRadius),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: _kStoryButtonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_kStoryButtonCornerRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: _kStoryButtonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_kStoryButtonCornerRadius),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: _kStoryButtonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_kStoryButtonCornerRadius),
        ),
      ),
    ),
  );
}
