import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

/// Botón de cerrar sesión. La navegación la decide la pantalla que lo usa.
class SettingsLogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SettingsLogoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: SizedBox(
          width: 22,
          height: 22,
          child: Image.asset(
            'assets/icons/log/cerrar_sesion_blanca.png',
            fit: BoxFit.contain,
            color: AppColors.danger,
          ),
        ),
        label: const Text(
          'CERRAR SESIÓN',
          style: TextStyle(
            color: AppColors.danger,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.danger.withValues(alpha: 0.08),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
