import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Full-bleed dark navy hero banner used at the top of Signup —
/// icon badge, two-tone heading (accent word gold/serif + rest white),
/// and a white70 subtitle underneath. Reusable for other "intro"
/// style banners if needed later.
class HeroBanner extends StatelessWidget {
  final IconData icon;
  final String accentWord;
  final String restOfTitle;
  final String subtitle;
  final EdgeInsetsGeometry padding;

  const HeroBanner({
    super.key,
    required this.icon,
    required this.accentWord,
    required this.restOfTitle,
    required this.subtitle,
    this.padding = const EdgeInsets.fromLTRB(24, 28, 24, 52),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.heroNavy,
      padding: padding,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.white, size: 28),
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: accentWord,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    color: AppColors.oliveGold,
                    fontSize: 29,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: restOfTitle,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}