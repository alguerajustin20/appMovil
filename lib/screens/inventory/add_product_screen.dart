import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/theme/app_colors.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../theme/app_theme.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _customCategoryController =
      TextEditingController();

  bool _isInventoryable = true;
  int _quantity = 1;
  String? _selectedCategory;
  String? _selectedUnit;

  final List<String> _categories = ['Bebidas', 'Carnes', 'Verduras'];
  final List<String> _units = ['Unidades', 'Kg', 'caja', 'Botella', 'Paquetes'];

  @override
  void dispose() {
    _nameController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;

    return Scaffold(
      // sin backgroundColor — lo toma de AppTheme.light/dark
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 20,
        title: Text(
          'Agregar Producto',
          style: TextStyle(
            color: AppColors.teal,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nuevo Producto',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ingresa los detalles del nuevo producto al inventario.',
                style: TextStyle(fontSize: 13, color: c.textMuted),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: c.card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: c.isDark
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('NOMBRE DEL PRODUCTO', c),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      style: TextStyle(color: c.textPrimary),
                      decoration: _buildInputDecoration(
                        c,
                        hintText: 'INGRESA EL NOMBRE DEL PRODUCTO...',
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildLabel('CREAR UNA CATEGORIA', c),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _customCategoryController,
                      style: TextStyle(color: c.textPrimary),
                      decoration: _buildInputDecoration(
                        c,
                        hintText: 'INGRESA LA CATEGORIA...',
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildLabel('CATEGORÍA', c),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      hint: Text(
                        'Selecciona una categoría',
                        style: TextStyle(color: c.textMuted, fontSize: 14),
                      ),
                      icon: Icon(Icons.keyboard_arrow_down, color: c.textMuted),
                      dropdownColor: c.card,
                      style: TextStyle(color: c.textPrimary, fontSize: 14),
                      decoration: _buildInputDecoration(c),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 14,
                              color: c.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    Container(
                      decoration: BoxDecoration(
                        color: c.inputFill,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: c.cardBorder),
                      ),
                      child: CheckboxListTile(
                        title: Text(
                          'Producto Inventariable',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: c.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          'Actívalo si el producto es inventariable',
                          style: TextStyle(fontSize: 11, color: c.textMuted),
                        ),
                        value: _isInventoryable,
                        activeColor: AppColors.teal,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        onChanged: (bool? value) {
                          setState(() {
                            _isInventoryable = value ?? true;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (_isInventoryable) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('CANTIDAD', c),
                                const SizedBox(height: 6),
                                Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: c.cardBorder),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          size: 18,
                                          color: c.textPrimary,
                                        ),
                                        onPressed: () {
                                          if (_quantity > 1) {
                                            setState(() => _quantity--);
                                          }
                                        },
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            '$_quantity',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: c.textPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          size: 18,
                                          color: c.textPrimary,
                                        ),
                                        onPressed: () {
                                          setState(() => _quantity++);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('UNIDAD', c),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: _selectedUnit,
                                  hint: Text(
                                    '',
                                    style: TextStyle(color: c.textMuted),
                                  ),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: c.textMuted,
                                  ),
                                  dropdownColor: c.card,
                                  style: TextStyle(
                                    color: c.textPrimary,
                                    fontSize: 13,
                                  ),
                                  decoration: _buildInputDecoration(c),
                                  items: _units.map((String unit) {
                                    return DropdownMenuItem<String>(
                                      value: unit,
                                      child: Text(
                                        unit,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: c.textPrimary,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedUnit = value;
                                    });
                                  },
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
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.save_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'GUARDAR EN INVENTARIO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 1),
    );
  }

  Widget _buildLabel(String text, AppPalette c) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: c.textMuted,
        letterSpacing: 0.8,
      ),
    );
  }

  InputDecoration _buildInputDecoration(AppPalette c, {String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: c.textMuted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: c.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: c.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
      ),
    );
  }
}
