import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  /// Obtiene la URL base de la API.
  /// Si existe en el .env la usa; si no, toma por defecto la IP del emulador (10.0.2.2:8080).
  String get baseUrl {
    try {
      final configured = dotenv.env['API_BASE_URL'];
      if (configured != null && configured.isNotEmpty) {
        if (!kIsWeb && Platform.isAndroid && configured.contains('localhost')) {
          return configured.replaceAll('localhost', '10.0.2.2');
        }
        return configured;
      }
    } catch (_) {
      // Manejo preventivo si dotenv no fue cargado
    }

    // Si es un emulador de Android, usa 10.0.2.2; de lo contrario, localhost
    // if (!kIsWeb && Platform.isAndroid) {
    //   return 'http://10.0.2.2:8080';
    // }
    return 'https://abuelapatio-atf8cag0bvgxcqbt.canadacentral-01.azurewebsites.net';
  }

  ApiConstants._privateConstructor();
  static final ApiConstants _instance = ApiConstants._privateConstructor();
  static ApiConstants get instance => _instance;

  // Endpoints de Categorías (Swagger)
  static const String categorias = '/api/Categorias';
  static const String categoriasActivos = '/api/Categorias/activos';
  static const String categoriasInactivos = '/api/Categorias/inactivos';
  static const String categoriasBuscar = '/api/Categorias/buscar';
  static const String categoriasRestaurar = '/api/Categorias/restaurar';

  // Endpoints de Productos (Swagger)
  static const String productos = '/api/Productos';
  static const String productosActivos = '/api/Productos/activos';
  static const String productosInactivos = '/api/Productos/inactivos';
  static const String productosBuscar = '/api/Productos/buscar';
  static const String productosRestaurar = '/api/Productos/restaurar';

  // Endpoints de Usuarios (Swagger)
  static const String usuarios = '/api/Usuarios';

  // Endpoints de Autenticación Reales
  static const String login = '/api/Auth/login';
  static const String refresh = '/api/Auth/refresh';
  static const String logout = '/api/Auth/logout';
  static const String systemLogs = '/api/Metrics/system-logs';
  static const String metricRequests = '/api/Metrics/requests';

  static const Duration timeoutDuration = Duration(seconds: 30);
}