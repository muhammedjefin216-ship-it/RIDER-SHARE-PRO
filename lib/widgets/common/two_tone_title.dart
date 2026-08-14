import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Two-tone headline used on auth screens — the accent word renders
/// bigger, in a serif font, olive-gold (matching the "Ride" treatment
/// in BrandLogo); the rest renders smaller, sans-serif, dark navy/black.
/// E.g. "Sign" + " in to your\naccount", or "Start" + " your carpooling
/// journey today".
class TwoToneTitle extends StatelessWidget {
  final String accentWord;
  final String restOfTitle;
  final double fontSize;

  const TwoToneTitle({
    super.key,
    required this.accentWord,
    required this.restOfTitle,
    this.fontSize = 26,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: accentWord,
            style: TextStyle(
              color: AppColors.oliveGold,
              fontSize: fontSize * 1.15,
              fontFamily: 'serif',
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
          TextSpan(
            text: restOfTitle,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}