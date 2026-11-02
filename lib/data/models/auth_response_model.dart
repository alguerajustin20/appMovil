class AuthResponseModel {
  final bool exito;
  final String mensaje;
  final String accessToken;
  final String refreshToken;
  final UserInfoModel? usuario;

  AuthResponseModel({
    required this.exito,
    required this.mensaje,
    required this.accessToken,
    required this.refreshToken,
    this.usuario,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      exito: json['exito'] ?? false,
      mensaje: json['mensaje'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      usuario: json['usuario'] != null
          ? UserInfoModel.fromJson(json['usuario'])
          : null,
    );
  }
}

class UserInfoModel {
  final int idUsuario;
  final String username;
  final String nombreCompleto;
  final int idRol;

  UserInfoModel({
    required this.idUsuario,
    required this.username,
    required this.nombreCompleto,
    required this.idRol,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      idUsuario: json['idUsuario'] ?? json['id_usuario'] ?? 0,
      username: json['username'] ?? '',
      nombreCompleto: json['nombreCompleto'] ?? json['nombre_completo'] ?? '',
      idRol: json['idRol'] ?? json['id_rol'] ?? 0,
    );
  }
}
