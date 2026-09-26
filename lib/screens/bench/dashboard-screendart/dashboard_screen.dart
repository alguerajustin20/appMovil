import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/screens/bench/widgets/dashboard_bench_screen.dart';
import 'package:integrador_vi_mobile/screens/bench/widgets/dashboard_cards_screen.dart';
import 'package:integrador_vi_mobile/screens/bench/widgets/dashboard_tasks_screen.dart';
import 'package:integrador_vi_mobile/screens/home_screen.dart';
import 'package:integrador_vi_mobile/screens/prueba1/prueba1-screendart/prueba1.dart';
import 'package:integrador_vi_mobile/screens/prueba2/prueba2-screendart/prueba2.dart';
import 'package:integrador_vi_mobile/screens/user_management_screen.dart';
import 'package:integrador_vi_mobile/widgets/custom_bottom_navigation.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _currentIndex = 0;
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          icon: Icon(Icons.menu),
        ),

        toolbarHeight:
            65.0, // 👈 Incrementa el alto de la barra para que el logo pueda crecer
        iconTheme: const IconThemeData(color: Colors.blueGrey),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Color.fromARGB(255, 3, 115, 140),
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                'assets/images/logo_B.png',
                width: 65, // 👈 El logo responderá a este tamaño más grande
                height: 65, // 👈 Alto proporcional equivalente
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      // 🛡️ Modificado: Cambiamos bottom a false para que la navegación se acople perfectamente abajo
      body: SafeArea(
        top: false,
        bottom: false, // El espacio del sistema lo maneja el menú inferior
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PRIMER GRUPO DE 4 TARJETAS MÓDULO CARD
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.4,
                  children: [
                    const DashboardCards(
                      title: 'Total en Inventario',
                      value: '12,450',
                      valueColor: Color.fromARGB(255, 3, 115, 140),
                      icon: Icons.inventory_2_outlined,
                      iconColor: Colors.grey,
                    ),
                    DashboardCards(
                      title: 'Tareas Pendientes',
                      value: '8',
                      valueColor: const Color.fromARGB(255, 115, 70, 16),
                      icon: Icons.note_alt_outlined,
                      iconColor: const Color.fromARGB(255, 115, 70, 16),
                      badge: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'URGENTES',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const DashboardCards(
                      title: 'Usuarios Activos',
                      value: '145',
                      valueColor: Color.fromARGB(255, 3, 115, 140),
                      icon: Icons.group_outlined,
                      iconColor: Colors.grey,
                    ),
                    const DashboardCards(
                      title: 'Bajo Stock',
                      value: '24',
                      valueColor: Color.fromARGB(255, 255, 145, 15),
                      icon: Icons.warning_amber_outlined,
                      iconColor: Color.fromARGB(255, 255, 145, 15),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // 📊 COMPONENTE GRÁFICO INTERACTIVO NATIVO
                const DashboardBench(),

                const SizedBox(
                  height: 25,
                ), // Este se mantiene igual para conservar la simetría inferior
                // 📋 LISTA DE TAREAS RECIENTES
                const DashboardTasks(),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Prueba1()),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserManagementScreen(),
              ),
            );
          }

          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Prueba2()),
            );
          }
        },
      ),
    );
  }
}