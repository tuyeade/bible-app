import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF1CA2F1),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE2E8F0),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1CA2F1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF1CA2F1),
        unselectedItemColor: Color(0xFF64748B),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1CA2F1),
        secondary: Color(0xFF4FC3F7),
        surface: Colors.white,
        onSurface: Color(0xFF0F172A),
      ),
      textTheme: TextTheme(
        bodyLarge: const TextStyle(color: Color(0xFF0F172A)),
        bodyMedium: const TextStyle(color: Color(0xFF334155)),
        bodySmall: const TextStyle(color: Color(0xFF64748B)),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF334155),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF1CA2F1),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      cardColor: const Color(0xFF16202A),
      dividerColor: const Color(0xFF23303E),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF10161D),
        selectedItemColor: Color(0xFF1CA2F1),
        unselectedItemColor: Color(0xFFA1AAB8),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF1CA2F1),
        secondary: Color(0xFF4FC3F7),
        surface: Color(0xFF16202A),
        surfaceTint: Color(0xFF1E3246),
        onSurface: Colors.white,
      ),
      textTheme: TextTheme(
        bodyLarge: const TextStyle(color: Colors.white),
        bodyMedium: const TextStyle(color: Colors.white70),
        bodySmall: const TextStyle(color: Color(0xFFA1AAB8)),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );
  }
}
