import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Decorative green-to-red demand gradient bar with labels and a
/// circular position indicator. Purely visual — there's no live
/// demand data from the backend yet, so [positionFraction] (0.0-1.0)
/// is just a placeholder position until that data exists.
class DemandGradientBar extends StatelessWidget {
  final String lowLabel;
  final String highLabel;
  final String currentDemandLabel;
  final double positionFraction;

  const DemandGradientBar({
    super.key,
    this.lowLabel = 'LOW DEMAND\n₹2.5/km',
    this.highLabel = 'HIGH DEMAND\n₹4.5/km',
    this.currentDemandLabel = 'Current Demand: Low',
    this.positionFraction = 0.18,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(lowLabel, style: const TextStyle(fontSize: 9, color: AppColors.hintText)),
            Text(highLabel,
                style: const TextStyle(fontSize: 9, color: AppColors.hintText),
                textAlign: TextAlign.right),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final indicatorLeft =
                (constraints.maxWidth - 14) * positionFraction.clamp(0.0, 1.0);
            return Container(
              height: 6,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: const LinearGradient(
                  colors: [Color(0xff86EFAC), Color(0xffFCA5A5)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: indicatorLeft,
                    child: Container(
                      width: 14,
                      height: 14,
                      transform: Matrix4.translationValues(0, -4, 0),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                          BorderSide(color: AppColors.primaryNavy, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Text(currentDemandLabel,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}