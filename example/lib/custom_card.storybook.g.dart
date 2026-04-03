// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_card.dart';

// **************************************************************************
// StorybookModelGenerator
// **************************************************************************

CustomCardSettings mergeCustomCardSettings(
  CustomCardSettings current,
  String fieldName,
  Object? newValue,
) {
  switch (fieldName) {
    case 'backgroundColor':
      return CustomCardSettings(
        backgroundColor: newValue as Color?,
        textColor: current.textColor,
      );
    case 'textColor':
      return CustomCardSettings(
        backgroundColor: current.backgroundColor,
        textColor: newValue as Color?,
      );
    default:
      return current;
  }
}
