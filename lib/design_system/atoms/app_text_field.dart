import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';

/// Atom: bordered input field with optional leading icon, matching the
/// prototype's `border-radius:12px` inputs.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.placeholder,
    this.icon,
    this.obscureText = false,
    this.trailing,
    this.controller,
    this.keyboardType,
    this.onChanged,
  });

  final String? label;
  final String? placeholder;
  final IconData? icon;
  final bool obscureText;
  final Widget? trailing;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 7),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: AppColors.textFaint),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  style: TextStyle(fontSize: 14.5, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    hintText: placeholder,
                    hintStyle: TextStyle(color: AppColors.textFaint),
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ],
    );
  }
}
