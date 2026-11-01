import 'package:flutter/material.dart';
import '../../../../../data/models/metrics_model.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../theme/app_theme.dart';

// ==========================================
// KPIs de encabezado (Peticiones y Latencia)
// ==========================================
class LogsStatsWidget extends StatelessWidget {
  final int totalRequests;
  final int avgDuration;
  final AppPalette c;

  const LogsStatsWidget({
    super.key,
    required this.totalRequests,
    required this.avgDuration,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildKpiCard(
            'Peticiones Totales',
            '$totalRequests',
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
}

// ==========================================
// Tarjeta de telemetría de cada petición HTTP
// ==========================================
class RequestCardWidget extends StatelessWidget {
  final RequestMetricModel req;
  final AppPalette c;

  const RequestCardWidget({super.key, required this.req, required this.c});

  @override
  Widget build(BuildContext context) {
    return _buildRequestCard(req, c);
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
}
