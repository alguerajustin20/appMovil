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
  //aqui es la parte donde se obtiene el usuario autenticado desde el AuthProvider y se muestran sus datos en la pantalla de ajustes.
  Future<void> _editUsername() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentName = authProvider.currentUser?.username ?? '';

    final newName = await showEditUsernameDialog(context, currentName);
    if (newName != null && newName.isNotEmpty && mounted) {
      try {
        // 3. Aquí debes llamar al método de tu AuthProvider o AuthService
        // para actualizarlo en la Base de Datos (Backend en C# / MongoDB).
        // Ejemplo:
        // await authProvider.updateUsername(newName);

        setState(() {}); // Refresca la vista si es necesario

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nombre de usuario actualizado con éxito'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
    // Obtenemos el usuario autenticado desde el AuthProvider
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    // Asignamos los datos reales (o valores por defecto si es nulo)
    final String userName = authProvider.currentUser?.username ?? 'Lordvader';
    final String userEmail =
        authProvider.currentUser?.nombreCompleto ??
        'vader30'; // O el campo que use modelo
    final String userRole = authProvider.getRolName();
    debugPrint(
      '🔍 USUARIO ACTUAL EN PROVIDER: $user | Username: ${user?.username}',
    );

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
            userName: userName,
            userEmail: userEmail,
            userRole: userRole,
            onEdit: _editUsername,
          ),

          const SizedBox(height: 20),
          AccountSection(userName: userName),
          const SizedBox(height: 20),
          const PreferencesSection(),
          const SizedBox(height: 20),
          const SupportSection(),
          const SizedBox(height: 24),

          SettingsLogoutButton(onPressed: () => _showLogoutDialog(context)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
