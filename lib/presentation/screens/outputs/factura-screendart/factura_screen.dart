import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_theme.dart';
import '../../../providers/factura_provider.dart';
import '../../outputs/widgets/factura_filter_screen.dart';
import '../../outputs/widgets/factura_list_screen.dart';
import '../../outputs/widgets/factura_search_screen.dart';
import '../../../../data/models/factura_model.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FacturaProvider>().cargarFacturasActivas();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FacturaModel> _getFilteredFacturas(List<FacturaModel> backendFacturas) {
    return backendFacturas.where((factura) {
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

  void _openFacturaDetailsModal(AppPalette c, FacturaModel factura) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.card,
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
    final provider = context.watch<FacturaProvider>();
    final filtered = _getFilteredFacturas(provider.facturas);

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
              if (provider.isLoading) ...[
                const LinearProgressIndicator(
                  color: AppColors.teal,
                  minHeight: 3,
                ),
                const SizedBox(height: 8),
              ],
              if (provider.errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.red.withValues(alpha: 0.1),
                  child: Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 8),
              ],
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
