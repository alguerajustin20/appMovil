import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/settings_screen.dart'; // ajusta la ruta real

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const DevApp());
}

class DevApp extends StatelessWidget {
  const DevApp({super.key});

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
          home:
              const SettingsScreen(), // tu pantalla directo, sin pasar por el nav bar del equipo
        );
      },
    );
  }
}
