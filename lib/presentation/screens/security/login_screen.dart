import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../service/auth_service.dart';
import '../../../data/models/user_model.dart';
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
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.iniciarSesion(
        _userController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (response.usuario != null) {
        final userModel = UserModel(
          id: response
              .usuario!
              .idUsuario, // Usamos idUsuario como marca tu modelo de respuesta
          idRol: response.usuario!.idRol,
          nombreCompleto: response.usuario!.nombreCompleto,
          username: response.usuario!.username,
          activo: true, // Por defecto true para el usuario autenticado activo
        );
        authProvider.setUser(userModel);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bienvenido, ${response.usuario?.nombreCompleto ?? "Administrador"}',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    } catch (e) {
      if (!mounted) return;

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
