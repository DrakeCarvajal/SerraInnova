import 'package:flutter/material.dart';

class AppColors {
  // Basados en tu mockup (aprox.)
  static const tealBg = Color(0xFF55DDE4);
  static const limePanel = Color(0xFFC9F57B);
  static const topBar = Color(0xFFC9F57B);
  static const borderCyan = Color(0xFF76D6E0);
  static const selectedYellow = Color(0xFFF2D15B);
  static const pageGray = Color(0xFFE0E0E0);
  static const cardWhite = Colors.white;
  static const callGreen = Color(0xFF2FB26E);
  static const deepBlueTitle = Color(0xFF0B4AA8);
}

class AppTheme {
  static ThemeData get theme {
    final base =
        ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF2FB26E));
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.pageGray,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: AppColors.topBar,
        foregroundColor: Colors.black,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.borderCyan, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.borderCyan, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.borderCyan, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
