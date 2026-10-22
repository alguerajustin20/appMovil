import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';
import '../models/auth_response_model.dart';

class AuthRepository {
  final http.Client _client;

  AuthRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<AuthResponseModel> login(String username, String password) async {
    final baseUrl = ApiConstants.instance.baseUrl;
    final url = Uri.parse('$baseUrl${ApiConstants.login}');

    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json', 'accept': '*/*'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final authResponse = AuthResponseModel.fromJson(data);

      // Guardar el Token de manera persistente en el dispositivo
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', authResponse.accessToken);
      await prefs.setString('refresh_token', authResponse.refreshToken);
      await prefs.setString('username', authResponse.usuario?.username ?? '');

      return authResponse;
    } else if (response.statusCode == 401) {
      throw const FormatException('Usuario o contraseña incorrectos.');
    } else {
      throw Exception('Error en el servidor (Código: ${response.statusCode})');
    }
  }
}
