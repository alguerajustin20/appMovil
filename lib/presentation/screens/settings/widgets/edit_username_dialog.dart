import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_theme.dart';

/// Abre el diálogo y devuelve el nuevo nombre, o null si se canceló o quedó vacío.
Future<String?> showEditUsernameDialog(
  BuildContext context,
  String currentName,
) {
  return showDialog<String>(
    context: context,
    builder: (_) => _EditUsernameDialog(currentName: currentName),
  );
}

class _EditUsernameDialog extends StatefulWidget {
  final String currentName;

  const _EditUsernameDialog({required this.currentName});

  @override
  State<_EditUsernameDialog> createState() => _EditUsernameDialogState();
}

class _EditUsernameDialogState extends State<_EditUsernameDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.currentName,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;

    return AlertDialog(
      backgroundColor: c.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Editar nombre de usuario',
        style: TextStyle(color: c.textPrimary),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: TextStyle(color: c.textPrimary),
        decoration: InputDecoration(
          hintText: 'Nombre de usuario',
          hintStyle: TextStyle(color: c.textMuted),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: c.cardBorder),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: AppColors.teal, width: 1.5),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: TextStyle(color: c.textMuted)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
          onPressed: () {
            final name = _controller.text.trim();
            Navigator.pop(context, name.isEmpty ? null : name);
          },
          child: const Text('Guardar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
