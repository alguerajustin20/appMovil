import 'package:flutter/material.dart';
import '../../../../main.dart';
import 'settings_section.dart';
import 'settings_switch_tile.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return SettingsSection(
          title: 'PREFERENCIAS',
          children: [
            SettingsSwitchTile(
              iconLight: 'assets/icons/mod/moon_stars_claro.png',
              iconDark: 'assets/icons/mod/moon_stars_oscuro.png',
              label: 'Modo Oscuro',
              value: mode == ThemeMode.dark,
              onChanged: (v) {
                themeNotifier.value = v ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ],
        );
      },
    );
  }
}
