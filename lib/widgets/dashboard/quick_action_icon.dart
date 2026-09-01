import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class QuickActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isHighlighted;

  const QuickActionIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: isHighlighted
                    ? AppColors.white
                    : AppColors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isHighlighted ? AppColors.primaryNavy : AppColors.white,
                size: 20,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}