import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class DropdownDisplayField extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const DropdownDisplayField({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.lightInputBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textLabel, fontSize: 14)),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.textLabel),
          ],
        ),
      ),
    );
  }
}