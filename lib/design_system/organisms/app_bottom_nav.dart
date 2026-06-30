import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';

class NavItemData {
  const NavItemData({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

const parentNavItems = [
  NavItemData(icon: Icons.home_rounded, label: 'Home'),
  NavItemData(icon: Icons.monitor_heart_outlined, label: 'Charts'),
  NavItemData(icon: Icons.eco_outlined, label: 'Tips'),
  NavItemData(icon: Icons.notifications_outlined, label: 'Notices'),
  NavItemData(icon: Icons.person_outline, label: 'Profile'),
];

const nurseNavItems = [
  NavItemData(icon: Icons.dashboard_outlined, label: 'Home'),
  NavItemData(icon: Icons.groups_outlined, label: 'Children'),
  NavItemData(icon: Icons.warning_amber_outlined, label: 'Alerts'),
  NavItemData(icon: Icons.description_outlined, label: 'Reports'),
  NavItemData(icon: Icons.settings_outlined, label: 'Settings'),
];

/// Organism: bottom navigation bar, role-tinted active state.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.role,
    required this.currentIndex,
    required this.onTap,
  });

  final Role role;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final items = role == Role.parent ? parentNavItems : nurseNavItems;
    final brand = AppColors.brandFor(role);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(6, 7, 6, 9),
      child: Row(
        children: List.generate(items.length, (i) {
          final active = i == currentIndex;
          final color = active ? brand : const Color(0xFF9DB0B7);
          return Expanded(
            child: InkWell(
              onTap: () => onTap(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(items[i].icon, size: 23, color: color),
                    const SizedBox(height: 3),
                    Text(
                      items[i].label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
