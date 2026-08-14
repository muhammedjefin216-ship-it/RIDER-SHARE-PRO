import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Small info tile — icon in a light circle, then a title/value pair.
/// Used for Date & Time / Availability on the trip card.
class TripInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const TripInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.lightInputBg,
          child: Icon(icon, color: AppColors.primaryNavy, size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}