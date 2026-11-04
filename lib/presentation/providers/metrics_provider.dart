import 'package:flutter/material.dart';
import '../../data/models/metrics_model.dart';
import '../../service/metrics_service.dart';

class MetricsProvider extends ChangeNotifier {
  final MetricsService _metricsService;

  MetricsProvider(this._metricsService);

  List<MetricModel> _logs = [];
  List<RequestMetricModel> _requestMetrics = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MetricModel> get metrics => _logs;
  List<MetricModel> get logs => _logs;
  List<RequestMetricModel> get requestMetrics => _requestMetrics;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMetrics() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _metricsService.getSystemLogs(),
        _metricsService.getRequestMetrics(),
      ]);

      _logs = (results[0] as List)
          .map((item) => MetricModel.fromJson(item))
          .toList();

      _requestMetrics = (results[1] as List)
          .map((item) => RequestMetricModel.fromJson(item))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
