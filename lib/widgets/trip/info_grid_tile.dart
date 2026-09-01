import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// White info tile — icon + caps label on top, value underneath.
/// Used in the 2x2 "Trip Information" grid on Trip Details.
class InfoGridTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlighted;

  const InfoGridTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xffFFF3E0) : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: highlighted ? const Color(0xffFFE0B2) : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: highlighted ? const Color(0xffB45309) : AppColors.textSecondary),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: highlighted ? const Color(0xffB45309) : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: highlighted ? const Color(0xffB45309) : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}