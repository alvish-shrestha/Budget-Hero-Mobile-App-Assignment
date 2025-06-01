import 'package:flutter/material.dart';

ThemeData myApplicationTheme() {
  const primaryColor = Color(0xFFF55345);
  const textColor = Colors.white;

  return ThemeData(
    useMaterial3: false,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: primaryColor,
    fontFamily: "Jaro",

    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.red,
      backgroundColor: primaryColor,
    ).copyWith(
      secondary: Colors.brown[800],
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontFamily: "Jaro",
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 20,
          fontFamily: "Jaro",
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(
        fontFamily: "Jaro",
        color: textColor,
      ),
      floatingLabelStyle: const TextStyle(
        fontFamily: "Jaro",
        color: textColor,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: textColor,
          width: 3,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: textColor,
          width: 3,
        ),
      ),
      errorStyle: const TextStyle(color: Colors.yellowAccent),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColor),
      bodyMedium: TextStyle(color: textColor),
      titleLarge: TextStyle(color: textColor),
      titleSmall: TextStyle(color: textColor),
    ),

    iconTheme: const IconThemeData(
      color: textColor,
    ),

    dividerTheme: const DividerThemeData(
      color: Colors.white,
      thickness: 1,
    ),
  );
}
