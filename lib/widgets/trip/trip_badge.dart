import 'package:flutter/material.dart';

/// Small rounded label badge — used for "HOST"/"UPCOMING" style tags
/// on trip cards. Colors are passed in so it covers any status.
class TripBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const TripBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}