import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/utils/utils.dart';

void main() {
  group('Utils', () {
    group('colorToHex', () {
      test('converts black color to hex', () {
        final hex = Utils.colorToHex(Colors.black);
        expect(hex, '#FF000000');
      });

      test('converts white color to hex', () {
        final hex = Utils.colorToHex(Colors.white);
        expect(hex, '#FFFFFFFF');
      });

      test('converts pure red color to hex', () {
        final hex = Utils.colorToHex(const Color(0xFFFF0000));
        expect(hex, '#FFFF0000');
      });

      test('converts pure green color to hex', () {
        final hex = Utils.colorToHex(const Color(0xFF00FF00));
        expect(hex, '#FF00FF00');
      });

      test('converts pure blue color to hex', () {
        final hex = Utils.colorToHex(const Color(0xFF0000FF));
        expect(hex, '#FF0000FF');
      });

      test('converts color with transparency to hex', () {
        final hex = Utils.colorToHex(const Color.fromARGB(128, 255, 0, 0));
        expect(hex, '#80FF0000');
      });

      test('hex output is uppercase', () {
        final hex = Utils.colorToHex(Colors.amber);
        expect(hex, hex.toUpperCase());
      });

      test('converts Material red color to hex', () {
        final hex = Utils.colorToHex(Colors.red);
        expect(hex, '#FFF44336');
      });

      test('converts Material green color to hex', () {
        final hex = Utils.colorToHex(Colors.green);
        expect(hex, '#FF4CAF50');
      });

      test('converts Material blue color to hex', () {
        final hex = Utils.colorToHex(Colors.blue);
        expect(hex, '#FF2196F3');
      });
    });
  });
}
