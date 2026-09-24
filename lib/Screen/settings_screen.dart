import 'package:flutter/material.dart';

/// Paleta "Campestre" (Adobe Color) usada en todo el proyecto.
class AppColors {
  static const teal = Color(0xFF03738C);
  static const tealDark = Color(0xFF037F8C);
  static const brown = Color(0xFF734610);
  static const brownLight = Color(0xFFA6671B);
  static const mustard = Color(0xFFFF910F);
  static const mustardLight = Color(0xFFFDB653);
  static const background = Color(0xFFF7F7F5);
  static const cardBorder = Color(0xFFE9E5DE);
  static const textMuted = Color(0xFF8A8A8A);
  static const danger = Color(0xFFD9534F);
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _darkMode = false;

  // TODO: reemplazar con datos reales del usuario autenticado
  final String _userName = 'Yamil';
  final String _userEmail = 'yamil@campestre.co';
  final String _userRole = 'Administrador';
  final String _lastSync = 'hace 2m';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.brown),
          onPressed: () {
            // TODO: abrir drawer / navegación lateral
          },
        ),
        title: const Text(
          'Ajustes',
          style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.brown),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileCard(),
          const SizedBox(height: 20),
          _sectionLabel('CUENTA'),
          _settingsCard(
            children: [
              _navTile(
                icon: Icons.person_outline,
                label: 'Información Personal',
                onTap: () {},
              ),
              _divider(),
              _navTile(
                icon: Icons.lock_outline,
                label: 'Seguridad y Contraseña',
                onTap: () {},
              ),
              _divider(),
              _switchTile(
                icon: Icons.notifications_active_outlined,
                label: 'Notificaciones Push',
                subtitle: 'Alertas críticas de inventario',
                value: _pushNotifications,
                onChanged: (v) => setState(() => _pushNotifications = v),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _sectionLabel('PREFERENCIAS'),
          _settingsCard(
            children: [
              _navTile(
                icon: Icons.language,
                label: 'Idioma',
                trailingText: 'Español',
                onTap: () {},
              ),
              _divider(),
              _switchTile(
                icon: Icons.dark_mode_outlined,
                label: 'Modo Oscuro',
                value: _darkMode,
                onChanged: (v) => setState(() => _darkMode = v),
              ),
              _divider(),
              _navTile(
                icon: Icons.sync,
                label: 'Sincronización de Datos',
                trailingText: 'Sincronizado: $_lastSync',
                trailingColor: AppColors.teal,
                onTap: () {
                  // TODO: disparar sincronización manual
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          _sectionLabel('SOPORTE'),
          _settingsCard(
            children: [
              _navTile(
                icon: Icons.help_outline,
                label: 'Centro de Ayuda',
                trailingIcon: Icons.open_in_new,
                onTap: () {},
              ),
              _divider(),
              _navTile(
                icon: Icons.info_outline,
                label: 'Acerca de la App',
                trailingText: 'v2.4.1',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _logoutButton(),
          const SizedBox(height: 8),
        ],
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  // ---------- Piezas reutilizables ----------

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.mustardLight,
            child: Icon(Icons.person, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _userEmail,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _userRole,
                    style: const TextStyle(
                      color: AppColors.teal,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.brownLight,
              size: 20,
            ),
            onPressed: () {
              // TODO: editar perfil
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.brownLight,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, indent: 52, color: AppColors.cardBorder);

  Widget _navTile({
    required IconData icon,
    required String label,
    String? trailingText,
    Color? trailingColor,
    IconData? trailingIcon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.brown, size: 22),
      title: Text(label, style: const TextStyle(fontSize: 14.5)),
      trailing: trailingIcon != null
          ? Icon(trailingIcon, size: 18, color: AppColors.textMuted)
          : trailingText != null
          ? Text(
              trailingText,
              style: TextStyle(
                color: trailingColor ?? AppColors.textMuted,
                fontSize: 13,
              ),
            )
          : const Icon(Icons.chevron_right, color: AppColors.textMuted),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String label,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.brown, size: 22),
      title: Text(label, style: const TextStyle(fontSize: 14.5)),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            )
          : null,
      trailing: Switch(
        value: value,
        activeColor: AppColors.teal,
        onChanged: onChanged,
      ),
    );
  }

  Widget _logoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          // TODO: cerrar sesión (limpiar token/estado y navegar a Login)
        },
        icon: const Icon(Icons.logout, color: AppColors.danger),
        label: const Text(
          'CERRAR SESIÓN',
          style: TextStyle(
            color: AppColors.danger,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.danger.withOpacity(0.08),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 3, // Ajustes activo
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.teal,
      unselectedItemColor: AppColors.textMuted,
      showUnselectedLabels: true,
      onTap: (index) {
        // TODO: navegar entre Panel / Inventario / Usuarios / Ajustes
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: 'Panel',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: 'Inventario',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Usuarios',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
      ],
    );
  }
}
