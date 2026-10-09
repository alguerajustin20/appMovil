import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/presentation/screens/security/login_screen.dart';
import 'themes/app_theme.dart';

/// Interruptor global de tema — cualquier pantalla puede leerlo o cambiarlo.
/// Empieza en modo claro por defecto.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const LoginScreen(),
        );
      },
    );
  }
}
