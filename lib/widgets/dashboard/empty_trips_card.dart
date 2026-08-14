import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../buttons/primary_button.dart';

/// Empty-state card shown when there are no upcoming trips —
/// icon in a white circle, title, subtitle, and a "Find a ride →" CTA.
class EmptyTripsCard extends StatelessWidget {
  final VoidCallback onFindRide;

  const EmptyTripsCard({super.key, required this.onFindRide});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: AppColors.lightInputBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_busy_rounded,
              color: AppColors.primaryNavy,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No trips scheduled',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "You haven't booked any rides yet.",
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: 160,
            child: PrimaryButton(
              label: 'Find a ride',
              trailingIcon: Icons.arrow_forward_rounded,
              height: 44,
              onPressed: onFindRide,
            ),
          ),
        ],
      ),
    );
  }
}