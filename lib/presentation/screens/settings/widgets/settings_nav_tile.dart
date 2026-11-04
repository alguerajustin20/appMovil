import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import 'settings_leading_icon.dart';

class SettingsNavTile extends StatelessWidget {
  final String iconLight;
  final String iconDark;
  final String label;
  final String? trailingText;
  final Color? trailingColor;
  final IconData? trailingIcon;
  final VoidCallback onTap;

  const SettingsNavTile({
    super.key,
    required this.iconLight,
    required this.iconDark,
    required this.label,
    required this.onTap,
    this.trailingText,
    this.trailingColor,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;

    final Widget trailing;
    if (trailingIcon != null) {
      trailing = Icon(trailingIcon, size: 18, color: c.textMuted);
    } else if (trailingText != null) {
      trailing = Text(
        trailingText!,
        style: TextStyle(color: trailingColor ?? c.textMuted, fontSize: 13),
      );
    } else {
      trailing = Icon(Icons.chevron_right, color: c.textMuted);
    }

    return ListTile(
      onTap: onTap,
      leading: SettingsLeadingIcon(lightPath: iconLight, darkPath: iconDark),
      title: Text(
        label,
        style: TextStyle(fontSize: 14.5, color: c.textPrimary),
      ),
      trailing: trailing,
    );
  }
}
