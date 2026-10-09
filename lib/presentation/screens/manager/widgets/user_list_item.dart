import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/themes/app_colors.dart';
import '../../../../themes/app_theme.dart';
import '../user-management-screen/user_management_screen.dart';

class UserListItem extends StatelessWidget {
  final User user;
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

  @override
  Widget build(BuildContext context) {
    final c = palette;

    return Opacity(
      opacity: user.isActive ? 1.0 : 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: user.isActive
                ? AppColors.teal.withOpacity(0.3)
                : c.cardBorder,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: user.isActive
                  ? AppColors.teal.withOpacity(0.15)
                  : Colors.grey.withOpacity(0.2),
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: TextStyle(
                  color: user.isActive ? AppColors.teal : c.textMuted,
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
                    user.name,
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
                          color: user.isActive
                              ? AppColors.teal.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          user.role,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: user.isActive ? AppColors.teal : c.textMuted,
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
                user.isActive
                    ? Icons.toggle_on_rounded
                    : Icons.toggle_off_rounded,
                size: 28,
                color: user.isActive
                    ? AppColors.teal
                    : Colors.redAccent.withOpacity(0.7),
              ),
              onPressed: onToggleStatus,
            ),
          ],
        ),
      ),
    );
  }
}
