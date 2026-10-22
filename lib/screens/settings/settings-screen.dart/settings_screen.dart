import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
//import '../../../widgets/custom_bottom_navigation.dart';
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
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
