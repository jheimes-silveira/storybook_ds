import 'package:flutter/material.dart';

final ThemeData customThemeDark = ThemeData.dark().copyWith(
  buttonTheme: const ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Cantos quadrados para botões
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Cantos quadrados para ElevatedButton
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Cantos quadrados para TextButton
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Cantos quadrados para OutlinedButton
      ),
    ),
  ),
  cardTheme: const CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Cantos quadrados para Cards
    ),
  ),
);
final ThemeData customThemeLight = ThemeData.light().copyWith(
  buttonTheme: const ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Cantos quadrados para botões
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Cantos quadrados para ElevatedButton
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Cantos quadrados para TextButton
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Cantos quadrados para OutlinedButton
      ),
    ),
  ),
  cardTheme: const CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Cantos quadrados para Cards
    ),
  ),
);
