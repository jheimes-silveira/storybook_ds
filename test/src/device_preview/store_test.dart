import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_frame/device_frame.dart';
import 'package:storybook_ds/src/device_preview/state/state.dart';
import 'package:storybook_ds/src/device_preview/state/store.dart';
import 'package:storybook_ds/src/device_preview/state/custom_device.dart';
import 'package:storybook_ds/src/device_preview/storage/storage.dart';

/// Mock storage for testing
class MockStorage implements DevicePreviewStorage {
  DevicePreviewData? _data;
  final List<DevicePreviewData> _savedData = [];
  final Duration saveDelay;
  final Duration loadDelay;

  MockStorage({
    this.saveDelay = Duration.zero,
    this.loadDelay = Duration.zero,
  });

  @override
  Future<DevicePreviewData?> load() async {
    if (loadDelay > Duration.zero) {
      await Future.delayed(loadDelay);
    }
    return _data;
  }

  @override
  Future<void> save(DevicePreviewData data) async {
    if (saveDelay > Duration.zero) {
      await Future.delayed(saveDelay);
    }
    _data = data;
    _savedData.add(data);
  }

  List<DevicePreviewData> get savedData => _savedData;
  void clearSavedData() => _savedData.clear();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DevicePreviewStore', () {
    late MockStorage storage;
    late DevicePreviewStore store;

    setUp(() {
      storage = MockStorage();
      store = DevicePreviewStore(
        defaultDevice: Devices.ios.iPhone13,
        storage: storage,
      );
    });

    test('initializes with initializing state', () {
      final delayedStorage = MockStorage(loadDelay: const Duration(milliseconds: 50));
      final delayedStore = DevicePreviewStore(
        defaultDevice: Devices.ios.iPhone13,
        storage: delayedStorage,
      );
      expect(delayedStore.state.isInitializing, isTrue);
    });

    test('initializes asynchronously', () async {
      await store.initialize();
      expect(store.state.isInitialized, isTrue);
    });

    test('data throws exception when not initialized', () {
      final delayedStorage = MockStorage(loadDelay: const Duration(milliseconds: 50));
      final delayedStore = DevicePreviewStore(
        defaultDevice: Devices.ios.iPhone13,
        storage: delayedStorage,
      );
      expect(() => delayedStore.data, throwsException);
    });

    test('data is accessible after initialization', () async {
      await store.initialize();
      expect(store.data, isNotNull);
    });

    test('deviceInfo returns default device after initialization', () async {
      await store.initialize();
      expect(store.deviceInfo.identifier, Devices.ios.iPhone13.identifier);
    });

    test('selectDevice updates deviceIdentifier', () async {
      await store.initialize();
      store.selectDevice(Devices.ios.iPhone13.identifier);
      expect(store.data.deviceIdentifier, Devices.ios.iPhone13.identifier.toString());
    });

    test('toggleFrame toggles isFrameVisible', () async {
      await store.initialize();
      final initialValue = store.data.isFrameVisible;
      store.toggleFrame();
      expect(store.data.isFrameVisible, !initialValue);
    });

    test('toggleVirtualKeyboard toggles isVirtualKeyboardVisible', () async {
      await store.initialize();
      final initialValue = store.data.isVirtualKeyboardVisible;
      store.toggleVirtualKeyboard();
      expect(store.data.isVirtualKeyboardVisible, !initialValue);
    });

    test('toggleDarkMode toggles isDarkMode', () async {
      await store.initialize();
      final initialValue = store.data.isDarkMode;
      store.toggleDarkMode();
      expect(store.data.isDarkMode, !initialValue);
    });

    test('rotate cycles through orientations', () async {
      await store.initialize();
      expect(store.data.orientation, Orientation.portrait);
      store.rotate();
      expect(store.data.orientation, Orientation.landscape);
      store.rotate();
      expect(store.data.orientation, Orientation.portrait);
    });

    test('enableCustomDevice sets custom device identifier', () async {
      await store.initialize();
      store.enableCustomDevice();
      expect(store.data.deviceIdentifier, CustomDeviceIdentifier.identifier.toString());
    });

    test('isCustomDevice returns true when custom device is selected', () async {
      await store.initialize();
      expect(store.isCustomDevice, isFalse);
      store.enableCustomDevice();
      expect(store.isCustomDevice, isTrue);
    });

    test('updateCustomDevice updates custom device data', () async {
      await store.initialize();
      const customData = CustomDeviceInfoData(
        id: CustomDeviceIdentifier.identifier,
        name: 'Custom Device',
        pixelRatio: 3,
        platform: TargetPlatform.iOS,
        safeAreas: EdgeInsets.only(top: 44),
        rotatedSafeAreas: EdgeInsets.only(top: 44),
        screenSize: Size(390, 844),
        type: DeviceType.phone,
      );

      store.updateCustomDevice(customData);
      expect(store.data.customDevice?.name, 'Custom Device');
      expect(store.data.customDevice?.pixelRatio, 3);
    });

    group('debounce', () {
      test('debounced save waits before writing to storage', () async {
        await store.initialize();
        storage.clearSavedData();

        // Rapid updates should only trigger one save
        store.data = store.data.copyWith(isFrameVisible: false);
        store.data = store.data.copyWith(isDarkMode: true);
        store.data = store.data.copyWith(isFrameVisible: true);

        // Immediately after updates, no save should have occurred
        expect(storage.savedData.length, 0);

        // Wait for debounce to complete
        await Future.delayed(const Duration(milliseconds: 600));

        // Only one save should have occurred (the last value)
        expect(storage.savedData.length, 1);
        expect(storage.savedData[0].isFrameVisible, isTrue);
        expect(storage.savedData[0].isDarkMode, isTrue);
      });

      test('immediate save with debounce=false', () async {
        await store.initialize();
        storage.clearSavedData();

        const customData = CustomDeviceInfoData(
          id: CustomDeviceIdentifier.identifier,
          name: 'Immediate Save',
          pixelRatio: 2,
          platform: TargetPlatform.android,
          safeAreas: EdgeInsets.only(top: 20),
          rotatedSafeAreas: EdgeInsets.only(top: 20),
          screenSize: Size(512, 1024),
          type: DeviceType.tablet,
        );

        store.updateCustomDevice(customData, debounce: false);

        // Immediate save should have occurred
        expect(storage.savedData.length, 1);
        expect(storage.savedData[0].customDevice?.name, 'Immediate Save');
      });
    });

    group('settings', () {
      test('settings returns default settings when not set', () async {
        await store.initialize();
        expect(store.settings, isNotNull);
      });

      test('settings can be updated', () async {
        await store.initialize();
        const newSettings = DevicePreviewSettingsData(
          toolbarPosition: DevicePreviewToolBarPositionData.top,
          toolbarTheme: DevicePreviewToolBarThemeData.light,
          backgroundTheme: DevicePreviewBackgroundThemeData.dark,
        );
        store.settings = newSettings;
        expect(store.settings.toolbarPosition, DevicePreviewToolBarPositionData.top);
        expect(store.settings.toolbarTheme, DevicePreviewToolBarThemeData.light);
        expect(store.settings.backgroundTheme, DevicePreviewBackgroundThemeData.dark);
      });
    });
  });
}
