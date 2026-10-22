import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/custom_bottom_navigation.dart';

class LoginFormCard extends StatefulWidget {
  final TextEditingController userController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;
  final bool isLoading;

  const LoginFormCard({
    super.key,
    required this.userController,
    required this.passwordController,
    required this.onLoginPressed,
    this.isLoading = false,
  });

  @override
  State<LoginFormCard> createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<LoginFormCard> {
  bool _ocultarPassword = true;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDarkMode = palette.isDark;

    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode
            ? palette.card
            : const Color.fromARGB(166, 244, 241, 241),
        borderRadius: BorderRadius.circular(16),
        border: isDarkMode ? Border.all(color: palette.cardBorder) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campo Usuario
          const Text(
            'Usuario',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFFDB653),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: widget.userController,
            style: TextStyle(
              color: isDarkMode ? palette.textPrimary : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'Ingrese su Usuario',
              hintStyle: TextStyle(
                color: isDarkMode ? palette.textMuted : Colors.grey,
              ),
              filled: isDarkMode,
              fillColor: isDarkMode ? palette.inputFill : null,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
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
                      borderSide: BorderSide(color: palette.cardBorder),
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 20),

          // Campo Contraseña
          const Text(
            'Contraseña',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFFDB653),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: widget.passwordController,
            obscureText: _ocultarPassword,
            style: TextStyle(
              color: isDarkMode ? palette.textPrimary : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: '**********',
              hintStyle: TextStyle(
                color: isDarkMode ? palette.textMuted : Colors.grey,
              ),
              filled: isDarkMode,
              fillColor: isDarkMode ? palette.inputFill : null,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
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
              enabledBorder: isDarkMode
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: palette.cardBorder),
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 24),

          // Botón Iniciar Sesión
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onLoginPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF03738C),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
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
    );
  }
}
