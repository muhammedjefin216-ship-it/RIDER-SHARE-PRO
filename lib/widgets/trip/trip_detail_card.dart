import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'trip_badge.dart';
import 'route_timeline_display.dart';
import 'trip_info_tile.dart';

/// Rich trip card — trip ID, status badges, price, route timeline,
/// date/availability tiles, and Details/Cancel actions. Richer than
/// [TripListCard] (which is the compact row used on Home) — this is
/// the full detail card used on the My Trips screen.
class TripDetailCard extends StatelessWidget {
  final String tripId;
  final String roleBadgeLabel;
  final String statusBadgeLabel;
  final Color statusBadgeBg;
  final Color statusBadgeText;
  final String price;
  final String priceUnit;
  final String from;
  final String to;
  final String dateTimeLabel;
  final String availabilityLabel;
  final VoidCallback onDetails;
  final VoidCallback onCancel;

  const TripDetailCard({
    super.key,
    required this.tripId,
    required this.roleBadgeLabel,
    required this.statusBadgeLabel,
    this.statusBadgeBg = AppColors.lightInputBg,
    this.statusBadgeText = AppColors.primaryNavy,
    required this.price,
    this.priceUnit = 'Per seat',
    required this.from,
    required this.to,
    required this.dateTimeLabel,
    required this.availabilityLabel,
    required this.onDetails,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TRIP ID: $tripId',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      TripBadge(
                        label: roleBadgeLabel,
                        backgroundColor: AppColors.primaryNavy,
                        textColor: AppColors.white,
                      ),
                      const SizedBox(width: 6),
                      TripBadge(
                        label: statusBadgeLabel,
                        backgroundColor: statusBadgeBg,
                        textColor: statusBadgeText,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  Text(priceUnit, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          RouteTimelineDisplay(fromLabel: from, toLabel: to),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TripInfoTile(
                  icon: Icons.calendar_today_outlined,
                  title: 'Date & Time',
                  value: dateTimeLabel,
                ),
              ),
              Expanded(
                child: TripInfoTile(
                  icon: Icons.accessible_sharp,
                  title: 'Availability',
                  value: availabilityLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Details', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Cancel Trip',
                    style: TextStyle(color: Color(0xffDC2626), fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}