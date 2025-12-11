import 'package:device_frame/device_frame.dart';
import 'package:flutter/widgets.dart';

import '../locales/locales.dart';
import '../utilities/json_converters.dart';

/// Represents the current state of the device preview.
abstract class DevicePreviewState {
  const DevicePreviewState();

  /// The device preview has not been initialized yet.
  const factory DevicePreviewState.notInitialized() =
      _NotInitializedDevicePreviewState;

  /// The device preview is currently being initialized.
  const factory DevicePreviewState.initializing() =
      _InitializingDevicePreviewState;

  /// The device preview is available.
  const factory DevicePreviewState.initialized({
    /// The list of all available devices.
    required List<DeviceInfo> devices,

    /// The list of all available locales.
    required List<NamedLocale> locales,

    /// The user settings of the preview.
    required DevicePreviewData data,
  }) = _InitializedDevicePreviewState;

  /// Pattern matching with optional handlers
  T maybeWhen<T>({
    T Function()? notInitialized,
    T Function()? initializing,
    T Function(
      List<DeviceInfo> devices,
      List<NamedLocale> locales,
      DevicePreviewData data,
    )? initialized,
    required T Function() orElse,
  }) {
    if (this is _NotInitializedDevicePreviewState) {
      return notInitialized?.call() ?? orElse();
    } else if (this is _InitializingDevicePreviewState) {
      return initializing?.call() ?? orElse();
    } else if (this is _InitializedDevicePreviewState) {
      final state = this as _InitializedDevicePreviewState;
      return initialized?.call(state.devices, state.locales, state.data) ??
          orElse();
    }
    return orElse();
  }

  /// Pattern matching with optional handlers returning DevicePreviewState
  T maybeMap<T>({
    T Function(_NotInitializedDevicePreviewState)? notInitialized,
    T Function(_InitializingDevicePreviewState)? initializing,
    T Function(_InitializedDevicePreviewState)? initialized,
    required T Function() orElse,
  }) {
    if (this is _NotInitializedDevicePreviewState) {
      return notInitialized?.call(this as _NotInitializedDevicePreviewState) ??
          orElse();
    } else if (this is _InitializingDevicePreviewState) {
      return initializing?.call(this as _InitializingDevicePreviewState) ??
          orElse();
    } else if (this is _InitializedDevicePreviewState) {
      return initialized?.call(this as _InitializedDevicePreviewState) ??
          orElse();
    }
    return orElse();
  }
}

class _NotInitializedDevicePreviewState extends DevicePreviewState {
  const _NotInitializedDevicePreviewState();
}

class _InitializingDevicePreviewState extends DevicePreviewState {
  const _InitializingDevicePreviewState();
}

class _InitializedDevicePreviewState extends DevicePreviewState {
  const _InitializedDevicePreviewState({
    required this.devices,
    required this.locales,
    required this.data,
  });

  final List<DeviceInfo> devices;
  final List<NamedLocale> locales;
  final DevicePreviewData data;

  _InitializedDevicePreviewState copyWith({
    List<DeviceInfo>? devices,
    List<NamedLocale>? locales,
    DevicePreviewData? data,
  }) {
    return _InitializedDevicePreviewState(
      devices: devices ?? this.devices,
      locales: locales ?? this.locales,
      data: data ?? this.data,
    );
  }
}

/// A [DevicePreview] configuration snapshot that can be
/// serialized to be persisted between sessions.
class DevicePreviewData {
  /// Create a new [DevicePreviewData] configuration from all
  /// properties.
  const DevicePreviewData({
    this.isToolbarVisibleLeft = true,
    this.isToolbarVisibleRight = true,
    this.isEnabled = true,
    this.orientation = Orientation.portrait,
    this.deviceIdentifier,
    this.locale = 'en-US',
    this.isFrameVisible = true,
    this.isDarkMode = false,
    this.boldText = false,
    this.isVirtualKeyboardVisible = false,
    this.disableAnimations = false,
    this.highContrast = false,
    this.accessibleNavigation = false,
    this.invertColors = false,
    this.pluginData = const <String, Map<String, dynamic>>{},
    this.textScaleFactor = 1.0,
    this.settings,
    this.customDevice,
  });

  /// Indicate whether the toolbar is visible.
  final bool isToolbarVisibleLeft;

  /// Indicate whether the toolbar is visible.
  final bool isToolbarVisibleRight;

  /// Indicate whether the device simulation is enabled.
  final bool isEnabled;

  /// The current orientation of the device
  final Orientation orientation;

  /// The currently selected device.
  final String? deviceIdentifier;

  /// The currently selected device locale.
  final String locale;

  /// Indicate whether the frame is currently visible.
  final bool isFrameVisible;

  /// Indicate whether the mode is currently dark.
  final bool isDarkMode;

  /// Indicate whether texts are forced to bold.
  final bool boldText;

  /// Indicate whether the virtual keyboard is visible.
  final bool isVirtualKeyboardVisible;

  /// Indicate whether animations are disabled.
  final bool disableAnimations;

  /// Indicate whether the highcontrast mode is activated.
  final bool highContrast;

  /// Indicate whether the navigation is in accessible mode.
  final bool accessibleNavigation;

  /// Indicate whether image colors are inverted.
  final bool invertColors;

  /// Plugin data storage.
  final Map<String, Map<String, dynamic>> pluginData;

  /// The current text scaling factor.
  final double textScaleFactor;

  /// Device preview settings.
  final DevicePreviewSettingsData? settings;

  /// The custom device configuration
  final CustomDeviceInfoData? customDevice;

  /// Creates a copy of this object with the given fields replaced.
  DevicePreviewData copyWith({
    bool? isToolbarVisibleLeft,
    bool? isToolbarVisibleRight,
    bool? isEnabled,
    Orientation? orientation,
    String? deviceIdentifier,
    String? locale,
    bool? isFrameVisible,
    bool? isDarkMode,
    bool? boldText,
    bool? isVirtualKeyboardVisible,
    bool? disableAnimations,
    bool? highContrast,
    bool? accessibleNavigation,
    bool? invertColors,
    Map<String, Map<String, dynamic>>? pluginData,
    double? textScaleFactor,
    DevicePreviewSettingsData? settings,
    CustomDeviceInfoData? customDevice,
  }) {
    return DevicePreviewData(
      isToolbarVisibleLeft: isToolbarVisibleLeft ?? this.isToolbarVisibleLeft,
      isToolbarVisibleRight:
          isToolbarVisibleRight ?? this.isToolbarVisibleRight,
      isEnabled: isEnabled ?? this.isEnabled,
      orientation: orientation ?? this.orientation,
      deviceIdentifier: deviceIdentifier ?? this.deviceIdentifier,
      locale: locale ?? this.locale,
      isFrameVisible: isFrameVisible ?? this.isFrameVisible,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      boldText: boldText ?? this.boldText,
      isVirtualKeyboardVisible:
          isVirtualKeyboardVisible ?? this.isVirtualKeyboardVisible,
      disableAnimations: disableAnimations ?? this.disableAnimations,
      highContrast: highContrast ?? this.highContrast,
      accessibleNavigation: accessibleNavigation ?? this.accessibleNavigation,
      invertColors: invertColors ?? this.invertColors,
      pluginData: pluginData ?? this.pluginData,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      settings: settings ?? this.settings,
      customDevice: customDevice ?? this.customDevice,
    );
  }

  /// Converts this object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'isToolbarVisibleLeft': isToolbarVisibleLeft,
      'isToolbarVisibleRight': isToolbarVisibleRight,
      'isEnabled': isEnabled,
      'orientation': orientation.name,
      'deviceIdentifier': deviceIdentifier,
      'locale': locale,
      'isFrameVisible': isFrameVisible,
      'isDarkMode': isDarkMode,
      'boldText': boldText,
      'isVirtualKeyboardVisible': isVirtualKeyboardVisible,
      'disableAnimations': disableAnimations,
      'highContrast': highContrast,
      'accessibleNavigation': accessibleNavigation,
      'invertColors': invertColors,
      'pluginData': pluginData,
      'textScaleFactor': textScaleFactor,
      'settings': settings?.toJson(),
      'customDevice': customDevice?.toJson(),
    };
  }

  /// Creates a [DevicePreviewData] from a JSON map.
  factory DevicePreviewData.fromJson(Map<String, dynamic> json) {
    return DevicePreviewData(
      isToolbarVisibleLeft: json['isToolbarVisibleLeft'] as bool? ?? true,
      isToolbarVisibleRight: json['isToolbarVisibleRight'] as bool? ?? true,
      isEnabled: json['isEnabled'] as bool? ?? true,
      orientation: json['orientation'] != null
          ? Orientation.values.firstWhere(
              (e) => e.name == json['orientation'],
              orElse: () => Orientation.portrait,
            )
          : Orientation.portrait,
      deviceIdentifier: json['deviceIdentifier'] as String?,
      locale: json['locale'] as String? ?? 'en-US',
      isFrameVisible: json['isFrameVisible'] as bool? ?? true,
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      boldText: json['boldText'] as bool? ?? false,
      isVirtualKeyboardVisible:
          json['isVirtualKeyboardVisible'] as bool? ?? false,
      disableAnimations: json['disableAnimations'] as bool? ?? false,
      highContrast: json['highContrast'] as bool? ?? false,
      accessibleNavigation: json['accessibleNavigation'] as bool? ?? false,
      invertColors: json['invertColors'] as bool? ?? false,
      pluginData: (json['pluginData'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(
                    key,
                    value as Map<String, dynamic>,
                  )) ??
          const <String, Map<String, dynamic>>{},
      textScaleFactor: (json['textScaleFactor'] as num?)?.toDouble() ?? 1.0,
      settings: json['settings'] != null
          ? DevicePreviewSettingsData.fromJson(
              json['settings'] as Map<String, dynamic>)
          : null,
      customDevice: json['customDevice'] != null
          ? CustomDeviceInfoData.fromJson(
              json['customDevice'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Info about a device and its frame.
class CustomDeviceInfoData {
  /// Create a new device info.
  const CustomDeviceInfoData({
    required this.id,
    required this.type,
    required this.platform,
    required this.name,
    this.rotatedSafeAreas,
    required this.safeAreas,
    required this.pixelRatio,
    required this.screenSize,
  });

  /// Identifier of the device.
  final String id;

  /// The device type.
  final DeviceType type;

  /// The device operating system.
  final TargetPlatform platform;

  /// The display name of the device.
  final String name;

  /// The safe areas when the device is in landscape orientation.
  final EdgeInsets? rotatedSafeAreas;

  /// The safe areas when the device is in portrait orientation.
  final EdgeInsets safeAreas;

  /// The screen pixel density of the device.
  final double pixelRatio;

  /// The size in points of the screen content.
  final Size screenSize;

  /// Creates a copy of this object with the given fields replaced.
  CustomDeviceInfoData copyWith({
    String? id,
    DeviceType? type,
    TargetPlatform? platform,
    String? name,
    EdgeInsets? rotatedSafeAreas,
    EdgeInsets? safeAreas,
    double? pixelRatio,
    Size? screenSize,
  }) {
    return CustomDeviceInfoData(
      id: id ?? this.id,
      type: type ?? this.type,
      platform: platform ?? this.platform,
      name: name ?? this.name,
      rotatedSafeAreas: rotatedSafeAreas ?? this.rotatedSafeAreas,
      safeAreas: safeAreas ?? this.safeAreas,
      pixelRatio: pixelRatio ?? this.pixelRatio,
      screenSize: screenSize ?? this.screenSize,
    );
  }

  /// Converts this object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'platform': platform.name,
      'name': name,
      'rotatedSafeAreas': rotatedSafeAreas != null
          ? const NullableEdgeInsetsJsonConverter().toJson(rotatedSafeAreas)
          : null,
      'safeAreas': const EdgeInsetsJsonConverter().toJson(safeAreas),
      'pixelRatio': pixelRatio,
      'screenSize': const SizeJsonConverter().toJson(screenSize),
    };
  }

  /// Creates a [CustomDeviceInfoData] from a JSON map.
  factory CustomDeviceInfoData.fromJson(Map<String, dynamic> json) {
    return CustomDeviceInfoData(
      id: json['id'] as String,
      type: DeviceType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DeviceType.phone,
      ),
      platform: TargetPlatform.values.firstWhere(
        (e) => e.name == json['platform'],
        orElse: () => TargetPlatform.android,
      ),
      name: json['name'] as String,
      rotatedSafeAreas: json['rotatedSafeAreas'] != null
          ? const NullableEdgeInsetsJsonConverter()
              .fromJson(json['rotatedSafeAreas'])
          : null,
      safeAreas: const EdgeInsetsJsonConverter()
          .fromJson(json['safeAreas'] as Object?),
      pixelRatio: (json['pixelRatio'] as num).toDouble(),
      screenSize:
          const SizeJsonConverter().fromJson(json['screenSize'] as Object?),
    );
  }
}

/// Settings of device preview itself (tool bar position, background style).
class DevicePreviewSettingsData {
  /// Create a new set of settings.
  const DevicePreviewSettingsData({
    this.toolbarPosition = DevicePreviewToolBarPositionData.bottom,
    this.toolbarTheme = DevicePreviewToolBarThemeData.dark,
    this.backgroundTheme = DevicePreviewBackgroundThemeData.light,
  });

  /// The toolbar position.
  final DevicePreviewToolBarPositionData toolbarPosition;

  /// The theme of the toolbar.
  final DevicePreviewToolBarThemeData toolbarTheme;

  /// The theme of the background.
  final DevicePreviewBackgroundThemeData backgroundTheme;

  /// Creates a copy of this object with the given fields replaced.
  DevicePreviewSettingsData copyWith({
    DevicePreviewToolBarPositionData? toolbarPosition,
    DevicePreviewToolBarThemeData? toolbarTheme,
    DevicePreviewBackgroundThemeData? backgroundTheme,
  }) {
    return DevicePreviewSettingsData(
      toolbarPosition: toolbarPosition ?? this.toolbarPosition,
      toolbarTheme: toolbarTheme ?? this.toolbarTheme,
      backgroundTheme: backgroundTheme ?? this.backgroundTheme,
    );
  }

  /// Converts this object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'toolbarPosition': toolbarPosition.name,
      'toolbarTheme': toolbarTheme.name,
      'backgroundTheme': backgroundTheme.name,
    };
  }

  /// Creates a [DevicePreviewSettingsData] from a JSON map.
  factory DevicePreviewSettingsData.fromJson(Map<String, dynamic> json) {
    return DevicePreviewSettingsData(
      toolbarPosition: json['toolbarPosition'] != null
          ? DevicePreviewToolBarPositionData.values.firstWhere(
              (e) => e.name == json['toolbarPosition'],
              orElse: () => DevicePreviewToolBarPositionData.bottom,
            )
          : DevicePreviewToolBarPositionData.bottom,
      toolbarTheme: json['toolbarTheme'] != null
          ? DevicePreviewToolBarThemeData.values.firstWhere(
              (e) => e.name == json['toolbarTheme'],
              orElse: () => DevicePreviewToolBarThemeData.dark,
            )
          : DevicePreviewToolBarThemeData.dark,
      backgroundTheme: json['backgroundTheme'] != null
          ? DevicePreviewBackgroundThemeData.values.firstWhere(
              (e) => e.name == json['backgroundTheme'],
              orElse: () => DevicePreviewBackgroundThemeData.light,
            )
          : DevicePreviewBackgroundThemeData.light,
    );
  }
}

enum DevicePreviewToolBarThemeData {
  dark,
  light,
}

enum DevicePreviewBackgroundThemeData {
  dark,
  light,
}

enum DevicePreviewToolBarPositionData {
  bottom,
  top,
  left,
  right,
}
