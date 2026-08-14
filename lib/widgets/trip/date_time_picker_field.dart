import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Small bordered field showing a date/time value with a leading
/// icon — tapping it opens the picker (handled by the screen via
/// [onTap]). Purely presentational; the screen owns the picked value.
class DateTimePickerField extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DateTimePickerField({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xffF9FAFB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: AppColors.hintText),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textLabel)),
          ],
        ),
      ),
    );
  }
}