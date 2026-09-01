import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class CommunityBanner extends StatelessWidget {
  final String label;
  final String extraCountLabel;
  final ImageProvider? backgroundImage;

  const CommunityBanner({
    super.key,
    this.label = 'GROWING COMMUNITY',
    this.extraCountLabel = '+2k',
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.lightInputBg,
        borderRadius: BorderRadius.circular(16),
        image: backgroundImage != null
            ? DecorationImage(image: backgroundImage!, fit: BoxFit.cover)
            : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 18, color: Colors.white),
              ),
              Transform.translate(
                offset: const Offset(-8, 0),
                child: const CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.person, size: 18, color: Colors.white),
                ),
              ),
              Transform.translate(
                offset: const Offset(-16, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    extraCountLabel,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primaryNavy,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}