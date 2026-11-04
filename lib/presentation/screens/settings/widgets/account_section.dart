import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import 'change_password_dialog.dart';
import 'settings_nav_tile.dart';
import 'settings_section.dart';
import '../../logs/activity-logs-screen/activity_logs_screen.dart';

class AccountSection extends StatelessWidget {
  final String userName;

  const AccountSection({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'CUENTA',
      children: [
        SettingsNavTile(
          iconLight: 'assets/icons/admin/account_claro.png',
          iconDark: 'assets/icons/admin/account_oscuro.png',
          label: 'Perfil',
          trailingText: userName,
          trailingColor: AppColors.teal,
          onTap: () {},
        ),
        // Los nombres de estos dos PNG están "al revés" a propósito:
        // as.
        // SettingsNavTile(
        //    iconLight: 'assets/icons/security/candado_oscuro.png',
        //    iconDark: 'assets/icons/security/candado_claro.png',
        //     label: 'Seguridad y Contraseña',
        //     onTap: () => showChangePasswordDialog(context),
        //  ),
        // Siguiente
        //SettingsNavTile(
        // iconLight: 'assets/icons/log/logs_blanco.png',
        //  iconDark: 'assets/icons/log/logs_oscuro.png',
        //  label: 'Monitoreo y Bitácora',
        //  onTap: () {
        //   Navigator.push(
        //    context,
        //   MaterialPageRoute(
        //      builder: (context) => const SystemMonitoringScreen(),
        //    ),
        //   );
        //    },
        //   ),
      ],
    );
  }
}
