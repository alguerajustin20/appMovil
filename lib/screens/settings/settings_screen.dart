import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../theme/app_colors.dart';
import '../../main.dart'; // ajusta la ruta según dónde esté settings_screen.dart
import '../security/login_screen.dart'; // ajusta la ruta según dónde esté home_screen.dart

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // reemplazar con datos reales del usuario autenticado
  String _userName = 'Yamil72';
  final String _userEmail = 'yamil';
  final String _userRole = 'Administrador';
  String _selectedLanguage = 'Español';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // sin backgroundColor — lo toma de AppTheme.light/dark (scaffoldBackgroundColor)
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Ajustes',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.teal,
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
          _buildProfileCard(context, isDark),
          const SizedBox(height: 20),
          _sectionLabel('CUENTA', isDark),
          _settingsCard(
            isDark: isDark,
            children: [
              _navTile(
                isDark: isDark,
                icon: isDark
                    ? 'assets/icons/admin/account_oscuro.png'
                    : 'assets/icons/admin/account_claro.png',
                label: 'Perfil',
                trailingText: _userName,
                trailingColor: AppColors.teal,
                onTap: () {},
              ),
              _divider(),
              _navTile(
                isDark: isDark,
                icon: isDark
                    ? 'assets/icons/security/candado_claro.png'
                    : 'assets/icons/security/candado_oscuro.png',
                label: 'Seguridad y Contraseña',
                onTap: () => _showChangePasswordDialog(context, isDark),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _sectionLabel('PREFERENCIAS', isDark),
          _settingsCard(
            isDark: isDark,
            children: [
              _divider(),
              _switchTile(
                isDark: isDark,
                icon: isDark
                    ? 'assets/icons/mod/moon_stars_oscuro.png'
                    : 'assets/icons/mod/moon_stars_claro.png',
                label: 'Modo Oscuro',
                value: themeNotifier.value == ThemeMode.dark,
                onChanged: (v) {
                  themeNotifier.value = v ? ThemeMode.dark : ThemeMode.light;
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          _sectionLabel('SOPORTE', isDark),
          _settingsCard(
            isDark: isDark,
            children: [
              _navTile(
                isDark: isDark,
                icon: isDark
                    ? 'assets/icons/docs/informacion_blanco.png'
                    : 'assets/icons/docs/informacion_negro.png',
                label: 'Centro de Ayuda',
                trailingIcon: Icons.open_in_new,
                onTap: () => _showHelpDialog(context, isDark),
              ),
              _divider(),
              _navTile(
                isDark: isDark,
                icon: isDark
                    ? 'assets/icons/error/signo_de_admiracion_blanco.png'
                    : 'assets/icons/error/signo_de_admiracion_negro.png',
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

      bottomNavigationBar: SafeArea(
        child: CustomBottomNavigation(currentIndex: 4),
      ),
    );
  }

  // ---------- Ventanas emergentes (Dialogs) ----------

  void _showEditUsernameDialog(BuildContext context, bool isDark) {
    final controller = TextEditingController(text: _userName);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Editar nombre de usuario',
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              hintText: 'Nombre de usuario',
              hintStyle: TextStyle(
                color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : AppColors.cardBorder,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: AppColors.teal, width: 1.5),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  setState(() => _userName = newName);
                }
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Guardar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context, bool isDark) {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkCard : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Seguridad y Contraseña',
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentPassController,
                    obscureText: obscureCurrent,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Nueva Contraseña',
                      labelStyle: TextStyle(
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.textMuted,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureCurrent
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.textMuted,
                        ),
                        onPressed: () {
                          setDialogState(
                            () => obscureCurrent = !obscureCurrent,
                          );
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkCardBorder
                              : AppColors.cardBorder,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: AppColors.teal,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: newPassController,
                    obscureText: obscureNew,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Verificar contraseña',
                      labelStyle: TextStyle(
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.textMuted,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureNew ? Icons.visibility_off : Icons.visibility,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.textMuted,
                        ),
                        onPressed: () {
                          setDialogState(() => obscureNew = !obscureNew);
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkCardBorder
                              : AppColors.cardBorder,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: AppColors.teal,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.textMuted,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                  ),
                  onPressed: () {
                    // TODO: validar contraseña actual y actualizar en backend cuando exista
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.help_outline, color: AppColors.teal),
              const SizedBox(width: 8),
              Text(
                'Centro de Ayuda',
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Necesitas ayuda con Campestre Admin?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Consulta las guías rápidas sobre inventario, órdenes y gestión de usuarios, '
                'o escríbenos directamente si tienes un problema con tu cuenta.',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(Icons.email_outlined, size: 16, color: AppColors.teal),
                  const SizedBox(width: 6),
                  Text(
                    'soporte@mediaSystem.com',
                    style: TextStyle(fontSize: 13, color: AppColors.teal),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Entendido',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // ---------- Piezas reutilizables ----------

  Widget _buildProfileCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
        ),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  _userEmail,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.textMuted,
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
                    color: AppColors.teal.withValues(alpha: 0.12),
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
            onPressed: () => _showEditUsernameDialog(context, isDark),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: TextStyle(
          color: isDark ? AppColors.mustardLight : AppColors.brownLight,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _settingsCard({required bool isDark, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, indent: 52, color: AppColors.cardBorder);

  Widget _navTile({
    required bool isDark,
    required dynamic icon,
    required String label,
    String? trailingText,
    Color? trailingColor,
    IconData? trailingIcon,
    required VoidCallback onTap,
  }) {
    Widget leading;

    if (icon is String) {
      leading = SizedBox(
        width: 22,
        height: 22,
        child: Image.asset(
          icon,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.image_not_supported,
            size: 22,
            color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
          ),
        ),
      );
    } else {
      leading = Icon(
        icon as IconData,
        color: isDark ? Colors.white : AppColors.brown,
        size: 22,
      );
    }

    return ListTile(
      onTap: onTap,
      leading: leading,
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14.5,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      trailing: trailingIcon != null
          ? Icon(
              trailingIcon,
              size: 18,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            )
          : trailingText != null
          ? Text(
              trailingText,
              style: TextStyle(
                color:
                    trailingColor ??
                    (isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                fontSize: 13,
              ),
            )
          : Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
    );
  }

  Widget _switchTile({
    required bool isDark,
    required dynamic icon,
    required String label,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    Widget leading;

    if (icon is String) {
      leading = SizedBox(
        width: 22,
        height: 22,
        child: Image.asset(
          icon,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.image_not_supported,
            size: 22,
            color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
          ),
        ),
      );
    } else {
      leading = Icon(
        icon as IconData,
        color: isDark ? Colors.white : AppColors.brown,
        size: 22,
      );
    }

    return ListTile(
      leading: leading,
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14.5,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                fontSize: 12,
              ),
            )
          : null,
      trailing: Switch(
        value: value,
        activeThumbColor: AppColors.teal,
        onChanged: onChanged,
      ),
    );
  }

  Widget _logoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        },
        icon: SizedBox(
          width: 22,
          height: 22,
          child: Image.asset(
            'assets/icons/log/cerrar_sesion_blanca.png',
            fit: BoxFit.contain,
            color: AppColors.danger,
          ),
        ),
        label: const Text(
          'CERRAR SESIÓN',
          style: TextStyle(
            color: AppColors.danger,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.danger.withValues(alpha: 0.08),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
