import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/theme/app_colors.dart';
import '../../../../theme/app_theme.dart';
import '../../../../core/network/api_client.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/models/categoria_model.dart';
import '../../../../data/repositories/product_repository.dart';
import '../../../../data/repositories/categoria_repository.dart';
import '../widgets/product_list_item.dart';
import '../widgets/product_form_card.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _customCategoryController = TextEditingController();
  final TextEditingController _customUnitController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  bool _isInventoryable = true;
  bool _showNewCategoryInput = false;
  int _quantity = 1;
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
    _customUnitController.dispose();
    _searchController.dispose();
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
    _customUnitController.clear();
    setState(() {
      _editingId = null;
      _selectedCategory = null;
      _showNewCategoryInput = false;
      _quantity = 1;
    });
  }

  void _startEditing(ProductModel item) {
    setState(() {
      _editingId = item.id;
      _nameController.text = item.nombre;
      final categoryNames = _categoryList.map((c) => c.nombre).toList();
      if (categoryNames.contains(item.categoria)) {
        _selectedCategory = item.categoria;
        _showNewCategoryInput = false;
      } else {
        _selectedCategory = null;
        _customCategoryController.text = item.categoria;
        _showNewCategoryInput = true;
      }
      _quantity = item.stock > 0 ? item.stock : 1;
      _isInventoryable = item.stock > 0;
    });
    _showProductFormModal();
  }

  void _showProductFormModal() {
    final c = context.palette;
    final categoryNames = _categoryList.map((cat) => cat.nombre).toList();

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
                        ProductFormCard(
                          isEditing: _editingId != null,
                          nameController: _nameController,
                          customCategoryController: _customCategoryController,
                          showNewCategoryInput: _showNewCategoryInput,
                          isInventoryable: _isInventoryable,
                          quantity: _quantity,
                          selectedCategory: _selectedCategory,
                          categories: categoryNames,
                          palette: c,
                          onCancelEditing: () {
                            _clearForm();
                            Navigator.of(context).pop();
                          },
                          onToggleCategoryInput: () => setStateModal(() {
                            _showNewCategoryInput = !_showNewCategoryInput;
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
                          onManageCategories: () {},
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
    final categoryToUse = _showNewCategoryInput
        ? _customCategoryController.text.trim()
        : (_selectedCategory ?? 'General');

    final nuevoProducto = ProductModel(
      id: _editingId,
      nombre: productName,
      categoria: categoryToUse,
      stock: _isInventoryable ? _quantity : 0,
      activo: true,
    );

    try {
      if (_showNewCategoryInput && categoryToUse.isNotEmpty) {
        await _categoriaRepository.crear(CategoriaModel(
          idCategoria: 0,
          nombre: categoryToUse,
          activo: true,
        ));
        await _loadCategories();
      }

      if (_editingId != null) {
        await _productRepository.actualizar(_editingId!, nuevoProducto);
      } else {
        await _productRepository.crear(nuevoProducto);
      }

      await _loadProducts(_selectedStatusFilter);
      _clearForm();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_editingId != null ? '¡Producto actualizado!' : '¡Producto registrado!'),
          backgroundColor: AppColors.teal,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _toggleProductStatus(ProductModel item, AppPalette c) async {
    if (item.id == null) return;
    try {
      if (item.activo) {
        await _productRepository.cambiarEstado(item.id!);
      } else {
        await _productRepository.restaurar(item.id!);
      }
      
      await _loadProducts(_selectedStatusFilter);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estado actualizado correctamente'), backgroundColor: AppColors.teal),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cambiar estado: $e'), backgroundColor: Colors.redAccent),
      );
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