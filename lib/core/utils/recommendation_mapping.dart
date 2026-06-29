import 'package:flutter/material.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../who_growth/z_score_engine.dart';

/// One nutrition/health advice card, as shown on the Parent > Tips screen.
class Recommendation {
  const Recommendation({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.shortText,
    required this.body,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String shortText;
  final String body;
}

/// Maps the worst WHO Z-score classification from a child's latest
/// measurement to canned, tiered advice. There's no recommendations table —
/// this is derived purely from [ZClassification], same as the alert message
/// already built in MeasurementRepository.
List<Recommendation> recommendationsFor(ZClassification worst) {
  switch (worst) {
    case ZClassification.severe:
      return const [
        Recommendation(
          icon: Icons.local_hospital,
          iconBg: AppColors.riskSevereBg,
          iconColor: AppColors.riskSevereDot,
          title: 'Urgent hospital referral',
          shortText: 'See a nurse or hospital within 48 hours.',
          body:
              'This measurement shows a severe risk. Bring the child to the nearest health facility promptly for a full nutrition assessment and possible therapeutic feeding.',
        ),
        Recommendation(
          icon: Icons.restaurant,
          iconBg: AppColors.riskSevereBg,
          iconColor: AppColors.riskSevereDot,
          title: 'High-energy feeding',
          shortText: 'Offer small, frequent, energy-dense meals.',
          body:
              'Until seen by a health worker, offer small frequent meals enriched with oil, groundnut paste or milk to safely increase energy intake.',
        ),
        Recommendation(
          icon: Icons.warning_amber_outlined,
          iconBg: AppColors.riskSevereBg,
          iconColor: AppColors.riskSevereDot,
          title: 'Watch for danger signs',
          shortText: 'Lethargy, refusal to feed, or swelling.',
          body:
              'If the child becomes very weak, stops feeding, or develops swelling of the feet, seek emergency care immediately.',
        ),
      ];
    case ZClassification.moderate:
      return const [
        Recommendation(
          icon: Icons.restaurant,
          iconBg: AppColors.riskNormalBg,
          iconColor: AppColors.riskNormalDot,
          title: 'Protein-rich meals',
          shortText: 'Add beans & plantain to daily meals.',
          body:
              'Combine beans, groundnut paste and plantain to boost protein and energy density. Aim for 3 meals plus 2 snacks per day for children 1-3 years.',
        ),
        Recommendation(
          icon: Icons.local_hospital_outlined,
          iconBg: AppColors.nurseInfoBg,
          iconColor: AppColors.nursePrimary,
          title: 'Hospital referral',
          shortText: 'Schedule a nutrition check-up.',
          body:
              'If weight-for-age stays in the orange band for two visits, refer to the district hospital nutritionist for a feeding assessment.',
        ),
        Recommendation(
          icon: Icons.clean_hands_outlined,
          iconBg: AppColors.infoBg,
          iconColor: AppColors.parentPrimary,
          title: 'Hygiene & water',
          shortText: 'Boil water; wash hands before meals.',
          body:
              'Safe water and handwashing reduce diarrhoea, a major cause of weight loss. Store boiled water in a covered container.',
        ),
      ];
    case ZClassification.normal:
    case ZClassification.moderateHigh:
    case ZClassification.severeHigh:
      return const [
        Recommendation(
          icon: Icons.restaurant,
          iconBg: AppColors.riskNormalBg,
          iconColor: AppColors.riskNormalDot,
          title: 'Balanced meals',
          shortText: 'Keep offering a varied diet.',
          body:
              'Continue with a mix of staple foods, legumes, vegetables and fruit. No additional intervention is needed at this growth stage.',
        ),
        Recommendation(
          icon: Icons.event_available_outlined,
          iconBg: AppColors.infoBg,
          iconColor: AppColors.parentPrimary,
          title: 'Routine check-ups',
          shortText: 'Keep up routine growth check-ups.',
          body:
              'Regular monthly weigh-ins help catch any change in growth trend early, even when everything looks healthy today.',
        ),
        Recommendation(
          icon: Icons.clean_hands_outlined,
          iconBg: AppColors.infoBg,
          iconColor: AppColors.parentPrimary,
          title: 'Hygiene & water',
          shortText: 'Boil water; wash hands before meals.',
          body:
              'Safe water and handwashing reduce diarrhoea, a major cause of weight loss. Store boiled water in a covered container.',
        ),
      ];
  }
}
