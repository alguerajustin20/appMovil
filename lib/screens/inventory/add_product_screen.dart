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

  bool _isInventoryable = true;
  bool _showNewCategoryInput = false;
  int _quantity = 1;
  int? _editingIndex;
  String? _selectedCategory;
  String? _selectedUnit = 'Unidades';

  final List<String> _categories = ['Bebidas', 'Carnes', 'Verduras', 'Abarrotes'];
  final List<String> _units = ['Unidades', 'Kg', 'Caja', 'Botella', 'Paquetes'];

  final List<ProductItem> _productList = [
    ProductItem(name: 'Coca Cola 2L', category: 'Bebidas', stock: 15, isActive: true),
    ProductItem(name: 'Carne de Res', category: 'Carnes', stock: 8, isActive: true),
    ProductItem(name: 'Tomates', category: 'Verduras', stock: 0, isActive: false),
    ProductItem(name: 'Jugo de Naranja', category: 'Bebidas', stock: 5, isActive: true),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameController.clear();
    _customCategoryController.clear();
    setState(() {
      _editingIndex = null;
      _selectedCategory = null;
      _showNewCategoryInput = false;
      _quantity = 1;
    });
  }

  void _startEditing(int index) {
    final item = _productList[index];
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

  void _confirmDeleteProduct(int index, AppPalette c) {
    final item = _productList[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: c.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Eliminar producto', style: TextStyle(fontWeight: FontWeight.bold, color: c.textPrimary, fontSize: 18)),
          content: Text('¿Quieres eliminar este producto (${item.name}) del inventario?', style: TextStyle(color: c.textMuted, fontSize: 14)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar', style: TextStyle(color: c.textMuted, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
              onPressed: () {
                setState(() {
                  _productList.removeAt(index);
                  if (_editingIndex == index) _clearForm();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Producto "${item.name}" eliminado.'), backgroundColor: Colors.red[600], behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                );
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;

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
                      Text('Toca para editar o eliminar', style: TextStyle(fontSize: 12, color: c.textMuted)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text('${_productList.length} ítems', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.teal)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _productList.length,
                itemBuilder: (context, index) {
                  final item = _productList[index];
                  final isEditing = _editingIndex == index;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isEditing ? AppColors.teal.withOpacity(0.08) : c.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isEditing ? AppColors.teal : (item.isActive ? AppColors.teal.withOpacity(0.3) : c.cardBorder), width: 1.2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: c.textPrimary)),
                              Text('${item.category} • Stock: ${item.stock}', style: TextStyle(fontSize: 12, color: c.textMuted)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => item.isActive = !item.isActive),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: item.isActive ? Colors.green.withOpacity(0.12) : Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                            child: Text(item.isActive ? 'Activo' : 'Inactivo', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: item.isActive ? Colors.green[700] : Colors.grey[700])),
                          ),
                        ),
                        IconButton(icon: Icon(Icons.edit_outlined, size: 18, color: AppColors.teal), onPressed: () => _startEditing(index)),
                        IconButton(icon: Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red[600]), onPressed: () => _confirmDeleteProduct(index, c)),
                      ],
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
                      decoration: _buildInputDecoration(c, hintText: 'Ej. Coca Cola 2L', prefixIcon: Icons.shopping_bag_outlined),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFieldLabel('Categoría', c),
                        GestureDetector(
                          onTap: () => setState(() => _showNewCategoryInput = !_showNewCategoryInput),
                          child: Text(_showNewCategoryInput ? 'Seleccionar existente' : '+ Agregar categoría', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.teal)),
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
                        value: _selectedCategory,
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
                        children: [
                          Expanded(
                            flex: 5,
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
                                      IconButton(icon: Icon(Icons.remove_rounded, size: 16, color: c.textPrimary), onPressed: () { if (_quantity > 1) setState(() => _quantity--); }),
                                      Expanded(child: Center(child: Text('$_quantity', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: c.textPrimary)))),
                                      IconButton(icon: Icon(Icons.add_rounded, size: 16, color: c.textPrimary), onPressed: () => setState(() => _quantity++)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Unidad', c),
                                const SizedBox(height: 4),
                                DropdownButtonFormField<String>(
                                  value: _selectedUnit,
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
                  icon: Icon(_editingIndex != null ? Icons.save_rounded : Icons.check_circle_outline_rounded, color: Colors.white, size: 18),
                  label: Text(_editingIndex != null ? 'Actualizar Producto' : 'Guardar en Inventario', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 1),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 1),
    );
  }

  Widget _buildFieldLabel(String text, AppPalette c) {
    return Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c.textPrimary));
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