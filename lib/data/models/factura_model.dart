class FacturaModel {
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

  const FacturaModel({
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
  });

  factory FacturaModel.fromJson(Map<String, dynamic> json) {
    return FacturaModel(
      idOrden: (json['id_orden'] as num?)?.toInt() ?? 0,
      idMeseroAtendiente: (json['id_mesero_atendiente'] as num?)?.toInt() ?? 0,
      idCajeroCobrador: (json['id_cajero_cobrador'] as num?)?.toInt() ?? 0,
      fechaEmision: json['fecha_emision'] as String? ?? '',
      metodoPago: json['metodo_pago'] as String? ?? 'Efectivo',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      montoImpuestos: (json['monto_impuestos'] as num?)?.toDouble() ?? 0.0,
      montoPropina: (json['monto_propina'] as num?)?.toDouble() ?? 0.0,
      montoTotal: (json['monto_total'] as num?)?.toDouble() ?? 0.0,
      numeroFacturaFiscal: json['numero_factura_fiscal'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_orden': idOrden,
      'id_mesero_atendiente': idMeseroAtendiente,
      'id_cajero_cobrador': idCajeroCobrador,
      'fecha_emision': fechaEmision,
      'metodo_pago': metodoPago,
      'subtotal': subtotal,
      'monto_impuestos': montoImpuestos,
      'monto_propina': montoPropina,
      'monto_total': montoTotal,
      'numero_factura_fiscal': numeroFacturaFiscal,
    };
  }

  String obtenerMesCalculado() {
    if (fechaEmision.length >= 7) {
      final caracteresMes = fechaEmision.substring(5, 7);
      switch (caracteresMes) {
        case '01': return 'Enero';
        case '02': return 'Febrero';
        case '03': return 'Marzo';
        case '04': return 'Abril';
        case '05': return 'Mayo';
        case '06': return 'Junio';
        case '07': return 'Julio';
        case '08': return 'Agosto';
        case '09': return 'Septiembre';
        case '10': return 'Octubre';
        case '11': return 'Noviembre';
        case '12': return 'Diciembre';
        default: return 'Indefinido';
      }
    }
    return 'Indefinido';
  }
}
