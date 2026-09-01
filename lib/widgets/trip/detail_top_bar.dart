import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../common/brand_logo.dart';

/// Top bar for Trip Details — brand logo on the left, favorite
/// (heart) and share icon buttons on the right. No back arrow, per
/// Figma — the screen relies on the bottom "Back to My trips" button
/// (and the system back gesture) for navigation.
class DetailTopBar extends StatelessWidget {
  final bool isFavorited;
  final VoidCallback onFavoriteTap;
  final VoidCallback onShareTap;

  const DetailTopBar({
    super.key,
    required this.isFavorited,
    required this.onFavoriteTap,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 12, 8),
      child: Row(
        children: [
          const BrandLogo(iconSize: 34, fontSize: 17),
          const Spacer(),
          IconButton(
            onPressed: onFavoriteTap,
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? AppColors.error : AppColors.textPrimary,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: onShareTap,
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary, size: 20),
          ),
        ],
      ),
    );
  }
}