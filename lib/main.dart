import 'package:flutter/material.dart';
import 'screens/security/login_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6EDF7),

        //colorSchemeSeed: Colors.purple
      ),

      home: LoginScreen(),
    );
  }
}
