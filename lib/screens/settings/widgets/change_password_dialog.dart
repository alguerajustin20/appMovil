import 'package:flutter/material.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_theme.dart';

Future<void> showChangePasswordDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const _ChangePasswordDialog(),
  );
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  bool _hideCurrent = true;
  bool _hideNew = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    super.dispose();
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool hidden,
    required VoidCallback onToggle,
  }) {
    final c = context.palette;

    return TextField(
      controller: controller,
      obscureText: hidden,
      style: TextStyle(color: c.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: c.textMuted),
        suffixIcon: IconButton(
          icon: Icon(
            hidden ? Icons.visibility_off : Icons.visibility,
            color: c.textMuted,
          ),
          onPressed: onToggle,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.cardBorder),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.teal, width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;

    return AlertDialog(
      backgroundColor: c.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Seguridad y Contraseña',
        style: TextStyle(color: c.textPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _passwordField(
            label: 'Contraseña actual',
            controller: _currentController,
            hidden: _hideCurrent,
            onToggle: () => setState(() => _hideCurrent = !_hideCurrent),
          ),
          const SizedBox(height: 14),
          _passwordField(
            label: 'Nueva contraseña',
            controller: _newController,
            hidden: _hideNew,
            onToggle: () => setState(() => _hideNew = !_hideNew),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: TextStyle(color: c.textMuted)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
          onPressed: () {
            if (_newController.text.trim().isEmpty) return;
            // TODO: validar la contraseña actual y actualizarla vía API.
            Navigator.pop(context);
          },
          child: const Text('Guardar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
