import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integrador_vi_mobile/presentation/screens/security/login_screen.dart';
import 'theme/app_theme.dart';

/// Interruptor global de tema — cualquier pantalla puede leerlo o cambiarlo.
/// Empieza en modo claro por defecto.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  // 1. Asegura la inicialización previa del framework de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Carga las variables de entorno de forma segura (.env)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Aviso: No se encontró el archivo .env o falló su carga: $e");
  }

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
