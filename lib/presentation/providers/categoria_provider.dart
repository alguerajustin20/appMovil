import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_theme.dart';

class CategoriaFormWidget extends StatelessWidget {
  final AppPalette palette;
  final bool isEditing;
  final TextEditingController codeController;
  final TextEditingController nameController;
  final String selectedStatus;
  final Function(String?) onStatusChanged;
  final VoidCallback onActionPressed;
  final VoidCallback onCancelEditing;

  const CategoriaFormWidget({
    super.key,
    required this.palette,
    required this.isEditing,
    required this.codeController,
    required this.nameController,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onActionPressed,
    required this.onCancelEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isEditing ? Icons.edit_note : Icons.add_box_outlined,
                color: AppColors.teal,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isEditing ? 'Editar categoría' : 'Nueva categoría',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: palette.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            'Código (PK)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: codeController,
            enabled: false,
            keyboardType: TextInputType.number,
            style: TextStyle(color: palette.textPrimary, fontSize: 13),
            decoration: _buildInputDecoration(
              isEditing ? 'Código asignado' : 'Autogenerado por la BD',
              enabled: false,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isEditing
                ? 'El código es inmutable.'
                : 'La base de datos asignará el código automáticamente.',
            style: TextStyle(fontSize: 11, color: palette.textMuted),
          ),

          const SizedBox(height: 14),

          Text(
            'Nombre de Categoría',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: nameController,
            style: TextStyle(color: palette.textPrimary, fontSize: 13),
            decoration: _buildInputDecoration('Ej: Bebidas calientes'),
          ),

          const SizedBox(height: 14),

          Text(
            'Estado',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: palette.isDark ? palette.inputFill : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: palette.cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedStatus,
                isExpanded: true,
                dropdownColor: palette.card,
                style: TextStyle(color: palette.textPrimary, fontSize: 13),
                items: const [
                  DropdownMenuItem(value: 'Activo', child: Text('Activo')),
                  DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
                ],
                onChanged: onStatusChanged,
              ),
            ),
          ),

          const SizedBox(height: 20),

          if (isEditing)
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: onActionPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF03738C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Actualizar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: onCancelEditing,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF03738C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Crear categoría',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, {bool enabled = true}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: palette.textMuted.withValues(alpha: 0.6),
        fontSize: 13,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: enabled
          ? (palette.isDark ? palette.inputFill : Colors.grey.shade50)
          : (palette.isDark ? Colors.grey.shade900 : Colors.grey.shade200),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: palette.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: palette.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
      ),
    );
  }
}
