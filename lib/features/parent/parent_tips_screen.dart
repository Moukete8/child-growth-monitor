import 'package:flutter/material.dart';
import '../../design_system/molecules/recommendation_card.dart';
import '../../design_system/templates/role_scaffold.dart';
import '../../design_system/tokens/app_colors.dart';

class _Rec {
  const _Rec(this.icon, this.iconBg, this.iconColor, this.title, this.shortText, this.body);
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String shortText;
  final String body;
}

class ParentTipsScreen extends StatefulWidget {
  const ParentTipsScreen({super.key});

  @override
  State<ParentTipsScreen> createState() => _ParentTipsScreenState();
}

class _ParentTipsScreenState extends State<ParentTipsScreen> {
  int _openIndex = -1;

  static const _recs = [
    _Rec(Icons.restaurant, AppColors.riskNormalBg, AppColors.riskNormalDot, 'Protein-rich meals',
        'Add beans & plantain to daily meals.',
        'Combine beans, groundnut paste and plantain to boost protein and energy density. Aim for 3 meals plus 2 snacks per day for children 1-3 years.'),
    _Rec(Icons.local_hospital_outlined, AppColors.nurseInfoBg, AppColors.nursePrimary, 'Hospital referral',
        'Schedule a nutrition check-up.',
        'If weight-for-age stays in the orange band for two visits, refer to the district hospital nutritionist for a feeding assessment.'),
    _Rec(Icons.clean_hands_outlined, AppColors.infoBg, AppColors.parentPrimary, 'Hygiene & water',
        'Boil water; wash hands before meals.',
        'Safe water and handwashing reduce diarrhoea, a major cause of weight loss. Store boiled water in a covered container.'),
  ];

  @override
  Widget build(BuildContext context) {
    return RoleScaffold(
      role: Role.parent,
      currentNavIndex: 2,
      onNavTap: (i) => _navigate(context, i),
      header: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tips & Advice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            SizedBox(height: 3),
            Text('Nutrition guidance for Lucas', style: TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (var i = 0; i < _recs.length; i++) ...[
            RecommendationCard(
              icon: _recs[i].icon,
              iconBg: _recs[i].iconBg,
              iconColor: _recs[i].iconColor,
              title: _recs[i].title,
              shortText: _recs[i].shortText,
              body: _recs[i].body,
              expanded: _openIndex == i,
              onToggle: () => setState(() => _openIndex = _openIndex == i ? -1 : i),
            ),
            const SizedBox(height: 12),
          ],
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFFBF0DC), borderRadius: BorderRadius.circular(15)),
            child: const Row(
              children: [
                Icon(Icons.campaign, color: AppColors.riskModerateDot, size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Text('Advice updates automatically as new measurements arrive.',
                      style: TextStyle(fontSize: 12.5, color: Color(0xFF8A5A12), height: 1.5)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, int i) {
    const routes = ['/parent/dashboard', '/parent/charts', '/parent/tips', '/parent/notifications', '/parent/profile'];
    if (i != 2) Navigator.of(context).pushReplacementNamed(routes[i]);
  }
}
