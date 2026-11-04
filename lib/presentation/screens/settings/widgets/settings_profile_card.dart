import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_theme.dart';

class SettingsProfileCard extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userRole;
  final VoidCallback onEdit;

  const SettingsProfileCard({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userRole,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.cardBorder),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.mustardLight,
            child: Icon(Icons.person, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: c.textPrimary,
                  ),
                ),
                Text(
                  userEmail,
                  style: TextStyle(color: c.textMuted, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    userRole,
                    style: const TextStyle(
                      color: AppColors.teal,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //IconButton(
          //   icon: const Icon(
          //     Icons.edit_outlined,
          //     color: AppColors.brownLight,
          //    size: 20,
          //  ),
          //  onPressed: onEdit,
          // ),
        ],
      ),
    );
  }
}
