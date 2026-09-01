import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class ExploreMoreCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String ctaLabel;
  final VoidCallback onCtaTap;

  const ExploreMoreCard({
    super.key,
    this.title = 'Looking for more?',
    required this.subtitle,
    this.ctaLabel = 'Create a new trip',
    required this.onCtaTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.infoBannerBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.lightInputBg,
            child: Icon(Icons.directions_car_outlined, color: AppColors.textLabel, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: onCtaTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ctaLabel,
                  style: const TextStyle(
                    color: AppColors.primaryNavy,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 16, color: AppColors.primaryNavy),
              ],
            ),
          ),
        ],
      ),
    );
  }
}