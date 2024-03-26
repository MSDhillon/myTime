import 'package:flutter/material.dart';  // Importing the Flutter Material package
import 'package:google_fonts/google_fonts.dart';  // Importing Google Fonts package
import 'package:mytime/theme/colours.dart';  // Importing custom color constants
import 'package:flutter/cupertino.dart';  // Importing the Flutter Cupertino package

class AppTheme {
  // ---  LIGHT THEME  ---
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Pallete.lightModeBackground,
    appBarTheme:
        const AppBarTheme(backgroundColor: Pallete.accentColour, elevation: 0),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.secondaryColour,
    ),
    navigationBarTheme:
        const NavigationBarThemeData(backgroundColor: Pallete.accentColour),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: const StadiumBorder(),
      foregroundColor: Colors.white,
      backgroundColor: Pallete.secondaryColour,
      side: const BorderSide(color: Pallete.secondaryColour),
    )),
    cupertinoOverrideTheme: const CupertinoThemeData(
      barBackgroundColor: Pallete.accentColour,
    ),
    textTheme: TextTheme(
      labelSmall: const TextStyle(color: Colors.black),
      labelMedium: const TextStyle(color: Colors.black),
      labelLarge: const TextStyle(color: Colors.black),
      headlineSmall: GoogleFonts.kaushanScript(color: Colors.black),
      headlineMedium: GoogleFonts.kaushanScript(color: Colors.black),
      headlineLarge: GoogleFonts.kaushanScript(color: Colors.black),
      bodySmall: const TextStyle(color: Colors.black),
      bodyMedium: const TextStyle(color: Colors.black),
      bodyLarge: const TextStyle(color: Colors.black),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.black),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: const StadiumBorder(),
          foregroundColor: Pallete.primaryColour,
          backgroundColor: Colors.white,
          side: const BorderSide(color: Pallete.primaryColour),
        )),
    hintColor: Colors.grey,
  );

  // ---  DARK THEME  ---
  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Pallete.darkModeBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Pallete.primaryColour,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Pallete.tertiaryColour,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Pallete.primaryColour,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: const StadiumBorder(),
        foregroundColor: Colors.white,
        backgroundColor: Pallete.primaryColour,
        side: const BorderSide(color: Pallete.primaryColour),
      )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: const StadiumBorder(),
          foregroundColor: Pallete.accentColour,
          backgroundColor: Pallete.darkModeBackground,
          side: const BorderSide(color: Pallete.secondaryColour),
        )),
      cupertinoOverrideTheme: const CupertinoThemeData(
        barBackgroundColor: Pallete.primaryColour,
      ),
      textTheme: TextTheme(
        labelSmall: const TextStyle(color: Colors.white),
        labelMedium: const TextStyle(color: Colors.white),
        labelLarge: const TextStyle(color: Colors.white),
        headlineSmall: GoogleFonts.kaushanScript (color: Colors.white),
        headlineMedium: GoogleFonts.kaushanScript (color: Colors.white),
        headlineLarge: GoogleFonts.kaushanScript (color: Colors.white),
        bodySmall: const TextStyle(color: Colors.white),
        bodyMedium: const TextStyle(color: Colors.white),
        bodyLarge: const TextStyle(color: Colors.white),
      ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.white),
    ),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(iconColor: MaterialStateProperty.all<Color>(Colors.white))
    ),
  );
}
