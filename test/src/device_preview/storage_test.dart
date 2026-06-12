import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/device_preview/storage/storage.dart';
import 'package:storybook_ds/src/device_preview/state/state.dart';

void main() {
  group('DevicePreviewStorage', () {
    test('none factory creates NoDevicePreviewStorage', () {
      final storage = DevicePreviewStorage.none();

      expect(storage, isA<NoDevicePreviewStorage>());
    });
  });

  group('NoDevicePreviewStorage', () {
    test('load returns null', () async {
      const storage = NoDevicePreviewStorage();

      final result = await storage.load();

      expect(result, isNull);
    });

    test('save completes without error', () async {
      const storage = NoDevicePreviewStorage();
      const data = DevicePreviewData(
        locale: 'en-US',
        isDarkMode: true,
      );

      await expectLater(
        storage.save(data),
        completes,
      );
    });
  });
}
