import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/themes/app_colors.dart';
import '../../../themes/app_theme.dart';
import '../widgets/product_list_item.dart';
import '../widgets/manage_list_dialog.dart';
import '../widgets/product_form_card.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _customCategoryController =
      TextEditingController();
  final TextEditingController _customUnitController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  bool _isInventoryable = true;
  bool _showNewCategoryInput = false;
  bool _showNewUnitInput = false;
  int _quantity = 1;
  int? _editingIndex;
  String? _selectedCategory;
  String? _selectedUnit;
  String _selectedStatusFilter = 'Todos';

  final List<String> _categories = [
    'Bebidas naturales',
    'licores ',
    'Cervezas',
    'Bebidas',
  ];

  final List<String> _units = ['Unidad', 'kg', 'g', 'L', 'ml', 'Paquete'];

  final List<String> _statusFilters = ['Todos', 'Activo', 'Inactivo'];

  final List<ProductItem> _productList = [
    ProductItem(
      name: 'Coca Cola',
      category: 'Bebidas',
      stock: 15,
      isActive: true,
    ),
    ProductItem(name: 'gaseosa', category: 'Bebidas', stock: 8, isActive: true),
    ProductItem(name: 'Toña', category: 'Cervezas', stock: 0, isActive: false),
    ProductItem(
      name: 'Jugo de Naranja',
      category: 'Bebidas naturales',
      stock: 5,
      isActive: true,
    ),
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
      final matchesSearch =
          item.name.toLowerCase().contains(query) ||
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
      _selectedUnit = null;

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
    _showProductFormModal();
  }

  void _showProductFormModal() {
    final c = context.palette;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            return SafeArea(
              top: false,
              bottom: true,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _editingIndex != null
                                  ? 'Editar Producto'
                                  : 'Nuevo Producto',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: c.textPrimary,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: c.textMuted),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ProductFormCard(
                          isEditing: _editingIndex != null,
                          nameController: _nameController,
                          customCategoryController: _customCategoryController,
                          customUnitController: _customUnitController,
                          showNewCategoryInput: _showNewCategoryInput,
                          showNewUnitInput: _showNewUnitInput,
                          isInventoryable: _isInventoryable,
                          quantity: _quantity,
                          selectedCategory: _selectedCategory,
                          selectedUnit: _selectedUnit,
                          categories: _categories,
                          units: _units,
                          palette: c,
                          onCancelEditing: () {
                            _clearForm();
                            Navigator.of(context).pop();
                          },
                          onToggleCategoryInput: () => setStateModal(() {
                            _showNewCategoryInput = !_showNewCategoryInput;
                          }),
                          onToggleUnitInput: () => setStateModal(() {
                            _showNewUnitInput = !_showNewUnitInput;
                          }),
                          onInventoryableChanged: (val) => setStateModal(() {
                            _isInventoryable = val;
                          }),
                          onQuantityChanged: (val) => setStateModal(() {
                            _quantity = val;
                          }),
                          onCategoryChanged: (val) => setStateModal(() {
                            _selectedCategory = val;
                          }),
                          onUnitChanged: (val) => setStateModal(() {
                            _selectedUnit = val;
                          }),
                          onManageCategories: () => _showManageListDialog(
                            title: 'Categorías',
                            items: _categories,
                            onEdit: (oldVal, newVal) {
                              final idx = _categories.indexOf(oldVal);
                              if (idx != -1) _categories[idx] = newVal;
                              if (_selectedCategory == oldVal)
                                _selectedCategory = newVal;
                            },
                            onDelete: (val) {
                              _categories.remove(val);
                              if (_selectedCategory == val)
                                _selectedCategory = null;
                            },
                            c: c,
                          ),
                          onManageUnits: () => _showManageListDialog(
                            title: 'Unidades',
                            items: _units,
                            onEdit: (oldVal, newVal) {
                              final idx = _units.indexOf(oldVal);
                              if (idx != -1) _units[idx] = newVal;
                              if (_selectedUnit == oldVal) {
                                _selectedUnit = newVal;
                              }
                            },
                            onDelete: (val) {
                              _units.remove(val);
                              if (_selectedUnit == val) _selectedUnit = null;
                            },
                            c: c,
                          ),
                          buildFieldLabel: _buildFieldLabel,
                          buildInputDecoration: _buildInputDecoration,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _saveProduct();
                                Navigator.of(context).pop();
                              }
                            },
                            icon: const Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: Text(
                              _editingIndex != null
                                  ? 'Actualizar Producto'
                                  : 'Guardar Producto',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
        return ManageListDialog(
          title: title,
          items: items,
          onEdit: onEdit,
          onDelete: onDelete,
          palette: c,
          buildInputDecoration: _buildInputDecoration,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            isActivating ? 'Activar producto' : 'Desactivar producto',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: c.textPrimary,
              fontSize: 18,
            ),
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
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: c.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isActivating
                    ? AppColors.teal
                    : Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
                    backgroundColor: isActivating
                        ? AppColors.teal
                        : Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              child: Text(
                isActivating ? 'Activar' : 'Desactivar',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveProduct() {
    final productName = _nameController.text.trim();
    final categoryToUse = _showNewCategoryInput
        ? _customCategoryController.text.trim()
        : (_selectedCategory ?? 'General');

    if (_showNewCategoryInput && !_categories.contains(categoryToUse)) {
      _categories.add(categoryToUse);
    }

    setState(() {
      if (_editingIndex != null) {
        _productList[_editingIndex!] = ProductItem(
          name: productName,
          category: categoryToUse,
          stock: _isInventoryable ? _quantity : 0,
          isActive: _productList[_editingIndex!].isActive,
        );
      } else {
        _productList.insert(
          0,
          ProductItem(
            name: productName,
            category: categoryToUse,
            stock: _isInventoryable ? _quantity : 0,
            isActive: true,
          ),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _editingIndex != null
              ? '¡Producto actualizado correctamente!'
              : '¡Producto registrado correctamente!',
        ),
        backgroundColor: AppColors.teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    _clearForm();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final filteredList = _filteredProducts;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Gestión de Inventario',
          style: TextStyle(
            color: c.isDark ? const Color(0xFF00B4D8) : const Color(0xFF03738C),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                      Text(
                        'Productos Existentes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: c.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.teal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${filteredList.length} ítems',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.teal,
                      ),
                    ),
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
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = _statusFilters[index];
                    final isSelected = _selectedStatusFilter == filter;

                    return ChoiceChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? Colors.white : c.textMuted,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.teal,
                      backgroundColor: c.card,
                      side: BorderSide(
                        color: isSelected ? AppColors.teal : c.cardBorder,
                      ),
                      onSelected: (selected) =>
                          setState(() => _selectedStatusFilter = filter),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              filteredList.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'No hay productos en esta sección.',
                          style: TextStyle(color: c.textMuted, fontSize: 13),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return ProductListItem(
                          item: item,
                          isEditing:
                              _editingIndex == _productList.indexOf(item),
                          palette: c,
                          onEdit: () => _startEditing(item),
                          onToggleStatus: () => _toggleProductStatus(item, c),
                        );
                      },
                    ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _clearForm();
          _showProductFormModal();
        },
        backgroundColor: AppColors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFieldLabel(String label, AppPalette c) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: c.textPrimary,
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    AppPalette c, {
    String? hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: c.textMuted.withValues(alpha: 0.7),
        fontSize: 13,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: c.textMuted, size: 18)
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: c.isDark ? c.inputFill : Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c.cardBorder),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
      ),
    );
  }
}
