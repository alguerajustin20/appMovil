class MetricModel {
  final String id;
  final String timestamp;
  final String method;
  final String path;
  final int statusCode;
  final int durationMs;
  final String ipAddress;
  final String username;
  final String? exceptionMessage;

  MetricModel({
    required this.id,
    required this.timestamp,
    required this.method,
    required this.path,
    required this.statusCode,
    required this.durationMs,
    required this.ipAddress,
    required this.username,
    this.exceptionMessage,
  });

  factory MetricModel.fromJson(Map<String, dynamic> json) {
    return MetricModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      timestamp:
          json['Timestamp']?.toString() ??
          json['timestamp']?.toString() ??
          DateTime.now().toString(),
      method: json['Method']?.toString() ?? json['method']?.toString() ?? 'GET',
      path: json['Path']?.toString() ?? json['path']?.toString() ?? '',
      statusCode: json['StatusCode'] ?? json['statusCode'] ?? 200,
      durationMs: json['DurationMs'] ?? json['durationMs'] ?? 0,
      ipAddress:
          json['IpAddress']?.toString() ?? json['ipAddress']?.toString() ?? '',
      username:
          json['Username']?.toString() ??
          json['username']?.toString() ??
          'Anónimo',
      exceptionMessage:
          json['ExceptionMessage']?.toString() ??
          json['exceptionMessage']?.toString(),
    );
  }

  // Getter para parsear la fecha de MongoDB
  DateTime get fecha {
    try {
      return DateTime.parse(timestamp);
    } catch (_) {
      return DateTime.now();
    }
  }

  // Lo que se muestra como título principal en la tarjeta
  String get accion => '$method $path';

  // Detalle secundario enriquecido para el BottomSheet o subtítulo
  String get descripcion =>
      'Estado: $statusCode | Duración: ${durationMs}ms | IP: $ipAddress';

  String get usuario => username;
}

/// Modelo para los datos de rendimiento / telemetría de MongoDB (/api/Metrics/requests)
class RequestMetricModel {
  final String id;
  final String timestamp;
  final String correlationId;
  final String method;
  final String route;
  final int statusCode;
  final int durationMs;
  final int sqlMs;
  final int redisMs;
  final int appMs;
  final String username;
  final String ipAddress;

  RequestMetricModel({
    required this.id,
    required this.timestamp,
    required this.correlationId,
    required this.method,
    required this.route,
    required this.statusCode,
    required this.durationMs,
    required this.sqlMs,
    required this.redisMs,
    required this.appMs,
    required this.username,
    required this.ipAddress,
  });

  factory RequestMetricModel.fromJson(Map<String, dynamic> json) {
    return RequestMetricModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      timestamp:
          json['Timestamp']?.toString() ?? json['timestamp']?.toString() ?? '',
      correlationId:
          json['CorrelationId']?.toString() ??
          json['correlationId']?.toString() ??
          '',
      method: json['Method']?.toString() ?? json['method']?.toString() ?? 'GET',
      route:
          json['Route']?.toString() ??
          json['route']?.toString() ??
          json['Path']?.toString() ??
          '',
      statusCode: json['StatusCode'] ?? json['statusCode'] ?? 200,
      durationMs: json['DurationMs'] ?? json['durationMs'] ?? 0,
      sqlMs: json['SqlMs'] ?? json['sqlMs'] ?? 0,
      redisMs: json['RedisMs'] ?? json['redisMs'] ?? 0,
      appMs: json['AppMs'] ?? json['appMs'] ?? 0,
      username:
          json['Username']?.toString() ??
          json['username']?.toString() ??
          'Anónimo',
      ipAddress:
          json['IpAddress']?.toString() ?? json['ipAddress']?.toString() ?? '',
    );
  }
}
