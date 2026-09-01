import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Decorative route map card — "GPS ACTIVE" badge, Street/Satellite
/// toggle (visual only), a distance+drive-time pill, and a 3-column
/// stats footer.
///
/// NOTE: same limitation as the seat-selection map — no real map/
/// geocoding integration exists yet, so this is a styled
/// placeholder, not a live map. The Street/Satellite toggle doesn't
/// switch any real content. "Route Feed: Live" is decorative text,
/// not a real live-tracking feed.
class RouteMapCard extends StatefulWidget {
  final String distanceLabel;
  final double distanceKm;
  final String estimatedDriveLabel;

  const RouteMapCard({
    super.key,
    required this.distanceLabel,
    required this.distanceKm,
    required this.estimatedDriveLabel,
  });

  @override
  State<RouteMapCard> createState() => _RouteMapCardState();
}

class _RouteMapCardState extends State<RouteMapCard> {
  bool _streetSelected = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xffE5E9F0),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 12,
                left: 12,
                child: Container(
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
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _toggleChip('Street', _streetSelected, () => setState(() => _streetSelected = true)),
                      _toggleChip('Satellite', !_streetSelected, () => setState(() => _streetSelected = false)),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${widget.distanceLabel} • ${widget.estimatedDriveLabel}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _footerStat('DISTANCE', widget.distanceLabel),
              _footerStat('EST. DRIVE', widget.estimatedDriveLabel),
              _footerStatWithDot('ROUTE FEED', 'Live'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _toggleChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryNavy : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: selected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _footerStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 9, color: AppColors.hintText, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _footerStatWithDot(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 9, color: AppColors.hintText, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(color: AppColors.successGreen, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(value,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ],
        ),
      ],
    );
  }
}