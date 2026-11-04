import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../data/models/auth_response_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _repository;
  final http.Client _client;

  AuthService({AuthRepository? repository, http.Client? client})
    : _repository = repository ?? AuthRepository(),
      _client = client ?? http.Client();

  Future<AuthResponseModel> iniciarSesion(
    String username,
    String password,
  ) async {
    final cleanUsername = username.trim();
    final cleanPassword = password.trim();

    if (cleanUsername.isEmpty) {
      throw const FormatException('Por favor, ingrese su nombre de usuario.');
    }

    if (cleanPassword.isEmpty) {
      throw const FormatException('Por favor, ingrese su contraseña.');
    }

    // 1. Petición HTTP POST al login de la API
    final authResponse = await _repository.login(cleanUsername, cleanPassword);

    // 2. RESTRICCIÓN 1: Validar que sea Administrador (idRol == 1)
    if (authResponse.usuario?.idRol != 1) {
      throw const FormatException(
        'Acceso denegado: Esta aplicación móvil es exclusiva para Administradores.',
      );
    }

    // 3. RESTRICCIÓN 2: Verificar contra la lista de inactivos usando el token devuelto
    final esInactivo = await _verificarSiEstaInactivo(
      authResponse.usuario?.idUsuario ?? 0,
      cleanUsername,
      authResponse.accessToken,
    );

    if (esInactivo) {
      throw const FormatException(
        'Acceso denegado: Su usuario se encuentra desactivado.',
      );
    }

    return authResponse;
  }

  /// Revisa la lista de inactivos de la API comparando ID y Username
  Future<bool> _verificarSiEstaInactivo(
    int idUsuario,
    String username,
    String token,
  ) async {
    try {
      final baseUrl = ApiConstants.instance.baseUrl;
      final url = Uri.parse('$baseUrl/api/Usuarios/inactivos');

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> listaInactivos = data['datos'] ?? [];

        for (var item in listaInactivos) {
          final int inactivoId = item['id_usuario'] ?? item['idUsuario'] ?? 0;
          final String inactivoUsername =
              (item['username'] ?? item['Username'] ?? '')
                  .toString()
                  .trim()
                  .toLowerCase();

          if ((idUsuario > 0 && inactivoId == idUsuario) ||
              (inactivoUsername.isNotEmpty &&
                  inactivoUsername == username.trim().toLowerCase())) {
            return true;
          }
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> cerrarSesion(String token) async {
    try {
      final baseUrl = ApiConstants.instance.baseUrl;
      final url = Uri.parse('$baseUrl${ApiConstants.logout}');

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al notificar cierre de sesión al servidor.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
