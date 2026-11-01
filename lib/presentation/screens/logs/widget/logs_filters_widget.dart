import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../theme/app_theme.dart';

class LogsFiltersWidget extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;
  final AppPalette c;

  const LogsFiltersWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: ['Todos', 'Hoy', 'Este Mes'].map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                onFilterSelected(filter);
              },
              selectedColor: AppColors.teal,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : c.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              backgroundColor: c.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Colors.transparent : c.cardBorder,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
