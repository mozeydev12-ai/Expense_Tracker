import 'package:flutter/material.dart';

class AppTheme {
  // ── Palette ──────────────────────────────────────────────
  static const Color bg       = Color(0xFF0F0F11);
  static const Color bg2      = Color(0xFF17171A);
  static const Color bg3      = Color(0xFF1E1E23);
  static const Color bg4      = Color(0xFF26262D);
  static const Color gold     = Color(0xFFE8B84B);
  static const Color goldLight= Color(0xFFF5D07A);
  static const Color textPrim = Color(0xFFF0EEEA);
  static const Color textSec  = Color(0xFF9A9890);
  static const Color textTert = Color(0xFF5A5856);
  static const Color border   = Color(0x0FFFFFFF);
  static const Color border2  = Color(0x1AFFFFFF);
  static const Color red      = Color(0xFFE05C5C);
  static const Color green    = Color(0xFF5CB885);
  static const Color blue     = Color(0xFF5C8EE0);
  static const Color purple   = Color(0xFF9B5CE0);

  // ── Category colours ─────────────────────────────────────
  static const Map<String, Color> catColors = {
    'food':      Color(0xFFE8B84B),
    'transport': Color(0xFF5C8EE0),
    'bills':     Color(0xFFE05C5C),
    'health':    Color(0xFF5CB885),
    'shopping':  Color(0xFF9B5CE0),
    'other':     Color(0xFF9A9890),
  };

  static const Map<String, String> catIcons = {
    'food':      '🍔',
    'transport': '🚗',
    'bills':     '⚡',
    'health':    '💊',
    'shopping':  '🛍️',
    'other':     '✨',
  };

  static const Map<String, String> catLabels = {
    'food':      'Food',
    'transport': 'Transport',
    'bills':     'Bills',
    'health':    'Health',
    'shopping':  'Shopping',
    'other':     'Other',
  };

  // ── Material ThemeData ────────────────────────────────────
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.dark(
      primary:    gold,
      secondary:  goldLight,
      surface:    bg2,
      error:      red,
      onPrimary:  bg,
      onSurface:  textPrim,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Syne',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textPrim,
      ),
      iconTheme: IconThemeData(color: textPrim),
    ),

    // Card
    cardTheme: CardThemeData(
      color: bg3,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: border),
      ),
    ),

    // BottomNavigation
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: bg2,
      selectedItemColor: gold,
      unselectedItemColor: textTert,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),

    // InputDecoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bg3,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: gold, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: red, width: 1.5),
      ),
      labelStyle: const TextStyle(color: textSec, fontSize: 14),
      hintStyle: const TextStyle(color: textTert, fontSize: 14),
    ),

    // ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: gold,
        foregroundColor: bg,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontFamily: 'Syne',
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    // Text
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Syne', color: textPrim, fontWeight: FontWeight.w800),
      headlineMedium: TextStyle(fontFamily: 'Syne', color: textPrim, fontWeight: FontWeight.w700, fontSize: 22),
      titleLarge: TextStyle(fontFamily: 'Syne', color: textPrim, fontWeight: FontWeight.w700, fontSize: 18),
      titleMedium: TextStyle(fontFamily: 'Syne', color: textPrim, fontWeight: FontWeight.w600, fontSize: 15),
      bodyLarge: TextStyle(color: textPrim, fontSize: 15),
      bodyMedium: TextStyle(color: textSec, fontSize: 13),
      labelSmall: TextStyle(fontFamily: 'Syne', color: textTert, fontSize: 10, letterSpacing: 0.8),
    ),

    fontFamily: 'DM Sans',
  );
}
