import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// The "RideSharePro" wordmark with its navy icon badge.
/// "Ride" renders bigger, in a serif font and olive-gold; "SharePro"
/// renders smaller, sans-serif bold, in navy — matches the Figma
/// wordmark exactly (the two words are NOT the same size/style).
class BrandLogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  
  const BrandLogo({
    super.key,
    this.iconSize = 38,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: iconSize,
          width: iconSize,
          decoration: BoxDecoration(
            color: AppColors.primaryNavy,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.directions_car_rounded,
            color: AppColors.white,
            size: iconSize * 0.58,
          ),
        ),
        const SizedBox(width: 10),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Ride',
                style: TextStyle(
                  color: AppColors.oliveGold,
                  fontSize: fontSize * 1.25,
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
              TextSpan(
                text: 'SharePro',
                style: TextStyle(
                  color: AppColors.primaryNavy,
                  fontSize: fontSize * 0.9,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}