import 'dart:async';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:storybook_ds/src/device_preview/locales/default_locales.dart';
import 'package:storybook_ds/src/device_preview/locales/locales.dart';
import 'package:storybook_ds/src/device_preview/state/state.dart';
import 'package:storybook_ds/src/device_preview/storage/storage.dart';

import 'custom_device.dart';

/// The store is a container for the current [state] of the device preview.
///
/// Whenever the state changes, it notifies its listener so that they can update themselves.
class DevicePreviewStore extends ChangeNotifier {
  /// Create a new store with the given [locales], [device] and [storage].
  DevicePreviewStore({
    required this.defaultDevice,
    List<Locale>? locales,
    List<DeviceInfo>? devices,
    required this.storage,
  }) {
    _initialize(
      locales: locales,
      devices: devices,
    );
  }

  final DeviceInfo defaultDevice;

  DevicePreviewState _state = const DevicePreviewState.notInitialized();

  /// The storage used to persist the states's data.
  final DevicePreviewStorage storage;

  /// Completer to track initialization completion
  Completer<void>? _initCompleter;

  /// The curren state of the device preview.
  DevicePreviewState get state => _state;

  /// Update the state with [value] and notifies all listeners
  /// of a change.
  set state(DevicePreviewState value) {
    _state = value;
    notifyListeners();
  }

  /// The default custom device when never edited.
  static const _defaultCustomDevice = CustomDeviceInfoData(
    id: CustomDeviceIdentifier.identifier,
    name: 'Custom',
    pixelRatio: 2,
    platform: TargetPlatform.android,
    safeAreas: EdgeInsets.only(top: 20),
    rotatedSafeAreas: EdgeInsets.only(top: 20),
    screenSize: Size(512, 1024),
    type: DeviceType.tablet,
  );

  /// RN-04.1: Timer para debounce de escrita no storage
  Timer? _saveDebounceTimer;
  static const _saveDebounceDuration = Duration(milliseconds: 500);

/// Initializes the state by loading data from storage (if [useStorage]).
  /// Returns a Future that completes when initialization is done.
  /// Multiple calls will wait for the same initialization.
  Future<void> initialize({
    List<Locale>? locales,
    List<DeviceInfo>? devices,
  }) {
    return _initialize(locales: locales, devices: devices);
  }

  Future<void> _initialize({
    List<Locale>? locales,
    List<DeviceInfo>? devices,
  }) async {
    // If already initialized, return immediately
    if (_state.isInitialized) {
      return;
    }

    // If initialization is already in progress, wait for it
    if (_state.isInitializing) {
      await _initCompleter?.future;
      return;
    }

    // Start new initialization
    final completer = _initCompleter ?? Completer<void>();
    _initCompleter = completer;

    await _state.maybeWhen(
      notInitialized: () async {
        state = const DevicePreviewState.initializing();

        final availaiableLocales = locales != null
            ? locales
                .map(
                  (available) =>
                      defaultAvailableLocales.cast<NamedLocale?>().firstWhere(
                            (all) => all!.code == available.toString(),
                            orElse: () => null,
                          ),
                )
                .where((x) => x != null)
                .toList()
            : defaultAvailableLocales;

        final defaultLocale =
            basicLocaleListResolutionDS(
              // ignore: deprecated_member_use
              WidgetsBinding.instance.window.locales,
              availaiableLocales.map((x) => x!.locale).toList(),
            )
                .toString();

        devices = devices ?? Devices.all;
        DevicePreviewData? data;
        try {
          data = await storage.load();
        } catch (e) {
          // RN-04: Removido print em produção
        }

        data ??= DevicePreviewData(
          locale: defaultLocale,
          customDevice: _defaultCustomDevice,
        );

        if (data.customDevice == null) {
          data = data.copyWith(
            customDevice: _defaultCustomDevice,
          );
        }
        state = DevicePreviewState.initialized(
          locales: availaiableLocales.cast<NamedLocale>(),
          devices: devices!,
          data: data,
        );

        completer.complete();
      },
      orElse: () async {
        // Already initialized or initializing (shouldn't happen with guards above)
        completer.complete();
      },
    );
  }
}

/// A set of extension to triggers updates of the state.
extension DevicePreviewStateHelperExtensions on DevicePreviewStore {
  /// Access to the current state's data.
  ///
  /// Throws an exception if not initialized.
  DevicePreviewData get data => state.maybeMap(
        initialized: (state) => state.data,
        orElse: () => throw Exception('Not initialized'),
      );

  /// Defines the current state's data.
  ///
  /// Throws an exception if not initialized.
  /// RN-04.1: Debounce de 500ms para escrita no storage
  set data(DevicePreviewData data) {
    state = state.maybeMap(
      initialized: (state) {
        final result = state.copyWith(data: data);
        _debouncedSave(data);
        return result;
      },
      orElse: () => throw Exception('Not initialized'),
    );
  }

  /// Debounced save to storage - RN-04.1
  void _debouncedSave(DevicePreviewData data) {
    _saveDebounceTimer?.cancel();
    _saveDebounceTimer = Timer(DevicePreviewStore._saveDebounceDuration, () {
      unawaited(storage.save(data));
    });
  }

  /// Access to all available locales.
  ///
  /// Throws an exception if not initialized.
  List<NamedLocale> get locales => state.maybeMap(
        initialized: (state) => state.locales,
        orElse: () => throw Exception('Not initialized'),
      );

  /// Access to all available devices.
  ///
  /// Throws an exception if not initialized.
  List<DeviceInfo> get devices => state.maybeMap(
        initialized: (state) => state.devices,
        orElse: () => throw Exception('Not initialized'),
      );

  /// Access to device preview settings from state's data.
  ///
  /// Throws an exception if not initialized.
  DevicePreviewSettingsData get settings =>
      data.settings ?? const DevicePreviewSettingsData();

  set settings(DevicePreviewSettingsData value) {
    data = data.copyWith(settings: value);
  }

  /// The currently selected device from the [availableDevices].
  ///
  /// Throws an exception if not initialized.
  DeviceInfo get deviceInfo {
    if (data.deviceIdentifier == CustomDeviceIdentifier.identifier) {
      return CustomDeviceInfo(data.customDevice!);
    }
    return state.maybeMap(
      initialized: (state) => state.devices.firstWhere(
        (x) =>
            x.identifier.toString() ==
            (data.deviceIdentifier ?? defaultDevice.identifier.toString()),
        orElse: () => state.devices.first,
      ),
      orElse: () => throw Exception('Not initialized'),
    );
  }

  /// Get the currently selected locale from state's data.
  ///
  /// Throws an exception if not initialized.
  Locale get locale => state.maybeMap(
        initialized: (state) => state.locales
            .firstWhere(
              (x) => x.locale.toString() == data.locale,
              orElse: () => state.locales.first,
            )
            .locale,
        orElse: () => throw Exception('Not initialized'),
      );

  /// Activate the custom device mode.
  void enableCustomDevice() {
    data = data.copyWith(
      deviceIdentifier: CustomDeviceIdentifier.identifier,
    );
  }

  /// Hide or show the current device frame.
  void toggleFrame() {
    data = data.copyWith(
      isFrameVisible: !data.isFrameVisible,
    );
  }

  /// Hide or show the virtual keyboard.
  void toggleVirtualKeyboard() {
    data = data.copyWith(
      isVirtualKeyboardVisible: !data.isVirtualKeyboardVisible,
    );
  }

  /// Switch from light to dark mode.
  void toggleDarkMode() {
    data = data.copyWith(
      isDarkMode: !data.isDarkMode,
    );
  }

  /// Change the simulated device orientation between portrait and landscape.
  void rotate() {
    final index = (data.orientation.index + 1) % Orientation.values.length;
    data = data.copyWith(
      orientation: Orientation.values[index],
    );
  }

  /// Select the current device.
  void selectDevice(DeviceIdentifier id) {
    data = data.copyWith(
      deviceIdentifier: id.toString(),
    );
  }

  /// Indicate whether the current device is a custom one.
  bool get isCustomDevice {
    return deviceInfo.identifier is CustomDeviceIdentifier;
  }

  /// Updates the custom device configuration.
  /// RN-04.2: Suporta debounce
  void updateCustomDevice(CustomDeviceInfoData data, {bool debounce = true}) {
    if (debounce) {
      this.data = this.data.copyWith(customDevice: data);
    } else {
      // Escrita imediata para o caso em que debounce é false
      state = state.maybeMap(
        initialized: (state) {
          final result = state.copyWith(data: this.data.copyWith(customDevice: data));
          unawaited(storage.save(result.data));
          return result;
        },
        orElse: () => throw Exception('Not initialized'),
      );
    }
  }
}
