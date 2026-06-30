import 'package:flutter/material.dart';
import '../../design_system/templates/role_scaffold.dart';
import '../../design_system/tokens/app_colors.dart';
import 'parent_dashboard_screen.dart';
import 'parent_growth_charts_screen.dart';
import 'parent_notifications_screen.dart';
import 'parent_profile_screen.dart';
import 'parent_tips_screen.dart';

/// Shell hosting the 5 parent tabs (Home, Charts, Tips, Notifications,
/// Profile) in a single [PageView] so the user can swipe between them, with
/// one shared [RoleScaffold]/bottom nav synced to the current page.
class ParentShell extends StatefulWidget {
  const ParentShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<ParentShell> createState() => _ParentShellState();
}

class _ParentShellState extends State<ParentShell> {
  late final _controller = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  void _onNavTap(int i) {
    _controller.animateToPage(i, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RoleScaffold(
      role: Role.parent,
      currentNavIndex: _index,
      onNavTap: _onNavTap,
      header: const SizedBox.shrink(),
      body: PageView(
        controller: _controller,
        onPageChanged: (i) => setState(() => _index = i),
        children: const [
          ParentDashboardScreen(),
          ParentGrowthChartsScreen(),
          ParentTipsScreen(),
          ParentNotificationsScreen(),
          ParentProfileScreen(),
        ],
      ),
    );
  }
}
