import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_frame/device_frame.dart';
import 'package:storybook_ds/src/device_preview/utilities/screenshot.dart';

void main() {
  group('DeviceScreenshot', () {
    test('creates instance with required parameters', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4]);
      final device = Devices.ios.iPhone13;

      final screenshot = DeviceScreenshot(
        device: device,
        bytes: bytes,
        format: ui.ImageByteFormat.png,
      );

      expect(screenshot.device, device);
      expect(screenshot.bytes, bytes);
      expect(screenshot.format, ui.ImageByteFormat.png);
    });

    test('stores correct byte data', () {
      final bytes = Uint8List.fromList([255, 0, 128, 64]);
      final device = Devices.ios.iPhone13;

      final screenshot = DeviceScreenshot(
        device: device,
        bytes: bytes,
        format: ui.ImageByteFormat.rawRgba,
      );

      expect(screenshot.bytes.length, 4);
      expect(screenshot.bytes[0], 255);
      expect(screenshot.bytes[1], 0);
      expect(screenshot.bytes[2], 128);
      expect(screenshot.bytes[3], 64);
    });
  });
}
