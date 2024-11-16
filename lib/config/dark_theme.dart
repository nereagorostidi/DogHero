import 'package:flutter/material.dart';

class DarkThemeColors {
  // Colores basados en la paleta cálida de marrones y naranjas proporcionada
  static const Color primaryColor = Color.fromARGB(
      255, 246, 98, 53); // Naranja brillante para elementos de acento
  static const Color accentColor =
      Color(0xFF795548); // Marrón para acento y elementos destacados
  static const Color primaryTextColor =
      Color.fromARGB(255, 211, 210, 210); // Blanco para el texto principal
  static const Color secondaryTextColor =
      Color.fromARGB(255, 213, 210, 210); // Gris claro para el texto secundario
  static const Color dividerColor =
      Color(0xFFBDBDBD); // Gris claro para divisores

  // Fondo y superficie para modo oscuro basados en marrones
  static const Color scaffoldBackgroundColor =
      Color.fromARGB(255, 92, 61, 54); // Marrón oscuro para el fondo general
  static const Color surfaceColor = Color.fromARGB(
      255, 135, 95, 81); // Marrón medio para superficies elevadas como tarjetas
  static const Color inputBackgroundColor =
      Color.fromARGB(255, 50, 50, 50); // Fondo oscuro para cuadros de texto
}

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 243, 98, 54),
  scaffoldBackgroundColor: DarkThemeColors
      .scaffoldBackgroundColor, // Fondo general para el modo oscuro
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: DarkThemeColors.primaryTextColor),
    bodyMedium:
        TextStyle(color: Color.fromARGB(255, 162, 161, 161), fontSize: 20.0),
  ),
  colorScheme: const ColorScheme.dark(
    primary: DarkThemeColors.primaryColor,
    secondary: DarkThemeColors.accentColor,
    surface: DarkThemeColors
        .surfaceColor, // Color para superficies elevadas como tarjetas
    error: DarkThemeColors.dividerColor,
    onPrimary:
        Color.fromARGB(255, 255, 255, 255), // Texto sobre el color primario
    onSecondary:
        Color.fromARGB(255, 255, 255, 255), // Texto sobre el color secundario
    onSurface:
        DarkThemeColors.primaryTextColor, // Texto sobre superficies elevadas
  ),
  // Definición de colores para botones
  buttonTheme: ButtonThemeData(
    buttonColor:
        DarkThemeColors.primaryColor, // Color de fondo para botones primarios
    textTheme: ButtonTextTheme.primary, // Texto blanco en los botones
    shape: RoundedRectangleBorder(
      // Forma de los botones
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: DarkThemeColors.primaryTextColor,
      backgroundColor:
          DarkThemeColors.primaryColor, // Texto en el botón primario
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor:
          DarkThemeColors.primaryColor, // Color del texto del botón
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: DarkThemeColors.primaryColor,
      side: const BorderSide(
          color: DarkThemeColors.primaryColor), // Borde del botón
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: DarkThemeColors.surfaceColor, // Fondo del cuadro de texto
    hintStyle: const TextStyle(
      color: DarkThemeColors.secondaryTextColor, // Placeholder gris claro
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(11.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
          11.0), // Bordes redondeados al no estar enfocado
    ),
  ),
);
