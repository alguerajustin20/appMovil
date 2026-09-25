import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/screens/bench/dashboard-screendart/dashboard_screen.dart';
import 'package:integrador_vi_mobile/screens/prueba2/prueba2-screendart/prueba2.dart';
import 'package:integrador_vi_mobile/screens/user_management_screen.dart';
import '../../../widgets/custom_bottom_navigation.dart';

void main() => runApp(const Prueba1());

class Prueba1 extends StatefulWidget {
  const Prueba1({super.key});

  @override
  State<Prueba1> createState() => _Prueba1State();
}

class _Prueba1State extends State<Prueba1> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _currentIndex = 1;
    });
    return MaterialApp(
      title: 'Material App 1',
      home: Scaffold(
        appBar: AppBar(title: const Text('Material App Bar 1')),
        body: const Center(child: Text('Hello World #1')),

        bottomNavigationBar: CustomBottomNavigation(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
              );
            }

            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserManagementScreen(),
                ),
              );
            }

            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Prueba2()),
              );
            }
          },
        ),
      ),
    );
  }
}
