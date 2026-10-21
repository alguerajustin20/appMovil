import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class ActivityLogsScreen extends StatefulWidget {
  const ActivityLogsScreen({super.key});

  @override
  State<ActivityLogsScreen> createState() => _ActivityLogsScreenState();
}

class _ActivityLogsScreenState extends State<ActivityLogsScreen> {
  // Filtro seleccionado ('Todos', 'Hoy', 'Este Mes')
  String _selectedFilter = 'Todos';

  // TODO: Reemplazar con los datos reales que vengan de tu API del backend
  final List<Map<String, dynamic>> _logs = [
    {
      'id': 1,
      'user': 'Yamil72',
      'action': 'Inicio de sesión exitoso',
      'module': 'Autenticación',
      'date': '09 Oct 2026, 08:30 PM',
    },
    {
      'id': 2,
      'user': 'Yamil72',
      'action': 'Registro de nuevo producto (Café de Altura)',
      'module': 'Inventario',
      'date': '09 Oct 2026, 04:15 PM',
    },
    {
      'id': 3,
      'user': 'AdminTest',
      'action': 'Modificación de rol de usuario',
      'module': 'Usuarios',
      'date': '08 Oct 2026, 11:10 AM',
    },
  ];

  // Función para mostrar el Bottom Sheet con el detalle del log
  void _showLogDetail(Map<String, dynamic> log) {
    final c = context.palette;

    showModalBottomSheet(
      context: context,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicador superior de arrastre
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.textMuted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Detalle de la Accion',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Módulo:', log['module'], c),
              _buildDetailRow('Acción:', log['action'], c),
              _buildDetailRow('Usuario:', log['user'], c),
              _buildDetailRow('Fecha y Hora:', log['date'], c),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, AppPalette c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, color: c.textMuted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: c.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bitácora de Actividad',
          style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filtros rápidos superiores (Día, Mes, Todos)
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                        // TODO: Filtrar los datos o llamar al backend con el parámetro de fecha
                      });
                    },
                    selectedColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : c.textPrimary,
                      fontWeight: FontWeight.w500,
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
          ),

          // Lista de Registros
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: c.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: c.cardBorder),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.15),
                      child: Icon(
                        Icons.history_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(
                      log['action'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: c.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '${log['module']} • ${log['date']}',
                        style: TextStyle(color: c.textMuted, fontSize: 12),
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: c.textMuted,
                    ),
                    onTap: () => _showLogDetail(log),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
