import '../../core/network/api_client.dart';
import '../models/factura_model.dart';

class FacturaRepository {
  final ApiClient _apiClient;

  FacturaRepository(this._apiClient);

  static const String endpointFacturasActivas = '/api/Facturas/activas';

  Future<List<FacturaModel>> getFacturasActivas() async {
    final response = await _apiClient.get(endpointFacturasActivas);
    
    if (response is Map<String, dynamic> && response['datos'] != null) {
      final datos = response['datos'];
      if (datos is List) {
        return datos
            .map((item) => FacturaModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } else if (response is List) {
      return response
          .map((item) => FacturaModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
