import 'package:flutter/material.dart';
import '../../../../themes/app_theme.dart';

class DashboardCards extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final IconData icon;
  final Color iconColor;
  final Widget? badge;

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
    final c = context.palette;

    return Card(
      color: c.card,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 13, color: c.textMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
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
                if (badge != null) badge!,
                Icon(icon, color: iconColor.withValues(alpha: 0.8), size: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
