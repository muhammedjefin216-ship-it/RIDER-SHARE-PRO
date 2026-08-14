import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Small translucent-white pill with an icon + label — used inside
/// [SearchSummaryBanner] for things like "📅 July 28, 2026" or
/// "👤 1 Passenger".
class InfoPillChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoPillChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}