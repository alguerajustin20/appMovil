class CategoriaModel {
  final int idCategoria;
  final String nombre;
  final bool activo;

  const CategoriaModel({
    required this.idCategoria,
    required this.nombre,
    required this.activo,
  });

  // Getters auxiliares para mantener compatibilidad con los widgets existentes
  String get code => idCategoria.toString();
  String get name => nombre;
  bool get isActive => activo;

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      idCategoria: (json['id_categoria'] as num?)?.toInt() ?? 
                   (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_categoria': idCategoria,
      'nombre': nombre,
      'activo': activo,
    };
  }

  CategoriaModel copyWith({
    int? idCategoria,
    String? nombre,
    bool? activo,
  }) {
    return CategoriaModel(
      idCategoria: idCategoria ?? this.idCategoria,
      nombre: nombre ?? this.nombre,
      activo: activo ?? this.activo,
    );
  }

  @override
  String toString() => 'CategoriaModel(id: $idCategoria, nombre: $nombre, activo: $activo)';
}
