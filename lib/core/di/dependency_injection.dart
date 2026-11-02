import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../core/network/api_client.dart';
import '../../service/auth_service.dart';
import '../../service/metrics_service.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/providers/metrics_provider.dart';

class DependencyInjection {
  static List<SingleChildWidget> get providers {
    // 1. Instancia base del cliente HTTP (Cliente global único)
    final apiClient = ApiClient();

    return [
      // Cliente HTTP Global
      Provider<ApiClient>.value(value: apiClient),

      // Auth Provider (Gestión de sesión de 15m / 8h y rol de Admin)
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

      //authProvider
      ChangeNotifierProvider(
        create: (context) => AuthProvider(
          Provider.of<ApiClient>(context, listen: false),
          Provider.of<AuthService>(context, listen: false),
        ),
      ),
    ];
  }
}
