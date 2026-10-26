import 'package:flutter/material.dart';
import '../../core/errors/app_exception.dart';
import '../../data/models/factura_model.dart';
import '../../services/factura_service.dart';

class FacturaProvider extends ChangeNotifier {
  final FacturaService _service;

  FacturaProvider(this._service);

  List<FacturaModel> _facturas = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<FacturaModel> get facturas => _facturas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> cargarFacturasActivas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _facturas = await _service.obtenerFacturasActivas();
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Error al conectar con el servidor de Facturas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
