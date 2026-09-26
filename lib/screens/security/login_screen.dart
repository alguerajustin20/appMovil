import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _ocultarPassword = true;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 80),
                Image.asset('assets/images/logo_B.png', width: 150),
                Text(
                  'Campestre Admin',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF037F8C),
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Panel de administración',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 45),
                Container(
                  width: 300,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(166, 244, 241, 241),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'usuario',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFDB653),
                        ),
                      ),
                      SizedBox(height: 6),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Ingrese su usuario',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/icons/mail/email_oscuro.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      Text(
                        'contraseña',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFDB653),
                        ),
                      ),
                      SizedBox(height: 6),
                      TextField(
                        obscureText: _ocultarPassword,
                        decoration: InputDecoration(
                          hintText: '**********',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/icons/security/candado_oscuro.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Image.asset(
                              'assets/icons/view/ojo_negro.png',
                              width: 20,
                              height: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _ocultarPassword = !_ocultarPassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF03738C),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
