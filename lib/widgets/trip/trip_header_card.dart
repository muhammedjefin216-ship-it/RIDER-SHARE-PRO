import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Light green header card — "YOUR TRIP" label, route title,
/// seats-left/booked count top-right, and a "Total Earnings" row.
class TripHeaderCard extends StatelessWidget {
  final String from;
  final String to;
  final int seatsLeft;
  final int bookedCount;
  final num totalEarnings;

  const TripHeaderCard({
    super.key,
    required this.from,
    required this.to,
    required this.seatsLeft,
    required this.bookedCount,
    required this.totalEarnings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.hostingTagBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'YOUR TRIP',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.successGreen,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$from → $to',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$seatsLeft seats left\n$bookedCount booked',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Earnings',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              Text(
                '₹$totalEarnings',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.successGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}