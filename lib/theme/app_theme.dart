import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Define los dos temas de la app (claro/oscuro).
/// Se conecta en main.dart junto con themeNotifier.
class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.teal,
      secondary: AppColors.mustard,
      surface: Colors.white,
    ),
    cardColor: Colors.white,
    dividerColor: AppColors.cardBorder,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: AppColors.brown,
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: ColorScheme.dark(
      primary: AppColors.teal,
      secondary: AppColors.mustard,
      surface: AppColors.darkCard,
    ),
    cardColor: AppColors.darkCard,
    dividerColor: AppColors.darkCardBorder,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
  );
}
