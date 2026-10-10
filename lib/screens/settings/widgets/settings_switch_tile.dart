import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import 'settings_leading_icon.dart';

/// Fila de ajustes con interruptor (por ejemplo, Modo Oscuro).
class SettingsSwitchTile extends StatelessWidget {
  final String iconLight;
  final String iconDark;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.iconLight,
    required this.iconDark,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;

    return ListTile(
      leading: SettingsLeadingIcon(lightPath: iconLight, darkPath: iconDark),
      title: Text(
        label,
        style: TextStyle(fontSize: 14.5, color: c.textPrimary),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(color: c.textMuted, fontSize: 12))
          : null,
      trailing: Switch(
        value: value,
        activeThumbColor: AppColors.teal,
        onChanged: onChanged,
      ),
    );
  }
}
