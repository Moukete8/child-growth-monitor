import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';

/// Molecule: expandable nutrition/health advice card (Parent > Tips).
class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.shortText,
    required this.body,
    required this.expanded,
    required this.onToggle,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String shortText;
  final String body;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onToggle,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text(shortText, style: TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.textFaint),
                ],
              ),
              if (expanded) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, color: AppColors.borderSubtle),
                ),
                Text(body,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF4A5C64), height: 1.55)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
