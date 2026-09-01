import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SeatLegend extends StatelessWidget {
  const SeatLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _LegendItem(color: Color(0xffCBD5E1), label: 'Booked', filled: true),
        _LegendItem(color: AppColors.primaryNavy, label: 'Available', filled: false),
        _LegendItem(color: AppColors.primaryNavy, label: 'Selected', filled: true),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool filled;

  const _LegendItem({required this.color, required this.label, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: filled ? color : Colors.transparent,
            border: Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
      ],
    );
  }
}