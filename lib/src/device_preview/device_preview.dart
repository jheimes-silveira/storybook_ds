// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:ui' as ui;

import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:storybook_ds/src/device_preview/model/tools_panel_model.dart';
import 'package:storybook_ds/src/device_preview/state/store.dart';
import 'package:storybook_ds/src/device_preview/storage/storage.dart';
import 'package:storybook_ds/src/device_preview/utilities/assert_inherited_media_query.dart';
import 'package:storybook_ds/src/device_preview/utilities/media_query_observer.dart';
import 'package:storybook_ds/src/device_preview/views/theme.dart';

import 'locales/default_locales.dart';
import 'state/state.dart';
import 'utilities/screenshot.dart';
import 'views/large.dart';
import 'views/small.dart';
import 'views/tool_panel/sections/accessibility.dart';
import 'views/tool_panel/sections/device.dart';
import 'views/tool_panel/sections/settings.dart';
import 'views/tool_panel/sections/system.dart';

/// Simulates how the result of [builder] would render on different
/// devices.
///
/// {@tool snippet}
///
/// This sample shows how to define an app with a plugin.
///
/// ```dart
/// DevicePreview(
///   builder: (context) => MaterialApp(
///      useInheritedMediaQuery: true,
///      locale: DevicePreview.locale(context),
///      builder: DevicePreview.appBuilder,
///      theme: ThemeData.light(),
///      darkTheme: ThemeData.dark(),
///      home: const Home(),
///    ),
/// )
/// ```
/// {@end-tool}
///
/// See also :
/// * [Devices] has a set of predefined common devices.
class DevicePreview extends StatefulWidget {
  /// Create a new [DevicePreview].
  const DevicePreview({
    super.key,
    required this.builder,
    this.devices,
    this.data,
    this.isToolbarVisible = true,
    this.availableLocales,
    this.defaultDevice,
    @Deprecated(
      'Use toolsLeft and toolsRight instead. '
      'This variable will be removed in a future release. ',
    )
    this.tools = defaultTools,
    this.toolsPanelLeft,
    this.toolsPanelRight,
    this.storage,
    this.enabled = true,
    this.backgroundColor,
  });

  /// If not [enabled], the [child] is used directly.
  final bool enabled;

  /// Indicates whether the tool bar should be visible or not.
  final bool isToolbarVisible;

  /// The configuration. If not precised, it is loaded from preferences.
  final DevicePreviewData? data;

  /// The previewed widget.
  ///
  /// It is common to give the root application widget.
  final WidgetBuilder builder;

  /// The background color of the canvas
  ///
  /// Overrides `theme.canvasColor`
  final Color? backgroundColor;

  /// The default selected device when opening device preview for the first time.
  final DeviceInfo? defaultDevice;

  /// The available devices used for previewing.
  final List<DeviceInfo>? devices;

  @Deprecated(
    'Use toolsPanelLeft and toolsPanelRight instead. '
    'This variable will be removed in a future release.',
  )
  final List<Widget> tools;

  /// List of tools on the left side.
  ///
  /// All tools must be [Sliver]s and will be added to the left menu.
  final ToolsPanelModel? toolsPanelLeft;

  /// List of tools on the right side.
  ///
  /// All tools must be [Sliver]s and will be added to the right menu.
  final ToolsPanelModel? toolsPanelRight;

  /// The available locales.
  final List<Locale>? availableLocales;

  /// The storage used to persist preferences.
  ///
  /// By default, it saves preferences to the local device preferences.
  ///
  /// To disable settings persistence use `DevicePreviewStorage.none()`.
  final DevicePreviewStorage? storage;

  /// All the default available devices.
  static final List<DeviceInfo> defaultDevices = Devices.all;

  /// All the default tools included in the menu : [DeviceSection], [SystemSection],
  /// [AccessibilitySection] and [SettingsSection].
  static const List<Widget> defaultTools = <Widget>[
    DeviceSection(),
    SystemSection(),
    AccessibilitySection(),
    SettingsSection(),
  ];

  @override
  // ignore: library_private_types_in_public_api
  _DevicePreviewState createState() => _DevicePreviewState();

  /// The currently selected device.
  static DeviceInfo selectedDevice(BuildContext context) {
    return context.select(
      (DevicePreviewStore store) => store.deviceInfo,
    );
  }

  /// The simulated target platform for the currently selected device.
  static TargetPlatform platform(BuildContext context) {
    final platform = context.select(
      (DevicePreviewStore store) => store.deviceInfo.identifier.platform,
    );
    return platform;
  }

  /// The simulated visual density for the currently selected device.
  static VisualDensity visualDensity(BuildContext context) {
    final deviceType = context.select(
      (DevicePreviewStore store) => store.deviceInfo.identifier.type,
    );
    if (deviceType == DeviceType.desktop || deviceType == DeviceType.laptop) {
      return VisualDensity.compact;
    }
    return VisualDensity.standard;
  }

  /// Create a new [ThemeData] from the given [data], but with updated properties from
  /// the currently simulated device.
  static Widget appBuilder(BuildContext context, Widget? child) {
    if (!_isEnabled(context)) {
      return child!;
    }

    final theme = Theme.of(context);
    final isInitializedAndEnabled = context.select(
      (DevicePreviewStore store) => store.state.maybeMap(
        initialized: (initialized) => initialized.data.isEnabled,
        orElse: () => false,
      ),
    );

    if (!isInitializedAndEnabled) {
      return child!;
    }

    return Theme(
      data: theme.copyWith(
        platform: platform(context),
        visualDensity: visualDensity(context),
      ),
      child: child!,
    );
  }

  /// Indicates whether the device preview is currently enabled.
  static bool isEnabled(BuildContext context) {
    if (_isEnabled(context)) {
      return context.select(
        (DevicePreviewStore store) => store.state.maybeMap(
          initialized: (initialized) => initialized.data.isEnabled,
          orElse: () => false,
        ),
      );
    }
    return false;
  }

  static bool _isEnabled(BuildContext context) {
    final state = context.findAncestorStateOfType<_DevicePreviewState>();
    return state != null && state.widget.enabled;
  }

  /// Currently defined locale.
  static Locale? locale(BuildContext context) {
    if (!_isEnabled(context)) {
      return null;
    }

    final store = Provider.of<DevicePreviewStore>(context);
    return store.state.maybeMap(
      initialized: (state) {
        final splits = state.data.locale.split('_');
        final languageCode = splits[0];
        String? scriptCode, countryCode;
        if (splits.length > 2) {
          scriptCode = splits[1];
          countryCode = splits[2];
        } else if (splits.length > 1) {
          countryCode = splits[1];
        }
        return Locale.fromSubtags(
          languageCode: languageCode,
          scriptCode: scriptCode,
          countryCode: countryCode,
        );
      },
      orElse: () => WidgetsBinding.instance.platformDispatcher.locale,
    );
  }

  /// Make the toolbar visible to the user.
  ///
  /// If [enablePreview] is set to `true`, then the device preview is also enabled
  /// when appearing.
  static void showToolbar(
    BuildContext context, {
    bool enablePreview = true,
  }) {
    final store = Provider.of<DevicePreviewStore>(context);
    store.data = store.data.copyWith(
      isToolbarVisibleRight: true,
      isEnabled: enablePreview,
    );
  }

  /// Hide the toolbar.
  ///
  /// If [disablePreview] is set to `false`, then the device preview stays active even
  /// if the toolbar is not visible anymore.
  static void hideToolbar(
    BuildContext context, {
    bool disablePreview = true,
  }) {
    final store = Provider.of<DevicePreviewStore>(context);
    store.data = store.data.copyWith(
      isToolbarVisibleRight: false,
      isEnabled: !disablePreview,
    );
  }

  /// Select a device from its unique [deviceIdentifier].
  ///
  /// All the identifiers are available from [Devices].
  static void selectDevice(
    BuildContext context,
    DeviceIdentifier deviceIdentifier,
  ) {
    final store = Provider.of<DevicePreviewStore>(context, listen: false);
    store.selectDevice(deviceIdentifier);
  }

  /// The list of all available device identifiers.
  static List<DeviceIdentifier> availableDeviceIdentifiers(
    BuildContext context,
  ) {
    final store = Provider.of<DevicePreviewStore>(context, listen: false);
    return store.devices.map((info) => info.identifier).toList();
  }

  /// All available locales in the tool.
  static List<Locale> allLocales(BuildContext context) {
    if (!_isEnabled(context)) {
      return defaultAvailableLocales.map((e) => Locale(e.code)).toList();
    }
    final store = Provider.of<DevicePreviewStore>(context);
    return store.state
        .maybeMap(
          initialized: (state) => state.locales,
          orElse: () => defaultAvailableLocales,
        )
        .map((e) => Locale(e.code))
        .toList();
  }

  /// Take a screenshot.
  static Future<DeviceScreenshot> screenshot(BuildContext context) {
    final state = context.findAncestorStateOfType<_DevicePreviewState>();
    final store = context.read<DevicePreviewStore>();
    return state!.screenshot(store);
  }

  static MediaQueryData _mediaQuery(BuildContext context) {
    final device = context.select(
      (DevicePreviewStore store) => store.deviceInfo,
    );

    final orientation = context.select(
      (DevicePreviewStore store) => store.data.orientation,
    );

    final isVirtualKeyboardVisible = context.select(
      (DevicePreviewStore store) => store.data.isVirtualKeyboardVisible,
    );

    final isDarkMode = context.select(
      (DevicePreviewStore store) => store.data.isDarkMode,
    );

    final textScaleFactor = context.select(
      (DevicePreviewStore store) => store.data.textScaleFactor,
    );

    final boldText = context.select(
      (DevicePreviewStore store) => store.data.boldText,
    );

    final disableAnimations = context.select(
      (DevicePreviewStore store) => store.data.disableAnimations,
    );

    final accessibleNavigation = context.select(
      (DevicePreviewStore store) => store.data.accessibleNavigation,
    );

    final invertColors = context.select(
      (DevicePreviewStore store) => store.data.invertColors,
    );

    var mediaQuery = DeviceFrame.mediaQuery(
      context: context,
      info: device,
      orientation: orientation,
    );

    if (isVirtualKeyboardVisible) {
      mediaQuery = VirtualKeyboard.mediaQuery(mediaQuery);
    }

    return mediaQuery.copyWith(
      platformBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      textScaleFactor: textScaleFactor,
      boldText: boldText,
      disableAnimations: disableAnimations,
      accessibleNavigation: accessibleNavigation,
      invertColors: invertColors,
    );
  }
}

/// Model class to hold preview state for Selector
class _PreviewModel {
  final DeviceInfo deviceInfo;
  final bool isFrameVisible;
  final Orientation orientation;
  final bool isVirtualKeyboardVisible;
  final bool isDarkMode;

  const _PreviewModel({
    required this.deviceInfo,
    required this.isFrameVisible,
    required this.orientation,
    required this.isVirtualKeyboardVisible,
    required this.isDarkMode,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _PreviewModel &&
        other.deviceInfo == deviceInfo &&
        other.isFrameVisible == isFrameVisible &&
        other.orientation == orientation &&
        other.isVirtualKeyboardVisible == isVirtualKeyboardVisible &&
        other.isDarkMode == isDarkMode;
  }

  @override
  int get hashCode => Object.hash(
        deviceInfo,
        isFrameVisible,
        orientation,
        isVirtualKeyboardVisible,
        isDarkMode,
      );
}

/// Model class to hold layout state for Selector
class _LayoutModel {
  final bool isInitialized;
  final bool isEnabled;
  final DevicePreviewToolBarThemeData toolbarTheme;
  final DevicePreviewBackgroundThemeData backgroundTheme;
  final bool isToolbarVisibleRight;
  final bool isToolbarVisibleLeft;

  const _LayoutModel({
    required this.isInitialized,
    required this.isEnabled,
    required this.toolbarTheme,
    required this.backgroundTheme,
    required this.isToolbarVisibleRight,
    required this.isToolbarVisibleLeft,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _LayoutModel &&
        other.isInitialized == isInitialized &&
        other.isEnabled == isEnabled &&
        other.toolbarTheme == toolbarTheme &&
        other.backgroundTheme == backgroundTheme &&
        other.isToolbarVisibleRight == isToolbarVisibleRight &&
        other.isToolbarVisibleLeft == isToolbarVisibleLeft;
  }

  @override
  int get hashCode => Object.hash(
        isInitialized,
        isEnabled,
        toolbarTheme,
        backgroundTheme,
        isToolbarVisibleRight,
        isToolbarVisibleLeft,
      );
}

class _DevicePreviewState extends State<DevicePreview> {
  bool _isToolPanelPopOverOpen = false;

  late ToolsPanelModel _toolsPanelLeft;
  late ToolsPanelModel _toolsPanelRight;

  late DevicePreviewStorage storage =
      widget.storage ?? DevicePreviewStorage.preferences();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// Whenever the [screenshot] is called, a new value is pushed to
  /// this stream.
  Stream<DeviceScreenshot> get onScreenshot => _onScreenshot!.stream;

  /// Takes a screenshot with the current configuration.
  Future<DeviceScreenshot> screenshot(DevicePreviewStore store) async {
    final boundary =
        _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    const format = ui.ImageByteFormat.png;

    final image = await boundary.toImage(
      pixelRatio: store.deviceInfo.pixelRatio,
    );
    final byteData = await image.toByteData(
      format: format,
    );
    final bytes = byteData!.buffer.asUint8List();
    final screenshot = DeviceScreenshot(
      device: store.deviceInfo,
      bytes: bytes,
      format: format,
    );
    _onScreenshot?.add(screenshot);
    return screenshot;
  }

  @override
  void initState() {
    _onScreenshot = StreamController<DeviceScreenshot>.broadcast();
    // `widget.tools` está deprecado mas ainda é mantido para
    // compatibilidade com consumidores que só passam `tools`.
    _toolsPanelRight = widget.toolsPanelRight ??
        // ignore: deprecated_member_use_from_same_package
        ToolsPanelModel(tools: widget.tools);
    _toolsPanelLeft = widget.toolsPanelLeft ?? ToolsPanelModel(tools: []);

    super.initState();
  }

  @override
  void dispose() {
    _onScreenshot?.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DevicePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.storage != widget.storage && widget.storage != null) {
      storage = widget.storage!;
    }
  }

  /// Builds the preview using a single Selector for efficiency.
  /// RN-02.2: Agrupa 8 context.select em 1 Selector
  Widget _buildPreview(BuildContext context) {
    return Selector<DevicePreviewStore, _PreviewModel>(
      selector: (_, store) {
        final isInitialized = store.state.maybeMap(
          initialized: (_) => true,
          orElse: () => false,
        );
        if (!isInitialized) {
          return _PreviewModel(
            deviceInfo: store.defaultDevice,
            isFrameVisible: false,
            orientation: Orientation.portrait,
            isVirtualKeyboardVisible: false,
            isDarkMode: false,
          );
        }
        return _PreviewModel(
          deviceInfo: store.deviceInfo,
          isFrameVisible: store.data.isFrameVisible,
          orientation: store.data.orientation,
          isVirtualKeyboardVisible: store.data.isVirtualKeyboardVisible,
          isDarkMode: store.data.isDarkMode,
        );
      },
      shouldRebuild: (prev, next) => prev != next,
      builder: (context, model, _) {
        final theme = Theme.of(context);
        final isEnabled = context.select(
          (DevicePreviewStore store) => store.state.maybeMap(
            initialized: (state) => state.data.isEnabled,
            orElse: () => false,
          ),
        );

        if (!isEnabled) return widget.builder(context);

        final mediaQuery = MediaQuery.of(context);

        return Container(
          color: widget.backgroundColor ?? theme.canvasColor,
          padding: EdgeInsets.only(
            top: 20 + mediaQuery.viewPadding.top,
            right: 20 + mediaQuery.viewPadding.right,
            left: 20 + mediaQuery.viewPadding.left,
            bottom: 20,
          ),
          child: FittedBox(
            fit: BoxFit.contain,
            child: RepaintBoundary(
              key: _repaintKey,
              child: DeviceFrame(
                device: model.deviceInfo,
                isFrameVisible: model.isFrameVisible,
                orientation: model.orientation,
                screen: VirtualKeyboard(
                  isEnabled: model.isVirtualKeyboardVisible,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      platform: model.deviceInfo.identifier.platform,
                      brightness: model.isDarkMode ? Brightness.dark : Brightness.light,
                    ),
                    child: MediaQuery(
                      data: DevicePreview._mediaQuery(context),
                      child: Builder(
                        key: _appKeyPreview,
                        builder: (context) {
                          final app = widget.builder(context);
                          assert(
                            isWidgetsAppUsingInheritedMediaQuery(app),
                            'Your widgets app should have its `useInheritedMediaQuery` property set to `true` in order to use DevicePreview.',
                          );
                          return app;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return Builder(
        key: _appKeyPreview,
        builder: widget.builder,
      );
    }

    return ChangeNotifierProvider(
      create: (context) => DevicePreviewStore(
        defaultDevice: widget.defaultDevice ?? Devices.ios.iPhone13,
        devices: widget.devices,
        locales: widget.availableLocales,
        storage: storage,
      ),
      builder: (context, child) {
        // RN-02.2: Agrupa 5 context.select em 1 Selector
        return Selector<DevicePreviewStore, _LayoutModel>(
          selector: (_, store) {
            final isInitialized = store.state.maybeMap(
              initialized: (_) => true,
              orElse: () => false,
            );
            if (!isInitialized) {
              return const _LayoutModel(
                isInitialized: false,
                isEnabled: false,
                toolbarTheme: DevicePreviewToolBarThemeData.dark,
                backgroundTheme: DevicePreviewBackgroundThemeData.dark,
                isToolbarVisibleRight: false,
                isToolbarVisibleLeft: false,
              );
            }
            final isEnabled = store.data.isEnabled;
            final toolbarTheme = store.settings.toolbarTheme;
            final backgroundTheme = store.settings.backgroundTheme;
            final isToolbarVisibleRight = widget.isToolbarVisible &&
                store.data.isToolbarVisibleRight;
            final isToolbarVisibleLeft = widget.isToolbarVisible &&
                store.data.isToolbarVisibleLeft;
            return _LayoutModel(
              isInitialized: isInitialized,
              isEnabled: isEnabled,
              toolbarTheme: toolbarTheme,
              backgroundTheme: backgroundTheme,
              isToolbarVisibleRight: isToolbarVisibleRight,
              isToolbarVisibleLeft: isToolbarVisibleLeft,
            );
          },
          shouldRebuild: (prev, next) => prev != next,
          builder: (context, layoutModel, _) {
            if (!layoutModel.isInitialized) {
              return Builder(
                key: _appKeyPreview,
                builder: widget.builder,
              );
            }

            final toolbar = layoutModel.toolbarTheme.asThemeData();
            final background = layoutModel.backgroundTheme.asThemeData();
            return Directionality(
              textDirection: TextDirection.ltr,
              child: MediaQueryObserver(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: toolbar.scaffoldBackgroundColor,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final mediaQuery = MediaQuery.of(context);
                      final isSmall = constraints.maxWidth < 700;

                      const borderRadius = BorderRadius.zero;

                      // RN-06.1: Corrigido offset - usa padding.left (não .right)
                      // RN-06.2: Usa collapsiblePanelWidth (64) em vez de mágico
                      const kCollapsedPanelWidth = 64.0;
                      final double rightPanelOffset = !isSmall
                          ? (layoutModel.isToolbarVisibleRight
                              ? _toolsPanelRight.panelWidth - 10
                              : (kCollapsedPanelWidth + mediaQuery.padding.left))
                          : 0;
                      final double leftPanelOffset = !isSmall
                          ? (layoutModel.isToolbarVisibleLeft
                              ? _toolsPanelLeft.panelWidth - 10
                              : (kCollapsedPanelWidth + mediaQuery.padding.left))
                          : 0;
                      final double bottomPanelOffset =
                          isSmall ? mediaQuery.padding.bottom + 52 : 0;
                      return Stack(
                        children: <Widget>[
                          if (isSmall)
                            Positioned(
                              key: const Key('Small'),
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: DevicePreviewSmallLayout(
                                toolsPanelRight: _toolsPanelRight,
                                toolsPanelLeft: _toolsPanelLeft,
                                maxMenuHeight: constraints.maxHeight * 0.5,
                                scaffoldKey: scaffoldKey,
                                isRight: true,
                                onMenuVisibleChanged: (isVisible) => setState(() {
                                  _isToolPanelPopOverOpen = isVisible;
                                }),
                              ),
                            ),
                          // RN-06.2: Painel esquerdo desmontado quando invisível
                          if (!isSmall &&
                              _toolsPanelLeft.tools.isNotEmpty &&
                              layoutModel.isToolbarVisibleLeft)
                            Positioned.fill(
                              key: const Key('Large-toolsPanelLeft'),
                              child: DevicePreviewLargeLayout(
                                tools: _toolsPanelLeft,
                                isRight: false,
                              ),
                            ),
                          if (!isSmall && _toolsPanelRight.tools.isNotEmpty &&
                              layoutModel.isToolbarVisibleRight)
                            Positioned.fill(
                              key: const Key('Large-toolsPanelRight'),
                              child: DevicePreviewLargeLayout(
                                tools: _toolsPanelRight,
                                isRight: true,
                              ),
                            ),
                          AnimatedPositioned(
                            key: const Key('preview'),
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            left: leftPanelOffset,
                            right: rightPanelOffset,
                            top: 0,
                            bottom: bottomPanelOffset,
                            child: Theme(
                              data: background,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: borderRadius,
                                  color: background.scaffoldBackgroundColor,
                                ),
                                child: ClipRRect(
                                  borderRadius: borderRadius,
                                  child: layoutModel.isEnabled
                                      ? _buildPreview(context)
                                      : Builder(
                                          key: _appKeyDisabled,
                                          builder: widget.builder,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          // Toggle button for collapsed left panel
                          if (!isSmall &&
                              _toolsPanelLeft.tools.isNotEmpty &&
                              !layoutModel.isToolbarVisibleLeft)
                            Positioned(
                              // Fica **dentro** do espaço reservado para o
                              // menu colapsado (`kCollapsedPanelWidth = 64`),
                              // alinhado à borda lateral esquerda (canto onde
                              // o painel costumava ficar), e não solto no
                              // canto da tela.
                              left: 0,
                              top: mediaQuery.padding.top + 8,
                              width: 64,
                              child: Align(
                                alignment: Alignment.center,
                                child: _CollapseToggleButton(
                                  isRight: false,
                                  value: false,
                                  onChanged: (v) {
                                    final store = context.read<DevicePreviewStore>();
                                    store.data = store.data.copyWith(
                                      isToolbarVisibleLeft: v,
                                    );
                                  },
                                ),
                              ),
                            ),
                          // Toggle button for collapsed right panel
                          if (!isSmall &&
                              _toolsPanelRight.tools.isNotEmpty &&
                              !layoutModel.isToolbarVisibleRight)
                            Positioned(
                              // Fica **dentro** do espaço reservado para o
                              // menu colapsado (`kCollapsedPanelWidth = 64`),
                              // alinhado à borda lateral direita.
                              right: 0,
                              top: mediaQuery.padding.top + 8,
                              width: 64,
                              child: Align(
                                alignment: Alignment.center,
                                child: _CollapseToggleButton(
                                  isRight: true,
                                  value: false,
                                  onChanged: (v) {
                                    final store = context.read<DevicePreviewStore>();
                                    store.data = store.data.copyWith(
                                      isToolbarVisibleRight: v,
                                    );
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: IgnorePointer(
                              ignoring: !_isToolPanelPopOverOpen,
                              child: Localizations(
                                locale: const Locale('en', 'US'),
                                delegates: const [
                                  GlobalMaterialLocalizations.delegate,
                                  GlobalCupertinoLocalizations.delegate,
                                  GlobalWidgetsLocalizations.delegate,
                                ],
                                child: Navigator(
                                  onGenerateInitialRoutes: (navigator, name) {
                                    return [
                                      MaterialPageRoute(
                                        builder: (context) => Scaffold(
                                          key: scaffoldKey,
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// The repaint key used for rendering screenshots.
  final _repaintKey = GlobalKey();

  /// A stream that sends a new value each time the user takes
  /// a new screenshot.
  StreamController<DeviceScreenshot>? _onScreenshot;

  /// RN-03.3: Keys separadas para cada Builder
  final GlobalKey _appKeyPreview = GlobalKey();
  final GlobalKey _appKeyDisabled = GlobalKey();
}

/// Selector (switch) mostrado no canto da tela quando o painel
/// lateral está colapsado. Mantém o mesmo "seletor" usado pelo
/// `ToolPanel` quando expandido (vide `tool_panel.dart`), trocando
/// apenas o estado `isToolbarVisible*` correspondente: ligado = painel
/// visível, desligado = painel oculto.
class _CollapseToggleButton extends StatelessWidget {
  const _CollapseToggleButton({
    required this.isRight,
    required this.value,
    required this.onChanged,
  });

  final bool isRight;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    // Cores fixas (não dependem do `Theme.of(context)`) para que a
    // aparência do switch **nunca mude**, independentemente do estado
    // (ativado/desativado) ou de qualquer re-renderização do contexto
    // (expandir/colapsar o painel lateral pode alterar o `Theme`
    // herdado do app pré-visualizado). Assim o switch apenas alterna
    // o thumb entre ligado e desligado, sem mudança visual.
    const trackColor = Color(0xFFB0B0B0);
    const thumbColor = Color(0xFFE0E0E0);
    const outlineColor = Color(0xFF8A8A8A);
    return Material(
      color: const Color(0xFF2A2A2A),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: thumbColor,
          activeTrackColor: trackColor,
          inactiveThumbColor: thumbColor,
          inactiveTrackColor: trackColor,
          trackOutlineColor: const WidgetStatePropertyAll(outlineColor),
        ),
      ),
    );
  }
}
