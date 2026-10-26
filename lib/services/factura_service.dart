import '../data/models/factura_model.dart';
import '../data/repositories/factura_repository.dart';

class FacturaService {
  final FacturaRepository _repository;

  FacturaService(this._repository);

  Future<List<FacturaModel>> obtenerFacturasActivas() async {
    return await _repository.getFacturasActivas();
  }
}
