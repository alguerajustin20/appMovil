///trae todos los datos de la api
import 'package:integrador_vi_mobile/core/network/api_client.dart';
import 'package:integrador_vi_mobile/data/models/factura_model.dart';
import 'package:integrador_vi_mobile/data/models/detalle_orden_model.dart';

class FacturaRepository {
  final ApiClient _apiClient;

  FacturaRepository(this._apiClient);

  Future<List<FacturaModel>> obtenerFacturasActivas() async {
    try {
      final data = await _apiClient.get('/api/Facturas/activas');

      if (data != null && data['exito'] == true) {
        final List<dynamic> lista = data['datos'];
        return lista.map((json) => FacturaModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al obtener facturas activas: $e');
    }
  }

  Future<List<DetalleOrdenModel>> obtenerDetallePorOrden(int idOrden) async {
    try {
      final data = await _apiClient.get('/api/DetalleOrdenes/orden/$idOrden');

      if (data != null && data['exito'] == true) {
        final List<dynamic> lista = data['datos'];
        return lista.map((json) => DetalleOrdenModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al obtener detalle de la orden: $e');
    }
  }
}
