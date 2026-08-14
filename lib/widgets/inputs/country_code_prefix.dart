import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// "+91 |" country code prefix used inside the Phone Number
/// [AppTextField] via its `customPrefix` slot.
class CountryCodePrefix extends StatelessWidget {
  final String code;

  const CountryCodePrefix({super.key, this.code = '+91'});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 12),
        Text(
          code,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Container(height: 18, width: 1, color: Colors.grey.shade400),
        const SizedBox(width: 8),
      ],
    );
  }
}