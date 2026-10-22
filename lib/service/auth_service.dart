import '../data/models/auth_response_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _repository;

  AuthService({AuthRepository? repository})
    : _repository = repository ?? AuthRepository();

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

    // 1. Llamar al repositorio
    final authResponse = await _repository.login(cleanUsername, cleanPassword);

    // 2. RESTRICCIÓN: Validar que sea Administrador (idRol == 1)
    if (authResponse.usuario?.idRol != 1) {
      throw const FormatException(
        'Acceso denegado: Esta aplicación móvil es exclusiva para Administradores.',
      );
    }

    return authResponse;
  }
}
