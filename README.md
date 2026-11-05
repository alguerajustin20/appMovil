# appMovil
Integrador VI




// 2. RESTRICCIÓN: Validar que sea Administrador (1) o Cajero (2)
final rol = authResponse.usuario?.idRol;
if (rol != 1 && rol != 2) {
  throw const FormatException(
    'Acceso denegado: Esta aplicación es exclusiva para Administradores y Cajeros.',
  );
}



import 'package:provider/provider.dart';
import '../presentation/providers/auth_provider.dart';

////borrar
final List<Widget> _screens = const [
    SystemMonitoringScreen(),
    AddProductScreen(),
    FacturaScreen(),
    UserManagementScreen(),
    SettingsScreen(),
  ];
///borrar



             child: Scaffold(
        body: Builder(
          builder: (context) {
            final authProvider = Provider.of<AuthProvider>(context);
            final esCajero = authProvider.currentUser?.idRol == 2;

            final screens = esCajero
                ? const [
                    FacturaScreen(),
                    AddProductScreen(),
                    SettingsScreen(),
                  ]
                : const [
                    SystemMonitoringScreen(),
                    AddProductScreen(),
                    FacturaScreen(),
                    UserManagementScreen(),
                    SettingsScreen(),
                  ];

            return IndexedStack(index: _currentIndex, children: screens);
          },
        ),
        bottomNavigationBar: Builder(
          builder: (context) {
            final authProvider = Provider.of<AuthProvider>(context);
            final esCajero = authProvider.currentUser?.idRol == 2;

            final navItems = esCajero
                ? const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.receipt_long_outlined),
                      activeIcon: Icon(Icons.receipt_long),
                      label: 'Factura',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.inventory_2_outlined),
                      label: 'Inventario',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings_outlined),
                      label: 'Ajustes',
                    ),
                  ]
                : const [
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
                  ];

            return BottomNavigationBar(
              currentIndex: _currentIndex >= navItems.length ? 0 : _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF007A8C),
              unselectedItemColor: const Color(0xFF94A3B8),
              items: navItems,
            );
          },
        ),
      ),