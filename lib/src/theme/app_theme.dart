import 'package:flutter/material.dart';

class AppTheme {
  // A vibrant, energy-focused seed color (Teal/Cyan)
  static const _seedColor = Color(0xFF00E5FF);

  // Modern Dark Mode Colors
  static const _darkBackground = Color(
    0xFF0A0E11,
  ); // Very dark blue/grey, better than pure black

  static ThemeData get darkTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
        surface: _darkBackground,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: _darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackground,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      // cardTheme: const CardTheme(
      //   elevation: 0,
      // ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );

    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(fontFamily: 'Outfit'),
    );
  }

  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      // cardTheme: const CardTheme(
      //   elevation: 0,
      // ),
    );

    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(fontFamily: 'Outfit'),
    );
  }
}
