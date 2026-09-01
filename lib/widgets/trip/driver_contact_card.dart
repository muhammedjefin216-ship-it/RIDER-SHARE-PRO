import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class DriverContactCard extends StatelessWidget {
  final String avatarText;
  final bool verified;
  final String driverName;
  final double rating;
  final String? memberSinceLabel;
  final VoidCallback onMessage;
  final VoidCallback onCall;

  const DriverContactCard({
    super.key,
    required this.avatarText,
    required this.verified,
    required this.driverName,
    required this.rating,
    required this.onMessage,
    required this.onCall,
    this.memberSinceLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.lightInputBg,
                child: Text(
                  avatarText,
                  style: const TextStyle(
                    color: AppColors.primaryNavy,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (verified)
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: AppColors.white,
                    child: Icon(Icons.check_circle, color: AppColors.primaryNavy, size: 14),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(driverName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.primaryNavy, size: 14),
                    const SizedBox(width: 2),
                    Text(rating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy)),
                    if (memberSinceLabel != null) ...[
                      const SizedBox(width: 6),
                      Text('• $memberSinceLabel',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          _iconButton(Icons.chat_bubble_outline_rounded, onMessage),
          const SizedBox(width: 8),
          _iconButton(Icons.phone_outlined, onCall),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.lightInputBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primaryNavy, size: 18),
      ),
    );
  }
}