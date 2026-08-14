import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Single seat tile — reflects booked (0) / available (1) /
/// selected (2) state with the same color logic as the original
/// _buildSeatWidget, just extracted into a standalone widget.
class SeatTile extends StatelessWidget {
  final int state; // 0 booked, 1 available, 2 selected
  final VoidCallback? onTap;

  const SeatTile({super.key, required this.state, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color borderCol = AppColors.primaryNavy;
    Color bgCol = AppColors.white;
    Widget iconWidget =
        const Icon(Icons.person_outline, color: AppColors.primaryNavy, size: 20);

    if (state == 0) {
      bgCol = const Color(0xffCBD5E1);
      borderCol = const Color(0xffCBD5E1);
      iconWidget = const Icon(Icons.close, color: AppColors.white, size: 18);
    } else if (state == 2) {
      bgCol = AppColors.primaryNavy;
      borderCol = AppColors.primaryNavy;
      iconWidget = const Icon(Icons.person, color: AppColors.white, size: 20);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: bgCol,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderCol, width: 1.5),
        ),
        child: Center(child: iconWidget),
      ),
    );
  }
}

/// Non-interactive "driver seat" tile shown alongside the passenger
/// seat grid, purely decorative — matches the Figma layout where the
/// driver's own seat is shown as a distinct, unselectable tile.
class DriverSeatTile extends StatelessWidget {
  const DriverSeatTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xffE2E8F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings, size: 14, color: AppColors.textSecondary),
            SizedBox(height: 1),
            Text('DRIVE',
                style: TextStyle(fontSize: 6, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}