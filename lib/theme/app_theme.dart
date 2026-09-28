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
    extensions: const [AppPalette.light],
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
    extensions: const [AppPalette.dark],
  );
}

// Define colores y estilos de texto que no cambian entre temas.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final bool isDark;
  final Color card;
  final Color cardBorder;
  final Color textPrimary;
  final Color textMuted;
  final Color inputFill;
  final Color sectionLabel;

  const AppPalette({
    required this.isDark,
    required this.card,
    required this.cardBorder,
    required this.textPrimary,
    required this.textMuted,
    required this.inputFill,
    required this.sectionLabel,
  });

  static const light = AppPalette(
    isDark: false,
    card: Colors.white,
    cardBorder: AppColors.cardBorder,
    textPrimary: Color(0xFF1E293B),
    textMuted: AppColors.textMuted,
    inputFill: Color(0xFFF1F5F9),
    sectionLabel: AppColors.brownLight,
  );

  static const dark = AppPalette(
    isDark: true,
    card: Color(
      0xFF1E1E1E,
    ), // Gris carbón oscuro (el mismo de las tarjetas de Ajustes)
    cardBorder: Color(0xFF2C2C2C), // Borde sutil gris oscuro
    textPrimary: Colors.white, // Texto principal blanco
    textMuted: Color(0xFF9E9E9E), // Texto secundario / subtítulos
    inputFill: Color(
      0xFF121212,
    ), // Fondo muy oscuro para los inputs adentro de la tarjeta
    sectionLabel: Color(0xFFFDB653),
  );

  @override
  AppPalette copyWith({
    bool? isDark,
    Color? card,
    Color? cardBorder,
    Color? textPrimary,
    Color? textMuted,
    Color? inputFill,
    Color? sectionLabel,
  }) {
    return AppPalette(
      isDark: isDark ?? this.isDark,
      card: card ?? this.card,
      cardBorder: cardBorder ?? this.cardBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      inputFill: inputFill ?? this.inputFill,
      sectionLabel: sectionLabel ?? this.sectionLabel,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      isDark: t < 0.5 ? isDark : other.isDark,
      card: Color.lerp(card, other.card, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      sectionLabel: Color.lerp(sectionLabel, other.sectionLabel, t)!,
    );
  }
}

/// Atajo: en cualquier pantalla usas `context.palette.card`
extension AppPaletteContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
