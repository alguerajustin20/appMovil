import 'package:flutter/material.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_theme.dart';

Future<void> showHelpDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final c = dialogContext.palette;

      return AlertDialog(
        backgroundColor: c.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.help_outline, color: AppColors.teal),
            const SizedBox(width: 8),
            Text('Centro de Ayuda', style: TextStyle(color: c.textPrimary)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Necesitas ayuda con Campestre Admin?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Consulta las guías rápidas sobre inventario, órdenes y gestión '
              'de usuarios, o escríbenos directamente si tienes un problema '
              'con tu cuenta.',
              style: TextStyle(fontSize: 13, color: c.textMuted),
            ),
            const SizedBox(height: 14),
            const Row(
              children: [
                Icon(Icons.email_outlined, size: 16, color: AppColors.teal),
                SizedBox(width: 6),
                Text(
                  'soporte@campestreadmin.com',
                  style: TextStyle(fontSize: 13, color: AppColors.teal),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Entendido',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
