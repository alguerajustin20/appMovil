import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../errors/app_exception.dart';

class ApiClient {
  final http.Client _client = http.Client();
  String? _authToken;

  String? get authToken => _authToken;

  void setAuthToken(String? token) {
    if (token == null) {
      _authToken = null;
    } else {
      // Limpiar comillas y espacios para coincidir con la validación del middleware en C#
      _authToken = token.replaceAll('"', '').trim();
    }
  }

  /// Autenticación automática de respaldo con el backend Docker
  Future<void> ensureAuthenticated() async {
    if (_authToken != null && _authToken!.isNotEmpty) return;

    try {
      final baseUrl = ApiConstants.instance.baseUrl;
      final uri = Uri.parse('$baseUrl${ApiConstants.login}');
      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': ApiConstants.instance.apiUsername,
          'password': ApiConstants.instance.apiPassword,
        }),
      ).timeout(ApiConstants.timeoutDuration);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data['accessToken'] != null) {
          setAuthToken(data['accessToken'] as String);
        }
      }
    } catch (_) {
      // Si falla la autenticación de respaldo, se intentará la petición directa
    }
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) async =>
      _send('GET', path, query, null);

  Future<dynamic> post(String path, {Object? body}) async =>
      _send('POST', path, null, body);

  Future<dynamic> put(String path, {Object? body}) async =>
      _send('PUT', path, null, body);

  Future<dynamic> patch(String path, {Object? body}) async =>
      _send('PATCH', path, null, body);

  Future<dynamic> delete(String path) async =>
      _send('DELETE', path, null, null);

  Future<dynamic> _send(
    String method,
    String path,
    Map<String, String>? query,
    Object? body,
  ) async {
    // Asegurar token antes de la llamada protegida
    await ensureAuthenticated();

    final baseUrl = ApiConstants.instance.baseUrl;
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    final request = http.Request(method, uri)..headers.addAll(headers);
    if (body != null) {
      request.body = jsonEncode(body);
    }

    final http.Response response;
    try {
      response = await _client
          .send(request)
          .timeout(ApiConstants.timeoutDuration)
          .then(http.Response.fromStream);
    } on TimeoutException {
      throw const NetworkException('Tiempo de espera agotado al conectar con el contenedor Docker.');
    } on http.ClientException {
      throw const NetworkException('No se pudo establecer conexión con el contenedor Docker (puerto 8080).');
    }

    if (response.statusCode == 401) {
      throw const UnauthorizedException();
    }
    if (response.statusCode == 403) {
      final msg = _extractErrorMessage(response.body) ?? 'Acceso Denegado: Rol sin permisos.';
      throw ForbiddenException(msg);
    }
    if (response.statusCode == 404) {
      throw const NotFoundException();
    }

    return _decode(response);
  }

  dynamic _decode(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final msg = _extractErrorMessage(response.body) ?? 'Error en la petición al servidor';
      throw ServerException(msg, statusCode: response.statusCode);
    }

    if (response.body.isEmpty) return null;

    try {
      return jsonDecode(response.body);
    } on FormatException {
      throw const ParsingException();
    }
  }

  String? _extractErrorMessage(String body) {
    try {
      final json = jsonDecode(body);
      if (json is Map<String, dynamic>) {
        return json['mensaje'] as String? ?? json['message'] as String? ?? json['detail'] as String?;
      }
    } catch (_) {}
    return null;
  }

  void dispose() => _client.close();
}
