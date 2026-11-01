import 'package:integrador_vi_mobile/core/constants/api_constants.dart';
import 'package:integrador_vi_mobile/core/network/api_client.dart';
import 'package:flutter/foundation.dart';

class MetricsService {
  final ApiClient _apiClient;

  MetricsService(this._apiClient);

  /// Obtiene los logs generales del sistema (/api/Metrics/system-logs)
  Future<List<dynamic>> getSystemLogs() async {
    try {
      final response = await _apiClient.get(ApiConstants.systemLogs);
      return _parseListResponse(response);
    } catch (e) {
      debugPrint(' Error en getSystemLogs: $e');
      throw Exception('Error al obtener la bitácora de actividad: $e');
    }
  }

  /// Obtiene la telemetría y métricas de rendimiento (/api/Metrics/requests)
  Future<List<dynamic>> getRequestMetrics() async {
    try {
      final response = await _apiClient.get(ApiConstants.metricRequests);
      return _parseListResponse(response);
    } catch (e) {
      debugPrint(' Error en getRequestMetrics: $e');
      throw Exception('Error al obtener las métricas de rendimiento: $e');
    }
  }

  /// Método auxiliar para extraer la lista de cualquier envoltorio del API
  List<dynamic> _parseListResponse(dynamic response) {
    if (response is List) {
      return response;
    } else if (response is Map<String, dynamic>) {
      for (var key in ['data', 'items', 'result', 'value']) {
        if (response.containsKey(key) && response[key] is List) {
          return response[key] as List<dynamic>;
        }
      }
      for (var entry in response.entries) {
        if (entry.value is List) {
          return entry.value as List<dynamic>;
        }
      }
    }
    return [];
  }
}
