import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_ds/src/device_preview/state/store.dart';
import 'package:storybook_ds/src/device_preview/views/theme.dart';
import 'package:storybook_ds/src/theme/storybook_theme_scope.dart';

/// The panel which contains all the tools.
class ToolPanel extends StatelessWidget {
  /// Create a new panel from the given tools grouped as [slivers].
  ///
  /// The [isModal] indicates whether the panel is shown modally as a new page, or if it
  /// stays visible on one side of the parent layout.
  const ToolPanel({
    super.key,
    required this.slivers,
    this.isModal = false,
    required this.isRight,
  });

  /// Indicates whether the panel is shown modally as a new page, or if it
  /// stays visible on one side of the parent layout.
  final bool isModal;

  final bool isRight;

  /// The sections containing the tools.
  ///
  /// They must be [Sliver]s.
  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    final rootContext = context;
    return Navigator(
      onGenerateInitialRoutes: (nav, name) {
        return [
          MaterialPageRoute(
            builder: (context) {
              final toolbarTheme = context.select(
                (DevicePreviewStore store) => store.settings.toolbarTheme,
              );
              return Theme(
                data: toolbarTheme.asThemeData(),
                child: _ToolPanel(
                  sections: slivers,
                  isModal: isModal,
                  isRight: isRight,
                  onClose: () {
                    Navigator.maybePop(rootContext);
                  },
                ),
              );
            },
          ),
        ];
      },
    );
  }
}

class _ToolPanel extends StatelessWidget {
  const _ToolPanel({
    required this.isModal,
    required this.isRight,
    required this.onClose,
    required this.sections,
  });

  final bool isModal;
  final bool isRight;
  final VoidCallback onClose;
  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final storybookTheme = StorybookThemeScope.of(context);
    late bool isEnabled;
    if (isRight) {
      isEnabled = context.select(
        (DevicePreviewStore store) => store.data.isToolbarVisibleRight,
      );
    } else {
      isEnabled = context.select(
        (DevicePreviewStore store) => store.data.isToolbarVisibleLeft,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          storybookTheme.appBarTitle,
          style: storybookTheme.appBarTitleStyle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: (theme.colorScheme.brightness == Brightness.dark
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onPrimary),
          ),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          maxLines: 1,
        ),
        leading: _getLeading(
          context: context,
          isModal: isModal,
          isRight: isRight,
          onClose: onClose,
        ),
        actions: [
          if (!isModal && isRight)
            // Espaçamento simétrico ao do `leading` (mesma `expansionTilePadding`
            // usada no `AttributesThemeWidget`) para que o switch fique à
            // mesma distância visual dos demais itens do AppBar.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Switch(
                  value: isEnabled,
                  onChanged: (v) {
                    final state = context.read<DevicePreviewStore>();
                    if (isRight) {
                      state.data = state.data.copyWith(
                        isToolbarVisibleRight: v,
                      );
                    } else {
                      state.data = state.data.copyWith(
                        isToolbarVisibleLeft: v,
                      );
                    }
                  },
                ),
              ),
            ),
        ],
      ),
      body: RepaintBoundary(
        child: CustomScrollView(
          slivers: sections,
        ),
      ),
    );
  }

  Widget _getLeading({
    required BuildContext context,
    required bool isModal,
    required bool isRight,
    required VoidCallback onClose,
  }) {
    late bool isEnabled;
    if (isRight) {
      isEnabled = context.select(
        (DevicePreviewStore store) => store.data.isToolbarVisibleRight,
      );
    } else {
      isEnabled = context.select(
        (DevicePreviewStore store) => store.data.isToolbarVisibleLeft,
      );
    }

    if (!isRight) {
      // Mesmo `padding` horizontal do switch à direita (vide `actions`
      // acima) para distribuição simétrica dos itens do AppBar.
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Switch(
            value: isEnabled,
            onChanged: (v) {
              final state = context.read<DevicePreviewStore>();
              if (isRight) {
                state.data = state.data.copyWith(
                  isToolbarVisibleRight: v,
                );
              } else {
                state.data = state.data.copyWith(
                  isToolbarVisibleLeft: v,
                );
              }
            },
          ),
        ),
      );
    }
    if (isModal) {
      return IconButton(
        icon: const Icon(Icons.close),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: onClose,
      );
    }
    return const SizedBox.shrink();
  }
}
