import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/screens/bench/dashboard-screendart/dashboard_screen.dart';
import 'package:integrador_vi_mobile/screens/prueba1/prueba1-screendart/prueba1.dart';
import 'package:integrador_vi_mobile/screens/user_management_screen.dart';
import 'package:integrador_vi_mobile/widgets/custom_bottom_navigation.dart';

void main() => runApp(const Prueba2());

class Prueba2 extends StatefulWidget {
  const Prueba2({super.key});

  @override
  State<Prueba2> createState() => _Prueba2State();
}

class _Prueba2State extends State<Prueba2> {
  int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _currentIndex = 3;
    });
    return MaterialApp(
      title: 'Material App 2',
      home: Scaffold(
        appBar: AppBar(title: const Text('Material App Bar 2')),
        body: const Center(child: Text('Hello World #2')),

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

            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Prueba1()),
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
          },
        ),
      ),
    );
  }
}
