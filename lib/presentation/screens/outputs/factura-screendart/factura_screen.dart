import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/core/network/api_client.dart';
import 'package:integrador_vi_mobile/data/models/factura_model.dart';
import 'package:integrador_vi_mobile/data/models/detalle_orden_model.dart';
import 'package:integrador_vi_mobile/data/repositories/factura_repository.dart';
import 'package:integrador_vi_mobile/presentation/screens/outputs/widgets/factura_filter_screen.dart';
import 'package:integrador_vi_mobile/presentation/screens/outputs/widgets/factura_list_screen.dart';
import 'package:integrador_vi_mobile/presentation/screens/outputs/widgets/factura_search_screen.dart';
import 'package:integrador_vi_mobile/theme/app_theme.dart';
import 'package:integrador_vi_mobile/theme/app_colors.dart';

class FacturaScreen extends StatefulWidget {
  const FacturaScreen({super.key});

  @override
  State<FacturaScreen> createState() => _FacturaScreenState();
}

class _FacturaScreenState extends State<FacturaScreen> {
  // Instanciamos el repositorio usando el ApiClient
  final FacturaRepository _facturaRepository = FacturaRepository(ApiClient());

  late Future<List<FacturaModel>> _futureFacturas;
  String _selectedFilter = 'Todas';
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = ['Todas', 'Activas', 'Inactivas'];

  @override
  void initState() {
    super.initState();
    _cargarFacturas();
  }

  void _cargarFacturas() {
    _futureFacturas = _facturaRepository.obtenerFacturasActivas();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFacturaDetailsModal(AppPalette c, FacturaModel factura) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: AppColors.teal)),
    );

    try {
      final List<DetalleOrdenModel> detalles = await _facturaRepository
          .obtenerDetallePorOrden(factura.idOrden);

      Navigator.pop(context);

      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: c.card,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return SafeArea(
            top: false,
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
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
                    _buildTextRow(
                      'Id_factura: ',
                      factura.idFactura.toString(),
                      c,
                    ),
                    _buildTextRow('Id_orden: ', factura.idOrden.toString(), c),
                    _buildTextRow(
                      'Id_mesero_atendiente: ',
                      factura.idMeseroAtendiente.toString(),
                      c,
                    ),
                    _buildTextRow(
                      'Id_cajero_cobrador: ',
                      factura.idCajeroCobrador.toString(),
                      c,
                    ),
                    _buildTextRow('Fecha_emision: ', factura.fechaEmision, c),
                    _buildTextRow('Metodo_pago: ', factura.metodoPago, c),
                    _buildTextRow(
                      'Subtotal: ',
                      '\$${factura.subtotal.toStringAsFixed(2)}',
                      c,
                    ),
                    _buildTextRow(
                      'Monto_impuestos: ',
                      '\$${factura.montoImpuestos.toStringAsFixed(2)}',
                      c,
                    ),
                    _buildTextRow(
                      'Monto_propina: ',
                      '\$${factura.montoPropina.toStringAsFixed(2)}',
                      c,
                    ),
                    _buildTextRow(
                      'Monto_total: ',
                      '\$${factura.montoTotal.toStringAsFixed(2)}',
                      c,
                    ),
                    _buildTextRow(
                      'Numero_factura_fiscal: ',
                      factura.numeroFacturaFiscal,
                      c,
                    ),
                    _buildTextRow('Activo: ', factura.activo ? 'Si' : 'No', c),

                    const Divider(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Productos en la Orden:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Lista de platillos/productos asociados a la orden
                    detalles.isEmpty
                        ? const Text(
                            'No hay detalles registrados para esta orden.',
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: detalles.length,
                            itemBuilder: (context, i) {
                              final item = detalles[i];
                              return ListTile(
                                dense: true,
                                title: Text(
                                  item.nombreProducto,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Cant: ${item.cantidad} • Nota: ${item.notas.isEmpty ? "Ninguna" : item.notas}',
                                ),
                                trailing: Text(
                                  '\$${item.subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
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
            ),
          );
        },
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar detalle: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                child: FutureBuilder<List<FacturaModel>>(
                  future: _futureFacturas,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.teal),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error al conectar con el servidor:\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red[300]),
                        ),
                      );
                    }

                    final listadoOriginal = snapshot.data ?? [];

                    if (listadoOriginal.isEmpty) {
                      return Center(
                        child: Text(
                          'No hay facturas registradas',
                          style: TextStyle(
                            fontSize: 15,
                            color: c.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    final filtered = listadoOriginal.where((factura) {
                      final query = _searchController.text.toLowerCase().trim();
                      final matchesSearch =
                          factura.numeroFacturaFiscal.toLowerCase().contains(
                            query,
                          ) ||
                          factura.idFactura.toString().contains(query);

                      final cleanFilter = _selectedFilter.trim();
                      bool matchesStatus = cleanFilter == 'Todas';
                      if (!matchesStatus) {
                        if (cleanFilter == 'Activas')
                          matchesStatus = factura.activo;
                        if (cleanFilter == 'Inactivas')
                          matchesStatus = !factura.activo;
                      }

                      return matchesSearch && matchesStatus;
                    }).toList();

                    return FacturaList(
                      filteredFacturas: filtered,
                      palette: c,
                      onViewDetailsPressed: (factura, index) {
                        _openFacturaDetailsModal(c, factura);
                      },
                      onToggleActive: (factura) {},
                    );
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
