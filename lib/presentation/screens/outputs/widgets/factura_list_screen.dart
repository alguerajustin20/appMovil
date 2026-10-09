import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/themes/app_colors.dart';
import 'package:integrador_vi_mobile/themes/app_theme.dart';

class FacturaList extends StatelessWidget {
  final List<dynamic> filteredFacturas;
  final AppPalette palette;
  final Function(dynamic, int) onViewDetailsPressed;
  final Function(dynamic) onToggleActive;

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
            border: Border.all(
              color: factura.isActive
                  ? AppColors.teal.withOpacity(0.3)
                  : palette.cardBorder,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      factura.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => onToggleActive(factura),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: factura.isActive
                                  ? Colors.green.withOpacity(0.12)
                                  : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              factura.isActive ? 'Activa' : 'Inactiva',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: factura.isActive
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mes • ${factura.mes}',
                      style: TextStyle(fontSize: 12, color: palette.textMuted),
                    ),
                  ],
                ),
              ),

              // Se añade el widget Material para activar el efecto de onda táctil (Ripple)
              Material(
                color: Colors
                    .transparent, // Mantiene el fondo limpio de tu tarjeta
                child: InkWell(
                  onTap: () => onViewDetailsPressed(factura, index),
                  borderRadius: BorderRadius.circular(
                    8,
                  ), // Redondeado para que la onda no se desborde
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 6.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Detalle',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.teal,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
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
