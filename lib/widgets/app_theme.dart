import 'package:flutter/material.dart';

/// Colores base de la identidad visual de la app.
/// Están tomados del mockup para mantener coherencia entre pantallas.
class AppColors {
  /// Fondo turquesa usado en algunas secciones del diseño.
  static const tealBg = Color(0xFF55DDE4);

  /// Verde lima usado como panel principal y barra superior.
  static const limePanel = Color(0xFFC9F57B);

  /// Color de la top bar (se mantiene separado por si luego quieres variarlo).
  static const topBar = Color(0xFFC9F57B);

  /// Color para bordes/acento (inputs, chips, separadores).
  static const borderCyan = Color(0xFF76D6E0);

  /// Color de selección (por ejemplo, estados activos o destacados).
  static const selectedYellow = Color(0xFFF2D15B);

  /// Fondo gris general para páginas (contrasta con cards blancas).
  static const pageGray = Color(0xFFE0E0E0);

  /// Fondo de tarjetas y superficies elevadas.
  static const cardWhite = Colors.white;

  /// Verde de acciones principales tipo “Llamar/Contactar”.
  static const callGreen = Color(0xFF2FB26E);

  /// Azul intenso para títulos y textos destacados.
  static const deepBlueTitle = Color(0xFF0B4AA8);
}

/// Tema global de la app.
/// Define estilos base para Scaffold, AppBar, Card y campos de texto.
class AppTheme {
  static ThemeData get theme {
    // Base Material 3 con un color semilla para generar el esquema.
    final base =
        ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF2FB26E));

    return base.copyWith(
      // Fondo por defecto de las pantallas.
      scaffoldBackgroundColor: AppColors.pageGray,

      // Estilo general de la AppBar.
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: AppColors.topBar,
        foregroundColor: Colors.black,
      ),

      // Estilo general de tarjetas para mantener consistencia.
      cardTheme: CardThemeData(
        color: AppColors.cardWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Estilo por defecto de TextField/Input (relleno + bordes en cian).
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
