import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_navigation.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _customCategoryController = TextEditingController();
  
  bool _isInventoryable = true;
  int _quantity = 1;
  String? _selectedCategory;
  String? _selectedUnit;

  final List<String> _categories = [
    'Bebidas',
    'Carnes',
    'Verduras',
  ];
  final List<String> _units = ['Unidades', 'Kg', 'caja', 'Botella', 'Paquetes'];

  @override
  void dispose() {
    _nameController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        titleSpacing: 20,
        title: const Text(
          'Agregar Producto',
          style: TextStyle(
            color: Color(0xFF007A8C),
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
              const Text(
                'Nuevo Producto',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ingresa los detalles del nuevo producto al inventario.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
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
                    _buildLabel('NOMBRE DEL PRODUCTO'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      decoration: _buildInputDecoration(hintText: 'INGRESA EL NOMBRE DEL PRODUCTO...'),
                    ),
                    const SizedBox(height: 16),

                    _buildLabel('CREAR UNA CATEGORIA'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _customCategoryController,
                      decoration: _buildInputDecoration(hintText: 'INGRESA LA CATEGORIA...'),
                    ),
                    const SizedBox(height: 16),

                    _buildLabel('CATEGORÍA'),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      hint: const Text(
                        'Selecciona una categoría',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                      decoration: _buildInputDecoration(),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category, style: const TextStyle(fontSize: 14)),
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
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: CheckboxListTile(
                        title: const Text(
                          'Producto Inventariable',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        subtitle: const Text(
                          'Actívalo si el producto es inventariable',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        value: _isInventoryable,
                        activeColor: const Color(0xFF007A8C),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
                                _buildLabel('CANTIDAD'),
                                const SizedBox(height: 6),
                                Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFFCBD5E1)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove, size: 18),
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
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add, size: 18),
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
                                _buildLabel('UNIDAD'),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: _selectedUnit,
                                  hint: const Text(
                                    '',
                                    style: TextStyle(color: Color(0xFF64748B)),
                                  ),
                                  icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                                  decoration: _buildInputDecoration(),
                                  items: _units.map((String unit) {
                                    return DropdownMenuItem<String>(
                                      value: unit,
                                      child: Text(unit, style: const TextStyle(fontSize: 13)),
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
                  icon: const Icon(Icons.save_outlined, color: Colors.white, size: 20),
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
                    backgroundColor: const Color(0xFF007A8C),
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
      bottomNavigationBar: const CustomBottomNavigation(
        currentIndex: 1,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Color(0xFF94A3B8),
        letterSpacing: 0.8,
      ),
    );
  }

  InputDecoration _buildInputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF007A8C), width: 1.5),
      ),
    );
  }
}