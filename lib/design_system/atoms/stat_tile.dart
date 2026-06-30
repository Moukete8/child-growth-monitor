import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';

enum StatTone { brand, moderate, severe }

/// Atom: nurse dashboard stat card. Mirrors StatTile.dc.html.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.value,
    required this.label,
    this.tone = StatTone.brand,
  });

  final String value;
  final String label;
  final StatTone tone;

  Color get _iconBg => switch (tone) {
        StatTone.brand => AppColors.nurseInfoBg,
        StatTone.moderate => AppColors.riskModerateBg,
        StatTone.severe => AppColors.riskSevereBg,
      };

  Color get _dotColor => switch (tone) {
        StatTone.brand => AppColors.parentPrimary,
        StatTone.moderate => AppColors.riskModerateDot,
        StatTone.severe => AppColors.riskSevereDot,
      };

  Color get _valueColor => switch (tone) {
        StatTone.brand => AppColors.parentPrimary,
        StatTone.moderate => AppColors.riskModerateText,
        StatTone.severe => AppColors.riskSevereText,
      };

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _iconBg,
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: tone == StatTone.brand
                  ? Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _dotColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    )
                  : Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                height: 1,
                color: _valueColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
