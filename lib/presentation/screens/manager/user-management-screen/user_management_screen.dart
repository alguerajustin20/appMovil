import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/theme/app_colors.dart';
import '../../../../theme/app_theme.dart';
import '../../../../core/network/api_client.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/user_repository.dart';
import '../widgets/user_list_item.dart';
import '../widgets/user_form_modal.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _selectedFilter = 'Todos';
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  List<UserModel> _userList = [];

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

  late final UserRepository _userRepository = UserRepository(ApiClient());

  @override
  void initState() {
    super.initState();
    _loadUsers(_selectedFilter);
  }

  Future<void> _loadUsers(String filter) async {
    setState(() => _isLoading = true);
    try {
      List<UserModel> users = [];

      if (filter == 'Activos') {
        users = await _userRepository.getActivos();
      } else if (filter == 'Inactivos') {
        users = await _userRepository.getInactivos();
      } else {
        final activos = await _userRepository.getActivos();
        final inactivos = await _userRepository.getInactivos();
        users = [...activos, ...inactivos];
      }

      setState(() {
        _userList = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar usuarios: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  int _getRoleId(String role) {
    switch (role) {
      case 'Admin':
        return 1;
      case 'Cajero':
        return 2;
      case 'Mesero':
        return 3;
      case 'Cocinero':
        return 4;
      default:
        return 2;
    }
  }

  List<UserModel> get _filteredUsers {
    return _userList.where((user) {
      final query = _searchController.text.toLowerCase().trim();
      final matchesSearch =
          user.nombreCompleto.toLowerCase().contains(query) ||
          user.username.toLowerCase().contains(query);

      final cleanFilter = _selectedFilter.trim();
      bool matchesRole = cleanFilter == 'Todos';
      if (!matchesRole) {
        final roleName = _getRoleName(user.idRol);
        if (cleanFilter == 'Activos') matchesRole = user.activo;
        if (cleanFilter == 'Inactivos') matchesRole = !user.activo;
        if (cleanFilter == 'Admins') matchesRole = roleName == 'Admin';
        if (cleanFilter == 'Cajeros') matchesRole = roleName == 'Cajero';
        if (cleanFilter == 'Cocineros') matchesRole = roleName == 'Cocinero';
        if (cleanFilter == 'Meseros') matchesRole = roleName == 'Mesero';
      }

      return matchesSearch && matchesRole;
    }).toList();
  }

  void _confirmToggleStatusUser(UserModel user, AppPalette c) {
    final willDeactivate = user.activo;
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
            '¿Desea $actionText al usuario ${user.nombreCompleto}?',
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
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  if (willDeactivate && user.id != null) {
                    await _userRepository.cambiarEstado(user.id!);
                  } else if (!willDeactivate && user.id != null) {
                    await _userRepository.restaurar(user.id!);
                  }
                  
                  if (!mounted) return;
                  await _loadUsers(_selectedFilter);
                  
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        willDeactivate
                            ? 'Usuario "${user.nombreCompleto}" desactivado.'
                            : 'Usuario "${user.nombreCompleto}" activado.',
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
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al cambiar estado: $e'), backgroundColor: Colors.redAccent),
                  );
                }
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
    UserModel? userToEdit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          bottom: true,
          child: UserFormModal(
            userToEdit: userToEdit,
            roles: _roles,
            palette: c,
            buildInputDecoration: _buildInputDecoration,
            onSave: (name, username, role, password) async {
              try {
                final newUser = UserModel(
                  id: userToEdit?.id,
                  idRol: _getRoleId(role),
                  nombreCompleto: name,
                  username: username,
                  password: password,
                  activo: userToEdit?.activo ?? true,
                );

                if (userToEdit != null && userToEdit.id != null) {
                  await _userRepository.actualizar(userToEdit.id!, newUser);
                } else {
                  await _userRepository.crear(newUser);
                }

                if (!mounted) return;
                await _loadUsers(_selectedFilter);

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      userToEdit != null
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
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al guardar: $e'), backgroundColor: Colors.redAccent),
                );
              }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
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
                        hintText: 'Buscar por nombre o usuario...',
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
                              if (selected) {
                                setState(() {
                                  _selectedFilter = filter;
                                });
                                _loadUsers(filter);
                              }
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

                                return UserListItem(
                                  user: user,
                                  palette: c,
                                  onEdit: () => _openUserFormModal(
                                    c,
                                    userToEdit: user,
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
      hintStyle: TextStyle(color: c.textMuted.withValues(alpha: 0.7), fontSize: 13),
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