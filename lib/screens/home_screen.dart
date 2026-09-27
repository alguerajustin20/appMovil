import 'package:flutter/material.dart';
import 'user_management_screen.dart';
import 'add_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF007A8C), width: 1.5),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icons/user/usuario_claro.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.person,
                          color: Color(0xFF007A8C),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none_outlined, size: 28),
                    color: const Color(0xFF2D3142),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Hola, ',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Buenas tardes • Martes, 12 de Octubre',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 24),

              _buildMenuCard(
                iconPath: 'assets/icons/performance/miniaturas_claro.png',
                fallbackIcon: Icons.grid_view_rounded,
                iconBgColor: const Color(0xFFE6F4F6),
                iconColor: const Color(0xFF007A8C),
                title: 'Dashboard',
                subtitle: 'Ver KPIs y resumen del negocio',
                onTap: () {},
              ),
              const SizedBox(height: 14),

              _buildMenuCard(
                iconPath: 'assets/icons/inventory/archivo_caja_negra.png',
                fallbackIcon: Icons.inventory_2_outlined,
                iconBgColor: const Color(0xFFFDF6EA),
                iconColor: const Color(0xFFD97706),
                title: 'Inventario',
                subtitle: 'Gestionar stock y productos',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddProductScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              _buildMenuCard(
                iconPath: 'assets/icons/user/usuario_claro.png',
                fallbackIcon: Icons.group_outlined,
                iconBgColor: const Color(0xFFFDF3EC),
                iconColor: const Color(0xFFC2410C),
                title: 'Usuarios',
                subtitle: 'Control de acceso y personal',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserManagementScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              _buildMenuCard(
                iconPath: 'assets/icons/config/ajuste_negro.png',
                fallbackIcon: Icons.settings_outlined,
                iconBgColor: const Color(0xFFF1F5F9),
                iconColor: const Color(0xFF64748B),
                title: 'Ajustes',
                subtitle: 'Configuración y seguridad',
                onTap: () {},
              ),
              const SizedBox(height: 28),

              const Text(
                'RESUMEN RÁPIDO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 12),

              _buildQuickSummaryCard(
                icon: Icons.tune,
                iconBgColor: const Color(0xFFE6F4F6),
                iconColor: const Color(0xFF007A8C),
                text: '3 tareas pendientes',
              ),
              const SizedBox(height: 10),

              _buildQuickSummaryCard(
                icon: Icons.warning_amber_rounded,
                iconBgColor: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFD97706),
                text: 'Stock bajo en 2 productos',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required String iconPath,
    required IconData fallbackIcon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Image.asset(
                      iconPath,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      color: iconColor,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        fallbackIcon,
                        color: iconColor,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickSummaryCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}