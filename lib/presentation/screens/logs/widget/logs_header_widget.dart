import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../theme/app_theme.dart';
import '../../../providers/metrics_provider.dart';

class LogsHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;

  const LogsHeaderWidget({super.key, required this.controller});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 72);

  @override
  Widget build(BuildContext context) {
    final c = context.palette;

    return AppBar(
      title: const Text(
        'Bitácora y Rendimiento',
        style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: AppColors.teal),
          onPressed: () {
            Provider.of<MetricsProvider>(context, listen: false).fetchMetrics();
          },
        ),
      ],
      bottom: TabBar(
        controller: controller,
        indicatorColor: AppColors.teal,
        labelColor: AppColors.teal,
        unselectedLabelColor: c.textMuted,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        tabs: const [
          Tab(icon: Icon(Icons.history_rounded), text: 'Bitácora'),
          Tab(icon: Icon(Icons.speed_rounded), text: 'Rendimiento'),
        ],
      ),
    );
  }
}
