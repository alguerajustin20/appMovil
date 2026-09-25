import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'label': 'Dashboard',
        'off': 'assets/icons/performance/miniaturas_claro.png',
        'on': 'assets/icons/performance/miniaturas_oscuro.png',
      },
      {
        'label': 'Inventario',
        'off': 'assets/icons/inventory/archivo_caja_negra.png',
        'on': 'assets/icons/inventory/archivo_caja_blanca.png',
      },
      {
        'label': 'Usuarios',
        'off': 'assets/icons/admin/usuario_claro.png',
        'on': 'assets/icons/admin/usuario_negro.png',
      },
      {
        'label': 'Ajustes',
        'off': 'assets/icons/config/ajuste_negro.png',
        'on': 'assets/icons/config/ajuste_blanco.png',
      },
    ];

    // 🛡️ ENVOLVEMOS EN SAFEAREA PARA QUE NUNCA SEA TAPADO POR LOS BOTONES DE FÁBRICA
    return SafeArea(
      top: false,    // Ignora la parte de arriba (barra de notificaciones)
      bottom: true,  // 👈 LA CLAVE: Empuja el menú hacia arriba dinámicamente si los botones del sistema están visibles
      child: Container(
        height: 65,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 0.8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final isSelected = currentIndex == index;
            return InkWell(
              onTap: () => onTap?.call(index),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    isSelected ? items[index]['on']! : items[index]['off']!,
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    color: isSelected ? const Color(0xFF007A8C) : Colors.grey,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image_not_supported,
                      size: 24,
                      color: isSelected ? const Color(0xFF007A8C) : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[index]['label']!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? const Color(0xFF007A8C) : Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}