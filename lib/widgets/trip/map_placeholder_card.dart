import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class MapPlaceholderCard extends StatelessWidget {
  final String distanceLabel;
  final String estimatedDriveLabel;
  final String trafficLabel;

  const MapPlaceholderCard({
    super.key,
    required this.distanceLabel,
    required this.estimatedDriveLabel,
    this.trafficLabel = 'Light',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xffE5E9F0),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 12,
            left: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(radius: 4, backgroundColor: AppColors.successGreen),
                      const SizedBox(width: 6),
                      const Text(
                        'GPS ACTIVE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    distanceLabel,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('EST. DRIVE',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(estimatedDriveLabel,
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(height: 24, width: 1, color: AppColors.border),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('TRAFFIC',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(trafficLabel,
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryNavy,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}