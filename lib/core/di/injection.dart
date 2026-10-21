import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../network/api_client.dart';
import '../../data/repositories/categoria_repository.dart';
import '../../services/categoria_service.dart';
import '../../presentation/providers/categoria_provider.dart';

List<SingleChildWidget> appProviders = [
  // 1. Cliente HTTP centralizado
  Provider<ApiClient>(
    create: (_) => ApiClient(),
    dispose: (_, client) => client.dispose(),
  ),

  // 2. Repositorio de Categorías
  ProxyProvider<ApiClient, CategoriaRepository>(
    update: (_, client, _) => CategoriaRepository(client),
  ),

  // 3. Servicio de Lógica de Negocio
  ProxyProvider<CategoriaRepository, CategoriaService>(
    update: (_, repo, _) => CategoriaService(repo),
  ),

  // 4. Gestor de Estado (Provider)
  ChangeNotifierProxyProvider<CategoriaService, CategoriaProvider>(
    create: (context) => CategoriaProvider(context.read<CategoriaService>()),
    update: (_, service, previous) => previous ?? CategoriaProvider(service),
  ),
];
