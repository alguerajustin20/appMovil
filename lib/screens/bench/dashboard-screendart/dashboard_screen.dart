import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight:
            65.0, // 👈 Incrementa el alto de la barra para que el logo pueda crecer
        iconTheme: const IconThemeData(color: Colors.blueGrey),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Color.fromARGB(255, 3, 115, 140),
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                'assets/images/logo_B.png',
                width: 65, // 👈 El logo responderá a este tamaño más grande
                height: 65, // 👈 Alto proporcional equivalente
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      // 2. 🛡️ Envolvemos todo el contenido en un SafeArea configurado para proteger la parte inferior (bottom: true)
      body: SafeArea(
        top: false, // El AppBar ya protege la parte superior automáticamente
        bottom:
            true, // 👈 Evita milimétricamente que los botones del celular tapen los widgets
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PRIMER GRUPO DE 4 TARJETAS MÓDULO CARD
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.4,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
