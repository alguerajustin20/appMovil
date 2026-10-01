import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/theme/app_colors.dart';
import '../../../../theme/app_theme.dart';

class ManageListDialog extends StatefulWidget {
  final String title;
  final List<String> items;
  final Function(String item, String newValue) onEdit;
  final Function(String item) onDelete;
  final AppPalette palette;
  final InputDecoration Function(AppPalette c, {String? hintText, IconData? prefixIcon}) buildInputDecoration;

  const ManageListDialog({
    super.key,
    required this.title,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    required this.palette,
    required this.buildInputDecoration,
  });

  @override
  State<ManageListDialog> createState() => _ManageListDialogState();
}

class _ManageListDialogState extends State<ManageListDialog> {
  @override
  Widget build(BuildContext context) {
    final c = widget.palette;
    return AlertDialog(
      backgroundColor: c.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Gestionar ${widget.title}',
        style: TextStyle(fontWeight: FontWeight.bold, color: c.textPrimary, fontSize: 18),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: widget.items.isEmpty
            ? Text('No hay elementos guardados.', style: TextStyle(color: c.textMuted))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  return ListTile(
                    title: Text(item, style: TextStyle(color: c.textPrimary, fontSize: 14)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.teal),
                          onPressed: () {
                            final editController = TextEditingController(text: item);
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: c.card,
                                title: Text('Editar $item', style: TextStyle(color: c.textPrimary, fontSize: 16)),
                                content: TextField(
                                  controller: editController,
                                  style: TextStyle(color: c.textPrimary),
                                  decoration: widget.buildInputDecoration(c, hintText: 'Nuevo nombre'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: Text('Cancelar', style: TextStyle(color: c.textMuted)),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
                                    onPressed: () {
                                      if (editController.text.trim().isNotEmpty) {
                                        widget.onEdit(item, editController.text.trim());
                                        setState(() {});
                                        Navigator.pop(ctx);
                                      }
                                    },
                                    child: const Text('Guardar', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red[600]),
                          onPressed: () {
                            setState(() {
                              widget.onDelete(item);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cerrar', style: TextStyle(color: c.textMuted, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}