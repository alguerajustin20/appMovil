import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  String get baseUrl {
    final configured = dotenv.env['BASE_API_URL'] ?? 'http://localhost:8080';
    if (!kIsWeb && Platform.isAndroid && configured.contains('localhost')) {
      return configured.replaceAll('localhost', '10.0.2.2');
    }
    return configured;
  }

  String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
  String get apiUsername => dotenv.env['API_USERNAME'] ?? 'yamil72';
  String get apiPassword => dotenv.env['API_PASSWORD'] ?? '123456';

  ApiConstants._privateConstructor();
  static final ApiConstants _instance = ApiConstants._privateConstructor();
  static ApiConstants get instance => _instance;

  // Endpoints de Categorías (Swagger)
  static const String categorias = '/api/Categorias';
  static const String categoriasActivos = '/api/Categorias/activos';
  static const String categoriasInactivos = '/api/Categorias/inactivos';
  static const String categoriasBuscar = '/api/Categorias/buscar';
  static const String categoriasRestaurar = '/api/Categorias/restaurar';

  // Endpoints de Autenticación
  static const String login = '/api/Auth/login';
  static const String refresh = '/api/Auth/refresh';
  static const String logout = '/api/Auth/logout';

  static const Duration timeoutDuration = Duration(seconds: 30);
}
