import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_theme.dart';
import '../../../providers/metrics_provider.dart';
import '../widget/logs_header_widget.dart';
import '../widget/logs_filters_widget.dart';
import '../widget/logs_list_widget.dart';
import '../widget/logs_stats_widget.dart';

class SystemMonitoringScreen extends StatefulWidget {
  const SystemMonitoringScreen({super.key});

  @override
  State<SystemMonitoringScreen> createState() => _SystemMonitoringScreenState();
}

class _SystemMonitoringScreenState extends State<SystemMonitoringScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MetricsProvider>(context, listen: false).fetchMetrics();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;

    return Scaffold(
      appBar: LogsHeaderWidget(controller: _tabController),
      body: TabBarView(
        controller: _tabController,
        children: [
          // PESTAÑA 1: System Logs (Bitácora de Actividad)
          _buildLogsView(c),

          // PESTAÑA 2: Request Metrics (Telemetría de Tiempos y Backend)
          _buildPerformanceView(c),
        ],
      ),
    );
  }

  // ==========================================
  // VISTA 1: BITÁCORA DE ACTIVIDAD (LOGS)
  // ==========================================
  Widget _buildLogsView(AppPalette c) {
    return Column(
      children: [
        LogsFiltersWidget(
          selectedFilter: _selectedFilter,
          onFilterSelected: (filter) {
            setState(() {
              _selectedFilter = filter;
            });
          },
          c: c,
        ),
        Expanded(
          child: Consumer<MetricsProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.teal),
                );
              }

              if (provider.errorMessage != null) {
                return _buildErrorState(provider, c);
              }

              if (provider.logs.isEmpty) {
                return Center(
                  child: Text(
                    'No hay registros en la bitácora.',
                    style: TextStyle(color: c.textMuted),
                  ),
                );
              }

              return LogsListWidget(logs: provider.logs, c: c);
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // VISTA 2: RENDIMIENTO Y MÉTRICAS DE REQUESTS
  // ==========================================
  Widget _buildPerformanceView(AppPalette c) {
    return Consumer<MetricsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.teal),
          );
        }

        if (provider.errorMessage != null) {
          return _buildErrorState(provider, c);
        }

        if (provider.requestMetrics.isEmpty) {
          return Center(
            child: Text(
              'Sin métricas de rendimiento disponibles.',
              style: TextStyle(color: c.textMuted),
            ),
          );
        }

        final avgDuration = provider.requestMetrics.isEmpty
            ? 0
            : (provider.requestMetrics
                          .map((e) => e.durationMs)
                          .reduce((a, b) => a + b) /
                      provider.requestMetrics.length)
                  .round();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // KPIs de Encabezado
            LogsStatsWidget(
              totalRequests: provider.requestMetrics.length,
              avgDuration: avgDuration,
              c: c,
            ),
            const SizedBox(height: 20),

            Text(
              'Telemetría de Peticiones HTTP',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Lista de Tarjetas de Rendimiento con los campos reales de Mongo
            ...provider.requestMetrics.map(
              (req) => RequestCardWidget(req: req, c: c),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorState(MetricsProvider provider, AppPalette c) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.redAccent),
          const SizedBox(height: 12),
          Text(
            'Error al conectar con MongoDB',
            style: TextStyle(fontWeight: FontWeight.bold, color: c.textPrimary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => provider.fetchMetrics(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
