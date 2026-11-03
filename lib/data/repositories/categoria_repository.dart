import '../../core/constants/api_constants.dart';
import '../../core/errors/app_exception.dart';
import '../../core/network/api_client.dart';
import '../models/categoria_model.dart';

class CategoriaRepository {
  final ApiClient _apiClient;

  CategoriaRepository(this._apiClient);

  // 1. GET /api/Categorias/activos
  Future<List<CategoriaModel>> getActivos() async {
    final response = await _apiClient.get(ApiConstants.categoriasActivos);
    return _parseList(response);
  }

  // 2. GET /api/Categorias/inactivos
  Future<List<CategoriaModel>> getInactivos() async {
    final response = await _apiClient.get(ApiConstants.categoriasInactivos);
    return _parseList(response);
  }

  // 2.1. GET /api/Categorias (Para obtener todas en el diálogo de gestión)
  Future<List<CategoriaModel>> getTodas() async {
    try {
      final response = await _apiClient.get(ApiConstants.categorias);
      return _parseList(response);
    } catch (_) {
      // Si el endpoint general no existe, combinamos activos e inactivos como respaldo
      final activos = await getActivos();
      final inactivos = await getInactivos();
      return [...activos, ...inactivos];
    }
  }

  // 3. GET /api/Categorias/{id}
  Future<CategoriaModel?> getById(int id) async {
    try {
      final response = await _apiClient.get('${ApiConstants.categorias}/$id');
      if (response is Map<String, dynamic> && response['datos'] != null) {
        return CategoriaModel.fromJson(response['datos'] as Map<String, dynamic>);
      }
      return null;
    } on NotFoundException {
      return null;
    }
  }

  // 4. GET /api/Categorias/buscar?nombre=...&id=...
  Future<List<CategoriaModel>> buscar({String? nombre, int? id}) async {
    final query = <String, String>{};
    if (nombre != null && nombre.trim().isNotEmpty) {
      query['nombre'] = nombre.trim();
    }
    if (id != null && id > 0) {
      query['id'] = id.toString();
    }

    final response = await _apiClient.get(
      ApiConstants.categoriasBuscar,
      query: query.isNotEmpty ? query : null,
    );
    return _parseList(response);
  }

  // 5. POST /api/Categorias
  Future<String> crear(CategoriaModel categoria) async {
    final response = await _apiClient.post(
      ApiConstants.categorias,
      body: categoria.toJson(),
    );
    return _extractMessage(response, fallback: 'Categoría creada con éxito');
  }

  // 6. PUT /api/Categorias/{id}
  Future<String> actualizar(int id, CategoriaModel categoria) async {
    final response = await _apiClient.put(
      '${ApiConstants.categorias}/$id',
      body: categoria.toJson(),
    );
    return _extractMessage(response, fallback: 'Categoría actualizada con éxito');
  }

  // 7. DELETE /api/Categorias/{id}
  Future<String> eliminar(int id) async {
    final response = await _apiClient.delete('${ApiConstants.categorias}/$id');
    return _extractMessage(response, fallback: 'Categoría desactivada con éxito');
  }

  // 8. PATCH /api/Categorias/restaurar/{id}
  Future<String> restaurar(int id) async {
    final response = await _apiClient.patch('${ApiConstants.categoriasRestaurar}/$id');
    return _extractMessage(response, fallback: 'Categoría restaurada con éxito');
  }

  // 9. MÉTODO UNIFICADO: Cambiar estado (Activar / Desactivar) para el Switch
  Future<String> cambiarEstado(int idCategoria, bool estadoActual) async {
    dynamic response;
    if (estadoActual) {
      // Si está activa, la desactivamos con DELETE
      response = await _apiClient.delete('${ApiConstants.categorias}/$idCategoria');
    } else {
      // Si está inactiva, la restauramos con PATCH
      response = await _apiClient.patch('${ApiConstants.categoriasRestaurar}/$idCategoria');
    }
    return _extractMessage(response, fallback: 'Estado de categoría actualizado');
  }

  List<CategoriaModel> _parseList(dynamic response) {
    if (response is Map<String, dynamic>) {
      final datos = response['datos'] ?? response;
      if (datos is List) {
        return datos
            .map((item) => CategoriaModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } else if (response is List) {
      return response
          .map((item) => CategoriaModel.fromJson(item as Map<String, dynamic>))
          .toList();
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