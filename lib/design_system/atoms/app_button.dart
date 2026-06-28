import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';

enum AppButtonVariant { primary, secondary, danger }

/// Atom: rounded full-width action button, matching the prototype's
/// `border-radius:13px` / `padding:15px` buttons.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;

  /// Overrides the primary background color (e.g. role brand color).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      if (icon != null) ...[
        Icon(icon, size: 20, color: _foreground),
        const SizedBox(width: 8),
      ],
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: _foreground,
        ),
      ),
    ];

    return SizedBox(
      width: double.infinity,
      child: switch (variant) {
        AppButtonVariant.secondary => OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.border),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: children),
          ),
        AppButtonVariant.danger => OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.dangerBorder),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: children),
          ),
        AppButtonVariant.primary => ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? AppColors.parentPrimary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: children),
          ),
      },
    );
  }

  Color get _foreground => switch (variant) {
        AppButtonVariant.primary => Colors.white,
        AppButtonVariant.secondary => AppColors.textPrimary,
        AppButtonVariant.danger => AppColors.dangerText,
      };
}
