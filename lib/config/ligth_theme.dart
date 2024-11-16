import 'package:flutter/material.dart';

class LightThemeColors {
  // Colores basados en la paleta proporcionada
  static const Color primaryColor = Color.fromARGB(
      255, 246, 98, 53); // Naranja brillante para elementos de acento
  static const Color lightPrimaryColor =
      Color(0xFFFFCCBC); // Naranja claro para el fondo
  static const Color accentColor =
      Color(0xFF795548); // Marrón para acento y elementos destacados
  static const Color primaryTextColor =
      Color(0xFF212121); // Gris oscuro para el texto principal
  static const Color secondaryTextColor =
      Color(0xFF757575); // Gris claro para el texto secundario
  static const Color dividerColor =
      Color(0xFFBDBDBD); // Gris claro para divisores

  // Fondo y superficie para modo claro
  static const Color scaffoldBackgroundColor =
      Color.fromARGB(255, 248, 178, 156); // Gris para el fondo general
  static const Color surfaceColor = Color.fromARGB(255, 241, 211,
      202); // Gris muy claro para superficies elevadas como tarjetas
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: LightThemeColors.primaryColor,
  scaffoldBackgroundColor: LightThemeColors
      .scaffoldBackgroundColor, // Fondo general para el modo claro
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: LightThemeColors.primaryTextColor,
      fontWeight: FontWeight.bold,
      // Texto principal en oscuro
    ),
    bodyMedium: TextStyle(
      color: LightThemeColors.secondaryTextColor,
      fontSize: 17.0, // Texto secundario en gris claro
    ),
  ),
  colorScheme: const ColorScheme.light(
    primary: LightThemeColors.primaryColor,
    secondary: LightThemeColors.accentColor,
    surface: LightThemeColors
        .surfaceColor, // Color para superficies elevadas como tarjetas
    error: LightThemeColors.dividerColor,
    onPrimary: Colors.white, // Texto sobre el color primario
    onSecondary: Colors.white, // Texto sobre el color secundario
    onSurface:
        LightThemeColors.primaryTextColor, // Texto sobre superficies elevadas
  ),
  // Definición de colores para botones
  buttonTheme: ButtonThemeData(
    buttonColor:
        LightThemeColors.primaryColor, // Color de fondo para botones primarios
    textTheme: ButtonTextTheme.primary, // Texto blanco en los botones
    shape: RoundedRectangleBorder(
      // Forma de los botones
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: LightThemeColors.primaryTextColor,
      backgroundColor:
          LightThemeColors.primaryColor, // Texto en el botón primario
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor:
          LightThemeColors.primaryColor, // Color del texto del botón
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: LightThemeColors.primaryColor,
      side: const BorderSide(
          color: LightThemeColors.primaryColor), // Borde del botón
    ),
  ),
);
