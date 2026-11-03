import '../../core/constants/api_constants.dart';
import '../../core/errors/app_exception.dart';
import '../../core/network/api_client.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);

  Future<List<ProductModel>> getActivos() async {
    final response = await _apiClient.get('${ApiConstants.productos}/activos');
    return _parseList(response);
  }

  Future<List<ProductModel>> getInactivos() async {
    final response = await _apiClient.get('${ApiConstants.productos}/inactivos');
    return _parseList(response);
  }

  Future<String> crear(ProductModel producto) async {
    final response = await _apiClient.post(
      ApiConstants.productos,
      body: producto.toJson(),
    );
    return _extractMessage(response, fallback: 'Producto creado con éxito');
  }

  Future<String> actualizar(int id, ProductModel producto) async {
    final response = await _apiClient.put(
      '${ApiConstants.productos}/$id',
      body: producto.toJson(),
    );
    return _extractMessage(response, fallback: 'Producto actualizado con éxito');
  }

  Future<String> restaurar(int id) async {
    final response = await _apiClient.patch('${ApiConstants.productos}/restaurar/$id');
    return _extractMessage(response, fallback: 'Producto restaurado con éxito');
  }

  Future<String> cambiarEstado(int id, ProductModel productoActual) async {
    dynamic response;
    
    if (productoActual.activo) {
      response = await _apiClient.delete('${ApiConstants.productos}/$id');
    } else {
      response = await _apiClient.patch('${ApiConstants.productos}/restaurar/$id');
    }

    return _extractMessage(response, fallback: 'Estado cambiado con éxito');
  }

  List<ProductModel> _parseList(dynamic response) {
    if (response is Map<String, dynamic>) {
      final datos = response['datos'] ?? response;
      if (datos is List) {
        return datos.map((item) => ProductModel.fromJson(item as Map<String, dynamic>)).toList();
      }
    } else if (response is List) {
      return response.map((item) => ProductModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  String _extractMessage(dynamic response, {required String fallback}) {
    if (response is Map<String, dynamic> && response['mensaje'] != null) {
      return response['mensaje'].toString();
    }
    return fallback;
  }
}