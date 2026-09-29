import 'package:flutter/material.dart';
import 'package:integrador_vi_mobile/theme/app_colors.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../theme/app_theme.dart';

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
    'Admins',
    'Cajeros',
    'Cocineros',
    'Meseros ',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;

    return Scaffold(
      // sin backgroundColor — lo toma de AppTheme.light/dark
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 20,
        title: Text(
          'Gestión de Usuarios',
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 20,
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
                style: TextStyle(color: c.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Buscar usuario por nombre o correo...',
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.group_outlined, size: 64, color: c.textMuted),
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
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.teal,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 2),
    );
  }
}
