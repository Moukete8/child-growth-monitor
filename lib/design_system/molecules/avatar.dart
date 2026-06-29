import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';

/// Circular avatar that renders [imageUrl] when present, falling back to
/// [fallbackIcon] on a tinted background otherwise. Centralizes the
/// fallback so every profile/child-card call site doesn't repeat the
/// null-check.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.imageUrl,
    required this.fallbackIcon,
    this.radius = 27,
    this.backgroundColor,
    this.iconColor = Colors.white,
  });

  final String? imageUrl;
  final IconData fallbackIcon;
  final double radius;
  final Color? backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.parentGradientDeep;
    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bg,
        child: Icon(fallbackIcon, color: iconColor, size: radius * 0.9),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      backgroundImage: NetworkImage(imageUrl!),
    );
  }
}
