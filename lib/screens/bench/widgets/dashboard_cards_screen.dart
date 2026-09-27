import 'package:flutter/material.dart';

class DashboardCards extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final IconData icon;
  final Color iconColor;
  final Widget?
  badge; // Widget opcional por si se quiere meter un contenedor por ejemplo en éste caso el de "URGENTES"

  const DashboardCards({
    super.key,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.icon,
    required this.iconColor,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primera línea: Título
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
              maxLines: 1,
              overflow: TextOverflow
                  .ellipsis, // Si el texto es muy largo, se añade "..."
            ),
            const Spacer(), // Distribuye dinámicamente el espacio vertical
            // Segunda línea: Valor, Badge (si existe) e Icono
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                // Si se pasa un badge (como el de URGENTES), se dibuja aquí en medio
                if (badge != null) badge!,

                Icon(icon, color: iconColor.withValues(alpha: 0.4), size: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }
}