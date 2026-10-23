import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  Future<List<UserModel>> getActivos() async {
    final response = await _apiClient.get('${ApiConstants.usuarios}/activos');
    return _parseList(response);
  }

  Future<List<UserModel>> getInactivos() async {
    final response = await _apiClient.get('${ApiConstants.usuarios}/inactivos');
    return _parseList(response);
  }

  Future<String> crear(UserModel usuario) async {
    final response = await _apiClient.post(
      ApiConstants.usuarios,
      body: usuario.toJson(),
    );
    return _extractMessage(response, fallback: 'Usuario creado con éxito');
  }

  Future<String> actualizar(int id, UserModel usuario) async {
    final response = await _apiClient.put(
      '${ApiConstants.usuarios}/$id',
      body: usuario.toJson(),
    );
    return _extractMessage(response, fallback: 'Usuario actualizado con éxito');
  }

  Future<String> cambiarEstado(int id) async {
    final response = await _apiClient.delete('${ApiConstants.usuarios}/$id');
    return _extractMessage(response, fallback: 'Estado cambiado con éxito');
  }

  Future<String> restaurar(int id) async {
    final response = await _apiClient.patch('${ApiConstants.usuarios}/restaurar/$id');
    return _extractMessage(response, fallback: 'Usuario restaurado con éxito');
  }

  List<UserModel> _parseList(dynamic response) {
    if (response is Map<String, dynamic>) {
      final datos = response['datos'] ?? response;
      if (datos is List) {
        return datos.map((item) => UserModel.fromJson(item as Map<String, dynamic>)).toList();
      }
    } else if (response is List) {
      return response.map((item) => UserModel.fromJson(item as Map<String, dynamic>)).toList();
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