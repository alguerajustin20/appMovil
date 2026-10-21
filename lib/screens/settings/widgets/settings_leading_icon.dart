import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// Ícono PNG con su par claro/oscuro. Elige solo según el tema activo.
class SettingsLeadingIcon extends StatelessWidget {
  final String lightPath;
  final String darkPath;

  const SettingsLeadingIcon({
    super.key,
    required this.lightPath,
    required this.darkPath,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;

    return SizedBox(
      width: 22,
      height: 22,
      child: Image.asset(
        c.isDark ? darkPath : lightPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.image_not_supported, size: 22, color: c.textMuted),
      ),
    );
  }
}
