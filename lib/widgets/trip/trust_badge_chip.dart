import 'package:flutter/material.dart';


class TrustBadgeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color contentColor;

  const TrustBadgeChip({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: contentColor, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: contentColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}