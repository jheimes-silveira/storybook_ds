import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/device_preview/utilities/json_converters.dart';

void main() {
  group('SizeJsonConverter', () {
    test('fromJson parses list with two values', () {
      const converter = SizeJsonConverter();

      final size = converter.fromJson([100.0, 200.0]);

      expect(size.width, 100.0);
      expect(size.height, 200.0);
    });

    test('fromJson parses list with int values', () {
      const converter = SizeJsonConverter();

      final size = converter.fromJson([100.0, 200.0]);

      expect(size.width, 100.0);
      expect(size.height, 200.0);
    });

    test('fromJson returns Size.zero for null', () {
      const converter = SizeJsonConverter();

      final size = converter.fromJson(null);

      expect(size, Size.zero);
    });

    test('fromJson throws for empty list', () {
      const converter = SizeJsonConverter();

      expect(
        () => converter.fromJson([]),
        throwsException,
      );
    });

    test('fromJson throws for single element list', () {
      const converter = SizeJsonConverter();

      expect(
        () => converter.fromJson([100.0]),
        throwsException,
      );
    });

    test('fromJson throws for invalid data', () {
      const converter = SizeJsonConverter();

      expect(
        () => converter.fromJson('invalid'),
        throwsException,
      );
    });

    test('toJson converts Size to list', () {
      const converter = SizeJsonConverter();

      final json = converter.toJson(const Size(100, 200));

      expect(json, [100.0, 200.0]);
    });
  });

  group('EdgeInsetsJsonConverter', () {
    test('fromJson parses list with four double values', () {
      const converter = EdgeInsetsJsonConverter();

      final insets = converter.fromJson([10.0, 20.0, 30.0, 40.0]);

      expect(insets.left, 10.0);
      expect(insets.top, 20.0);
      expect(insets.right, 30.0);
      expect(insets.bottom, 40.0);
    });

    test('fromJson returns EdgeInsets.zero for null', () {
      const converter = EdgeInsetsJsonConverter();

      final insets = converter.fromJson(null);

      expect(insets, EdgeInsets.zero);
    });

    test('fromJson throws for empty list', () {
      const converter = EdgeInsetsJsonConverter();

      expect(
        () => converter.fromJson([]),
        throwsException,
      );
    });

    test('fromJson throws for list with less than 4 elements', () {
      const converter = EdgeInsetsJsonConverter();

      expect(
        () => converter.fromJson([10.0, 20.0, 30.0]),
        throwsException,
      );
    });

    test('fromJson throws for invalid data', () {
      const converter = EdgeInsetsJsonConverter();

      expect(
        () => converter.fromJson('invalid'),
        throwsException,
      );
    });

    test('toJson converts EdgeInsets to list', () {
      const converter = EdgeInsetsJsonConverter();

      final json = converter.toJson(const EdgeInsets.only(
        left: 10,
        top: 20,
        right: 30,
        bottom: 40,
      ));

      expect(json, [10.0, 20.0, 30.0, 40.0]);
    });
  });

  group('NullableEdgeInsetsJsonConverter', () {
    test('fromJson parses list with four values', () {
      const converter = NullableEdgeInsetsJsonConverter();

      final insets = converter.fromJson([10.0, 20.0, 30.0, 40.0]);

      expect(insets?.left, 10.0);
      expect(insets?.top, 20.0);
      expect(insets?.right, 30.0);
      expect(insets?.bottom, 40.0);
    });

    test('fromJson returns null for null input', () {
      const converter = NullableEdgeInsetsJsonConverter();

      final insets = converter.fromJson(null);

      expect(insets, isNull);
    });

    test('toJson converts EdgeInsets to list', () {
      const converter = NullableEdgeInsetsJsonConverter();

      final json = converter.toJson(const EdgeInsets.only(
        left: 10,
        top: 20,
        right: 30,
        bottom: 40,
      ));

      expect(json, [10.0, 20.0, 30.0, 40.0]);
    });

    test('toJson returns null for null input', () {
      const converter = NullableEdgeInsetsJsonConverter();

      final json = converter.toJson(null);

      expect(json, isNull);
    });
  });
}
