import 'package:flutter/material.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_theme.dart';

class CategoriaSearchBar extends StatelessWidget {
  final AppPalette palette;
  final TextEditingController codeSearchController;
  final TextEditingController nameSearchController;
  final String selectedFilterStatus;
  final Function(String?) onFilterStatusChanged;
  final VoidCallback onSearchPressed;

  const CategoriaSearchBar({
    super.key,
    required this.palette,
    required this.codeSearchController,
    required this.nameSearchController,
    required this.selectedFilterStatus,
    required this.onFilterStatusChanged,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Buscar por Código (Endpoint GET /api/Categorias/{id} si se usa solo)
                    SizedBox(
                      height: 38,
                      child: TextField(
                        controller: codeSearchController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: palette.textPrimary, fontSize: 13),
                        decoration: _buildDecoration('Código Categoría...'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Buscar Nombre Categoría
                    SizedBox(
                      height: 38,
                      child: TextField(
                        controller: nameSearchController,
                        style: TextStyle(color: palette.textPrimary, fontSize: 13),
                        decoration: _buildDecoration('Nombre Categoría ACTIVA...'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 38,
                child: OutlinedButton.icon(
                  onPressed: onSearchPressed,
                  icon: const Icon(Icons.search, size: 16, color: AppColors.teal),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: palette.cardBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  label: Text(
                    'Buscar',
                    style: TextStyle(color: palette.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          
          Row(
            children: [
              Text(
                'Filtrar Tabla por Estado:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: palette.textPrimary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: palette.isDark ? palette.inputFill : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: palette.cardBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedFilterStatus,
                      dropdownColor: palette.card,
                      style: TextStyle(color: palette.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                      items: const [
                        DropdownMenuItem(value: 'Activo', child: Text('Activas')),
                        DropdownMenuItem(value: 'Inactivo', child: Text('Inactivas')),
                      ],
                      onChanged: onFilterStatusChanged,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _buildDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: palette.textMuted.withValues(alpha: 0.5), fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      filled: true,
      fillColor: palette.isDark ? palette.inputFill : Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: palette.cardBorder)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: palette.cardBorder)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.teal, width: 1.2)),
    );
  }
}
