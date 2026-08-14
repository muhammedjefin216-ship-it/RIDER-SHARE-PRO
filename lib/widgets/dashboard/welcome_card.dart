import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'quick_action_icon.dart';

/// The dark navy hero card on Home — "WELCOME BACK" + greeting + date
/// (serif, matching the brand style), an "Upcoming Trips" summary pill,
/// and a row of 4 quick-action icons. All content/behavior is passed
/// in by the screen — this widget is purely presentational.
class WelcomeCard extends StatelessWidget {
  final String greetingName;
  final bool isLoadingName;
  final String dateLabel;
  final int upcomingTripsCount;
  final VoidCallback onUpcomingTripsTap;
  final List<QuickActionIcon> quickActions;

  const WelcomeCard({
    super.key,
    required this.greetingName,
    required this.dateLabel,
    required this.upcomingTripsCount,
    required this.onUpcomingTripsTap,
    required this.quickActions,
    this.isLoadingName = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primaryNavy,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryNavy.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WELCOME BACK',
              style: TextStyle(
                fontFamily: 'serif',
                color: AppColors.oliveGold,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            isLoadingName
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Good afternoon, $greetingName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      color: AppColors.white,
                      fontSize: 15,
                    ),
                  ),
            const SizedBox(height: 2),
            Text(
              dateLabel,
              style: const TextStyle(
                fontFamily: 'serif',
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),

            // Upcoming trips summary pill
            GestureDetector(
              onTap: onUpcomingTripsTap,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.white.withOpacity(0.12)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.calendar_month_rounded,
                        color: AppColors.white,
                        size: 17,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Upcoming Trips',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'You have $upcomingTripsCount upcoming trips',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        color: Colors.white70, size: 18),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Quick actions
            Row(children: quickActions),
          ],
        ),
      ),
    );
  }
}