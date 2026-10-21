import '../data/models/categoria_model.dart';
import '../data/repositories/categoria_repository.dart';

class CategoriaService {
  final CategoriaRepository _repository;

  CategoriaService(this._repository);

  Future<List<CategoriaModel>> obtenerActivos() async {
    return await _repository.getActivos();
  }

  Future<List<CategoriaModel>> obtenerInactivos() async {
    return await _repository.getInactivos();
  }

  Future<CategoriaModel?> obtenerPorId(int id) async {
    if (id <= 0) {
      throw const FormatException('El código debe ser un número entero mayor a 0');
    }
    return await _repository.getById(id);
  }

  Future<List<CategoriaModel>> buscar({String? nombre, int? id}) async {
    return await _repository.buscar(nombre: nombre, id: id);
  }

  Future<String> registrarCategoria(String nombre) async {
    final cleanName = nombre.trim();
    if (cleanName.isEmpty) {
      throw const FormatException('El nombre de la categoría no puede estar vacío');
    }
    if (cleanName.length < 3) {
      throw const FormatException('El nombre de la categoría debe tener al menos 3 caracteres');
    }

    final model = CategoriaModel(
      idCategoria: 0,
      nombre: cleanName,
      activo: true,
    );

    return await _repository.crear(model);
  }

  Future<String> actualizarCategoria(int id, String nombre, bool activo) async {
    if (id <= 0) {
      throw const FormatException('El ID de categoría no es válido');
    }
    final cleanName = nombre.trim();
    if (cleanName.isEmpty) {
      throw const FormatException('El nombre de la categoría no puede estar vacío');
    }

    final model = CategoriaModel(
      idCategoria: id,
      nombre: cleanName,
      activo: activo,
    );

    return await _repository.actualizar(id, model);
  }

  Future<String> desactivarCategoria(int id) async {
    if (id <= 0) {
      throw const FormatException('El ID de categoría no es válido');
    }
    return await _repository.eliminar(id);
  }

  Future<String> restaurarCategoria(int id) async {
    if (id <= 0) {
      throw const FormatException('El ID de categoría no es válido');
    }
    return await _repository.restaurar(id);
  }
}
