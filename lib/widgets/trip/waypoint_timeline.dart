import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class WaypointStop {
  final String name;
  final String subLabel;
  final bool isFirst;
  final bool isLast;

  const WaypointStop({
    required this.name,
    required this.subLabel,
    this.isFirst = false,
    this.isLast = false,
  });
}

/// Route timeline supporting any number of stops (not just a fixed
/// from/to pair) — green dot for the first stop, red for the last,
/// gray for any stops in between, connected by a solid line.
class WaypointTimeline extends StatelessWidget {
  final List<WaypointStop> stops;

  const WaypointTimeline({super.key, required this.stops});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < stops.length; i++) ...[
          _StopRow(stop: stops[i], showLineBelow: i != stops.length - 1),
        ],
      ],
    );
  }
}

class _StopRow extends StatelessWidget {
  final WaypointStop stop;
  final bool showLineBelow;

  const _StopRow({required this.stop, required this.showLineBelow});

  @override
  Widget build(BuildContext context) {
    final dotColor = stop.isFirst
        ? AppColors.successGreen
        : stop.isLast
            ? Colors.redAccent
            : AppColors.primaryNavy;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(Icons.circle, size: 12, color: dotColor),
              if (showLineBelow) Expanded(child: Container(width: 2, color: AppColors.border)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: showLineBelow ? 20 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stop.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                  Text(stop.subLabel,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}