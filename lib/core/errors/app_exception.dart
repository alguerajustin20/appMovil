sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// No connection, DNS failure, timeout, etc.
class NetworkException extends AppException {
  const NetworkException([
    super.message =
        'No se pudo conectar con el servidor Docker. Verifica tu conexión.',
  ]);
}

class ServerException extends AppException {
  const ServerException(super.message, {this.statusCode});

  final int? statusCode;
}

class ParsingException extends AppException {
  const ParsingException([
    super.message = 'Formato de respuesta inesperado del servidor.',
  ]);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Acceso no autorizado. Inicia sesión nuevamente.',
  ]);
}

class ForbiddenException extends AppException {
  const ForbiddenException([
    super.message =
        'Acceso Denegado: Tu rol no tiene permisos para esta acción.',
  ]);
}

class NotFoundException extends AppException {
  const NotFoundException([
    super.message = 'El recurso solicitado no fue encontrado.',
  ]);
}
