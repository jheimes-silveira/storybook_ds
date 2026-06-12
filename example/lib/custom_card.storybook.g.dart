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
        borderColor: current.borderColor,
      );
    case 'textColor':
      return CustomCardSettings(
        backgroundColor: current.backgroundColor,
        textColor: newValue as Color?,
        borderColor: current.borderColor,
      );
    case 'borderColor':
      return CustomCardSettings(
        backgroundColor: current.backgroundColor,
        textColor: current.textColor,
        borderColor: newValue as Color?,
      );
    default:
      return current;
  }
}
