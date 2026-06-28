import 'package:flutter/material.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/templates/role_scaffold.dart';
import '../../design_system/tokens/app_colors.dart';

class NurseSettingsScreen extends StatefulWidget {
  const NurseSettingsScreen({super.key});

  @override
  State<NurseSettingsScreen> createState() => _NurseSettingsScreenState();
}

class _NurseSettingsScreenState extends State<NurseSettingsScreen> {
  String _lang = 'EN';

  @override
  Widget build(BuildContext context) {
    return RoleScaffold(
      role: Role.nurse,
      currentNavIndex: 4,
      onNavTap: (i) => _navigate(context, i),
      header: GradientHeader(
        role: Role.nurse,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: const [
            CircleAvatar(radius: 29, backgroundColor: Color(0x33FFFFFF), child: Icon(Icons.person, color: Colors.white, size: 28)),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nurse Joy Ekane', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: Colors.white)),
                  SizedBox(height: 2),
                  Text('Staff ID · HGD-0192', style: TextStyle(fontSize: 12.5, color: Color(0xD9FFFFFF))),
                ],
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.cloud_done_outlined, color: AppColors.riskNormalDot, size: 21),
                const SizedBox(width: 11),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sync status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      SizedBox(height: 1),
                      Text('Last synced 4 min ago', style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Syncing with Supabase…'), backgroundColor: AppColors.toastBg),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.nursePrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sync, size: 16, color: Colors.white),
                      SizedBox(width: 6),
                      Text('Sync now', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('PREFERENCES',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.6)),
          const SizedBox(height: 11),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () => setState(() => _lang = _lang == 'EN' ? 'FR' : 'EN'),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        const Icon(Icons.language, color: AppColors.nursePrimary, size: 21),
                        const SizedBox(width: 13),
                        const Expanded(child: Text('Language', style: TextStyle(fontSize: 14, color: AppColors.textPrimary))),
                        Text(_lang, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                        const Icon(Icons.chevron_right, color: AppColors.textFaint),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppColors.borderSubtle),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: const [
                      Icon(Icons.verified_user_outlined, color: AppColors.nursePrimary, size: 21),
                      SizedBox(width: 13),
                      Expanded(child: Text('Audit trail', style: TextStyle(fontSize: 14, color: AppColors.textPrimary))),
                      Text('Every record signed', style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AppButton(
            label: 'Log out',
            variant: AppButtonVariant.danger,
            icon: Icons.logout,
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, int i) {
    const routes = ['/nurse/dashboard', '/nurse/children', '/nurse/alerts', '/nurse/reports', '/nurse/settings'];
    if (i != 4) Navigator.of(context).pushReplacementNamed(routes[i]);
  }
}
