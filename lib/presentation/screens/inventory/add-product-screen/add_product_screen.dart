import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/theme/app_colors.dart';
import '../../../../theme/app_theme.dart';
import '../../../../core/network/api_client.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/models/categoria_model.dart';
import '../../../../data/repositories/product_repository.dart';
import '../../../../data/repositories/categoria_repository.dart';
import '../widgets/product_list_item.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _customCategoryController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _minStockController = TextEditingController(text: '5');

  bool _isInventoryable = true;
  int? _editingId;
  String? _selectedCategory;
  String _selectedStatusFilter = 'Todos';

  bool _isLoading = true;
  List<ProductModel> _productList = [];
  List<CategoriaModel> _categoryList = [];

  final List<String> _statusFilters = ['Todos', 'Activo', 'Inactivo'];

  late final ProductRepository _productRepository = ProductRepository(ApiClient());
  late final CategoriaRepository _categoriaRepository = CategoriaRepository(ApiClient());

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      await _loadCategories();
      await _loadProducts(_selectedStatusFilter);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _categoriaRepository.getActivos();
      setState(() {
        _categoryList = categories;
      });
    } catch (e) {
      debugPrint('Error cargando categorías: $e');
    }
  }

  Future<void> _loadProducts(String statusFilter) async {
    setState(() => _isLoading = true);
    try {
      List<ProductModel> products = [];

      if (statusFilter == 'Activo') {
        products = await _productRepository.getActivos();
      } else if (statusFilter == 'Inactivo') {
        products = await _productRepository.getInactivos();
      } else {
        final activos = await _productRepository.getActivos();
        final inactivos = await _productRepository.getInactivos();
        products = [...activos, ...inactivos];
      }

      setState(() {
        _productList = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _customCategoryController.dispose();
    _searchController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  List<ProductModel> get _filteredProducts {
    return _productList.where((item) {
      final query = _searchController.text.toLowerCase().trim();
      final matchesSearch =
          item.nombre.toLowerCase().contains(query) ||
          item.categoria.toLowerCase().contains(query);

      bool matchesStatus = true;
      if (_selectedStatusFilter == 'Activo') {
        matchesStatus = item.activo;
      } else if (_selectedStatusFilter == 'Inactivo') {
        matchesStatus = !item.activo;
      }

      return matchesSearch && matchesStatus;
    }).toList();
  }

  void _clearForm() {
    _nameController.clear();
    _customCategoryController.clear();
    _priceController.clear();
    _stockController.clear();
    _minStockController.text = '5';
    setState(() {
      _editingId = null;
      _selectedCategory = null;
      _isInventoryable = true;
    });
  }

  void _startEditing(ProductModel item) {
    setState(() {
      _editingId = item.id;
      _nameController.text = item.nombre;
      _priceController.text = item.precioUnitario.toString();
      _stockController.text = item.stock.toString();
      _minStockController.text = item.stockMinimo.toString();
      _isInventoryable = item.esInventariable;
      
      final categoryNames = _categoryList.map((c) => c.nombre).toSet().toList();
      if (categoryNames.contains(item.categoria)) {
        _selectedCategory = item.categoria;
      } else {
        _selectedCategory = null;
      }
    });
    _showProductFormModal();
  }

  void _showAddCategoryDialog(StateSetter setStateModal) {
    _customCategoryController.clear();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final c = context.palette;
        return AlertDialog(
          backgroundColor: c.card,
          title: Text('Nueva Categoría', style: TextStyle(color: c.textPrimary, fontSize: 16)),
          content: TextField(
            controller: _customCategoryController,
            style: TextStyle(color: c.textPrimary, fontSize: 14),
            decoration: _buildInputDecoration(c, hintText: 'Nombre de categoría'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancelar', style: TextStyle(color: c.textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
              onPressed: () async {
                final newCatName = _customCategoryController.text.trim();
                if (newCatName.isNotEmpty) {
                  try {
                    await _categoriaRepository.crear(CategoriaModel(
                      idCategoria: 0,
                      nombre: newCatName,
                      activo: true,
                    ));
                    
                    // Recargamos las categorías en la pantalla principal
                    await _loadCategories();

                    // Actualizamos el estado interno del modal y seleccionamos la nueva categoría al instante
                    setStateModal(() {
                      _selectedCategory = newCatName;
                    });

                    if (mounted) Navigator.of(dialogContext).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al crear categoría: $e'), backgroundColor: Colors.redAccent),
                    );
                  }
                }
              },
              child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
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
            final categoryNames = _categoryList.map((cat) => cat.nombre).toSet().toList();

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
                              _editingId != null ? 'Editar Producto' : 'Nuevo Producto',
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
                        _buildFieldLabel('Nombre del producto', c),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameController,
                          style: TextStyle(color: c.textPrimary, fontSize: 14),
                          decoration: _buildInputDecoration(c, hintText: 'Ej. Coca Cola', prefixIcon: Icons.shopping_bag_outlined),
                          validator: (value) => (value == null || value.trim().isEmpty) ? 'Ingresa el nombre' : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildFieldLabel('Categoría', c),
                            GestureDetector(
                              onTap: () => _showAddCategoryDialog(setStateModal),
                              child: const Text(
                                '+ Nueva categoría',
                                style: TextStyle(color: AppColors.teal, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: (_selectedCategory != null && categoryNames.contains(_selectedCategory)) 
                              ? _selectedCategory 
                              : null,
                          dropdownColor: c.card,
                          style: TextStyle(color: c.textPrimary, fontSize: 14),
                          decoration: _buildInputDecoration(c, hintText: 'Selecciona una categoría'),
                          items: categoryNames.map((cat) {
                            return DropdownMenuItem(value: cat, child: Text(cat));
                          }).toList(),
                          onChanged: (val) => setStateModal(() => _selectedCategory = val),
                          validator: (val) => (val == null) ? 'Selecciona una categoría' : null,
                        ),
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          title: Text('Producto inventariable', style: TextStyle(color: c.textPrimary, fontSize: 14)),
                          value: _isInventoryable,
                          activeColor: AppColors.teal,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (val) => setStateModal(() => _isInventoryable = val ?? true),
                        ),
                        
                        if (_isInventoryable) ...[
                          const SizedBox(height: 12),
                          _buildFieldLabel('Stock actual', c),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _stockController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: c.textPrimary, fontSize: 14),
                            decoration: _buildInputDecoration(c, hintText: 'Ej. 10', prefixIcon: Icons.inventory_2_outlined),
                            validator: (value) {
                              if (_isInventoryable && (value == null || value.trim().isEmpty)) {
                                return 'Ingresa el stock actual';
                              }
                              return null;
                            },
                          ),
                        ],

                        const SizedBox(height: 12),
                        _buildFieldLabel('Precio Unitario', c),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(color: c.textPrimary, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Ej. 50.00',
                            hintStyle: TextStyle(
                              color: c.textMuted.withValues(alpha: 0.7),
                              fontSize: 13,
                            ),
                            prefixText: 'C\$ ',
                            prefixStyle: TextStyle(
                              color: c.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
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
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor ingresa el precio unitario';
                            }
                            if (double.tryParse(value.trim()) == null) {
                              return 'Ingresa un número válido';
                            }
                            return null;
                          },
                        ),

                        if (_isInventoryable) ...[
                          const SizedBox(height: 12),
                          _buildFieldLabel('Stock Mínimo', c),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _minStockController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: c.textPrimary, fontSize: 14),
                            decoration: _buildInputDecoration(
                              c,
                              hintText: 'Ej. 5',
                              prefixIcon: Icons.warning_amber_rounded,
                            ),
                            validator: (value) {
                              if (_isInventoryable && (value == null || value.trim().isEmpty)) {
                                return 'Ingresa el stock mínimo';
                              }
                              if (value != null && int.tryParse(value.trim()) == null) {
                                return 'Ingresa un número entero válido';
                              }
                              return null;
                            },
                          ),
                        ],

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
                              _editingId != null ? 'Actualizar Producto' : 'Guardar Producto',
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

  Future<void> _saveProduct() async {
    final productName = _nameController.text.trim();
    final categoryToUse = _selectedCategory ?? 'General';
    final parsedPrice = double.tryParse(_priceController.text.trim()) ?? 0.0;
    
    final parsedStock = _isInventoryable ? (int.tryParse(_stockController.text.trim()) ?? 0) : 0;
    final parsedMinStock = _isInventoryable ? (int.tryParse(_minStockController.text.trim()) ?? 5) : 5;

    final nuevoProducto = ProductModel(
      id: _editingId,
      nombre: productName,
      categoria: categoryToUse,
      precioUnitario: parsedPrice,
      stock: parsedStock,
      stockMinimo: parsedMinStock,
      activo: true, // Asegura que siempre se registre como activo en la BD
      esInventariable: _isInventoryable,
    );

    try {
      if (_editingId != null) {
        await _productRepository.actualizar(_editingId!, nuevoProducto);
      } else {
        await _productRepository.crear(nuevoProducto);
      }

      await _loadProducts(_selectedStatusFilter);
      _clearForm();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_editingId != null ? '¡Producto actualizado!' : '¡Producto registrado!'),
            backgroundColor: AppColors.teal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _toggleProductStatus(ProductModel item, AppPalette c) async {
    if (item.id == null) return;
    try {
      await _productRepository.cambiarEstado(item.id!, item);
      await _loadProducts(_selectedStatusFilter);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estado actualizado correctamente'), backgroundColor: AppColors.teal),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cambiar estado: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Productos Existentes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                            side: BorderSide(
                              color: isSelected ? AppColors.teal : c.cardBorder,
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedStatusFilter = filter);
                                _loadProducts(filter);
                              }
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
                                isEditing: _editingId == item.id,
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
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
      ),
    );
  }
}