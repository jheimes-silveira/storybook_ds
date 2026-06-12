import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/device_preview/locales/locales.dart';
import 'package:storybook_ds/src/device_preview/locales/default_locales.dart';

void main() {
  group('NamedLocale', () {
    test('creates instance with code and name', () {
      const locale = NamedLocale('en_US', 'English (United States)');

      expect(locale.code, 'en_US');
      expect(locale.name, 'English (United States)');
    });

    test('locale property parses simple language code', () {
      const locale = NamedLocale('en', 'English');

      final resolved = locale.locale;

      expect(resolved.languageCode, 'en');
      expect(resolved.countryCode, isNull);
      expect(resolved.scriptCode, isNull);
    });

    test('locale property parses language and country code', () {
      const locale = NamedLocale('en_US', 'English (United States)');

      final resolved = locale.locale;

      expect(resolved.languageCode, 'en');
      expect(resolved.countryCode, 'US');
      expect(resolved.scriptCode, isNull);
    });

    test('toString returns name', () {
      const locale = NamedLocale('en_US', 'English (United States)');

      expect(locale.toString(), 'English (United States)');
    });
  });

  group('basicLocaleListResolutionDS', () {
    test('returns first supported locale when preferredLocales is null', () {
      const supportedLocales = [
        Locale('en'),
        Locale('es'),
      ];

      final result = basicLocaleListResolutionDS(null, supportedLocales);

      expect(result, const Locale('en'));
    });

    test('returns first supported locale when preferredLocales is empty', () {
      const supportedLocales = [
        Locale('en'),
        Locale('es'),
      ];

      final result = basicLocaleListResolutionDS([], supportedLocales);

      expect(result, const Locale('en'));
    });

    test('returns exact match when found', () {
      const supportedLocales = [
        Locale('en'),
        Locale('es'),
        Locale('pt', 'BR'),
      ];
      const preferredLocales = [
        Locale('pt', 'BR'),
        Locale('en'),
      ];

      final result = basicLocaleListResolutionDS(preferredLocales, supportedLocales);

      expect(result, const Locale('pt', 'BR'));
    });

    test('returns language match when country differs', () {
      const supportedLocales = [
        Locale('en'),
        Locale('pt', 'BR'),
      ];
      const preferredLocales = [
        Locale('pt', 'PT'),
      ];

      final result = basicLocaleListResolutionDS(preferredLocales, supportedLocales);

      expect(result, const Locale('pt', 'BR'));
    });

    test('returns language-only match when no better match exists', () {
      const supportedLocales = [
        Locale('en'),
        Locale('pt'),
      ];
      const preferredLocales = [
        Locale('pt', 'MZ'),
      ];

      final result = basicLocaleListResolutionDS(preferredLocales, supportedLocales);

      expect(result, const Locale('pt'));
    });
  });

  group('defaultAvailableLocales', () {
    test('contains locales', () {
      expect(defaultAvailableLocales, isNotEmpty);
    });

    test('contains common locales', () {
      final codes = defaultAvailableLocales.map((l) => l.code).toList();

      expect(codes, contains('en'));
      expect(codes, contains('en_US'));
      expect(codes, contains('pt'));
      expect(codes, contains('pt_BR'));
      expect(codes, contains('es'));
      expect(codes, contains('zh'));
      expect(codes, contains('zh_CN'));
    });

    test('each locale has valid locale property', () {
      for (final namedLocale in defaultAvailableLocales) {
        final locale = namedLocale.locale;
        expect(locale.languageCode, isNotEmpty);
      }
    });
  });
}
