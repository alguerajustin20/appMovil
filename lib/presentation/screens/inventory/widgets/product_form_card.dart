import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/theme/app_colors.dart';
import '../../../../../theme/app_theme.dart';

class ProductFormCard extends StatelessWidget {
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController customCategoryController;
  final bool showNewCategoryInput;
  final bool isInventoryable;
  final int quantity;
  final String? selectedCategory;
  final List<String> categories;
  final AppPalette palette;
  final VoidCallback onCancelEditing;
  final VoidCallback onToggleCategoryInput;
  final ValueChanged<bool> onInventoryableChanged;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onManageCategories;
  final Widget Function(String, AppPalette) buildFieldLabel;
  final InputDecoration Function(
    AppPalette, {
    String? hintText,
    IconData? prefixIcon,
  })
  buildInputDecoration;

  const ProductFormCard({
    super.key,
    required this.isEditing,
    required this.nameController,
    required this.customCategoryController,
    required this.showNewCategoryInput,
    required this.isInventoryable,
    required this.quantity,
    required this.selectedCategory,
    required this.categories,
    required this.palette,
    required this.onCancelEditing,
    required this.onToggleCategoryInput,
    required this.onInventoryableChanged,
    required this.onQuantityChanged,
    required this.onCategoryChanged,
    required this.onManageCategories,
    required this.buildFieldLabel,
    required this.buildInputDecoration,
  });

  @override
  Widget build(BuildContext context) {
    final c = palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isEditing ? Icons.edit_note_rounded : Icons.add_box_rounded,
                    color: AppColors.teal,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isEditing ? 'Editar Producto' : 'Agregar Producto',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary,
                  ),
                ),
              ],
            ),
            if (isEditing)
              GestureDetector(
                onTap: onCancelEditing,
                child: Text(
                  'Cancelar edición',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.cardBorder.withValues(alpha: 0.6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFieldLabel('Nombre del producto', c),
              const SizedBox(height: 4),
              TextFormField(
                controller: nameController,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Por favor ingresa un nombre.';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: TextStyle(color: c.textPrimary, fontSize: 14),
                decoration: buildInputDecoration(
                  c,
                  hintText: 'Ej. Coca Cola',
                  prefixIcon: Icons.shopping_bag_outlined,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildFieldLabel('Categoría', c),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onManageCategories,
                        child: Text(
                          'Gestionar',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: c.textMuted,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onToggleCategoryInput,
                        child: Text(
                          showNewCategoryInput ? 'Seleccionar' : '+ Nueva',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.teal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (showNewCategoryInput)
                TextFormField(
                  controller: customCategoryController,
                  validator: (val) {
                    if (showNewCategoryInput &&
                        (val == null || val.trim().isEmpty)) {
                      return 'Por favor ingresa una categoría.';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextStyle(color: c.textPrimary, fontSize: 14),
                  decoration: buildInputDecoration(
                    c,
                    hintText: 'Ej. Verduras, carnes...',
                    prefixIcon: Icons.create_new_folder_outlined,
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  initialValue: categories.contains(selectedCategory)
                      ? selectedCategory
                      : null,
                  validator: (val) {
                    if (!showNewCategoryInput &&
                        (val == null || val.trim().isEmpty)) {
                      return 'Por favor selecciona una categoría.';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  hint: Text(
                    'Selecciona una categoría',
                    style: TextStyle(color: c.textMuted, fontSize: 14),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: c.textMuted,
                  ),
                  dropdownColor: c.card,
                  style: TextStyle(color: c.textPrimary, fontSize: 14),
                  decoration: buildInputDecoration(
                    c,
                    prefixIcon: Icons.category_outlined,
                  ),
                  items: categories
                      .map(
                        (String category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: TextStyle(color: c.textPrimary),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onCategoryChanged,
                ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: c.isDark ? c.inputFill : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: c.cardBorder.withValues(alpha: 0.6),
                  ),
                ),
                child: CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 0,
                  ),
                  title: Text(
                    'Producto inventariable',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                    ),
                  ),
                  value: isInventoryable,
                  activeColor: AppColors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (bool? val) => onInventoryableChanged(val ?? true),
                ),
              ),
              if (isInventoryable) ...[
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildFieldLabel('Cantidad', c),
                    const SizedBox(height: 4),
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: c.isDark ? c.inputFill : Colors.white,
                        border: Border.all(color: c.cardBorder),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              Icons.remove_rounded,
                              size: 16,
                              color: c.textPrimary,
                            ),
                            onPressed: () {
                              if (quantity > 1) {
                                onQuantityChanged(quantity - 1);
                              }
                            },
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '$quantity',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: c.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              Icons.add_rounded,
                              size: 16,
                              color: c.textPrimary,
                            ),
                            onPressed: () => onQuantityChanged(quantity + 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
