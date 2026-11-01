import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart'; // Ajusta la ruta según tu estructura de carpetas

class UserService {
  final ApiClient _apiClient = ApiClient();

  /// Actualiza la información del usuario en la BD (incluyendo la contraseña)
  Future<void> updateUserPassword({
    required int userId,
    required String username,
    required String nombreCompleto,
    required int idRol,
    required String newPassword,
  }) async {
    try {
      // Estructura exacta que exige el Swagger (/api/Usuarios/{id}) no tocar
      final body = {
        "id_usuario": userId,
        "id_rol": idRol,
        "nombre_completo": nombreCompleto,
        "username": username,
        "password_hash": "",
        "password": newPassword, // La nueva contraseña
        "activo": true,
      };

      // Llamada a tu método put existente en el ApiClient
      await _apiClient.put('/api/Usuarios/$userId', body: body);
    } catch (e) {
      debugPrint(' Error en UserService al actualizar contraseña: $e');
      rethrow;
    }
  }
}
