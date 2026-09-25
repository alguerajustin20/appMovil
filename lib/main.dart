import 'package:flutter/material.dart';
import 'Screen/settings_screen.dart'; // ajusta la ruta según donde la guardaste

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home:
          const SettingsScreen(), // <- esta línea establece la pantalla de inicio como SettingsScreen en la que me toco trabajar
    );
  }
}
