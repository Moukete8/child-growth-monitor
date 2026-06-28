import 'package:flutter/material.dart';
import '../../design_system/molecules/list_tiles.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/templates/role_scaffold.dart';
import '../../design_system/tokens/app_colors.dart';

class NurseReportsScreen extends StatelessWidget {
  const NurseReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoleScaffold(
      role: Role.nurse,
      currentNavIndex: 3,
      onNavTap: (i) => _navigate(context, i),
      header: GradientHeader(
        role: Role.nurse,
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            SizedBox(height: 3),
            Text('Generate & export growth records', style: TextStyle(fontSize: 12.5, color: Color(0xD9FFFFFF))),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ReportTile(
            icon: Icons.history,
            title: 'Junior — Growth history',
            subtitle: 'Jan – May 2024 · 6 measurements',
            brand: AppColors.nursePrimary,
            onGeneratePdf: () => _toast(context, 'Generating PDF report…'),
            onExport: () => _toast(context, 'Exporting data (CSV)…'),
            onShare: () => _toast(context, 'Opening share sheet…'),
          ),
          const SizedBox(height: 12),
          ReportTile(
            icon: Icons.calendar_month_outlined,
            title: 'Amina — Monthly summary',
            subtitle: 'May 2024 · WAZ, HAZ, WHZ',
            brand: AppColors.nursePrimary,
            onGeneratePdf: () => _toast(context, 'Generating PDF report…'),
            onExport: () => _toast(context, 'Exporting data (CSV)…'),
            onShare: () => _toast(context, 'Opening share sheet…'),
          ),
          const SizedBox(height: 12),
          ReportTile(
            icon: Icons.groups_outlined,
            title: 'Clinic caseload',
            subtitle: '124 children · risk breakdown',
            brand: AppColors.nursePrimary,
            onGeneratePdf: () => _toast(context, 'Generating PDF report…'),
            onExport: () => _toast(context, 'Exporting data (CSV)…'),
            onShare: () => _toast(context, 'Opening share sheet…'),
          ),
        ],
      ),
    );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: AppColors.toastBg));
  }

  void _navigate(BuildContext context, int i) {
    const routes = ['/nurse/dashboard', '/nurse/children', '/nurse/alerts', '/nurse/reports', '/nurse/settings'];
    if (i != 3) Navigator.of(context).pushReplacementNamed(routes[i]);
  }
}
