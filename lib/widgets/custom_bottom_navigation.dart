import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integrador_vi_mobile/presentation/screens/outputs/factura-screendart/factura_screen.dart';
import '../presentation/screens/logs/activity-logs-screen/activity_logs_screen.dart';
import '../presentation/screens/inventory/add-product-screen/add_product_screen.dart';
import '../presentation/screens/manager/user-management-screen/user_management_screen.dart';
import '../presentation/screens/settings/settings-screen.dart/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  DateTime? _lastPressedAt;
  final List<Widget> _screens = const [
    SystemMonitoringScreen(),
    AddProductScreen(),
    FacturaScreen(),
    UserManagementScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return;
        }

        final now = DateTime.now();
        final backButtonHasBeenPressedTwice =
            _lastPressedAt != null &&
            now.difference(_lastPressedAt!) < const Duration(seconds: 2);

        if (backButtonHasBeenPressedTwice) {
          SystemNavigator.pop();
        } else {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Presiona de nuevo para salir de la aplicación'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF007A8C),
          unselectedItemColor: const Color(0xFF94A3B8),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.speed_rounded),
              label: 'Monitoreo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              label: 'Inventario',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Factura',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              label: 'Usuarios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Ajustes',
            ),
          ],
        ),
      ),
    );
  }
}
