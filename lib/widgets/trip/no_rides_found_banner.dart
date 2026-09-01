import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class NoRidesFoundBanner extends StatelessWidget {
  const NoRidesFoundBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: AppColors.textSecondary),
          SizedBox(height: 12),
          Text(
            "Can't find a ride?",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "No trips match your search right now. Try a different date or route.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}