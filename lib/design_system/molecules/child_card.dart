import 'package:flutter/material.dart';
import '../atoms/risk_badge.dart';
import '../tokens/app_colors.dart';

/// Molecule: child summary card used on the Parent dashboard.
class ChildCard extends StatelessWidget {
  const ChildCard({
    super.key,
    required this.name,
    required this.meta,
    required this.metric,
    required this.lastUpdated,
    required this.level,
    required this.badgeLabel,
    this.onTap,
  });

  final String name;
  final String meta;
  final String metric;
  final String lastUpdated;
  final RiskLevel level;
  final String badgeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const CircleAvatar(radius: 27, backgroundColor: AppColors.background, child: Icon(Icons.child_care, color: AppColors.textFaint)),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        ),
                        RiskBadge(level: level, label: badgeLabel),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(meta, style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        const Icon(Icons.monitor_weight_outlined, size: 16, color: AppColors.parentPrimary),
                        const SizedBox(width: 6),
                        Text(metric,
                            style: const TextStyle(
                                fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const Text('  ·  ', style: TextStyle(color: AppColors.textFaint)),
                        Text('Updated $lastUpdated',
                            style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textFaint),
            ],
          ),
        ),
      ),
    );
  }
}
