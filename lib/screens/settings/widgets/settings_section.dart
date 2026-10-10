import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// Etiqueta de sección + tarjeta con sus filas. Inserta los divisores solo.
class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;

    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i < children.length - 1) {
        items.add(Divider(height: 1, indent: 52, color: c.cardBorder));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4),
          child: Text(
            title,
            style: TextStyle(
              color: c.sectionLabel,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        // Material (y no Container con color) para que el efecto de toque
        // de los ListTile se vea sobre la tarjeta.
        Material(
          color: c.card,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: c.cardBorder),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}
