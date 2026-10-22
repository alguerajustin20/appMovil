import 'package:flutter/material.dart';
import '../../../../data/models/categoria_model.dart';
import '../../../../themes/app_theme.dart';

class CategoriaListView extends StatelessWidget {
  final AppPalette palette;
  final List<CategoriaModel> categories;
  final Function(CategoriaModel, int) onEdit;
  final Function(CategoriaModel) onDelete;
  final Function(CategoriaModel) onActivateRecord;

  const CategoriaListView({
    super.key,
    required this.palette,
    required this.categories,
    required this.onEdit,
    required this.onDelete,
    required this.onActivateRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(flex: 22, child: Text('Código', style: _headerStyle())),
                Expanded(flex: 40, child: Text('Nombre Categoría', style: _headerStyle())),
                Expanded(flex: 22, child: Text('Estado', style: _headerStyle())),
                Expanded(flex: 16, child: Text('Acciones', style: _headerStyle())),
              ],
            ),
          ),
          const Divider(height: 1),
          
          if (categories.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'No hay registros que coincidan.',
                  style: TextStyle(color: palette.textMuted, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 22,
                      fit: FlexFit.tight,
                      child: Text(
                        item.code,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFFD63384), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 40,
                      fit: FlexFit.tight,
                      child: Text(
                        item.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: palette.textPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    // 6. Botón interactivo de Estado: SOLO el de Inactivo activa la restauración (PATCH)
                    Flexible(
                      flex: 22,
                      fit: FlexFit.tight,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: MouseRegion(
                          cursor: item.activo ? SystemMouseCursors.basic : SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              if (!item.activo) {
                                onActivateRecord(item);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: item.activo
                                    ? Colors.green.withValues(alpha: 0.12)
                                    : Colors.red.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                                border: !item.activo
                                    ? Border.all(color: Colors.red.withValues(alpha: 0.4), width: 0.8)
                                    : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.activo ? 'Activo' : 'Inactivo',
                                    style: TextStyle(
                                      color: item.activo ? Colors.green.shade700 : Colors.red.shade700,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (!item.activo) ...[
                                    const SizedBox(width: 3),
                                    Icon(Icons.refresh, size: 10, color: Colors.red.shade700),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 2 y 3. Acciones: Editar (Lápiz Azul -> PUT) y Eliminar (Bote Rojo -> DELETE)
                    Flexible(
                      flex: 16,
                      fit: FlexFit.tight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => onEdit(item, index),
                            child: const Tooltip(
                              message: 'Editar registro (PUT)',
                              child: Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => onDelete(item),
                            child: Tooltip(
                              message: item.activo ? 'Eliminar registro (DELETE)' : 'Registro ya inactivo',
                              child: Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                                color: item.activo ? Colors.red : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() {
    return TextStyle(color: palette.textPrimary, fontWeight: FontWeight.bold, fontSize: 12);
  }
}
