import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';

/// Atom: pill-shaped risk indicator. Mirrors RiskBadge.dc.html.
class RiskBadge extends StatelessWidget {
  const RiskBadge({super.key, required this.level, this.label});

  final RiskLevel level;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final text = label ?? level.defaultLabel;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: level.backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: level.dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              color: level.textColor,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
