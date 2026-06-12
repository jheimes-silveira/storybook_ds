import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/theme/storybook_toolbar_colors.dart';

void main() {
  group('StorybookToolbarColors', () {
    test('creates instance with required parameters', () {
      const colors = StorybookToolbarColors(
        color: Colors.white,
        onColor: Colors.black,
        surface: Color(0xFFF5F5F5),
        onSurface: Color(0xFF212121),
      );

      expect(colors.color, Colors.white);
      expect(colors.onColor, Colors.black);
      expect(colors.surface, const Color(0xFFF5F5F5));
      expect(colors.onSurface, const Color(0xFF212121));
    });

    test('copyWith creates new instance with updated values', () {
      const original = StorybookToolbarColors(
        color: Colors.white,
        onColor: Colors.black,
        surface: Color(0xFFF5F5F5),
        onSurface: Color(0xFF212121),
      );

      final copied = original.copyWith(color: Colors.blue);

      expect(copied.color, Colors.blue);
      expect(copied.onColor, Colors.black); // unchanged
      expect(copied.surface, const Color(0xFFF5F5F5)); // unchanged
      expect(copied.onSurface, const Color(0xFF212121)); // unchanged
    });

    test('copyWith returns same instance when no parameters provided', () {
      const original = StorybookToolbarColors(
        color: Colors.white,
        onColor: Colors.black,
        surface: Color(0xFFF5F5F5),
        onSurface: Color(0xFF212121),
      );

      final copied = original.copyWith();

      expect(copied, original);
    });

    test('equality works correctly', () {
      const colors1 = StorybookToolbarColors(
        color: Colors.white,
        onColor: Colors.black,
        surface: Color(0xFFF5F5F5),
        onSurface: Color(0xFF212121),
      );

      const colors2 = StorybookToolbarColors(
        color: Colors.white,
        onColor: Colors.black,
        surface: Color(0xFFF5F5F5),
        onSurface: Color(0xFF212121),
      );

      const colors3 = StorybookToolbarColors(
        color: Colors.blue,
        onColor: Colors.black,
        surface: Color(0xFFF5F5F5),
        onSurface: Color(0xFF212121),
      );

      expect(colors1, colors2);
      expect(colors1, isNot(colors3));
    });

    test('hashCode is consistent with equality', () {
      const colors1 = StorybookToolbarColors(
        color: Colors.white,
        onColor: Colors.black,
        surface: Color(0xFFF5F5F5),
        onSurface: Color(0xFF212121),
      );

      const colors2 = StorybookToolbarColors(
        color: Colors.white,
        onColor: Colors.black,
        surface: Color(0xFFF5F5F5),
        onSurface: Color(0xFF212121),
      );

      expect(colors1.hashCode, colors2.hashCode);
    });

    group('lerp', () {
      test('returns null when both inputs are null', () {
        final result = StorybookToolbarColors.lerp(null, null, 0.5);
        expect(result, isNull);
      });

      test('returns non-null when one input is null', () {
        const colors = StorybookToolbarColors(
          color: Colors.white,
          onColor: Colors.black,
          surface: Color(0xFFF5F5F5),
          onSurface: Color(0xFF212121),
        );

        final result = StorybookToolbarColors.lerp(colors, null, 0.5);
        expect(result, colors);
      });

      test('interpolates colors correctly at t=0', () {
        const colors1 = StorybookToolbarColors(
          color: Colors.white,
          onColor: Colors.black,
          surface: Color(0xFFF5F5F5),
          onSurface: Color(0xFF212121),
        );

        const colors2 = StorybookToolbarColors(
          color: Colors.black,
          onColor: Colors.white,
          surface: Color(0xFF303030),
          onSurface: Color(0xFFFFFFFF),
        );

        final result = StorybookToolbarColors.lerp(colors1, colors2, 0.0);

        expect(result!.color, Colors.white);
        expect(result.onColor, Colors.black);
      });

      test('interpolates colors correctly at t=1', () {
        const colors1 = StorybookToolbarColors(
          color: Colors.white,
          onColor: Colors.black,
          surface: Color(0xFFF5F5F5),
          onSurface: Color(0xFF212121),
        );

        const colors2 = StorybookToolbarColors(
          color: Colors.black,
          onColor: Colors.white,
          surface: Color(0xFF303030),
          onSurface: Color(0xFFFFFFFF),
        );

        final result = StorybookToolbarColors.lerp(colors1, colors2, 1.0);

        expect(result!.color, Colors.black);
        expect(result.onColor, Colors.white);
      });

      test('interpolates colors correctly at t=0.5', () {
        // Use colors with clear midpoint
        const colors1 = StorybookToolbarColors(
          color: Color(0xFF000000),
          onColor: Color(0xFF000000),
          surface: Color(0xFF000000),
          onSurface: Color(0xFF000000),
        );

        const colors2 = StorybookToolbarColors(
          color: Color(0xFF0000FF),
          onColor: Color(0xFF0000FF),
          surface: Color(0xFF0000FF),
          onSurface: Color(0xFF0000FF),
        );

        final result = StorybookToolbarColors.lerp(colors1, colors2, 0.5);

        // At t=0.5, blue channel should be at midpoint (0x80)
        // ignore: deprecated_member_use
        expect(result!.color.blue, closeTo(128, 5));
        // ignore: deprecated_member_use
        expect(result.onColor.blue, closeTo(128, 5));
      });
    });
  });
}
