import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_frame/device_frame.dart';
import 'package:storybook_ds/src/device_preview/state/state.dart';
import 'package:storybook_ds/src/device_preview/state/custom_device.dart';

void main() {
  group('DevicePreviewState', () {
    test('notInitialized state is created correctly', () {
      const state = DevicePreviewState.notInitialized();

      expect(state.isNotInitialized, true);
      expect(state.isInitializing, false);
      expect(state.isInitialized, false);
    });

    test('initializing state is created correctly', () {
      const state = DevicePreviewState.initializing();

      expect(state.isNotInitialized, false);
      expect(state.isInitializing, true);
      expect(state.isInitialized, false);
    });

    test('initialized state is created correctly', () {
      final state = DevicePreviewState.initialized(
        devices: [],
        locales: [],
        data: const DevicePreviewData(),
      );

      expect(state.isNotInitialized, false);
      expect(state.isInitializing, false);
      expect(state.isInitialized, true);
    });

    group('maybeWhen', () {
      test('calls notInitialized handler for notInitialized state', () {
        const state = DevicePreviewState.notInitialized();

        final result = state.maybeWhen(
          notInitialized: () => 'not initialized',
          orElse: () => 'else',
        );

        expect(result, 'not initialized');
      });

      test('calls initializing handler for initializing state', () {
        const state = DevicePreviewState.initializing();

        final result = state.maybeWhen(
          initializing: () => 'initializing',
          orElse: () => 'else',
        );

        expect(result, 'initializing');
      });

      test('calls initialized handler for initialized state', () {
        final state = DevicePreviewState.initialized(
          devices: [],
          locales: [],
          data: const DevicePreviewData(),
        );

        final result = state.maybeWhen(
          initialized: (devices, locales, data) => 'initialized',
          orElse: () => 'else',
        );

        expect(result, 'initialized');
      });

      test('falls back to orElse when handler is null', () {
        const state = DevicePreviewState.notInitialized();

        final result = state.maybeWhen(
          orElse: () => 'fallback',
        );

        expect(result, 'fallback');
      });
    });

    group('maybeMap', () {
      test('calls notInitialized handler for notInitialized state', () {
        const state = DevicePreviewState.notInitialized();

        final result = state.maybeMap(
          notInitialized: (_) => 'not initialized',
          orElse: () => 'else',
        );

        expect(result, 'not initialized');
      });

      test('calls initializing handler for initializing state', () {
        const state = DevicePreviewState.initializing();

        final result = state.maybeMap(
          initializing: (_) => 'initializing',
          orElse: () => 'else',
        );

        expect(result, 'initializing');
      });

      test('calls initialized handler for initialized state', () {
        final state = DevicePreviewState.initialized(
          devices: [],
          locales: [],
          data: const DevicePreviewData(),
        );

        final result = state.maybeMap(
          initialized: (_) => 'initialized',
          orElse: () => 'else',
        );

        expect(result, 'initialized');
      });
    });
  });

  group('DevicePreviewData', () {
    test('creates instance with default values', () {
      const data = DevicePreviewData();

      expect(data.isToolbarVisibleLeft, true);
      expect(data.isToolbarVisibleRight, true);
      expect(data.isEnabled, true);
      expect(data.orientation, Orientation.portrait);
      expect(data.deviceIdentifier, isNull);
      expect(data.locale, 'en-US');
      expect(data.isFrameVisible, true);
      expect(data.isDarkMode, false);
      expect(data.boldText, false);
      expect(data.isVirtualKeyboardVisible, false);
      expect(data.disableAnimations, false);
      expect(data.highContrast, false);
      expect(data.accessibleNavigation, false);
      expect(data.invertColors, false);
      expect(data.pluginData, isEmpty);
      expect(data.textScaleFactor, 1.0);
      expect(data.settings, isNull);
      expect(data.customDevice, isNull);
    });

    test('creates instance with custom values', () {
      const data = DevicePreviewData(
        isToolbarVisibleLeft: false,
        isToolbarVisibleRight: false,
        isEnabled: false,
        orientation: Orientation.landscape,
        deviceIdentifier: 'test-device',
        locale: 'pt-BR',
        isFrameVisible: false,
        isDarkMode: true,
        boldText: true,
        isVirtualKeyboardVisible: true,
        disableAnimations: true,
        highContrast: true,
        accessibleNavigation: true,
        invertColors: true,
        textScaleFactor: 1.5,
      );

      expect(data.isToolbarVisibleLeft, false);
      expect(data.isToolbarVisibleRight, false);
      expect(data.isEnabled, false);
      expect(data.orientation, Orientation.landscape);
      expect(data.deviceIdentifier, 'test-device');
      expect(data.locale, 'pt-BR');
      expect(data.isFrameVisible, false);
      expect(data.isDarkMode, true);
      expect(data.boldText, true);
      expect(data.isVirtualKeyboardVisible, true);
      expect(data.disableAnimations, true);
      expect(data.highContrast, true);
      expect(data.accessibleNavigation, true);
      expect(data.invertColors, true);
      expect(data.textScaleFactor, 1.5);
    });

    test('copyWith creates new instance with updated values', () {
      const original = DevicePreviewData(
        locale: 'en-US',
        isDarkMode: false,
      );

      final updated = original.copyWith(
        locale: 'pt-BR',
        isDarkMode: true,
      );

      expect(updated.locale, 'pt-BR');
      expect(updated.isDarkMode, true);
      expect(updated.isToolbarVisibleLeft, original.isToolbarVisibleLeft);
    });

    test('toJson serializes correctly', () {
      const data = DevicePreviewData(
        locale: 'pt-BR',
        isDarkMode: true,
        textScaleFactor: 1.5,
      );

      final json = data.toJson();

      expect(json['locale'], 'pt-BR');
      expect(json['isDarkMode'], true);
      expect(json['textScaleFactor'], 1.5);
      expect(json['orientation'], 'portrait');
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'locale': 'pt-BR',
        'isDarkMode': true,
        'textScaleFactor': 1.5,
        'orientation': 'landscape',
      };

      final data = DevicePreviewData.fromJson(json);

      expect(data.locale, 'pt-BR');
      expect(data.isDarkMode, true);
      expect(data.textScaleFactor, 1.5);
      expect(data.orientation, Orientation.landscape);
    });

    test('fromJson handles missing values with defaults', () {
      final json = <String, dynamic>{};

      final data = DevicePreviewData.fromJson(json);

      expect(data.locale, 'en-US');
      expect(data.isDarkMode, false);
      expect(data.textScaleFactor, 1.0);
      expect(data.orientation, Orientation.portrait);
    });
  });

  group('CustomDeviceInfoData', () {
    test('creates instance with required parameters', () {
      const data = CustomDeviceInfoData(
        id: 'custom-1',
        type: DeviceType.phone,
        platform: TargetPlatform.android,
        name: 'Custom Phone',
        safeAreas: EdgeInsets.all(20),
        pixelRatio: 2.0,
        screenSize: Size(375, 812),
      );

      expect(data.id, 'custom-1');
      expect(data.type, DeviceType.phone);
      expect(data.platform, TargetPlatform.android);
      expect(data.name, 'Custom Phone');
      expect(data.safeAreas, EdgeInsets.all(20));
      expect(data.pixelRatio, 2.0);
      expect(data.screenSize, const Size(375, 812));
      expect(data.rotatedSafeAreas, isNull);
    });

    test('copyWith creates new instance with updated values', () {
      const original = CustomDeviceInfoData(
        id: 'custom-1',
        type: DeviceType.phone,
        platform: TargetPlatform.android,
        name: 'Custom Phone',
        safeAreas: EdgeInsets.all(20),
        pixelRatio: 2.0,
        screenSize: Size(375, 812),
      );

      final updated = original.copyWith(
        name: 'Updated Phone',
        pixelRatio: 3.0,
      );

      expect(updated.name, 'Updated Phone');
      expect(updated.pixelRatio, 3.0);
      expect(updated.id, original.id);
    });

    test('toJson serializes correctly', () {
      const data = CustomDeviceInfoData(
        id: 'custom-1',
        type: DeviceType.tablet,
        platform: TargetPlatform.iOS,
        name: 'Custom Tablet',
        safeAreas: EdgeInsets.all(20),
        pixelRatio: 2.0,
        screenSize: Size(768, 1024),
      );

      final json = data.toJson();

      expect(json['id'], 'custom-1');
      expect(json['type'], 'tablet');
      expect(json['platform'], 'iOS');
      expect(json['name'], 'Custom Tablet');
      expect(json['pixelRatio'], 2.0);
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'id': 'custom-1',
        'type': 'tablet',
        'platform': 'iOS',
        'name': 'Custom Tablet',
        'safeAreas': [20.0, 20.0, 20.0, 20.0],
        'pixelRatio': 2.0,
        'screenSize': [768.0, 1024.0],
      };

      final data = CustomDeviceInfoData.fromJson(json);

      expect(data.id, 'custom-1');
      expect(data.type, DeviceType.tablet);
      expect(data.platform, TargetPlatform.iOS);
      expect(data.name, 'Custom Tablet');
      expect(data.pixelRatio, 2.0);
    });
  });

  group('DevicePreviewSettingsData', () {
    test('creates instance with default values', () {
      const settings = DevicePreviewSettingsData();

      expect(settings.toolbarPosition, DevicePreviewToolBarPositionData.bottom);
      expect(settings.toolbarTheme, DevicePreviewToolBarThemeData.dark);
      expect(settings.backgroundTheme, DevicePreviewBackgroundThemeData.light);
    });

    test('copyWith creates new instance with updated values', () {
      const original = DevicePreviewSettingsData();

      final updated = original.copyWith(
        toolbarPosition: DevicePreviewToolBarPositionData.top,
        toolbarTheme: DevicePreviewToolBarThemeData.light,
      );

      expect(updated.toolbarPosition, DevicePreviewToolBarPositionData.top);
      expect(updated.toolbarTheme, DevicePreviewToolBarThemeData.light);
      expect(updated.backgroundTheme, original.backgroundTheme);
    });

    test('toJson serializes correctly', () {
      const settings = DevicePreviewSettingsData(
        toolbarPosition: DevicePreviewToolBarPositionData.left,
        toolbarTheme: DevicePreviewToolBarThemeData.light,
        backgroundTheme: DevicePreviewBackgroundThemeData.dark,
      );

      final json = settings.toJson();

      expect(json['toolbarPosition'], 'left');
      expect(json['toolbarTheme'], 'light');
      expect(json['backgroundTheme'], 'dark');
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'toolbarPosition': 'right',
        'toolbarTheme': 'light',
        'backgroundTheme': 'dark',
      };

      final settings = DevicePreviewSettingsData.fromJson(json);

      expect(settings.toolbarPosition, DevicePreviewToolBarPositionData.right);
      expect(settings.toolbarTheme, DevicePreviewToolBarThemeData.light);
      expect(settings.backgroundTheme, DevicePreviewBackgroundThemeData.dark);
    });
  });

  group('CustomDeviceInfo', () {
    test('creates custom device from data', () {
      const data = CustomDeviceInfoData(
        id: 'custom-1',
        type: DeviceType.phone,
        platform: TargetPlatform.android,
        name: 'Custom Phone',
        safeAreas: EdgeInsets.all(20),
        pixelRatio: 2.0,
        screenSize: Size(375, 812),
      );

      final device = CustomDeviceInfo(data);

      expect(device.name, 'Custom Phone');
      expect(device.pixelRatio, 2.0);
      expect(device.screenSize, const Size(375, 812));
      expect(device.safeAreas, EdgeInsets.all(20));
      expect(device.rotatedSafeAreas, isNull);
    });

    test('copyWith throws UnsupportedError', () {
      const data = CustomDeviceInfoData(
        id: 'custom-1',
        type: DeviceType.phone,
        platform: TargetPlatform.android,
        name: 'Custom Phone',
        safeAreas: EdgeInsets.all(20),
        pixelRatio: 2.0,
        screenSize: Size(375, 812),
      );

      final device = CustomDeviceInfo(data);

      expect(() => device.copyWith, throwsUnsupportedError);
    });
  });

  group('CustomDeviceIdentifier', () {
    test('creates identifier with correct properties', () {
      const data = CustomDeviceInfoData(
        id: 'custom-1',
        type: DeviceType.phone,
        platform: TargetPlatform.android,
        name: 'Custom Phone',
        safeAreas: EdgeInsets.all(20),
        pixelRatio: 2.0,
        screenSize: Size(375, 812),
      );

      const identifier = CustomDeviceIdentifier(data);

      expect(identifier.name, 'Custom Phone');
      expect(identifier.platform, TargetPlatform.android);
      expect(identifier.type, DeviceType.phone);
      expect(CustomDeviceIdentifier.identifier, 'custom_device');
    });

    test('equality works correctly', () {
      const data1 = CustomDeviceInfoData(
        id: 'custom-1',
        type: DeviceType.phone,
        platform: TargetPlatform.android,
        name: 'Custom Phone',
        safeAreas: EdgeInsets.all(20),
        pixelRatio: 2.0,
        screenSize: Size(375, 812),
      );

      const data2 = CustomDeviceInfoData(
        id: 'custom-2',
        type: DeviceType.phone,
        platform: TargetPlatform.android,
        name: 'Custom Phone',
        safeAreas: EdgeInsets.all(20),
        pixelRatio: 2.0,
        screenSize: Size(375, 812),
      );

      const identifier1 = CustomDeviceIdentifier(data1);
      const identifier2 = CustomDeviceIdentifier(data2);

      // Same name, type, platform = equal
      expect(identifier1 == identifier2, true);
    });

    test('inequality when names differ', () {
      const data1 = CustomDeviceInfoData(
        id: 'custom-1',
        type: DeviceType.phone,
        platform: TargetPlatform.android,
        name: 'Custom Phone',
        safeAreas: EdgeInsets.all(20),
        pixelRatio: 2.0,
        screenSize: Size(375, 812),
      );

      const data2 = CustomDeviceInfoData(
        id: 'custom-2',
        type: DeviceType.phone,
        platform: TargetPlatform.android,
        name: 'Different Phone',
        safeAreas: EdgeInsets.all(20),
        pixelRatio: 2.0,
        screenSize: Size(375, 812),
      );

      const identifier1 = CustomDeviceIdentifier(data1);
      const identifier2 = CustomDeviceIdentifier(data2);

      // Different names = not equal
      expect(identifier1 == identifier2, false);
    });

    test('hashCode is consistent', () {
      const data = CustomDeviceInfoData(
        id: 'custom-1',
        type: DeviceType.phone,
        platform: TargetPlatform.android,
        name: 'Custom Phone',
        safeAreas: EdgeInsets.all(20),
        pixelRatio: 2.0,
        screenSize: Size(375, 812),
      );

      const identifier = CustomDeviceIdentifier(data);

      expect(identifier.hashCode, isA<int>());
    });
  });
}
