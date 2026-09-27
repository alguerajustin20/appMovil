import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/screens/bench/dashboard-screendart/dashboard_screen.dart';
import '../widgets/custom_bottom_navigation.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  int selectedFilter = 0;
  final List<String> filters = [
    'Todos',
    'Admin',
    'Meseros',
    'Cocineros',
    'Cajero',
  ];
  int _currentIndex = 2;

  void _showAddUserDialog() {
    final nameController = TextEditingController();
    final roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Agregar Usuario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(
                labelText: 'Rol (Admin, Mesero, etc.)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007A8C),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _currentIndex = 2;
    });
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Usuarios',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Gestiona el acceso y los roles del personal',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar usuario...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(filters.length, (index) {
                    final isSelected = selectedFilter == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(filters[index]),
                        selected: isSelected,
                        selectedColor: const Color(0xFF4DD0E1),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.grey.shade300,
                          ),
                        ),
                        onSelected: (bool selected) =>
                            setState(() => selectedFilter = index),
                      ),
                    );
                  }),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'No hay usuarios registrados',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
        backgroundColor: const Color(0xFF007A8C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),

      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          }
          /*
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const prueba1()),
            );
          }*/
          /*
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const prueba2()),
            );
          }*/
        },
      ),
    );
  }
}
