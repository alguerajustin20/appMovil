import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_theme.dart';
//import '../../../widgets/custom_bottom_navigation.dart';
import '../../../providers/auth_provider.dart';
import '../../security/login_screen.dart';
import '../widgets/account_section.dart';
import '../widgets/edit_username_dialog.dart';
import '../widgets/preferences_section.dart';
import '../widgets/settings_logout_button.dart';
import '../widgets/settings_profile_card.dart';
import '../widgets/support_section.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // TODO: reemplazar con los datos del usuario autenticado cuando exista la API
  String _userName = 'Yamil72';
  final String _userEmail = 'yamil';
  final String _userRole = 'Administrador';

  Future<void> _editUsername() async {
    final newName = await showEditUsernameDialog(context, _userName);
    if (newName != null && mounted) {
      setState(() => _userName = newName);
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: const Text(
          'Se cerrará tu sesión activa y se invalidara su acceso rapido.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogContext); // Cierra el diálogo

              try {
                // 1. Ejecuta el logout del Provider (llama al AuthService y limpia tokens)
                await Provider.of<AuthProvider>(
                  context,
                  listen: false,
                ).logout();

                // 2. Navegación correcta al Login limpiando el historial
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              }
            },
            child: const Text('Salir', style: TextStyle(color: Colors.white)),
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
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Ajustes',
          style: TextStyle(
            color: c.isDark ? Colors.white : AppColors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Image.asset(
              'assets/images/logo_B.png',
              width: 69,
              height: 69,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsProfileCard(
            userName: _userName,
            userEmail: _userEmail,
            userRole: _userRole,
            onEdit: _editUsername,
          ),
          const SizedBox(height: 20),
          AccountSection(userName: _userName),
          const SizedBox(height: 20),
          const PreferencesSection(),
          const SizedBox(height: 20),
          const SupportSection(),
          const SizedBox(height: 24),
          SettingsLogoutButton(onPressed: _logout),
          SettingsLogoutButton(onPressed: () => _showLogoutDialog(context)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
