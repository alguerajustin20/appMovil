import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/theme/app_colors.dart';
import '../../../theme/app_theme.dart';

class DashboardTasks extends StatefulWidget {
  const DashboardTasks({super.key});

  @override
  State<DashboardTasks> createState() => _DashboardTasks();
}

class _DashboardTasks extends State<DashboardTasks> {
  final List<bool> _taskStatuses = [false, false, false];

  @override
  Widget build(BuildContext context) {
    final c = context.palette;

    return Card(
      color: c.card,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tareas Recientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            _buildTaskItem(
              context: context,
              index: 0,
              title: 'Revisar Lote B de Coca Cola',
              tagLabel: 'Urgente',
              tagBgColor: const Color(0xFFFFEBEE),
              tagTextColor: Colors.red,
              dateLabel: 'Hoy',
            ),
            Divider(color: c.cardBorder, height: 1),

            _buildTaskItem(
              context: context,
              index: 1,
              title: 'Actualizar Registros Proveedores',
              tagLabel: 'Normal',
              tagBgColor: c.isDark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFF5F5F5),
              tagTextColor: Colors.blueGrey,
              dateLabel: 'Mañana',
            ),
            Divider(color: c.cardBorder, height: 1),

            _buildTaskItem(
              context: context,
              index: 2,
              title: 'Reporte de Auditoría Mensual',
              tagLabel: 'Normal',
              tagBgColor: c.isDark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFF5F5F5),
              tagTextColor: Colors.blueGrey,
              dateLabel: 'En 3 días',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem({
    required BuildContext context,
    required int index,
    required String title,
    required String tagLabel,
    required Color tagBgColor,
    required Color tagTextColor,
    required String dateLabel,
  }) {
    final c = context.palette;
    final isCompleted = _taskStatuses[index];

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        setState(() {
          _taskStatuses[index] = !_taskStatuses[index];
        });
      },
      leading: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isCompleted
                ? AppColors.teal
                : c.textMuted.withValues(alpha: 0.4),
            width: 2,
          ),
          color: Colors.transparent,
        ),
        child: isCompleted
            ? Icon(Icons.check, size: 16, color: AppColors.teal)
            : null,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: c.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tagBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tagLabel,
                  style: TextStyle(
                    color: tagTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                dateLabel,
                style: TextStyle(color: c.textMuted, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
