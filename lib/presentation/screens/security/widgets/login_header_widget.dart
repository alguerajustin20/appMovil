import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDarkMode = palette.isDark;

    return Column(
      children: [
        const SizedBox(height: 80),
        Image.asset('assets/images/logo_B.png', width: 150),
        const SizedBox(height: 12),
        const Text(
          'Campestre Admin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF037F8C),
            fontSize: 24,
          ),
        ),
        Text(
          'Panel de administración',
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? palette.textMuted : Colors.grey,
          ),
        ),
      ],
    );
  }
}
