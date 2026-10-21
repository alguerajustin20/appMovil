import 'package:flutter/material.dart';
import '../../core/errors/app_exception.dart';
import '../../data/models/categoria_model.dart';
import '../../services/categoria_service.dart';

class CategoriaProvider extends ChangeNotifier {
  final CategoriaService _service;

  CategoriaProvider(this._service);

  List<CategoriaModel> _categorias = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Filtro de Estado: exclusivamente 'Activo' o 'Inactivo'
  String _selectedFilterStatus = 'Activo';

  List<CategoriaModel> get categorias => _categorias;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String get selectedFilterStatus => _selectedFilterStatus;

  void limpiarMensajes() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // Cargar Categorías Activas: GET /api/Categorias/activos
  Future<void> cargarActivos() async {
    _isLoading = true;
    _errorMessage = null;
    _selectedFilterStatus = 'Activo';
    notifyListeners();

    try {
      _categorias = await _service.obtenerActivos();
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Error al cargar categorías activas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cargar Categorías Inactivas: GET /api/Categorias/inactivos
  Future<void> cargarInactivos() async {
    _isLoading = true;
    _errorMessage = null;
    _selectedFilterStatus = 'Inactivo';
    notifyListeners();

    try {
      _categorias = await _service.obtenerInactivos();
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Error al cargar categorías inactivas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cambio en el dropdown de Estado (exclusivamente Activas o Inactivas)
  Future<void> cambiarFiltroEstado(String nuevoFiltro) async {
    if (nuevoFiltro == 'Inactivo') {
      await cargarInactivos();
    } else {
      await cargarActivos();
    }
  }

  // Búsqueda:
  // - Si solo se envía Código -> GET /api/Categorias/{id}
  // - Si se envían Código y Nombre (o solo Nombre) -> GET /api/Categorias/buscar
  Future<void> buscarCategorias({String? codigo, String? nombre}) async {
    final cleanCode = codigo?.trim() ?? '';
    final cleanName = nombre?.trim() ?? '';

    // Si ambos están vacíos, recargamos según el filtro activo actual (Activos o Inactivos)
    if (cleanCode.isEmpty && cleanName.isEmpty) {
      if (_selectedFilterStatus == 'Inactivo') {
        await cargarInactivos();
      } else {
        await cargarActivos();
      }
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Solo Código -> GET /api/Categorias/{id}
      if (cleanCode.isNotEmpty && cleanName.isEmpty) {
        final id = int.tryParse(cleanCode);
        if (id == null || id <= 0) {
          _categorias = [];
        } else {
          final cat = await _service.obtenerPorId(id);
          _categorias = cat != null ? [cat] : [];
        }
      } 
      // Código y Nombre (o solo Nombre) -> GET /api/Categorias/buscar
      else {
        final id = cleanCode.isNotEmpty ? int.tryParse(cleanCode) : null;
        final resultados = await _service.buscar(
          nombre: cleanName.isNotEmpty ? cleanName : null,
          id: id,
        );
        _categorias = resultados;
      }
    } on AppException catch (e) {
      _errorMessage = e.message;
      _categorias = [];
    } catch (e) {
      _errorMessage = 'Error en la búsqueda: $e';
      _categorias = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // POST /api/Categorias y recarga de Activos
  Future<bool> crearCategoria(String nombre) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final msg = await _service.registrarCategoria(nombre);
      _successMessage = msg;
      await cargarActivos();
      return true;
    } on FormatException catch (e) {
      _errorMessage = e.message;
      return false;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Error al crear la categoría: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // PUT /api/Categorias/{id} y recarga de Activos
  Future<bool> actualizarCategoria(int id, String nombre, bool activo) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final msg = await _service.actualizarCategoria(id, nombre, activo);
      _successMessage = msg;
      await cargarActivos();
      return true;
    } on FormatException catch (e) {
      _errorMessage = e.message;
      return false;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Error al actualizar la categoría: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // DELETE /api/Categorias/{id} y recarga de Activos
  Future<bool> desactivarCategoria(int id) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final msg = await _service.desactivarCategoria(id);
      _successMessage = msg;
      await cargarActivos();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Error al desactivar: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // PATCH /api/Categorias/restaurar/{id} (Activación de Inactivos)
  Future<bool> restaurarCategoria(int id) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final msg = await _service.restaurarCategoria(id);
      _successMessage = msg;
      if (_selectedFilterStatus == 'Inactivo') {
        await cargarInactivos();
      } else {
        await cargarActivos();
      }
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Error al restaurar: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
