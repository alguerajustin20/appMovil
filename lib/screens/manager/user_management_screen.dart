import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/theme/app_colors.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../theme/app_theme.dart';

abstract class User {
  String name;
  String username;
  String role;
  bool isActive;

  User({
    required this.name,
    required this.username,
    required this.role,
    this.isActive = true,
  });
}

class CajeroUser extends User {
  CajeroUser({required super.name, required super.username, super.isActive})
    : super(role: 'Cajero');
}

class AdminUser extends User {
  AdminUser({required super.name, required super.username, super.isActive})
    : super(role: 'Admin');
}

class MeseroUser extends User {
  MeseroUser({required super.name, required super.username, super.isActive})
    : super(role: 'Mesero');
}

class CocineroUser extends User {
  CocineroUser({required super.name, required super.username, super.isActive})
    : super(role: 'Cocinero');
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _selectedFilter = 'Todos';

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordObscured = true;
  String? _selectedRoleForm = 'Cajero';
  int? _editingIndex;

  final List<String> _filters = [
    'Todos',
    'Activos',
    'Inactivos',
    'Admins',
    'Cajeros',
    'Cocineros',
    'Meseros',
  ];

  final List<String> _roles = ['Admin', 'Cajero', 'Mesero', 'Cocinero'];

  final List<User> _userList = [
    CajeroUser(name: 'Justin', username: 'justin123', isActive: true),
    AdminUser(name: 'Yamil', username: 'yamil72', isActive: false),
    MeseroUser(name: 'Mauro', username: 'mauro69', isActive: true),
    CocineroUser(name: 'Jeffry', username: 'jeffry', isActive: true),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  List<User> get _filteredUsers {
    return _userList.where((user) {
      final query = _searchController.text.toLowerCase().trim();
      final matchesSearch =
          user.name.toLowerCase().contains(query) ||
          user.username.toLowerCase().contains(query);

      final cleanFilter = _selectedFilter.trim();
      bool matchesRole = cleanFilter == 'Todos';
      if (!matchesRole) {
        if (cleanFilter == 'Activos') matchesRole = user.isActive;
        if (cleanFilter == 'Inactivos') matchesRole = !user.isActive;
        if (cleanFilter == 'Admins') matchesRole = user.role == 'Admin';
        if (cleanFilter == 'Cajeros') matchesRole = user.role == 'Cajero';
        if (cleanFilter == 'Cocineros') matchesRole = user.role == 'Cocinero';
        if (cleanFilter == 'Meseros') matchesRole = user.role == 'Mesero';
      }

      return matchesSearch && matchesRole;
    }).toList();
  }

  void _confirmToggleStatusUser(User user, AppPalette c) {
    final willDeactivate = user.isActive;
    final actionText = willDeactivate ? 'desactivar' : 'activar';
    final titleText = willDeactivate ? 'Desactivar usuario' : 'Activar usuario';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: c.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            titleText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: c.textPrimary,
              fontSize: 18,
            ),
          ),
          content: Text(
            '¿Desea $actionText al usuario ${user.name}?',
            style: TextStyle(color: c.textMuted, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: c.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: willDeactivate
                    ? Colors.redAccent
                    : AppColors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: () {
                setState(() {
                  user.isActive = !user.isActive;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      willDeactivate
                          ? 'Usuario "${user.name}" desactivado.'
                          : 'Usuario "${user.name}" activado.',
                    ),
                    backgroundColor: willDeactivate
                        ? Colors.redAccent
                        : AppColors.teal,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              child: Text(
                willDeactivate ? 'Desactivar' : 'Activar',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  User _createUserInstance(
    String name,
    String username,
    String role,
    bool isActive,
  ) {
    switch (role) {
      case 'Admin':
        return AdminUser(name: name, username: username, isActive: isActive);
      case 'Mesero':
        return MeseroUser(name: name, username: username, isActive: isActive);
      case 'Cocinero':
        return CocineroUser(name: name, username: username, isActive: isActive);
      case 'Cajero':
      default:
        return CajeroUser(name: name, username: username, isActive: isActive);
    }
  }

  void _openUserFormModal(
    AppPalette c, {
    User? userToEdit,
    int? originalIndex,
  }) {
    if (userToEdit != null) {
      _nameController.text = userToEdit.name;
      _usernameController.text = userToEdit.username;
      _passwordController.clear();
      _selectedRoleForm = userToEdit.role;
      _editingIndex = originalIndex;
    } else {
      _nameController.clear();
      _usernameController.clear();
      _passwordController.clear();
      _selectedRoleForm = 'Cajero';
      _editingIndex = null;
    }

    _isPasswordObscured = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                          _editingIndex != null
                              ? 'Editar Usuario'
                              : 'Agregar Usuario',
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
                      decoration: _buildInputDecoration(
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
                      decoration: _buildInputDecoration(
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
                      'Contraseña',
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
                      decoration: _buildInputDecoration(
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
                            setModalState(() {
                              _isPasswordObscured = !_isPasswordObscured;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (_editingIndex == null &&
                            (value == null || value.trim().isEmpty)) {
                          return 'Por favor ingresa una contraseña.';
                        }
                        if (value != null &&
                            value.isNotEmpty &&
                            value.length < 6) {
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
                      value: _selectedRoleForm,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: c.textMuted,
                      ),
                      dropdownColor: c.card,
                      style: TextStyle(color: c.textPrimary, fontSize: 14),
                      decoration: _buildInputDecoration(
                        c,
                        prefixIcon: Icons.badge_outlined,
                      ),
                      items: _roles
                          .map(
                            (r) => DropdownMenuItem(value: r, child: Text(r)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setModalState(() => _selectedRoleForm = val),
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
                            setState(() {
                              final newUser = _createUserInstance(
                                _nameController.text.trim(),
                                _usernameController.text.trim(),
                                _selectedRoleForm!,
                                _editingIndex != null
                                    ? _userList[_editingIndex!].isActive
                                    : true,
                              );

                              if (_editingIndex != null) {
                                _userList[_editingIndex!] = newUser;
                              } else {
                                _userList.insert(0, newUser);
                              }
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _editingIndex != null
                                      ? '¡Usuario actualizado!'
                                      : '¡Usuario agregado!',
                                ),
                                backgroundColor: AppColors.teal,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text(
                          _editingIndex != null
                              ? 'Actualizar Usuario'
                              : 'Guardar Usuario',
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final filtered = _filteredUsers;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 20,
        title: Text(
          'Gestión de Usuarios',
          style: TextStyle(
            color: c.isDark ? const Color(0xFF00B4D8) : const Color(0xFF03738C),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: TextStyle(color: c.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Buscar usuario por nombre o usuario...',
                  hintStyle: TextStyle(color: c.textMuted, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: c.textMuted),
                  filled: true,
                  fillColor: c.card,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: c.cardBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: c.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.teal,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selectedFilter == filter;

                    return ChoiceChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? Colors.white : c.textMuted,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.teal,
                      backgroundColor: c.card,
                      side: BorderSide(
                        color: isSelected ? AppColors.teal : c.cardBorder,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.group_outlined,
                              size: 64,
                              color: c.textMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No hay usuarios registrados',
                              style: TextStyle(
                                fontSize: 15,
                                color: c.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final user = filtered[index];
                          final realIndex = _userList.indexOf(user);

                          return Opacity(
                            opacity: user.isActive ? 1.0 : 0.5,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: c.card,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: user.isActive
                                      ? AppColors.teal.withOpacity(0.3)
                                      : c.cardBorder,
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: user.isActive
                                        ? AppColors.teal.withOpacity(0.15)
                                        : Colors.grey.withOpacity(0.2),
                                    child: Text(
                                      user.name.isNotEmpty
                                          ? user.name[0].toUpperCase()
                                          : 'U',
                                      style: TextStyle(
                                        color: user.isActive
                                            ? AppColors.teal
                                            : c.textMuted,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: c.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: user.isActive
                                                    ? AppColors.teal
                                                          .withOpacity(0.1)
                                                    : Colors.grey.withOpacity(
                                                        0.2,
                                                      ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                user.role,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: user.isActive
                                                      ? AppColors.teal
                                                      : c.textMuted,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '@${user.username}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: c.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                      color: AppColors.teal,
                                    ),
                                    onPressed: () => _openUserFormModal(
                                      c,
                                      userToEdit: user,
                                      originalIndex: realIndex,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      user.isActive
                                          ? Icons.toggle_on_rounded
                                          : Icons.toggle_off_rounded,
                                      size: 28,
                                      color: user.isActive
                                          ? AppColors.teal
                                          : Colors.redAccent.withOpacity(0.7),
                                    ),
                                    onPressed: () =>
                                        _confirmToggleStatusUser(user, c),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openUserFormModal(c),
        backgroundColor: AppColors.teal,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 3),
    );
  }

  InputDecoration _buildInputDecoration(
    AppPalette c, {
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: c.textMuted.withOpacity(0.7), fontSize: 13),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: c.textMuted, size: 18)
          : null,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: c.isDark ? c.inputFill : Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
      ),
    );
  }
}
