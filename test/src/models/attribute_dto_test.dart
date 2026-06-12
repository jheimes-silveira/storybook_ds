import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_ds/src/models/dto/attribute_dto.dart';

void main() {
  group('AttributeDto', () {
    test('AttributeDto is an alias for AttributeModel', () {
      // Verify that AttributeDto can be used as AttributeModel
      final dto = AttributeDto(
        type: 'String',
        name: 'test',
      );

      expect(dto.type, 'String');
      expect(dto.name, 'test');
    });

    test('exports are available', () {
      // Test that all exported types are accessible
      expect(DefaultType, isNotNull);
      expect(RangeIntIntervalType, isNotNull);
      expect(RangeDoubleIntervalType, isNotNull);
      expect(StringType, isNotNull);
      expect(EnumType, isNotNull);
      expect(ColorType, isNotNull);
      expect(FunctionType, isNotNull);
      expect(FunctionCallbackScenario, isNotNull);
      expect(HtmlType, isNotNull);
      expect(WrapType, isNotNull);
      expect(ObjectInObjectType, isNotNull);
      expect(VariableOption, isNotNull);
      expect(VariableOptionType, isNotNull);
      expect(StorybookNestedMerge, isNotNull);
    });
  });
}
