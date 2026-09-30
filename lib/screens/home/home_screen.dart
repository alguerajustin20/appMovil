import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/screens/bench/dashboard-screendart/dashboard_screen.dart';
import '../manager/user_management_screen.dart';
import '../inventory/add_product_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Paleta de colores para modo oscuro (Estilo Ajustes / Dark AMOLED)
    const darkBackgroundColor = Color(0xFF121212);
    const darkCardColor = Color(0xFF1E1E1E);
    const darkBorderColor = Color(0xFF2C2C2C);
    const darkTextPrimary = Colors.white;
    const darkTextSecondary = Color(0xFF9E9E9E);
    const darkSectionLabel = Color(0xFFFDB653);

    // Colores dinámicos según el tema activo
    final backgroundColor = isDarkMode
        ? darkBackgroundColor
        : const Color(0xFFF8F9FA);
    final cardColor = isDarkMode ? darkCardColor : Colors.white;
    final textPrimaryColor = isDarkMode
        ? darkTextPrimary
        : const Color(0xFF1E293B);
    final textSecondaryColor = isDarkMode
        ? darkTextSecondary
        : const Color(0xFF64748B);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- ENCABEZADO ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF007A8C),
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icons/user/usuario_claro.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.person,
                                color: Color(0xFF007A8C),
                              ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.notifications_none_outlined,
                        size: 28,
                        color: isDarkMode
                            ? Colors.white
                            : const Color(0xFF2D3142),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- SALUDO Y FECHA ---
                Text(
                  'Hola, yamil72',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? const Color(0xFF00B4D8)
                        : const Color(0xFF03738C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Buenas tardes • Martes, 12 de Octubre',
                  style: TextStyle(fontSize: 17, color: textSecondaryColor),
                ),
                const SizedBox(height: 24),

                // --- DASHBOARD ---
                _buildMenuCard(
                  iconPath: 'assets/icons/performance/miniaturas_claro.png',
                  fallbackIcon: Icons.grid_view_rounded,
                  iconColor: const Color(0xFF00B4D8),
                  iconBgColor: isDarkMode
                      ? const Color(0xFF00B4D8).withOpacity(0.15)
                      : const Color(0xFFE6F4F6),
                  title: 'Dashboard',
                  subtitle: 'Ver KPIs y resumen del negocio',
                  isDarkMode: isDarkMode,
                  cardColor: cardColor,
                  borderColor: darkBorderColor,
                  textPrimary: textPrimaryColor,
                  textSecondary: textSecondaryColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),

                // --- INVENTARIO ---
                _buildMenuCard(
                  iconPath: 'assets/icons/inventory/archivo_caja_negra.png',
                  fallbackIcon: Icons.inventory_2_outlined,
                  iconColor: const Color(0xFFF59E0B),
                  iconBgColor: isDarkMode
                      ? const Color(0xFFF59E0B).withOpacity(0.15)
                      : const Color(0xFFFDF6EA),
                  title: 'Inventario',
                  subtitle: 'Gestionar stock y productos',
                  isDarkMode: isDarkMode,
                  cardColor: cardColor,
                  borderColor: darkBorderColor,
                  textPrimary: textPrimaryColor,
                  textSecondary: textSecondaryColor,
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

                // --- USUARIOS ---
                _buildMenuCard(
                  iconPath: 'assets/icons/user/usuario_claro.png',
                  fallbackIcon: Icons.group_outlined,
                  iconColor: const Color(0xFFF97316),
                  iconBgColor: isDarkMode
                      ? const Color(0xFFF97316).withOpacity(0.15)
                      : const Color(0xFFFDF3EC),
                  title: 'Usuarios',
                  subtitle: 'Control de acceso y personal',
                  isDarkMode: isDarkMode,
                  cardColor: cardColor,
                  borderColor: darkBorderColor,
                  textPrimary: textPrimaryColor,
                  textSecondary: textSecondaryColor,
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

                // --- AJUSTES ---
                _buildMenuCard(
                  iconPath: 'assets/icons/config/ajuste_negro.png',
                  fallbackIcon: Icons.settings_outlined,
                  iconColor: isDarkMode
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  iconBgColor: isDarkMode
                      ? const Color(0xFF94A3B8).withOpacity(0.15)
                      : const Color(0xFFF1F5F9),
                  title: 'Ajustes',
                  subtitle: 'Configuración y seguridad',
                  isDarkMode: isDarkMode,
                  cardColor: cardColor,
                  borderColor: darkBorderColor,
                  textPrimary: textPrimaryColor,
                  textSecondary: textSecondaryColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),

                // --- SECCIÓN RESUMEN RÁPIDO ---
                Text(
                  'RESUMEN RÁPIDO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: isDarkMode
                        ? darkSectionLabel
                        : const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 12),

                _buildQuickSummaryCard(
                  icon: Icons.tune,
                  iconColor: const Color(0xFF00B4D8),
                  iconBgColor: isDarkMode
                      ? const Color(0xFF00B4D8).withOpacity(0.15)
                      : const Color(0xFFE6F4F6),
                  text: '3 tareas pendientes',
                  isDarkMode: isDarkMode,
                  cardColor: cardColor,
                  borderColor: darkBorderColor,
                  textPrimary: textPrimaryColor,
                ),
                const SizedBox(height: 10),

                _buildQuickSummaryCard(
                  icon: Icons.warning_amber_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  iconBgColor: isDarkMode
                      ? const Color(0xFFF59E0B).withOpacity(0.15)
                      : const Color(0xFFFEF3C7),
                  text: 'Stock bajo en 2 productos',
                  isDarkMode: isDarkMode,
                  cardColor: cardColor,
                  borderColor: darkBorderColor,
                  textPrimary: textPrimaryColor,
                ),
                const SizedBox(height: 16),
              ],
            ),
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
    required bool isDarkMode,
    required Color cardColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: isDarkMode ? Border.all(color: borderColor) : null,
        boxShadow: isDarkMode
            ? []
            : [
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
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(fallbackIcon, color: iconColor, size: 24),
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
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 13, color: textSecondary),
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
    required bool isDarkMode,
    required Color cardColor,
    required Color borderColor,
    required Color textPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isDarkMode ? Border.all(color: borderColor) : null,
        boxShadow: isDarkMode
            ? []
            : [
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
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
