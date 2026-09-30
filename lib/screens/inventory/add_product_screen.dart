import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/theme/app_colors.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../theme/app_theme.dart';

class ProductItem {
  String name;
  String category;
  int stock;
  bool isActive;

  ProductItem({
    required this.name,
    required this.category,
    required this.stock,
    this.isActive = true,
  });
}

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _customCategoryController = TextEditingController();
  final TextEditingController _customUnitController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  bool _isInventoryable = true;
  bool _showNewCategoryInput = false;
  bool _showNewUnitInput = false;
  int _quantity = 1;
  int? _editingIndex;
  String? _selectedCategory;
  String? _selectedUnit = 'Paquete';
  String _selectedStatusFilter = 'Todos';

  final List<String> _categories = ['Bebidas', 'Carnes', 'Verduras', 'Abarrotes'];
  final List<String> _units = ['Paquete', 'Kg', 'Caja', 'Botella', 'onza'];
  final List<String> _statusFilters = ['Todos', 'Activo', 'Inactivo'];

  final List<ProductItem> _productList = [
    ProductItem(name: 'Coca Cola ', category: 'Bebidas', stock: 15, isActive: true),
    ProductItem(name: 'Carne de Res', category: 'Carnes', stock: 8, isActive: true),
    ProductItem(name: 'Tomates', category: 'Verduras', stock: 0, isActive: false),
    ProductItem(name: 'Jugo de Naranja', category: 'Bebidas', stock: 5, isActive: true),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _customCategoryController.dispose();
    _customUnitController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<ProductItem> get _filteredProducts {
    return _productList.where((item) {
      final query = _searchController.text.toLowerCase().trim();
      final matchesSearch = item.name.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);

      bool matchesStatus = true;
      if (_selectedStatusFilter == 'Activo') {
        matchesStatus = item.isActive;
      } else if (_selectedStatusFilter == 'Inactivo') {
        matchesStatus = !item.isActive;
      }

      return matchesSearch && matchesStatus;
    }).toList();
  }

  void _clearForm() {
    _nameController.clear();
    _customCategoryController.clear();
    _customUnitController.clear();
    setState(() {
      _editingIndex = null;
      _selectedCategory = null;
      _selectedUnit = 'Paquete';
      _showNewCategoryInput = false;
      _showNewUnitInput = false;
      _quantity = 1;
    });
  }

  void _startEditing(ProductItem item) {
    final index = _productList.indexOf(item);
    setState(() {
      _editingIndex = index;
      _nameController.text = item.name;
      if (_categories.contains(item.category)) {
        _selectedCategory = item.category;
        _showNewCategoryInput = false;
      } else {
        _selectedCategory = null;
        _customCategoryController.text = item.category;
        _showNewCategoryInput = true;
      }
      _quantity = item.stock > 0 ? item.stock : 1;
      _isInventoryable = item.stock > 0;
    });
  }

  void _showManageListDialog({
    required String title,
    required List<String> items,
    required Function(String item, String newValue) onEdit,
    required Function(String item) onDelete,
    required AppPalette c,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: c.card,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Gestionar $title', style: TextStyle(fontWeight: FontWeight.bold, color: c.textPrimary, fontSize: 18)),
              content: SizedBox(
                width: double.maxFinite,
                child: items.isEmpty
                    ? Text('No hay elementos guardados.', style: TextStyle(color: c.textMuted))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            title: Text(item, style: TextStyle(color: c.textPrimary, fontSize: 14)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.teal),
                                  onPressed: () {
                                    final editController = TextEditingController(text: item);
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        backgroundColor: c.card,
                                        title: Text('Editar $item', style: TextStyle(color: c.textPrimary, fontSize: 16)),
                                        content: TextField(
                                          controller: editController,
                                          style: TextStyle(color: c.textPrimary),
                                          decoration: _buildInputDecoration(c, hintText: 'Nuevo nombre'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: Text('Cancelar', style: TextStyle(color: c.textMuted)),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
                                            onPressed: () {
                                              if (editController.text.trim().isNotEmpty) {
                                                setState(() {
                                                  onEdit(item, editController.text.trim());
                                                });
                                                setDialogState(() {});
                                                Navigator.pop(ctx);
                                              }
                                            },
                                            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red[600]),
                                  onPressed: () {
                                    setState(() {
                                      onDelete(item);
                                    });
                                    setDialogState(() {});
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cerrar', style: TextStyle(color: c.textMuted, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _toggleProductStatus(ProductItem item, AppPalette c) {
    final isActivating = !item.isActive;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: c.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            isActivating ? 'Activar producto' : 'Desactivar producto',
            style: TextStyle(fontWeight: FontWeight.bold, color: c.textPrimary, fontSize: 18),
          ),
          content: Text(
            isActivating
                ? '¿Quieres activar el producto "${item.name}" nuevamente?'
                : '¿Quieres desactivar el producto "${item.name}"?',
            style: TextStyle(color: c.textMuted, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar', style: TextStyle(color: c.textMuted, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isActivating ? AppColors.teal : Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              onPressed: () {
                setState(() {
                  item.isActive = isActivating;
                  final realIndex = _productList.indexOf(item);
                  if (_editingIndex == realIndex) _clearForm();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isActivating
                          ? 'Producto "${item.name}" activado correctamente.'
                          : 'Producto "${item.name}" marcado como inactivo.',
                    ),
                    backgroundColor: isActivating ? AppColors.teal : Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: Text(
                isActivating ? 'Activar' : 'Desactivar',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final filteredList = _filteredProducts;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: c.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Gestión de Inventario', style: TextStyle(color: c.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Productos Existentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: c.textPrimary)),
                      Text('Toca para editar, activar o desactivar', style: TextStyle(fontSize: 12, color: c.textMuted)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text('${filteredList.length} ítems', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.teal)),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: TextStyle(color: c.textPrimary, fontSize: 14),
                decoration: _buildInputDecoration(
                  c,
                  hintText: 'Buscar producto por nombre o categoría...',
                  prefixIcon: Icons.search_rounded,
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _statusFilters.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = _statusFilters[index];
                    final isSelected = _selectedStatusFilter == filter;

                    return ChoiceChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? Colors.white : c.textMuted,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.teal,
                      backgroundColor: c.card,
                      side: BorderSide(color: isSelected ? AppColors.teal : c.cardBorder),
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatusFilter = filter;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              filteredList.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text('No hay productos en esta sección.', style: TextStyle(color: c.textMuted, fontSize: 13)),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        final realIndex = _productList.indexOf(item);
                        final isEditing = _editingIndex == realIndex;

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
                                    : (item.isActive ? AppColors.teal.withOpacity(0.3) : c.cardBorder),
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
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                                        ],
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
                                  icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.teal),
                                  onPressed: () => _startEditing(item),
                                ),
                                IconButton(
                                  icon: Icon(
                                    item.isActive ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
                                    size: 28,
                                    color: item.isActive ? AppColors.teal : Colors.redAccent.withOpacity(0.7),
                                  ),
                                  onPressed: () => _toggleProductStatus(item, c),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

              const SizedBox(height: 12),
              Divider(color: c.cardBorder.withOpacity(0.6), thickness: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: AppColors.teal.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                        child: Icon(_editingIndex != null ? Icons.edit_note_rounded : Icons.add_box_rounded, color: AppColors.teal, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(_editingIndex != null ? 'Editar Producto' : 'Agregar Producto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: c.textPrimary)),
                    ],
                  ),
                  if (_editingIndex != null)
                    GestureDetector(
                      onTap: _clearForm,
                      child: Text('Cancelar edición', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red[600])),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: c.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: c.cardBorder.withOpacity(0.6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Nombre del producto', c),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _nameController,
                      style: TextStyle(color: c.textPrimary, fontSize: 14),
                      decoration: _buildInputDecoration(c, hintText: 'Ej. Coca Cola ', prefixIcon: Icons.shopping_bag_outlined),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFieldLabel('Categoría', c),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _showManageListDialog(
                                title: 'Categorías',
                                items: _categories,
                                onEdit: (oldVal, newVal) {
                                  final idx = _categories.indexOf(oldVal);
                                  if (idx != -1) _categories[idx] = newVal;
                                  if (_selectedCategory == oldVal) _selectedCategory = newVal;
                                },
                                onDelete: (val) {
                                  _categories.remove(val);
                                  if (_selectedCategory == val) _selectedCategory = null;
                                },
                                c: c,
                              ),
                              child: Text('Gestionar', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: c.textMuted)),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => setState(() => _showNewCategoryInput = !_showNewCategoryInput),
                              child: Text(_showNewCategoryInput ? 'Seleccionar' : '+ Nueva', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.teal)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (_showNewCategoryInput)
                      TextField(
                        controller: _customCategoryController,
                        style: TextStyle(color: c.textPrimary, fontSize: 14),
                        decoration: _buildInputDecoration(c, hintText: 'Ej. Lácteos, Limpieza...', prefixIcon: Icons.create_new_folder_outlined),
                      )
                    else
                      DropdownButtonFormField<String>(
                        value: _categories.contains(_selectedCategory) ? _selectedCategory : null,
                        hint: Text('Selecciona una categoría', style: TextStyle(color: c.textMuted, fontSize: 14)),
                        icon: Icon(Icons.keyboard_arrow_down_rounded, color: c.textMuted),
                        dropdownColor: c.card,
                        style: TextStyle(color: c.textPrimary, fontSize: 14),
                        decoration: _buildInputDecoration(c, prefixIcon: Icons.category_outlined),
                        items: _categories.map((String category) => DropdownMenuItem<String>(value: category, child: Text(category, style: TextStyle(color: c.textPrimary)))).toList(),
                        onChanged: (value) => setState(() => _selectedCategory = value),
                      ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(color: c.isDark ? c.inputFill : Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: c.cardBorder.withOpacity(0.6))),
                      child: CheckboxListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        title: Text('Producto inventariable', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.textPrimary)),
                        value: _isInventoryable,
                        activeColor: AppColors.teal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (bool? value) => setState(() => _isInventoryable = value ?? true),
                      ),
                    ),
                    if (_isInventoryable) ...[
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Cantidad', c),
                                const SizedBox(height: 4),
                                Container(
                                  height: 44,
                                  decoration: BoxDecoration(color: c.isDark ? c.inputFill : Colors.white, border: Border.all(color: c.cardBorder), borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: Icon(Icons.remove_rounded, size: 16, color: c.textPrimary), onPressed: () { if (_quantity > 1) setState(() => _quantity--); }),
                                      Expanded(child: Center(child: Text('$_quantity', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: c.textPrimary)))),
                                      IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: Icon(Icons.add_rounded, size: 16, color: c.textPrimary), onPressed: () => setState(() => _quantity++)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFieldLabel('Unidad de medida', c),
                                    ),
                                    GestureDetector(
                                      onTap: () => _showManageListDialog(
                                        title: 'Unidades',
                                        items: _units,
                                        onEdit: (oldVal, newVal) {
                                          final idx = _units.indexOf(oldVal);
                                          if (idx != -1) _units[idx] = newVal;
                                          if (_selectedUnit == oldVal) _selectedUnit = newVal;
                                        },
                                        onDelete: (val) {
                                          _units.remove(val);
                                          if (_selectedUnit == val) _selectedUnit = _units.isNotEmpty ? _units.first : null;
                                        },
                                        c: c,
                                      ),
                                      child: Icon(Icons.settings_outlined, size: 16, color: c.textMuted),
                                    ),
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: () => setState(() => _showNewUnitInput = !_showNewUnitInput),
                                      child: Text(_showNewUnitInput ? 'Lista' : '+ Nueva', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.teal)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                if (_showNewUnitInput)
                                  TextField(
                                    controller: _customUnitController,
                                    style: TextStyle(color: c.textPrimary, fontSize: 13),
                                    decoration: _buildInputDecoration(c, hintText: 'Ej. Litro...'),
                                  )
                                else
                                  DropdownButtonFormField<String>(
                                    value: _units.contains(_selectedUnit) ? _selectedUnit : (_units.isNotEmpty ? _units.first : null),
                                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: c.textMuted),
                                    dropdownColor: c.card,
                                    style: TextStyle(color: c.textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                                    decoration: _buildInputDecoration(c),
                                    items: _units.map((String unit) => DropdownMenuItem<String>(value: unit, child: Text(unit, style: TextStyle(color: c.textPrimary)))).toList(),
                                    onChanged: (value) => setState(() => _selectedUnit = value),
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
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final categoryToUse = _showNewCategoryInput ? _customCategoryController.text.trim() : (_selectedCategory ?? 'General');
                    final finalCategory = categoryToUse.isEmpty ? 'General' : categoryToUse;
                    if (_showNewCategoryInput && categoryToUse.isNotEmpty && !_categories.contains(categoryToUse)) {
                      _categories.add(categoryToUse);
                    }

                    if (_showNewUnitInput && _customUnitController.text.trim().isNotEmpty) {
                      final newUnit = _customUnitController.text.trim();
                      if (!_units.contains(newUnit)) {
                        _units.add(newUnit);
                      }
                      _selectedUnit = newUnit;
                    }

                    if (_nameController.text.isNotEmpty) {
                      setState(() {
                        if (_editingIndex != null) {
                          _productList[_editingIndex!] = ProductItem(
                            name: _nameController.text,
                            category: finalCategory,
                            stock: _isInventoryable ? _quantity : 0,
                            isActive: _productList[_editingIndex!].isActive,
                          );
                        } else {
                          _productList.insert(0, ProductItem(name: _nameController.text, category: finalCategory, stock: _isInventoryable ? _quantity : 0, isActive: true));
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_editingIndex != null ? '¡Producto actualizado!' : '¡Producto registrado!'), backgroundColor: AppColors.teal, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      );
                      _clearForm();
                    }
                  },
                  icon: const Icon(Icons.save_rounded, color: Colors.white, size: 20),
                  label: Text(_editingIndex != null ? 'Actualizar Producto' : 'Guardar Producto', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 2),
    );
  }

  Widget _buildFieldLabel(String label, AppPalette c) {
    return Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c.textPrimary));
  }

  InputDecoration _buildInputDecoration(AppPalette c, {String? hintText, IconData? prefixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: c.textMuted.withOpacity(0.7), fontSize: 13),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: c.textMuted, size: 18) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: c.isDark ? c.inputFill : Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: c.cardBorder)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: c.cardBorder)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.teal, width: 1.5)),
    );
  }
}