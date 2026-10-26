import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../network/api_client.dart';
import '../../data/repositories/factura_repository.dart';
import '../../services/factura_service.dart';
import '../../presentation/providers/factura_provider.dart';

List<SingleChildWidget> appProviders = [
  // 1. Cliente HTTP centralizado (Inmutable)
  Provider<ApiClient>(
    create: (_) => ApiClient(),
    dispose: (_, client) => client.dispose(),
  ),

  // 2. Repositorio de Facturas
  ProxyProvider<ApiClient, FacturaRepository>(
    update: (_, client, _) => FacturaRepository(client),
  ),

  // 3. Servicio de Lógica de Negocio de Facturas
  ProxyProvider<FacturaRepository, FacturaService>(
    update: (_, repo, _) => FacturaService(repo),
  ),

  // 4. Gestor de Estado reactivo para la UI
  ChangeNotifierProxyProvider<FacturaService, FacturaProvider>(
    create: (context) => FacturaProvider(context.read<FacturaService>()),
    update: (_, service, previous) => previous ?? FacturaProvider(service),
  ),
];
