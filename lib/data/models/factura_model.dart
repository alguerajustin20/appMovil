class FacturaModel {
  final int idFactura;
  final int idOrden;
  final int idMeseroAtendiente;
  final int idCajeroCobrador;
  final String fechaEmision;
  final String metodoPago;
  final double subtotal;
  final double montoImpuestos;
  final double montoPropina;
  final double montoTotal;
  final String numeroFacturaFiscal;
  final bool activo;

  FacturaModel({
    required this.idFactura,
    required this.idOrden,
    required this.idMeseroAtendiente,
    required this.idCajeroCobrador,
    required this.fechaEmision,
    required this.metodoPago,
    required this.subtotal,
    required this.montoImpuestos,
    required this.montoPropina,
    required this.montoTotal,
    required this.numeroFacturaFiscal,
    required this.activo,
  });

  factory FacturaModel.fromJson(Map<String, dynamic> json) {
    return FacturaModel(
      idFactura: json['id_factura'] ?? 0,
      idOrden: json['id_orden'] ?? 0,
      idMeseroAtendiente: json['id_mesero_atendiente'] ?? 0,
      idCajeroCobrador: json['id_cajero_cobrador'] ?? 0,
      fechaEmision: json['fecha_emision'] ?? '',
      metodoPago: json['metodo_pago'] ?? '',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      montoImpuestos: (json['monto_impuestos'] ?? 0).toDouble(),
      montoPropina: (json['monto_propina'] ?? 0).toDouble(),
      montoTotal: (json['monto_total'] ?? 0).toDouble(),
      numeroFacturaFiscal: json['numero_factura_fiscal'] ?? '',
      activo: json['activo'] ?? true,
    );
  }
}
