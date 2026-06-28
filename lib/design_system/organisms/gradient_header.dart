import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';

/// Organism: the role-tinted gradient header used at the top of most screens.
class GradientHeader extends StatelessWidget {
  const GradientHeader({
    super.key,
    required this.role,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(18, 16, 18, 24),
  });

  final Role role;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(gradient: AppColors.headerGradientFor(role)),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: child,
      ),
    );
  }
}

/// Organism: the big branded header used at the top of the auth screens
/// (login, signup) — logo + app name, a large title and a subtitle, with an
/// optional back button so it can be reused on pushed screens.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.role,
    required this.title,
    required this.subtitle,
    this.onBack,
  });

  final Role role;
  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(26, 28, 26, 30),
      decoration: BoxDecoration(gradient: AppColors.headerGradientFor(role)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (onBack != null) ...[
                HeaderIconButton(icon: Icons.arrow_back, onPressed: onBack),
                const SizedBox(width: 12),
              ],
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.favorite, color: AppColors.accentCoral, size: 32),
                    Icon(Icons.child_care, color: Colors.white, size: 15),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Text('Child Growth Monitoring',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 22),
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.4)),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 13.5)),
        ],
      ),
    );
  }
}

/// A small circular icon button used inside gradient headers
/// (back arrow, notifications bell, etc.), matching the
/// `background:rgba(255,255,255,.12)` circular buttons in the prototype.
class HeaderIconButton extends StatelessWidget {
  const HeaderIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.showDot = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.white.withValues(alpha: 0.12),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 34,
              height: 34,
              child: Icon(icon, size: 20, color: Colors.white),
            ),
          ),
        ),
        if (showDot)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.accentCoral,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.parentGradientEnd, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}
