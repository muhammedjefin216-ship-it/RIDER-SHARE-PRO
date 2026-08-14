import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Display-only route timeline — filled navy dot at top, dotted
/// connector, hollow gray dot at bottom, with from/to labels and
/// sub-labels (e.g. "Departure Point" / "Destination").
class RouteTimelineDisplay extends StatelessWidget {
  final String fromLabel;
  final String fromSubLabel;
  final String toLabel;
  final String toSubLabel;

  const RouteTimelineDisplay({
    super.key,
    required this.fromLabel,
    this.fromSubLabel = 'Departure Point',
    required this.toLabel,
    this.toSubLabel = 'Destination',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const Icon(Icons.circle, size: 10, color: AppColors.primaryNavy),
            Container(width: 2, height: 28, color: AppColors.border),
            Icon(Icons.circle, size: 10, color: AppColors.border),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fromLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(fromSubLabel, style: const TextStyle(color: AppColors.hintText, fontSize: 12)),
              const SizedBox(height: 12),
              Text(toLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(toSubLabel, style: const TextStyle(color: AppColors.hintText, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}