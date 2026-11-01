import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integrador_vi_mobile/presentation/providers/metrics_provider.dart';
import 'package:provider/provider.dart';
import 'package:integrador_vi_mobile/core/network/api_client.dart';
import 'package:integrador_vi_mobile/presentation/providers/auth_provider.dart';
import 'package:integrador_vi_mobile/presentation/screens/security/login_screen.dart';
import 'service/auth_service.dart';
import 'service/metrics_service.dart';
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

  // 3. Inicializamos el ApiClient y verificamos si hay sesión previa guardada (persistencia de 8 horas)
  final apiClient = ApiClient();
  await apiClient.ensureAuthenticated();

  // 4. Corremos la app envolviéndola en el MultiProvider global
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(apiClient, AuthService()),
        ),

        // Metrics Service y su respectivo Provider para la bitácora
        Provider<MetricsService>(create: (_) => MetricsService(apiClient)),
        ChangeNotifierProvider(
          create: (context) => MetricsProvider(
            Provider.of<MetricsService>(context, listen: false),
          ),
        ),
      ],
      child: const MainApp(),
    ),
  );
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
