import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BrandLogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final double? imageWidth;
  final double? imageHeight;

  const BrandLogo({
    super.key,
    this.iconSize = 65,
    this.fontSize = 40,
    this.imageWidth = 40,
    this.imageHeight = 35,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png', 
          width: imageWidth ?? iconSize,
          height: imageHeight ?? iconSize,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 3),
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