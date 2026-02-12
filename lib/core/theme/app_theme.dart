import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.red,
        brightness: Brightness.light,
      ),
      textTheme: _textTheme,
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.red,
        brightness: Brightness.dark,
      ),
      textTheme: _textTheme,
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );
  }

  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
  );
}
