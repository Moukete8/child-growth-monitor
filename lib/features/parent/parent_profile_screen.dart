import 'package:flutter/material.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/templates/role_scaffold.dart';
import '../../design_system/tokens/app_colors.dart';

class ParentProfileScreen extends StatefulWidget {
  const ParentProfileScreen({super.key});

  @override
  State<ParentProfileScreen> createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  String _lang = 'EN';

  @override
  Widget build(BuildContext context) {
    return RoleScaffold(
      role: Role.parent,
      currentNavIndex: 4,
      onNavTap: (i) => _navigate(context, i),
      header: GradientHeader(
        role: Role.parent,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: const [
            CircleAvatar(radius: 30, backgroundColor: Color(0x33FFFFFF), child: Icon(Icons.person, color: Colors.white, size: 28)),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sarah Johnson', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: Colors.white)),
                  SizedBox(height: 2),
                  Text('Parent · 2 children linked', style: TextStyle(fontSize: 13, color: Color(0xD9FFFFFF))),
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
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _infoRow(Icons.call_outlined, 'Phone', '+237 671 23 45 67', divider: true),
                _infoRow(Icons.mail_outline, 'Email', 'sarah@example.com', divider: false),
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
                        const Icon(Icons.language, color: AppColors.parentPrimary, size: 21),
                        const SizedBox(width: 13),
                        const Expanded(
                          child: Text('Language', style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                        ),
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
                    children: [
                      const Icon(Icons.cloud_done_outlined, color: AppColors.parentPrimary, size: 21),
                      const SizedBox(width: 13),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Offline data', style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                            SizedBox(height: 1),
                            Text('Synced · all measurements available offline',
                                style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      Container(width: 9, height: 9, decoration: const BoxDecoration(color: AppColors.riskNormalDot, shape: BoxShape.circle)),
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

  Widget _infoRow(IconData icon, String label, String value, {required bool divider}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.parentPrimary, size: 21),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                    const SizedBox(height: 1),
                    Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (divider) const Divider(height: 1, color: AppColors.borderSubtle),
      ],
    );
  }

  void _navigate(BuildContext context, int i) {
    const routes = ['/parent/dashboard', '/parent/charts', '/parent/tips', '/parent/notifications', '/parent/profile'];
    if (i != 4) Navigator.of(context).pushReplacementNamed(routes[i]);
  }
}
