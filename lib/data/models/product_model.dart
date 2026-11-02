class ProductModel {
  final int? id;
  final String nombre;
  final String categoria;
  final int stock;
  final bool activo;
  
  String get name => nombre;
  String get category => categoria;
  bool get isActive => activo;

  ProductModel({
    this.id,
    required this.nombre,
    required this.categoria,
    required this.stock,
    required this.activo,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id_producto'],
      nombre: json['nombre'] ?? '',
      categoria: json['nombreCategoria'] ?? json['id_categoria']?.toString() ?? 'General',
      stock: json['stock_actual'] ?? 0,
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id_producto': id,
      'nombre': nombre,
      'id_categoria': int.tryParse(categoria) ?? 1,
      'nombreCategoria': categoria, // Satisface la validación requerida por el backend en .NET
      'stock_actual': stock,
      'activo': activo,
    };
  }
}