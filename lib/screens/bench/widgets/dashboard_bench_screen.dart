import 'package:flutter/material.dart';

class DashboardBench extends StatefulWidget {
  const DashboardBench({super.key});

  @override
  State<DashboardBench> createState() => _DashboardBench();
}

class _DashboardBench extends State<DashboardBench> {
  // Se almacena el índice de la barra presionada por el usuario (-1 = ninguna)
  int selectedBarIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título interno del gráfico compacto
            const Text(
              'Velocidad de Inventario',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Área del Gráfico Coordinada en Altura
            SizedBox(
              height: 230, // Altura total fija del gráfico
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Reservamos exactamente 24px arriba para los globos (tooltips) y 25px abajo para las etiquetas del día
                  final drawingHeight = constraints.maxHeight - 49;

                  // Función matemática unificada para calcular la altura exacta de cualquier valor (Máx 1000)
                  double calculateHeight(double value) {
                    return (value / 1000) * drawingHeight;
                  }

                  // Mapeo exacto de tus datos y colores
                  final List<Map<String, dynamic>> barData = [
                    {
                      'day': 'Lun',
                      'value': 600.0,
                      'color': const Color(0xFF036573),
                    },
                    {
                      'day': 'Mar',
                      'value': 820.0,
                      'color': const Color(0xFF036573),
                    },
                    {
                      'day': 'Mie',
                      'value': 400.0,
                      'color': const Color(0xFF036573),
                    },
                    {
                      'day': 'Jue',
                      'value': 700.0,
                      'color': const Color(0xFF90B9C6),
                    },
                    {
                      'day': 'Vie',
                      'value': 1000.0,
                      'color': const Color(0xFF036573),
                    },
                    {
                      'day': 'Sab',
                      'value': 300.0,
                      'color': const Color(0xFF734610),
                    },
                    {
                      'day': 'Dom',
                      'value': 500.0,
                      'color': const Color(0xFF036573),
                    },
                  ];

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. EJE Y COHERENTE: Usa exactamente las mismas alturas calculadas matemáticamente
                      SizedBox(
                        width: 32,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Contenedor que simula la altura del tope (1000) hasta la base (0)
                            SizedBox(
                              height: drawingHeight,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // Etiqueta 1000: Alineada a la altura de una barra con valor 1000
                                  Positioned(
                                    bottom: calculateHeight(1000) - 6,
                                    right: 0,
                                    child: const Text(
                                      '1000',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  // Etiqueta 500: Alineada a la altura exacta del valor 500
                                  Positioned(
                                    bottom: calculateHeight(500) - 6,
                                    right: 0,
                                    child: const Text(
                                      '500',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  // Etiqueta 0: Alineada a la base exacta del gráfico
                                  Positioned(
                                    bottom: calculateHeight(0) - 6,
                                    right: 0,
                                    child: const Text(
                                      '0',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ), // 👈 Compensación exacta de la altura de la etiqueta de los días
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // 2. RENDERIZADOR DE BARRAS NATIVAS
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(barData.length, (index) {
                            final item = barData[index];
                            final isSelected = selectedBarIndex == index;

                            return _buildInteractiveBar(
                              index: index,
                              day: item['day'],
                              height: calculateHeight(item['value']),
                              valueText: item['value'].toStringAsFixed(0),
                              barColor: isSelected
                                  ? item['color']
                                  : item['color'].withValues(alpha: 0.85),
                              isSelected: isSelected,
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 14),
            const Divider(color: Color(0xFFF1F1F1), height: 1),
            const SizedBox(height: 16),

            // 3. Leyenda inferior
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Ingresos', const Color(0xFF036573)),
                const SizedBox(width: 24),
                _buildLegendItem('Salidas', const Color(0xFF734610)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper interno de barras interactivas
  Widget _buildInteractiveBar({
    required int index,
    required String day,
    required double height,
    required String valueText,
    required Color barColor,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTapDown: (_) => setState(() => selectedBarIndex = index),
      onTapUp: (_) => setState(() => selectedBarIndex = -1),
      onTapCancel: () => setState(() => selectedBarIndex = -1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Globo indicador (Ocupa exactamente 24px de alto fijo)
          SizedBox(
            height: 24,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: isSelected ? 1.0 : 0.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  valueText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // La Barra del Gráfico
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: isSelected ? 36 : 32,
            height: height,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: barColor.withValues(alpha: 0.35),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
          ),

          // Etiqueta de días (Ocupa exactamente 25px de alto total)
          const SizedBox(height: 8),
          SizedBox(
            height: 17,
            child: Text(
              day,
              style: TextStyle(
                color: isSelected ? Colors.black87 : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
