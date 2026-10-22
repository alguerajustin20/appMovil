import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../service/auth_service.dart';
import '../../../widgets/custom_bottom_navigation.dart';
import 'widgets/login_form_card.dart';
import 'widgets/login_header_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    // 1. Ocultar teclado
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Ejecutar la llamada a la API en Docker
      final response = await _authService.iniciarSesion(
        _userController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      // 3. Si el login es exitoso y es Admin, mostrar mensaje de bienvenida
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bienvenido, ${response.usuario?.nombreCompleto ?? "Administrador"}',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // 4. Navegar a la pantalla principal (Dashboard)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      // Extrae la causa o mensaje interno eliminando los prefijos de excepciones de Dart
      String errorMessage = e.toString();

      if (e is FormatException) {
        errorMessage = e.message;
      } else {
        errorMessage = errorMessage
            .replaceAll('FormatException: ', '')
            .replaceAll('Exception: ', '')
            .replaceAll('Exception', '')
            .trim();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
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
                const LoginHeaderWidget(),
                const SizedBox(height: 45),
                LoginFormCard(
                  userController: _userController,
                  passwordController: _passwordController,
                  isLoading: _isLoading,
                  onLoginPressed: _onLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
