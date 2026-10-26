import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/themes/app_colors.dart';
import 'package:integrador_vi_mobile/themes/app_theme.dart';
import '../../../../data/models/factura_model.dart'; // Importación del modelo profesional

class FacturaList extends StatelessWidget {
  final List<FacturaModel>
  filteredFacturas;
  final AppPalette palette;
  final Function(FacturaModel, int)
  onViewDetailsPressed; // Tipado fuerte aplicado
  final Function(FacturaModel) onToggleActive; // Tipado fuerte aplicado

  const FacturaList({
    super.key,
    required this.filteredFacturas,
    required this.palette,
    required this.onViewDetailsPressed,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredFacturas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: palette.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              'No hay facturas registradas',
              style: TextStyle(
                fontSize: 15,
                color: palette.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: filteredFacturas.length,
      itemBuilder: (context, index) {
        final factura = filteredFacturas[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: palette.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: palette.cardBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      factura.numeroFacturaFiscal,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Mes • ${factura.obtenerMesCalculado()}',
                      style: TextStyle(fontSize: 12, color: palette.textMuted),
                    ),
                  ],
                ),
              ),

              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onViewDetailsPressed(factura, index),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 6.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Detalle',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.teal,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.visibility_outlined,
                          size: 18,
                          color: AppColors.teal,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
