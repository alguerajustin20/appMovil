import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/themes/app_colors.dart';
import 'package:integrador_vi_mobile/themes/app_theme.dart';

class FacturaFilter extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final AppPalette palette;
  final Function(String) onFilterSelected;

  const FacturaFilter({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.palette,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return ChoiceChip(
            label: Text(
              filter,
              style: TextStyle(
                color: isSelected ? Colors.white : palette.textMuted,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
            selected: isSelected,
            selectedColor: AppColors.teal,
            backgroundColor: palette.card,
            side: BorderSide(
              color: isSelected ? AppColors.teal : palette.cardBorder,
            ),
            onSelected: (selected) {
              if (selected) {
                onFilterSelected(filter);
              }
            },
          );
        },
      ),
    );
  }
}
