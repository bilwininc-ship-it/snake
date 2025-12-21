import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.amber,
      scaffoldBackgroundColor: const Color(0xFF1a1a2e),
      colorScheme: const ColorScheme.dark(
        primary: Colors.amber,
        secondary: Colors.orange,
        surface: Color(0xFF16213e),
        error: Colors.red,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.amber,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
