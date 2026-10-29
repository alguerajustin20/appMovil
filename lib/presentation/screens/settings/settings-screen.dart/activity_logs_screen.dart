import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/models/metrics_model.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_theme.dart';
import '../../../providers/metrics_provider.dart';

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
      appBar: AppBar(
        title: const Text(
          'Bitácora y Rendimiento',
          style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.teal),
            onPressed: () {
              Provider.of<MetricsProvider>(
                context,
                listen: false,
              ).fetchMetrics();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.teal,
          labelColor: AppColors.teal,
          unselectedLabelColor: c.textMuted,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.history_rounded), text: 'Bitácora'),
            Tab(icon: Icon(Icons.speed_rounded), text: 'Rendimiento'),
          ],
        ),
      ),
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
        _buildFilterChips(c),
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

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: provider.logs.length,
                itemBuilder: (context, index) {
                  final log = provider.logs[index];
                  return _buildLogCard(log, c);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLogCard(MetricModel log, AppPalette c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.cardBorder),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.teal.withValues(alpha: 0.15),
          child: const Icon(
            Icons.history_rounded,
            color: AppColors.teal,
            size: 20,
          ),
        ),
        title: Text(
          log.accion,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: c.textPrimary,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          'Usuario: ${log.usuario}\nFecha: ${log.timestamp}',
          style: TextStyle(color: c.textMuted, fontSize: 12),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: c.textMuted),
      ),
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

        // Calculamos un promedio de latencia total rápida
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
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    'Peticiones Totales',
                    '${provider.requestMetrics.length}',
                    Icons.analytics_rounded,
                    AppColors.teal,
                    c,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    'Latencia Promedio',
                    '${avgDuration} ms',
                    Icons.timer_rounded,
                    Colors.orangeAccent,
                    c,
                  ),
                ),
              ],
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
            ...provider.requestMetrics.map((req) => _buildRequestCard(req, c)),
          ],
        );
      },
    );
  }

  Widget _buildRequestCard(RequestMetricModel req, AppPalette c) {
    final isSuccess = req.statusCode >= 200 && req.statusCode < 300;
    final statusColor = isSuccess ? Colors.green : Colors.redAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Método HTTP, Ruta y StatusCode
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${req.method} ${req.route}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${req.statusCode}',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Badges de Tiempos y Servicios (DurationMs, SqlMs, RedisMs, AppMs)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildBadge('Total: ${req.durationMs}ms', AppColors.teal),
              _buildBadge('SQL: ${req.sqlMs}ms', Colors.blue),
              _buildBadge('Redis: ${req.redisMs}ms', Colors.purpleAccent),
              _buildBadge('App: ${req.appMs}ms', Colors.orange),
            ],
          ),
          const SizedBox(height: 8),

          // Usuario e IP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'User: ${req.username}',
                style: TextStyle(
                  fontSize: 11,
                  color: c.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'IP: ${req.ipAddress}',
                style: TextStyle(fontSize: 11, color: c.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildKpiCard(
    String title,
    String value,
    IconData icon,
    Color color,
    AppPalette c,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 11, color: c.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(AppPalette c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: ['Todos', 'Hoy', 'Este Mes'].map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: AppColors.teal,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : c.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              backgroundColor: c.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Colors.transparent : c.cardBorder,
                ),
              ),
            ),
          );
        }).toList(),
      ),
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
