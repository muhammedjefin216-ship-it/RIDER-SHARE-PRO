import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Standard labeled input field (label above + light-filled field)
/// used across Login, Signup, Post Trip, Profile, etc.
///
/// Pass [suffixIcon] for things like the password visibility toggle.
/// Pass [customPrefix] instead of [prefixIcon] for non-icon prefixes
/// like the "+91 |" country code shown on the Phone Number field —
/// when [customPrefix] is set it takes priority over [prefixIcon].
class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final Widget? customPrefix;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.prefixIcon,
    this.customPrefix,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  }) : assert(
          prefixIcon != null || customPrefix != null,
          'Provide either prefixIcon or customPrefix',
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.hint,
            prefixIcon: customPrefix ??
                Icon(
                  prefixIcon,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.lightInputBg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}