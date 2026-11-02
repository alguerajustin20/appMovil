import 'package:flutter/material.dart';
import '../../../../../data/models/metrics_model.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../theme/app_theme.dart';

class LogsListWidget extends StatelessWidget {
  final List<MetricModel> logs;
  final AppPalette c;

  const LogsListWidget({super.key, required this.logs, required this.c});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return _buildLogCard(log, c);
      },
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
}
