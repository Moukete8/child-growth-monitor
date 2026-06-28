import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography tokens. Font family is IBM Plex Sans, matching the design prototype.
class AppTypography {
  AppTypography._();

  static TextTheme get textTheme => GoogleFonts.ibmPlexSansTextTheme();

  static TextStyle get h1 => GoogleFonts.ibmPlexSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: AppColors.textPrimary,
      );

  static TextStyle get h2 => GoogleFonts.ibmPlexSans(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get h3 => GoogleFonts.ibmPlexSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyStrong => GoogleFonts.ibmPlexSans(
        fontSize: 14.5,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get body => GoogleFonts.ibmPlexSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get caption => GoogleFonts.ibmPlexSans(
        fontSize: 12.5,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      );

  static TextStyle get label => GoogleFonts.ibmPlexSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      );

  static TextStyle get eyebrow => GoogleFonts.ibmPlexSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
        letterSpacing: 0.6,
      );
}
