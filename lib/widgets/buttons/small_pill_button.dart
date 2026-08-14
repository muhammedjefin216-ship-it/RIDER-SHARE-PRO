import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Small compact pill button — used for things like "Join Now"
/// or "Sign in →" in a header row where a full PrimaryButton
/// would be too big. Pass [trailingIcon] for the arrow variant.
class SmallPillButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? trailingIcon;

  const SmallPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: AppColors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 4),
            Icon(trailingIcon, size: 15, color: AppColors.white),
          ],
        ],
      ),
    );
  }
}