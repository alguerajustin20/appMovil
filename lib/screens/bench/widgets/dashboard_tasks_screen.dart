import 'package:flutter/material.dart';

class DashboardTasks extends StatefulWidget {
  const DashboardTasks({super.key});

  @override
  State<DashboardTasks> createState() => _DashboardTasks();
}

class _DashboardTasks extends State<DashboardTasks> {
  // Lista de estados para simular cuáles tareas están completadas
  //final List<bool> _taskStatuses = [false, true, false];
  final List<bool> _taskStatuses = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la tarjeta
            const Text(
              'Tareas Recientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Tarea 1
            _buildTaskItem(
              index: 0,
              title: 'Revisar Lote B de Coca Cola',
              tagLabel: 'Urgente',
              tagBgColor: const Color(0xFFFFEBEE),
              tagTextColor: Colors.red,
              dateLabel: 'Hoy',
            ),
            const Divider(color: Color(0xFFF5F5F5), height: 1),

            // Tarea 2
            _buildTaskItem(
              index: 1,
              title: 'Actualizar Registros Proveedores',
              tagLabel: 'Normal',
              tagBgColor: const Color(0xFFF5F5F5),
              tagTextColor: Colors.blueGrey,
              dateLabel: 'Mañana',
            ),
            const Divider(color: Color(0xFFF5F5F5), height: 1),

            // Tarea 3
            _buildTaskItem(
              index: 2,
              title: 'Reporte de Auditoría Mensual',
              tagLabel: 'Normal',
              tagBgColor: const Color(0xFFF5F5F5),
              tagTextColor: Colors.blueGrey,
              dateLabel: 'En 3 días',
            ),
          ],
        ),
      ),
    );
  }

  // Helper para construir cada fila de tarea interactiva
  Widget _buildTaskItem({
    required int index,
    required String title,
    required String tagLabel,
    required Color tagBgColor,
    required Color tagTextColor,
    required String dateLabel,
  }) {
    final isCompleted = _taskStatuses[index];

    return ListTile(
      contentPadding: EdgeInsets.zero,
      // Cambia el estado del check al presionar cualquier parte de la fila
      onTap: () {
        setState(() {
          _taskStatuses[index] = !_taskStatuses[index];
        });
      },
      // Ícono de Check dinámico según wireframe
      leading: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isCompleted ? const Color(0xFF036573) : Colors.grey.shade300,
            width: 2,
          ),
          color: isCompleted ? Colors.transparent : Colors.transparent,
        ),
        child: isCompleted
            ? const Icon(Icons.check, size: 16, color: Color(0xFF036573))
            : null,
      ),
      // Título y fila inferior de detalles
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              // Badge de prioridad redondeado
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
              // Texto del tiempo/fecha
              Text(
                dateLabel,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
