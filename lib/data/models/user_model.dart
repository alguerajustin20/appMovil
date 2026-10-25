class UserModel {
  final int? id;
  final int idRol;
  final String nombreCompleto;
  final String username;
  final String? password;
  final bool activo;

  UserModel({
    this.id,
    required this.idRol,
    required this.nombreCompleto,
    required this.username,
    this.password,
    required this.activo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id_usuario'] ?? json['id'],
      idRol: json['id_rol'] ?? 1,
      nombreCompleto: json['nombre_completo'] ?? json['nombre'] ?? '',
      username: json['username'] ?? '',
      password: json['Password'] ?? json['password_hash'] ?? json['password'],
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id_usuario': id,
      'id_rol': idRol,
      'nombre_completo': nombreCompleto,
      'username': username,
     
      'Password': password != null && password!.isNotEmpty ? password : '',
      'password_hash': password != null && password!.isNotEmpty ? password : '',
      'activo': activo,
    };
  }
}