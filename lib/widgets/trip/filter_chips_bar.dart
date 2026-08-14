import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Horizontal scrolling row of filter chips (Filters / Morning /
/// Verified / Price: Low). Client-side only for now — no backend
/// filter API — matches the original FilterChipsBar's intent, just
/// restyled and with the "Morning" chip added to match Figma.
class FilterChipsBar extends StatelessWidget {
  const FilterChipsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          FilterChipItem(label: 'Filters', icon: Icons.tune_rounded, highlighted: true),
          SizedBox(width: 8),
          FilterChipItem(label: 'Morning'),
          SizedBox(width: 8),
          FilterChipItem(label: 'Verified'),
          SizedBox(width: 8),
          FilterChipItem(label: 'Price: Low', hasDropdown: true),
        ],
      ),
    );
  }
}

class FilterChipItem extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool hasDropdown;
  final bool highlighted;

  const FilterChipItem({
    super.key,
    required this.label,
    this.icon,
    this.hasDropdown = false,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: AppColors.primaryNavy),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: highlighted ? FontWeight.w600 : FontWeight.w500,
              color: highlighted ? AppColors.primaryNavy : AppColors.textPrimary,
            ),
          ),
          if (hasDropdown) ...[
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textSecondary),
          ],
        ],
      ),
    );
  }
}