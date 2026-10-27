import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/theme/app_colors.dart';
import '../../../../../theme/app_theme.dart';
import '../../../../data/models/user_model.dart';

class UserListItem extends StatelessWidget {
  final UserModel user;
  final AppPalette palette;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  const UserListItem({
    super.key,
    required this.user,
    required this.palette,
    required this.onEdit,
    required this.onToggleStatus,
  });

  String _getRoleName(int idRol) {
    switch (idRol) {
      case 1:
        return 'Admin';
      case 2:
        return 'Cajero';
      case 3:
        return 'Mesero';
      case 4:
        return 'Cocinero';
      default:
        return 'Cajero';
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = palette;
    final roleName = _getRoleName(user.idRol);

    return Opacity(
      opacity: user.activo ? 1.0 : 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: user.activo
                ? AppColors.teal.withValues(alpha: 0.3)
                : c.cardBorder,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: user.activo
                  ? AppColors.teal.withValues(alpha: 0.15)
                  : Colors.grey.withValues(alpha: 0.2),
              child: Text(
                user.nombreCompleto.isNotEmpty ? user.nombreCompleto[0].toUpperCase() : 'U',
                style: TextStyle(
                  color: user.activo ? AppColors.teal : c.textMuted,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.nombreCompleto,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: user.activo
                              ? AppColors.teal.withValues(alpha: 0.1)
                              : Colors.grey.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          roleName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: user.activo ? AppColors.teal : c.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@${user.username}',
                    style: TextStyle(fontSize: 12, color: c.textMuted),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                size: 20,
                color: AppColors.teal,
              ),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(
                user.activo
                    ? Icons.toggle_on_rounded
                    : Icons.toggle_off_rounded,
                size: 28,
                color: user.activo
                    ? AppColors.teal
                    : Colors.redAccent.withValues(alpha: 0.7),
              ),
              onPressed: onToggleStatus,
            ),
          ],
        ),
      ),
    );
  }
}