import 'package:flutter/material.dart';
import '../organisms/app_bottom_nav.dart';
import '../tokens/app_colors.dart';

/// Template: page shell with the role-tinted background and bottom nav.
/// `header` is typically a [GradientHeader]; `body` scrolls independently.
class RoleScaffold extends StatelessWidget {
  const RoleScaffold({
    super.key,
    required this.role,
    required this.header,
    required this.body,
    this.currentNavIndex,
    this.onNavTap,
  });

  final Role role;
  final Widget header;
  final Widget body;

  /// Null hides the bottom nav (used by task/detail screens reached by push).
  final int? currentNavIndex;
  final ValueChanged<int>? onNavTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            header,
            Expanded(child: body),
          ],
        ),
      ),
      bottomNavigationBar: currentNavIndex == null
          ? null
          : AppBottomNav(role: role, currentIndex: currentNavIndex!, onTap: onNavTap ?? (_) {}),
    );
  }
}
