import 'package:flutter/material.dart';
import 'help_dialog.dart';
import 'settings_nav_tile.dart';
import 'settings_section.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'SOPORTE',
      children: [
        SettingsNavTile(
          iconLight: 'assets/icons/docs/informacion_negro.png',
          iconDark: 'assets/icons/docs/informacion_blanco.png',
          label: 'Centro de Ayuda',
          trailingIcon: Icons.open_in_new,
          onTap: () => showHelpDialog(context),
        ),
        SettingsNavTile(
          iconLight: 'assets/icons/error/signo_de_admiracion_negro.png',
          iconDark: 'assets/icons/error/signo_de_admiracion_blanco.png',
          label: 'Acerca de la App',
          trailingText: 'v2.4.1',
          onTap: () {},
        ),
      ],
    );
  }
}
