import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';
import '../../core/network/api_client.dart';
import '../../service/auth_service.dart';
import '../../service/password_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  final AuthService _authService;
  final UserService _userService = UserService();

  UserModel? _currentUser;
  bool _isLoading = false;

  AuthProvider(this._apiClient, this._authService);

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  void setCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> loadSessionFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    // Si guardaste el json del usuario o sus datos:
    // final userJson = prefs.getString('current_user');
    // if (userJson != null) {
    //   _currentUser = UserModel.fromJson(jsonDecode(userJson));
    //   notifyListeners();
    // }
  }

  /// Inicia sesión consumiendo la API de Docker y guardando los tokens
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.post(
        '/api/Auth/login',
        body: {'username': username, 'Password': password},
      );
      debugPrint('🔑 Respuesta de login: $response');

      // Extraemos tokens y datos del usuario devueltos por el backend en C#
      final accessToken = response['token'] ?? response['accessToken'];
      final refreshToken = response['refreshToken'];

      if (accessToken != null && refreshToken != null) {
        await _apiClient.setTokens(accessToken, refreshToken);
      }

      if (response['usuario'] != null || response['user'] != null) {
        final userData = response['usuario'] ?? response['user'];
        _currentUser = UserModel.fromJson(userData);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Asigna directamente el usuario (por ejemplo, al recuperar sesión almacenada)
  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Traduce el id_rol numérico del modelo de tu compañero a un texto legible
  String getRolName() {
    if (_currentUser == null) return 'Administrador';
    switch (_currentUser!.idRol) {
      case 1:
        return 'Administrador';
      case 2:
        return 'Cajero';
      case 3:
        return 'Mesero';
      default:
        return 'Personal';
    }
  }

  /// Cierra sesión limpiando tokens y estado local
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Obtenemos el token actual del ApiClient para pasárselo al servicio
      final token =
          await _apiClient.getAccessToken() ??
          ''; // O como guardes tu token actual en el cliente

      if (token.isNotEmpty) {
        // Llamamos al método que creamos en el AuthService
        await _authService.cerrarSesion(token);
      }
    } catch (e) {
      debugPrint(' Error en logout del servidor: $e');
    } finally {
      _currentUser = null;
      await _apiClient.clearAuthToken();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Actualiza el nombre de usuario en la base de datos y en el estado local
  Future<bool> changePassword({
    required int userId,
    required String username,
    required String nombreCompleto,
    required int idRol,
    required String newPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userService = UserService();
      await userService.updateUserPassword(
        userId: userId,
        username: username,
        nombreCompleto: nombreCompleto,
        idRol: idRol,
        newPassword: newPassword,
      );
      return true;
    } catch (e) {
      debugPrint('Error al cambiar contraseña: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
