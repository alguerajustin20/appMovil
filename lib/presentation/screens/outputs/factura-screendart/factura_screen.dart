import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/presentation/screens/outputs/widgets/factura_filter_screen.dart';
import 'package:integrador_vi_mobile/presentation/screens/outputs/widgets/factura_list_screen.dart';
import 'package:integrador_vi_mobile/presentation/screens/outputs/widgets/factura_search_screen.dart';
import 'package:integrador_vi_mobile/themes/app_theme.dart';

class Factura {
  final String name;
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
  final int mesa;

  Factura({
    required this.name,
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
    required this.mesa,
  });

  String obtenerMesCalculado() {
    if (fechaEmision.length >= 7) {
      String caracteresMes = fechaEmision.substring(5, 7);
      switch (caracteresMes) {
        case '01':
          return 'Enero';
        case '02':
          return 'Febrero';
        case '03':
          return 'Marzo';
        case '04':
          return 'Abril';
        case '05':
          return 'Mayo';
        case '06':
          return 'Junio';
        case '07':
          return 'Julio';
        case '08':
          return 'Agosto';
        case '09':
          return 'Septiembre';
        case '10':
          return 'Octubre';
        case '11':
          return 'Noviembre';
        case '12':
          return 'Diciembre';
        default:
          return 'Indefinido';
      }
    }
    return 'Indefinido';
  }
}

class FacturaScreen extends StatefulWidget {
  const FacturaScreen({super.key});

  @override
  State<FacturaScreen> createState() => _FacturaScreenState();
}

class _FacturaScreenState extends State<FacturaScreen> {
  String _selectedFilter = 'Todas las Facturas';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = [
    'Todas las Facturas',
    'Con Tarjeta',
    'Con Efectivo',
  ];

  final List<Factura> _facturaList = [
    Factura(
      name: 'FAC001',
      idFactura: 1090,
      idOrden: 8,
      idMeseroAtendiente: 1,
      idCajeroCobrador: 1,
      fechaEmision: '2026-06-20T17:58:58.657',
      metodoPago: 'Efectivo',
      subtotal: 455.00,
      montoImpuestos: 68.25,
      montoPropina: 0.00,
      montoTotal: 523.25,
      numeroFacturaFiscal: 'FAC-202600071',
      mesa: 3,
    ),
    Factura(
      name: 'FAC002',
      idFactura: 1091,
      idOrden: 12,
      idMeseroAtendiente: 3,
      idCajeroCobrador: 2,
      fechaEmision: '2026-01-15T11:22:14.301',
      metodoPago: 'Tarjeta de Crédito',
      subtotal: 820.00,
      montoImpuestos: 123.00,
      montoPropina: 40.00,
      montoTotal: 983.00,
      numeroFacturaFiscal: 'FAC-202600072',
      mesa: 1,
    ),
    Factura(
      name: 'FAC003',
      idFactura: 1092,
      idOrden: 5,
      idMeseroAtendiente: 2,
      idCajeroCobrador: 1,
      fechaEmision: '2026-04-10T20:05:33.112',
      metodoPago: 'Tarjeta de Débito',
      subtotal: 210.00,
      montoImpuestos: 31.50,
      montoPropina: 15.00,
      montoTotal: 256.50,
      numeroFacturaFiscal: 'FAC-202600073',
      mesa: 5,
    ),
    Factura(
      name: 'FAC004',
      idFactura: 1093,
      idOrden: 19,
      idMeseroAtendiente: 1,
      idCajeroCobrador: 2,
      fechaEmision: '2026-06-28T23:14:02.994',
      metodoPago: 'Efectivo',
      subtotal: 340.00,
      montoImpuestos: 51.00,
      montoPropina: 20.00,
      montoTotal: 411.00,
      numeroFacturaFiscal: 'FAC-202600074',
      mesa: 2,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Factura> get _filteredFacturas {
    return _facturaList.where((factura) {
      final mesCalculado = factura.obtenerMesCalculado().toLowerCase();
      final query = _searchController.text.toLowerCase().trim();

      final matchesSearch = query.isEmpty || mesCalculado.contains(query);

      final cleanFilter = _selectedFilter.trim();
      bool matchesPayment = cleanFilter == 'Todas las Facturas';
      if (!matchesPayment) {
        if (cleanFilter == 'Con Tarjeta') {
          matchesPayment = factura.metodoPago.toLowerCase().contains('tarjeta');
        }
        if (cleanFilter == 'Con Efectivo') {
          matchesPayment = factura.metodoPago.toLowerCase() == 'efectivo';
        }
      }

      return matchesSearch && matchesPayment;
    }).toList();
  }

  void _openFacturaDetailsModal(AppPalette c, Factura factura) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.card,
      // 🛡️ SE ACTIVA EL BLOQUEO TÁCTIL: Solo se cierra con el botón rojo
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Detalle de Factura',
                    style: TextStyle(
                      color: Colors.transparent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: c.isDark
                          ? const Color(0xFF00B4D8)
                          : const Color(0xFF03738C),
                      decorationThickness: 2.0,
                      shadows: [
                        Shadow(
                          color: c.isDark
                              ? const Color(0xFF00B4D8)
                              : const Color(0xFF03738C),
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                _buildTextRow('id_orden: ', factura.idOrden.toString(), c),
                _buildTextRow(
                  'id_mesero_atendiente: ',
                  factura.idMeseroAtendiente.toString(),
                  c,
                ),
                _buildTextRow(
                  'id_cajero_cobrador: ',
                  factura.idCajeroCobrador.toString(),
                  c,
                ),
                _buildTextRow('fecha_emision: ', factura.fechaEmision, c),
                _buildTextRow('metodo_pago: ', factura.metodoPago, c),
                _buildTextRow(
                  'subtotal: ',
                  '\$${factura.subtotal.toStringAsFixed(2)}',
                  c,
                ),
                _buildTextRow(
                  'monto_impuestos: ',
                  '\$${factura.montoImpuestos.toStringAsFixed(2)}',
                  c,
                ),
                _buildTextRow(
                  'monto_propina: ',
                  '\$${factura.montoPropina.toStringAsFixed(2)}',
                  c,
                ),
                _buildTextRow(
                  'monto_total: ',
                  '\$${factura.montoTotal.toStringAsFixed(2)}',
                  c,
                ),
                _buildTextRow(
                  'numero_factura_fiscal: ',
                  factura.numeroFacturaFiscal,
                  c,
                ),
                _buildTextRow('mesa: ', factura.mesa.toString(), c),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text(
                      'Dejar de visualizar Detalle',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextRow(String header, String value, AppPalette c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(fontSize: 14, color: c.textPrimary),
            children: [
              TextSpan(
                text: header,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final filtered = _filteredFacturas;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 20,
        title: Text(
          'Resumen Facturas activas',
          style: TextStyle(
            color: c.isDark ? const Color(0xFF00B4D8) : const Color(0xFF03738C),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              FacturaSearch(
                controller: _searchController,
                palette: c,
                onChanged: () => setState(() {}),
              ),
              const SizedBox(height: 16),
              FacturaFilter(
                filters: _filters,
                selectedFilter: _selectedFilter,
                palette: c,
                onFilterSelected: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FacturaList(
                  filteredFacturas: filtered,
                  palette: c,
                  onViewDetailsPressed: (factura, index) {
                    _openFacturaDetailsModal(c, factura);
                  },
                  onToggleActive: (factura) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
