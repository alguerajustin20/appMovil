import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

/// Cliente HTTP personalizado para gestionar peticiones a la API en Docker
/// con soporte automático de renovación de Access Token (15 min) vía Refresh Token (8 horas).
class ApiClient {
  final http.Client _client;
  String? _accessToken;
  String? _refreshToken;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Asigna y guarda localmente los tokens obtenidos tras un login/refresh.
  Future<void> setTokens(String accessToken, String refreshToken) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  /// Limpia la sesión completa (por ejemplo, al cerrar sesión o expirar las 8h).
  Future<void> clearAuthToken() async {
    _accessToken = null;
    _refreshToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('refresh_token');
  }

  /// Recupera los tokens de SharedPreferences si no están en memoria.
  Future<void> ensureAuthenticated() async {
    if (_accessToken == null || _accessToken!.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      _accessToken = prefs.getString('jwt_token');
      _refreshToken = prefs.getString('refresh_token');
    }
  }

  /// Devuelve el token de acceso actual en memoria (o lo carga si es necesario)
  Future<String?> getAccessToken() async {
    await ensureAuthenticated();
    return _accessToken;
  }

  /// Construye los encabezados JSON con el Bearer Token.
  Future<Map<String, String>> _buildHeaders([
    Map<String, String>? customHeaders,
  ]) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    await ensureAuthenticated();

    if (_accessToken != null && _accessToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    return headers;
  }

  /// Intenta renovar el Access Token caducado usando el Refresh Token.
  Future<bool> _tryRefreshToken() async {
    await ensureAuthenticated();

    if (_refreshToken == null || _refreshToken!.isEmpty) return false;

    try {
      final baseUrl = ApiConstants.instance.baseUrl;
      final uri = Uri.parse(
        '$baseUrl/api/Auth/refresh',
      ); // Revisa la ruta exacta en tu Backend

      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'accessToken': _accessToken,
              'refreshToken': _refreshToken,
            }),
          )
          .timeout(ApiConstants.timeoutDuration);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccess = data['token'] ?? data['accessToken'];
        final newRefresh = data['refreshToken'] ?? _refreshToken;

        if (newAccess != null) {
          await setTokens(newAccess, newRefresh);
          return true;
        }
      }
    } catch (e) {
      print('Error en renovación automática de token: $e');
    }

    // Si falló el refresh (expiraron las 8 horas), limpiamos sesión.
    await clearAuthToken();
    return false;
  }

  /// Ejecuta peticiones HTTP con reintento automático si el Access Token caducó (HTTP 401).
  Future<http.Response> _sendWithRetry(
    Future<http.Response> Function(Map<String, String> headers) requestCall,
    Map<String, String>? customHeaders,
  ) async {
    var headers = await _buildHeaders(customHeaders);
    var response = await requestCall(headers);

    // Si responde 401 (Pasaron los 15 minutos del Access Token), intentamos refrescar
    if (response.statusCode == 401) {
      final isRefreshed = await _tryRefreshToken();

      if (isRefreshed) {
        // Reintentamos la petición con el nuevo Access Token
        headers = await _buildHeaders(customHeaders);
        response = await requestCall(headers);
      }
    }

    return response;
  }

  /// Método GET genérico
  Future<dynamic> get(
    String path, {
    Map<String, String>? query,
    Map<String, String>? headers,
  }) async {
    final baseUrl = ApiConstants.instance.baseUrl;
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: query != null && query.isNotEmpty ? query : null,
    );

    final response = await _sendWithRetry(
      (h) => _client.get(uri, headers: h).timeout(ApiConstants.timeoutDuration),
      headers,
    );

    return _processResponse(response);
  }

  /// Método POST genérico
  Future<dynamic> post(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final baseUrl = ApiConstants.instance.baseUrl;
    final uri = Uri.parse('$baseUrl$path');

    final response = await _sendWithRetry(
      (h) => _client
          .post(uri, headers: h, body: body != null ? jsonEncode(body) : null)
          .timeout(ApiConstants.timeoutDuration),
      headers,
    );

    return _processResponse(response);
  }

  /// Método PUT genérico
  Future<dynamic> put(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final baseUrl = ApiConstants.instance.baseUrl;
    final uri = Uri.parse('$baseUrl$path');

    final response = await _sendWithRetry(
      (h) => _client
          .put(uri, headers: h, body: body != null ? jsonEncode(body) : null)
          .timeout(ApiConstants.timeoutDuration),
      headers,
    );

    return _processResponse(response);
  }

  /// Método PATCH genérico
  Future<dynamic> patch(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final baseUrl = ApiConstants.instance.baseUrl;
    final uri = Uri.parse('$baseUrl$path');

    final response = await _sendWithRetry(
      (h) => _client
          .patch(uri, headers: h, body: body != null ? jsonEncode(body) : null)
          .timeout(ApiConstants.timeoutDuration),
      headers,
    );

    return _processResponse(response);
  }

  /// Método DELETE genérico
  Future<dynamic> delete(String path, {Map<String, String>? headers}) async {
    final baseUrl = ApiConstants.instance.baseUrl;
    final uri = Uri.parse('$baseUrl$path');

    final response = await _sendWithRetry(
      (h) =>
          _client.delete(uri, headers: h).timeout(ApiConstants.timeoutDuration),
      headers,
    );

    return _processResponse(response);
  }

  /// Procesa la respuesta HTTP
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Error de servidor [${response.statusCode}]: ${response.body}',
      );
    }
  }
}
