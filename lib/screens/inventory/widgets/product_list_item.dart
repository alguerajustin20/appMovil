import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/themes/app_colors.dart';
import '../../../themes/app_theme.dart';
import '../add_product_screen.dart';

class ProductListItem extends StatelessWidget {
  final ProductItem item;
  final bool isEditing;
  final AppPalette palette;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  const ProductListItem({
    super.key,
    required this.item,
    required this.isEditing,
    required this.palette,
    required this.onEdit,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final c = palette;
    return Opacity(
      opacity: item.isActive ? 1.0 : 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isEditing ? AppColors.teal.withOpacity(0.08) : c.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isEditing
                ? AppColors.teal
                : (item.isActive
                      ? AppColors.teal.withOpacity(0.3)
                      : c.cardBorder),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: item.isActive
                  ? AppColors.teal.withOpacity(0.15)
                  : Colors.grey.withOpacity(0.2),
              child: Text(
                item.name.isNotEmpty ? item.name[0].toUpperCase() : 'P',
                style: TextStyle(
                  color: item.isActive ? AppColors.teal : c.textMuted,
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
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: item.isActive
                          ? AppColors.teal.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.category,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: item.isActive ? AppColors.teal : c.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Stock: ${item.stock}',
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
                item.isActive
                    ? Icons.toggle_on_rounded
                    : Icons.toggle_off_rounded,
                size: 28,
                color: item.isActive
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
