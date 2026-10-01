import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../widgets/user_list_item.dart';
import '../widgets/user_form_modal.dart';

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

  void _openUserFormModal(
    AppPalette c, {
    User? userToEdit,
    int? originalIndex,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // 🛡️ SOLUCIÓN: Protege la base del formulario contra los botones digitales del teléfono
        return SafeArea(
          top: false,
          bottom:
              true, // 👈 Desplaza el botón de guardar por encima de la barra táctil
          child: UserFormModal(
            userToEdit: userToEdit,
            editingIndex: originalIndex,
            roles: _roles,
            palette: c,
            buildInputDecoration: _buildInputDecoration,
            onSave: (name, username, role, index) {
              setState(() {
                final newUser = _createUserInstance(
                  name,
                  username,
                  role,
                  index != null ? _userList[index].isActive : true,
                );

                if (index != null) {
                  _userList[index] = newUser;
                } else {
                  _userList.insert(0, newUser);
                }
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    index != null
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
            },
          ),
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
                decoration: _buildInputDecoration(
                  c,
                  hintText: 'Buscar usuario por nombre o usuario...',
                  prefixIcon: Icons.search,
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

                          return UserListItem(
                            user: user,
                            palette: c,
                            onEdit: () => _openUserFormModal(
                              c,
                              userToEdit: user,
                              originalIndex: realIndex,
                            ),
                            onToggleStatus: () =>
                                _confirmToggleStatusUser(user, c),
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
