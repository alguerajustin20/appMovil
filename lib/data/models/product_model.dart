class ProductModel {
  final int? id;
  final String nombre;
  final String categoria;
  final double precioUnitario;
  final int stock;
  final int stockMinimo;
  final bool activo;
  final bool esInventariable;

  String get name => nombre;
  String get category => categoria;
  double get price => precioUnitario;
  int get minStock => stockMinimo;
  bool get isActive => activo;

  ProductModel({
    this.id,
    required this.nombre,
    required this.categoria,
    required this.precioUnitario,
    required this.stock,
    required this.stockMinimo,
    required this.activo,
    required this.esInventariable,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id_producto'],
      nombre: json['nombre'] ?? '',
      categoria: json['nombreCategoria'] ?? json['id_categoria']?.toString() ?? 'General',
      precioUnitario: (json['precio_unitario'] ?? 0).toDouble(),
      stock: json['stock_actual'] ?? json['stock'] ?? 0,
      stockMinimo: json['stock_minimo'] ?? 0,
      activo: json['activo'] ?? true,
      esInventariable: json['es_inventariable'] ?? json['esInventariable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id_producto': id,
      'nombre': nombre,
      'id_categoria': int.tryParse(categoria) ?? 1,
      'nombreCategoria': categoria,
      'precio_unitario': precioUnitario,
      'stock_actual': stock,
      'stock_minimo': stockMinimo,
      'activo': activo,
      'es_inventariable': esInventariable,
    };
  }
}