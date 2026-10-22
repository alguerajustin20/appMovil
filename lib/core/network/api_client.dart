import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

/// Cliente HTTP personalizado para gestionar peticiones a la API en Docker
/// y adjuntar automáticamente el Token JWT de autenticación.
class ApiClient {
  final http.Client _client;
  String? _authToken;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Asigna el token JWT obtenido tras un inicio de sesión exitoso con la BD.
  void setAuthToken(String? token) {
    _authToken = token;
  }

  /// Limpia el token (por ejemplo, al cerrar sesión).
  void clearAuthToken() {
    _authToken = null;
  }

  /// Verifica si existe un token activo para enviar en las peticiones.
  Future<void> ensureAuthenticated() async {
    if (_authToken == null || _authToken!.isEmpty) {
      // Si no hay token guardado, las llamadas que requieran rol retornarán 401 Unauthorized
    }
  }

  /// Encabezados por defecto para enviar JSON y el Token Bearer.
  Map<String, String> _buildHeaders([Map<String, String>? customHeaders]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    return headers;
  }

  /// Método GET genérico que soporta parámetros query
  Future<dynamic> get(
    String path, {
    Map<String, String>? query,
    Map<String, String>? headers,
  }) async {
    final baseUrl = ApiConstants.instance.baseUrl;
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: query != null && query.isNotEmpty ? query : null,
    );

    final response = await _client
        .get(uri, headers: _buildHeaders(headers))
        .timeout(ApiConstants.timeoutDuration);

    return _processResponse(response);
  }

  /// Método POST genérico
  Future<dynamic> post(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final baseUrl = ApiConstants.instance.baseUrl;
    final url = Uri.parse('$baseUrl$path');

    final response = await _client
        .post(
          url,
          headers: _buildHeaders(headers),
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(ApiConstants.timeoutDuration);

    return _processResponse(response);
  }

  /// Método PUT genérico
  Future<dynamic> put(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final baseUrl = ApiConstants.instance.baseUrl;
    final url = Uri.parse('$baseUrl$path');

    final response = await _client
        .put(
          url,
          headers: _buildHeaders(headers),
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(ApiConstants.timeoutDuration);

    return _processResponse(response);
  }

  /// Método PATCH genérico
  Future<dynamic> patch(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final baseUrl = ApiConstants.instance.baseUrl;
    final url = Uri.parse('$baseUrl$path');

    final response = await _client
        .patch(
          url,
          headers: _buildHeaders(headers),
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(ApiConstants.timeoutDuration);

    return _processResponse(response);
  }

  /// Método DELETE genérico
  Future<dynamic> delete(String path, {Map<String, String>? headers}) async {
    final baseUrl = ApiConstants.instance.baseUrl;
    final url = Uri.parse('$baseUrl$path');

    final response = await _client
        .delete(url, headers: _buildHeaders(headers))
        .timeout(ApiConstants.timeoutDuration);

    return _processResponse(response);
  }

  /// Procesa la respuesta HTTP y valida el código de estado
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
