class DetalleOrdenModel {
  final int idDetalle;
  final int idOrden;
  final int idProducto;
  final int cantidad;
  final double precioAlMomento;
  final String notas;
  final String estadoItem;
  final bool activo;
  final String nombreProducto;
  final double subtotal;

  DetalleOrdenModel({
    required this.idDetalle,
    required this.idOrden,
    required this.idProducto,
    required this.cantidad,
    required this.precioAlMomento,
    required this.notas,
    required this.estadoItem,
    required this.activo,
    required this.nombreProducto,
    required this.subtotal,
  });

  factory DetalleOrdenModel.fromJson(Map<String, dynamic> json) {
    return DetalleOrdenModel(
      idDetalle: json['id_detalle'] ?? 0,
      idOrden: json['id_orden'] ?? 0,
      idProducto: json['id_producto'] ?? 0,
      cantidad: json['cantidad'] ?? 0,
      precioAlMomento: (json['precio_al_momento'] ?? 0).toDouble(),
      notas: json['notas'] ?? '',
      estadoItem: json['estado_item'] ?? '',
      activo: json['activo'] ?? true,
      nombreProducto: json['nombreProducto'] ?? '',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }
}
