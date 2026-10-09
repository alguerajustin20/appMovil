import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:integrador_vi_mobile/screens/bench/dashboard-screendart/dashboard_screen.dart';
import 'package:integrador_vi_mobile/themes/app_theme.dart';
import 'package:integrador_vi_mobile/presentation/widgets/custom_bottom_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _ocultarPassword = true;
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDarkMode = palette.isDark;
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
                const SizedBox(height: 80),
                SizedBox(height: 80),
                Image.asset('assets/images/logo_B.png', width: 150),
                const SizedBox(height: 12),
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
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? palette.textMuted : Colors.grey,
                  ),
                ),
                const SizedBox(height: 45),
                Container(
                  width: 300,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? palette.card
                        : const Color.fromARGB(166, 244, 241, 241),
                    borderRadius: BorderRadius.circular(16),
                    border: isDarkMode
                        ? Border.all(color: palette.cardBorder)
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usuario',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFDB653),
                        ),
                      ),
                      SizedBox(height: 6),
                      TextField(
                        style: TextStyle(
                          color: isDarkMode
                              ? palette.textPrimary
                              : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ingrese su Usuario',
                          hintStyle: TextStyle(
                            color: isDarkMode ? palette.textMuted : Colors.grey,
                          ),
                          filled: isDarkMode ? true : false,
                          fillColor: isDarkMode ? palette.inputFill : null,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Image.asset(
                              //aqui iria el otro icono que declare del pubspec
                              'assets/icons/mail/email_oscuro.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: isDarkMode
                              ? OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: palette.cardBorder,
                                  ),
                                )
                              : null,
                        ),
                      ),

                      const SizedBox(height: 20),
                      Text(
                        'Contraseña',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFDB653),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        obscureText: _ocultarPassword,
                        style: TextStyle(
                          color: isDarkMode
                              ? palette.textPrimary
                              : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: '**********',
                          hintStyle: TextStyle(
                            color: isDarkMode ? palette.textMuted : Colors.grey,
                          ),
                          filled: isDarkMode,
                          fillColor: isDarkMode ? palette.inputFill : null,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Image.asset(
                              //el otro icono
                              'assets/icons/security/candado_oscuro.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Image.asset(
                              // el otro
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
                          enabledBorder: isDarkMode
                              ? OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: palette.cardBorder,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MainNavigationScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF03738C),
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
