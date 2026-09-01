import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class RideResultCard extends StatelessWidget {
  final String departureDate;
  final String departTime;
  final String avatarText;
  final String driver;
  final bool verified;
  final double rating;
  final num price;
  final String vehicleInfo;
  final int seatsLeft;
  final VoidCallback onViewRide;


  final String? adjacentDateLabel;
  final bool isLastSeats;
  final VoidCallback? onShare;

  const RideResultCard({
    super.key,
    required this.departureDate,
    required this.departTime,
    required this.avatarText,
    required this.driver,
    required this.verified,
    required this.rating,
    required this.price,
    required this.vehicleInfo,
    required this.seatsLeft,
    required this.onViewRide,
    this.adjacentDateLabel,
    this.isLastSeats = false,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withOpacity(0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (adjacentDateLabel != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    adjacentDateLabel!.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (isLastSeats)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.successGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'LAST SEATS',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.successGreen,
                          ),
                        ),
                      ],
                    ),
                ],
              )
            else
              Text(
                '$departureDate · $departTime'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),

            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.lightInputBg,
                  child: Text(
                    avatarText,
                    style: const TextStyle(
                      color: AppColors.primaryNavy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              driver,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (verified) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.check_circle,
                                size: 14, color: AppColors.primaryNavy),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.starGold, size: 13),
                          const SizedBox(width: 2),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹$price',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    const Text(
                      'TOTAL',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            if (vehicleInfo.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.directions_car_outlined,
                        size: 14, color: AppColors.primaryNavy),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        vehicleInfo,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            Row(
              children: [
                const Icon(Icons.event_seat_outlined,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  '$seatsLeft seats available',
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onViewRide,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNavy,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      adjacentDateLabel != null ? 'View Adjacent Ride' : 'View Ride',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                if (onShare != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onShare,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.lightInputBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.share_outlined,
                          size: 18, color: AppColors.primaryNavy),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}