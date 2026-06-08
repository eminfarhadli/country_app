import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.indigo;
  static const Color primaryLight = Color(0xFFC5CAE9);
  static const Color primaryDark = Color(0xFF303F9F);

  static const Color accent = Colors.redAccent;

  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF9E9E9E);

  static const Color favorite = Colors.red;
  static const Color favoriteBorder = Colors.grey;
}

class AppTheme {
  static const double radiusValue = 12.0;
  static final BorderRadius borderRadius12 = BorderRadius.circular(radiusValue);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      // DƏYİŞİKLİK BURADA: CardTheme yerinə CardThemeData istifadə edildi
      cardTheme: CardThemeData(
        elevation: 2,
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: borderRadius12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: borderRadius12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: borderRadius12,
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius12,
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius12,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}