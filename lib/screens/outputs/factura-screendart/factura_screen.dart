import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/screens/outputs/widgets/factura_filter_screen.dart';
import 'package:integrador_vi_mobile/screens/outputs/widgets/factura_list_screen.dart';
import 'package:integrador_vi_mobile/screens/outputs/widgets/factura_search_screen.dart';
import 'package:integrador_vi_mobile/themes/app_theme.dart';
import 'package:integrador_vi_mobile/widgets/custom_bottom_navigation.dart';

class Factura {
  final String name;
  final String mes;
  bool isActive;

  // Variables requeridas para el pop-up informativo
  final String idFactura;
  final String idOrden;
  final String idMeseroAtendiente;
  final String idCajeroCobrador;
  final String fechaEmision;
  final String metodoPago;
  final String subtotal;
  final String montoImpuestos;
  final String montoPropina;
  final String montoTotal;
  final String numeroFacturaFiscal;

  Factura({
    required this.name,
    required this.mes,
    this.isActive = true,
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
  });
}

class FacturaScreen extends StatefulWidget {
  const FacturaScreen({super.key});

  @override
  State<FacturaScreen> createState() => _FacturaScreenState();
}

class _FacturaScreenState extends State<FacturaScreen> {
  String _selectedFilter = 'Todas';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['Todas', 'Activas', 'Inactivas'];

  // 🎲 LISTA CON DATOS TOTALMENTE AL AZAR GENERADOS INDEPENDIENTEMENTE PARA CADA FACTURA
  final List<Factura> _facturaList = [
    Factura(
      name: 'FAC001',
      mes: 'Marzo',
      isActive: true,
      idFactura: '87612',
      idOrden: '4491',
      idMeseroAtendiente: '4',
      idCajeroCobrador: '2',
      fechaEmision: '12/03/2026',
      metodoPago: 'Efectivo',
      subtotal: '\$35.50',
      montoImpuestos: '\$5.32',
      montoPropina: '\$3.50',
      montoTotal: '\$44.32',
      numeroFacturaFiscal: 'NF-0009841',
    ),
    Factura(
      name: 'FAC002',
      mes: 'Junio',
      isActive: false,
      idFactura: '12904',
      idOrden: '8812',
      idMeseroAtendiente: '11',
      idCajeroCobrador: '1',
      fechaEmision: '24/06/2026',
      metodoPago: 'Tarjeta de Crédito',
      subtotal: '\$120.00',
      montoImpuestos: '\$18.00',
      montoPropina: '\$15.00',
      montoTotal: '\$153.00',
      numeroFacturaFiscal: 'NF-0010415',
    ),
    Factura(
      name: 'FAC003',
      mes: 'Enero',
      isActive: true,
      idFactura: '5102',
      idOrden: '2195',
      idMeseroAtendiente: '2',
      idCajeroCobrador: '2',
      fechaEmision: '15/01/2026',
      metodoPago: 'Transferencia',
      subtotal: '\$68.25',
      montoImpuestos: '\$10.24',
      montoPropina: '\$6.00',
      montoTotal: '\$84.49',
      numeroFacturaFiscal: 'NF-0008512',
    ),
    Factura(
      name: 'FAC004',
      mes: 'Noviembre',
      isActive: true,
      idFactura: '4',
      idOrden: '7764',
      idMeseroAtendiente: '8',
      idCajeroCobrador: '1',
      fechaEmision: '09/11/2026',
      metodoPago: 'Tarjeta de Débito',
      subtotal: '\$42.10',
      montoImpuestos: '\$6.31',
      montoPropina: '\$4.00',
      montoTotal: '\$52.41',
      numeroFacturaFiscal: 'NF-0011984',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtra de manera exacta las facturas evaluando el campo del Mes (.mes)
  List<Factura> get _filteredFacturas {
    return _facturaList.where((factura) {
      final query = _searchController.text.toLowerCase().trim();
      final matchesSearch = factura.mes.toLowerCase().contains(query);

      final cleanFilter = _selectedFilter.trim();
      bool matchesStatus = cleanFilter == 'Todas';
      if (!matchesStatus) {
        if (cleanFilter == 'Activas') matchesStatus = factura.isActive;
        if (cleanFilter == 'Inactivas') matchesStatus = !factura.isActive;
      }

      return matchesSearch && matchesStatus;
    }).toList();
  }

  void _openFacturaDetailsModal(AppPalette c, Factura factura) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // 🛡️ SOLUCIÓN: El SafeArea evita que la barra del Xiaomi POCO F7 tape el botón rojo
        return SafeArea(
          top: false,
          bottom:
              true, // 👈 Crea el colchón dinámico contra los botones del sistema
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
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

                const SizedBox(height: 16),

                _buildTextRow('Id_factura: ', factura.idFactura, c),
                _buildTextRow('Id_orden: ', factura.idOrden, c),
                _buildTextRow(
                  'Id_mesero_atendiente: ',
                  factura.idMeseroAtendiente,
                  c,
                ),
                _buildTextRow(
                  'Id_cajero_cobrador: ',
                  factura.idCajeroCobrador,
                  c,
                ),
                _buildTextRow('Fecha_emision: ', factura.fechaEmision, c),
                _buildTextRow('Metodo_pago: ', factura.metodoPago, c),
                _buildTextRow('Subtotal: ', factura.subtotal, c),
                _buildTextRow('Monto_impuestos: ', factura.montoImpuestos, c),
                _buildTextRow('Monto_propina: ', factura.montoPropina, c),
                _buildTextRow('Monto_total: ', factura.montoTotal, c),
                _buildTextRow(
                  'Numero_factura_fiscal: ',
                  factura.numeroFacturaFiscal,
                  c,
                ),
                _buildTextRow('Activo: ', factura.isActive ? 'Si' : 'No', c),

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

  // Helper para pintar de forma limpia cada línea de texto plano con encabezado en negrita
  Widget _buildTextRow(String header, String value, AppPalette c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
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
          'Visualización de Factura',
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
                  onToggleActive: (factura) {
                    setState(() {
                      factura.isActive = !factura.isActive;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
