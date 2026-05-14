import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  static const Color _primaryDark = Color(0xFFFFFFFF);
  static const Color _primaryLight = Color(0xFF1A1A1A);
  static const Color _backgroundDark = Color(0xFF0A0A0A);
  static const Color _backgroundLight = Color(0xFFF8F8F8);
  static const Color _surfaceDark = Color(0xFF141414);
  static const Color _surfaceLight = Color(0xFFFFFFFF);
  static const Color _cardDark = Color(0xFF1E1E1E);
  static const Color _cardLight = Color(0xFFF0F0F0);
  static const Color _accentDark = Color(0xFF3A3A3A);
  static const Color _accentLight = Color(0xFFE0E0E0);
  static const Color _subtleDark = Color(0xFF888888);
  static const Color _subtleLight = Color(0xFF666666);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: _primaryDark,
        onPrimary: _backgroundDark,
        surface: _surfaceDark,
        onSurface: _primaryDark,
        secondary: _accentDark,
        onSecondary: _primaryDark,
      ),
      fontFamily: 'Battambang',
      appBarTheme: const AppBarTheme(
        backgroundColor: _backgroundDark,
        foregroundColor: _primaryDark,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _primaryDark,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: _cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _backgroundDark,
        selectedItemColor: _primaryDark,
        unselectedItemColor: _subtleDark,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 11,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: _primaryDark,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: _primaryDark,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: _primaryDark,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _primaryDark,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _primaryDark,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: _primaryDark,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 16,
          color: _primaryDark,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 14,
          color: _subtleDark,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 12,
          color: _subtleDark,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: _primaryDark,
          letterSpacing: 1.2,
        ),
      ),
      iconTheme: const IconThemeData(color: _primaryDark, size: 24),
      dividerTheme: const DividerThemeData(
        color: _accentDark,
        thickness: 0.5,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryDark,
          foregroundColor: _backgroundDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Battambang',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryDark,
          side: const BorderSide(color: _accentDark, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Battambang',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: const TextStyle(
          fontFamily: 'Battambang',
          color: _subtleDark,
          fontSize: 14,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primaryDark;
          return _subtleDark;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _accentDark;
          return _cardDark;
        }),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: _primaryLight,
        onPrimary: _backgroundLight,
        surface: _surfaceLight,
        onSurface: _primaryLight,
        secondary: _accentLight,
        onSecondary: _primaryLight,
      ),
      fontFamily: 'Battambang',
      appBarTheme: const AppBarTheme(
        backgroundColor: _backgroundLight,
        foregroundColor: _primaryLight,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _primaryLight,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: _cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _backgroundLight,
        selectedItemColor: _primaryLight,
        unselectedItemColor: _subtleLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 11,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: _primaryLight,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: _primaryLight,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: _primaryLight,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _primaryLight,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _primaryLight,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: _primaryLight,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 16,
          color: _primaryLight,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 14,
          color: _subtleLight,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 12,
          color: _subtleLight,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Battambang',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: _primaryLight,
          letterSpacing: 1.2,
        ),
      ),
      iconTheme: const IconThemeData(color: _primaryLight, size: 24),
      dividerTheme: const DividerThemeData(
        color: _accentLight,
        thickness: 0.5,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryLight,
          foregroundColor: _backgroundLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Battambang',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryLight,
          side: const BorderSide(color: _accentLight, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Battambang',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _cardLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: const TextStyle(
          fontFamily: 'Battambang',
          color: _subtleLight,
          fontSize: 14,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primaryLight;
          return _subtleLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _accentLight;
          return _cardLight;
        }),
      ),
    );
  }
}
