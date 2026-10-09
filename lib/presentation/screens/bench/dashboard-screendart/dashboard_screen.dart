import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/presentation/screens/bench/widgets/dashboard_bench_screen.dart';
import 'package:integrador_vi_mobile/presentation/screens/bench/widgets/dashboard_cards_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Paleta de colores consistente con la HomeScreen
    const darkBackgroundColor = Color(0xFF121212);
    const lightBackgroundColor = Color(0xFFF8F9FA);

    final backgroundColor = isDarkMode
        ? darkBackgroundColor
        : lightBackgroundColor;
    final primaryTitleColor = isDarkMode
        ? const Color(0xFF00B4D8)
        : const Color(0xFF03738C);
    final defaultIconColor = isDarkMode ? const Color(0xFF94A3B8) : Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 65.0,
        titleSpacing: 20.0,
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: isDarkMode
                ? const Color(0xFF00B4D8)
                : const Color(0xFF03738C),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                'assets/images/logo_B.png',
                width: 65,
                height: 65,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- SALUDO 2 Y FECHA ---
                Text(
                  'Hola, yamil72',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? const Color(0xFF00B4D8)
                        : const Color(0xFF03738C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Buenas tardes • Martes, 12 de Octubre',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // PRIMER GRUPO DE 4 TARJETAS
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.35,
                  children: [
                    DashboardCards(
                      title: 'Total de Productos',
                      value: '12,450',
                      valueColor: primaryTitleColor,
                      icon: Icons.inventory_2_outlined,
                      iconColor: defaultIconColor,
                    ),
                    DashboardCards(
                      title: 'Comandas Pendientes',
                      value: '8',
                      valueColor: isDarkMode
                          ? const Color(0xFFFDB653)
                          : const Color(0xFF734610),
                      icon: Icons.note_alt_outlined,
                      iconColor: isDarkMode
                          ? const Color(0xFFFDB653)
                          : const Color(0xFF734610),
                      badge: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(
                            isDarkMode ? 0.2 : 0.15,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'URGENTES',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DashboardCards(
                      title: 'Usuarios Activos',
                      value: '145',
                      valueColor: primaryTitleColor,
                      icon: Icons.group_outlined,
                      iconColor: defaultIconColor,
                    ),
                    DashboardCards(
                      title: 'Bajo Stock',
                      value: '24',
                      valueColor: const Color(0xFFF59E0B),
                      icon: Icons.warning_amber_outlined,
                      iconColor: const Color(0xFFF59E0B),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // 📊 COMPONENTE GRÁFICO INTERACTIVO NATIVO
                const DashboardBench(),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
