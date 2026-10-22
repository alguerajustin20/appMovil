import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/theme/app_colors.dart';
import 'package:integrador_vi_mobile/theme/app_theme.dart';

class FacturaSearch extends StatelessWidget {
  final TextEditingController controller;
  final AppPalette palette;
  final VoidCallback onChanged;

  const FacturaSearch({
    super.key,
    required this.controller,
    required this.palette,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      style: TextStyle(color: palette.textPrimary),
      decoration: InputDecoration(
        hintText: 'Buscar factura por nombre de Mes...',
        hintStyle: TextStyle(color: palette.textMuted, fontSize: 14),
        prefixIcon: Icon(Icons.search, color: palette.textMuted),
        filled: true,
        fillColor: palette.card,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
        ),
      ),
    );
  }
}
