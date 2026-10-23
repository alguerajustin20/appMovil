import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/theme/app_colors.dart';
import '../../../../../theme/app_theme.dart';
import '../../../../data/models/user_model.dart';

class UserFormModal extends StatefulWidget {
  final UserModel? userToEdit;
  final List<String> roles;
  final AppPalette palette;
  final Function(String name, String username, String role, String? password) onSave;
  final InputDecoration Function(
    AppPalette c, {
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  })
  buildInputDecoration;

  const UserFormModal({
    super.key,
    this.userToEdit,
    required this.roles,
    required this.palette,
    required this.onSave,
    required this.buildInputDecoration,
  });

  @override
  State<UserFormModal> createState() => _UserFormModalState();
}

class _UserFormModalState extends State<UserFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  bool _isPasswordObscured = true;
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.userToEdit?.nombreCompleto ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.userToEdit?.username ?? '',
    );
    _passwordController = TextEditingController();
    
    if (widget.userToEdit != null) {
      _selectedRole = _getRoleName(widget.userToEdit!.idRol);
    } else {
      _selectedRole = widget.roles.isNotEmpty ? widget.roles.first : 'Cajero';
    }
  }

  String _getRoleName(int idRol) {
    switch (idRol) {
      case 1:
        return 'Admin';
      case 2:
        return 'Cajero';
      case 3:
        return 'Mesero';
      case 4:
        return 'Cocinero';
      default:
        return 'Cajero';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.palette;
    final isEditing = widget.userToEdit != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Editar Usuario' : 'Agregar Usuario',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: c.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Nombre completo',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _nameController,
              style: TextStyle(color: c.textPrimary, fontSize: 14),
              decoration: widget.buildInputDecoration(
                c,
                hintText: 'Ej. Juan Pérez',
                prefixIcon: Icons.person_outline,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor ingresa un nombre.';
                }
                if (value.trim().length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Nombre de usuario',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _usernameController,
              style: TextStyle(color: c.textPrimary, fontSize: 14),
              decoration: widget.buildInputDecoration(
                c,
                hintText: 'Ej. juanperez123',
                prefixIcon: Icons.account_circle_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor ingresa un nombre de usuario.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Text(
              isEditing ? 'Contraseña (Opcional)' : 'Contraseña',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _passwordController,
              obscureText: _isPasswordObscured,
              style: TextStyle(color: c.textPrimary, fontSize: 14),
              decoration: widget.buildInputDecoration(
                c,
                hintText: '••••••••',
                prefixIcon: Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: c.textMuted,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (!isEditing && (value == null || value.trim().isEmpty)) {
                  return 'Por favor ingresa una contraseña.';
                }
                if (value != null && value.isNotEmpty && value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Rol / Cargo asignado',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: c.textMuted),
              dropdownColor: c.card,
              style: TextStyle(color: c.textPrimary, fontSize: 14),
              decoration: widget.buildInputDecoration(
                c,
                prefixIcon: Icons.badge_outlined,
              ),
              items: widget.roles
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedRole = val),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor selecciona un rol para el usuario.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSave(
                      _nameController.text.trim(),
                      _usernameController.text.trim(),
                      _selectedRole!,
                      _passwordController.text.trim().isEmpty ? null : _passwordController.text.trim(),
                    );
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                label: Text(
                  isEditing ? 'Actualizar Usuario' : 'Guardar Usuario',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}