import 'package:flutter/material.dart';
import '../screens/bench/dashboard-screendart/dashboard_screen.dart';
<<<<<<< Updated upstream
import '../screens/inventory/add_product_screen.dart';
import '../screens/manager/user_management_screen.dart';
import '../screens/settings/settings_screen.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigation({super.key, required this.currentIndex});

  void _navigateToScreen(BuildContext context, int index) {
    if (index == currentIndex) return;
=======
import '../screens/inventory/add-product-screen/add_product_screen.dart';
import '../screens/manager/user-management-screen/user_management_screen.dart';
import '../screens/settings/settings-screen.dart/settings_screen.dart';
>>>>>>> Stashed changes

    Widget targetScreen;
    switch (index) {
      case 0: //
        targetScreen = const DashboardScreen();
        break;
      case 1:
        targetScreen = const AddProductScreen();
        break;
      case 2:
        targetScreen = const UserManagementScreen();
        break;
      case 3:
        targetScreen = const SettingsScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => targetScreen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _navigateToScreen(context, index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF007A8C),
      unselectedItemColor: const Color(0xFF94A3B8),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: 'Inventario',
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
    );
  }
}
