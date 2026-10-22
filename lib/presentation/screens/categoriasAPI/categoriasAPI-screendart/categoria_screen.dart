import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../presentation/providers/categoria_provider.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_theme.dart';
import '../widgets/categoria_form_widget.dart';
import '../widgets/categoria_search_bar.dart';
import '../widgets/categoria_list_view.dart';

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({super.key});

  @override
  State<CategoriaScreen> createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _codeSearchController = TextEditingController();
  final TextEditingController _nameSearchController = TextEditingController();

  String _selectedStatusForm = 'Activo';
  bool _isEditing = false;
  int? _editingId;

  @override
  void initState() {
    super.initState();
    // 7. Carga inicial: llamar inmediatamente GET /api/Categorias/activos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriaProvider>().cargarActivos();
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _codeSearchController.dispose();
    _nameSearchController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _codeController.clear();
    _nameController.clear();
    _selectedStatusForm = 'Activo';
    _isEditing = false;
    _editingId = null;
  }

  // 1 y 2. Envío de Formulario: POST para creación y PUT para actualización
  void _handleFormSubmission(AppPalette c) {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showAlertDialog(
        c,
        'Validación de Formulario',
        'Por favor, ingresa el Nombre de la categoría.',
      );
      return;
    }

    final provider = context.read<CategoriaProvider>();

    // 2. Modo Edición -> PUT /api/Categorias/{id}
    if (_isEditing) {
      if (_editingId == null) return;
      _showConfirmationDialog(
        c: c,
        title: 'Confirmar Actualización',
        message: '¿Quieres actualizar esta categoría (PUT /api/Categorias/$_editingId)?',
        onConfirm: () async {
          setState(() {
            _codeSearchController.clear();
            _nameSearchController.clear();
          });

          final isActivo = _selectedStatusForm == 'Activo';
          final success = await provider.actualizarCategoria(_editingId!, name, isActivo);
          if (!mounted) return;

          if (success) {
            _showFeedback(provider.successMessage ?? 'Categoría actualizada con éxito');
            setState(() => _resetForm());
          } else {
            _showAlertDialog(c, 'Error al actualizar', provider.errorMessage ?? 'No se pudo actualizar.');
          }
        },
      );
    } 
    // 1. Modo Creación -> POST /api/Categorias
    else {
      _showConfirmationDialog(
        c: c,
        title: 'Confirmar Creación',
        message: '¿Deseas registrar esta categoría (POST /api/Categorias)?',
        onConfirm: () async {
          final success = await provider.crearCategoria(name);
          if (!mounted) return;

          if (success) {
            _showFeedback(provider.successMessage ?? 'Categoría creada con éxito');
            setState(() => _resetForm());
          } else {
            _showAlertDialog(c, 'Error al crear', provider.errorMessage ?? 'No se pudo crear.');
          }
        },
      );
    }
  }

  // 4 y 5. Búsqueda por Código (GET /{id}) o Combinada (GET /buscar)
  void _executeSearchValidation(AppPalette c) {
    final codeQuery = _codeSearchController.text.trim();
    final nameQuery = _nameSearchController.text.trim();

    if (codeQuery.isEmpty && nameQuery.isEmpty) {
      final provider = context.read<CategoriaProvider>();
      if (provider.selectedFilterStatus == 'Inactivo') {
        provider.cargarInactivos();
      } else {
        provider.cargarActivos();
      }
      return;
    }

    if (codeQuery.isNotEmpty && int.tryParse(codeQuery) == null) {
      _showAlertDialog(
        c,
        'Validación de Búsqueda',
        'El Código ingresado debe ser un número entero válido.',
      );
      return;
    }

    context.read<CategoriaProvider>().buscarCategorias(
      codigo: codeQuery,
      nombre: nameQuery,
    );
  }

  void _showConfirmationDialog({
    required AppPalette c,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: c.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          title,
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(color: c.textMuted, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: c.textMuted, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.teal,
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text(
              'Confirmar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAlertDialog(AppPalette c, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: c.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          title,
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(color: c.textMuted, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Entendido',
              style: TextStyle(
                color: AppColors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.teal,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final provider = context.watch<CategoriaProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 20,
        title: Text(
          'Mantenimiento de Categorías',
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Indicador de Carga Superior
                if (provider.isLoading) ...[
                  const LinearProgressIndicator(color: AppColors.teal, minHeight: 3),
                  const SizedBox(height: 12),
                ],

                // 1. Formulario de Creación / Edición
                CategoriaFormWidget(
                  palette: c,
                  isEditing: _isEditing,
                  codeController: _codeController,
                  nameController: _nameController,
                  selectedStatus: _selectedStatusForm,
                  onStatusChanged: (val) =>
                      setState(() => _selectedStatusForm = val ?? 'Activo'),
                  onActionPressed: () => _handleFormSubmission(c),
                  onCancelEditing: () {
                    _showConfirmationDialog(
                      c: c,
                      title: 'Cancelar Edición',
                      message:
                          '¿Estás seguro de que quieres cancelar la edición actual? Los cambios no guardados se perderán.',
                      onConfirm: () => setState(() => _resetForm()),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // 4, 5, 7, 8. Barra de Búsqueda y Filtros de Estado
                CategoriaSearchBar(
                  palette: c,
                  codeSearchController: _codeSearchController,
                  nameSearchController: _nameSearchController,
                  selectedFilterStatus: provider.selectedFilterStatus,
                  onFilterStatusChanged: (val) {
                    setState(() {
                      _codeSearchController.clear();
                      _nameSearchController.clear();
                    });
                    provider.cambiarFiltroEstado(val ?? 'Activo');
                  },
                  onSearchPressed: () => _executeSearchValidation(c),
                ),
                const SizedBox(height: 16),

                // Tabla de Categorías (Gestiona internamente el mensaje "No hay registros que coincidan")
                CategoriaListView(
                  palette: c,
                  categories: provider.categorias,
                  // 2. Editar -> Carga en formulario y envía PUT /api/Categorias/{id}
                  onEdit: (item, index) {
                    _showConfirmationDialog(
                      c: c,
                      title: 'Cargar Edición',
                      message: '¿Deseas cargar la categoría "${item.nombre}" para editarla (PUT)?',
                      onConfirm: () {
                        setState(() {
                          _isEditing = true;
                          _editingId = item.idCategoria;
                          _codeController.text = item.code;
                          _nameController.text = item.nombre;
                          _selectedStatusForm = item.activo ? 'Activo' : 'Inactivo';
                        });
                      },
                    );
                  },
                  // 3 y 7. Eliminar -> Dispara DELETE /api/Categorias/{id} y luego recarga GET /activos
                  onDelete: (item) {
                    if (item.activo) {
                      _showConfirmationDialog(
                        c: c,
                        title: 'Eliminar Categoría',
                        message: '¿Deseas eliminar (DELETE) la categoría "${item.nombre}"?',
                        onConfirm: () async {
                          setState(() {
                            _codeSearchController.clear();
                            _nameSearchController.clear();
                          });

                          final success = await provider.desactivarCategoria(item.idCategoria);
                          if (!mounted) return;
                          if (success) {
                            _showFeedback(provider.successMessage ?? 'Categoría eliminada.');
                          } else {
                            _showAlertDialog(c, 'Error al eliminar', provider.errorMessage ?? 'No se pudo eliminar.');
                          }
                        },
                      );
                    }
                  },
                  // 6. Botón interactivo SOLO de Inactivo -> Dispara PATCH /api/Categorias/restaurar/{id}
                  onActivateRecord: (item) {
                    if (!item.activo) {
                      _showConfirmationDialog(
                        c: c,
                        title: 'Confirmar Activación',
                        message: '¿Quieres reactivar la categoría "${item.nombre}" (PATCH /api/Categorias/restaurar/${item.code})?',
                        onConfirm: () async {
                          setState(() {
                            _codeSearchController.clear();
                            _nameSearchController.clear();
                          });

                          final success = await provider.restaurarCategoria(item.idCategoria);
                          if (!mounted) return;
                          if (success) {
                            _showFeedback(provider.successMessage ?? 'Categoría reactivada con éxito.');
                          } else {
                            _showAlertDialog(c, 'Error al reactivar', provider.errorMessage ?? 'No se pudo reactivar.');
                          }
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
