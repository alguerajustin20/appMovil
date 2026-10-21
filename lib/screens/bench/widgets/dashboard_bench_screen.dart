import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/themes/app_colors.dart';
import '../../../themes/app_theme.dart';

class DashboardBench extends StatefulWidget {
  const DashboardBench({super.key});

  @override
  State<DashboardBench> createState() => _DashboardBench();
}

class _DashboardBench extends State<DashboardBench> {
  int selectedBarIndex = -1;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;

    return Card(
      color: c.card,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Frecuencia de Productos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 230,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final drawingHeight = constraints.maxHeight - 49;

                  double calculateHeight(double value) {
                    return (value / 1000) * drawingHeight;
                  }

                  final List<Map<String, dynamic>> barData = [
                    {'day': 'Lun', 'value': 600.0, 'color': AppColors.teal},
                    {'day': 'Mar', 'value': 820.0, 'color': AppColors.teal},
                    {'day': 'Mie', 'value': 400.0, 'color': AppColors.teal},
                    {
                      'day': 'Jue',
                      'value': 700.0,
                      'color': const Color(0xFF90B9C6),
                    },
                    {'day': 'Vie', 'value': 1000.0, 'color': AppColors.teal},
                    {'day': 'Sab', 'value': 300.0, 'color': AppColors.brown},
                    {'day': 'Dom', 'value': 500.0, 'color': AppColors.teal},
                  ];

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: 32,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: drawingHeight,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    bottom: calculateHeight(1000) - 6,
                                    right: 0,
                                    child: Text(
                                      '1000',
                                      style: TextStyle(
                                        color: c.textMuted,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: calculateHeight(500) - 6,
                                    right: 0,
                                    child: Text(
                                      '500',
                                      style: TextStyle(
                                        color: c.textMuted,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: calculateHeight(0) - 6,
                                    right: 0,
                                    child: Text(
                                      '0',
                                      style: TextStyle(
                                        color: c.textMuted,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(barData.length, (index) {
                            final item = barData[index];
                            final isSelected = selectedBarIndex == index;

                            return _buildInteractiveBar(
                              context: context,
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
            Divider(color: c.cardBorder, height: 1),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(context, 'Ingresos', AppColors.teal),
                const SizedBox(width: 24),
                _buildLegendItem(context, 'Salidas', AppColors.brown),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveBar({
    required BuildContext context,
    required int index,
    required String day,
    required double height,
    required String valueText,
    required Color barColor,
    required bool isSelected,
  }) {
    final c = context.palette;

    return GestureDetector(
      onTapDown: (_) => setState(() => selectedBarIndex = index),
      onTapUp: (_) => setState(() => selectedBarIndex = -1),
      onTapCancel: () => setState(() => selectedBarIndex = -1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
          const SizedBox(height: 8),
          SizedBox(
            height: 17,
            child: Text(
              day,
              style: TextStyle(
                color: isSelected ? c.textPrimary : c.textMuted,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    final c = context.palette;

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
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
