import 'package:flutter/material.dart';

/// Design tokens extracted from the Claude Design prototype
/// (ChildGrowthApp.dc.html, RiskBadge.dc.html, StatTile.dc.html, GrowthChart.dc.html).
class AppColors {
  AppColors._();

  // Page / surface
  static const background = Color(0xFFEEF3F4);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE2EAEC);
  static const borderSubtle = Color(0xFFEEF3F4);

  // Text
  static const textPrimary = Color(0xFF16242B);
  static const textSecondary = Color(0xFF5E7480);
  static const textMuted = Color(0xFF8CA0A8);
  static const textFaint = Color(0xFFA7B6BC);
  static const textOnDark70 = Color(0xB3FFFFFF);

  // Parent role (teal)
  static const parentPrimary = Color(0xFF15728E);
  static const parentGradientStart = Color(0xFF1B7E9C);
  static const parentGradientEnd = Color(0xFF125E77);
  static const parentGradientDeep = Color(0xFF0E4F64);

  // Nurse role (navy)
  static const nursePrimary = Color(0xFF234C6E);
  static const nurseGradientStart = Color(0xFF2C5C82);
  static const nurseGradientEnd = Color(0xFF1E3F5C);

  // Accent
  static const accentCoral = Color(0xFFF2785C);

  // Risk levels
  static const riskNormalText = Color(0xFF1E7A52);
  static const riskNormalDot = Color(0xFF2E9E6B);
  static const riskNormalBg = Color(0xFFE4F4EC);

  static const riskModerateText = Color(0xFFB26A0E);
  static const riskModerateDot = Color(0xFFE08A1E);
  static const riskModerateBg = Color(0xFFFBF0DC);

  static const riskSevereText = Color(0xFFB23A33);
  static const riskSevereDot = Color(0xFFD24D45);
  static const riskSevereBg = Color(0xFFFBE7E5);

  // Info / misc
  static const infoBg = Color(0xFFE6F1F4);
  static const infoText = Color(0xFF16567A);
  static const toastBg = Color(0xFF16242B);
  static const nurseInfoBg = Color(0xFFE7F0F4);
  static const nurseInfoText = Color(0xFF1E466A);
  static const successBg = Color(0xFFE4F4EC);
  static const successText = Color(0xFF1E6B47);
  static const dangerBorder = Color(0xFFF4D7D4);
  static const dangerText = Color(0xFFD24D45);

  /// Returns the role-specific brand color.
  static Color brandFor(Role role) =>
      role == Role.parent ? parentPrimary : nursePrimary;

  /// Returns the role-specific header gradient.
  static LinearGradient headerGradientFor(Role role) {
    return role == Role.parent
        ? const LinearGradient(
            begin: Alignment(-0.6, -1),
            end: Alignment(0.6, 1),
            colors: [parentGradientStart, parentGradientEnd],
          )
        : const LinearGradient(
            begin: Alignment(-0.6, -1),
            end: Alignment(0.6, 1),
            colors: [nurseGradientStart, nurseGradientEnd],
          );
  }
}

enum Role { parent, nurse }

enum RiskLevel { normal, moderate, severe }

extension RiskLevelColors on RiskLevel {
  Color get textColor => switch (this) {
        RiskLevel.normal => AppColors.riskNormalText,
        RiskLevel.moderate => AppColors.riskModerateText,
        RiskLevel.severe => AppColors.riskSevereText,
      };

  Color get dotColor => switch (this) {
        RiskLevel.normal => AppColors.riskNormalDot,
        RiskLevel.moderate => AppColors.riskModerateDot,
        RiskLevel.severe => AppColors.riskSevereDot,
      };

  Color get backgroundColor => switch (this) {
        RiskLevel.normal => AppColors.riskNormalBg,
        RiskLevel.moderate => AppColors.riskModerateBg,
        RiskLevel.severe => AppColors.riskSevereBg,
      };

  String get defaultLabel => switch (this) {
        RiskLevel.normal => 'Healthy',
        RiskLevel.moderate => 'At Risk',
        RiskLevel.severe => 'Severe',
      };
}
