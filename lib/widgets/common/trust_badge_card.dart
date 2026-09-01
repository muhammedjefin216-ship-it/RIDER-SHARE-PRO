import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class TrustBadgeCard extends StatelessWidget {
  final String ratingLabel;
  final String ratingValue;
  final String statValue;
  final String statLabel;
  final List<String> avatarUrls;
  final String extraCountLabel;
  final String verifiedLabel;

  const TrustBadgeCard({
    super.key,
    this.ratingLabel = 'Community Trust',
    this.ratingValue = '4.9/5 Avg',
    this.statValue = '50k+',
    this.statLabel = 'ACTIVE COMMUTERS',
    this.avatarUrls = const [],
    this.extraCountLabel = '+50k',
    this.verifiedLabel = 'Verified',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ratingLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textLabel,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.starGold, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            ratingValue,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: VerticalDivider(color: AppColors.border, width: 1),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        statValue,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accentBlue,
                        ),
                      ),
                      Text(
                        statLabel,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _AvatarStack(extraCountLabel: extraCountLabel),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.verifiedPillBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded,
                        color: AppColors.primaryNavy, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      verifiedLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _AvatarStack extends StatelessWidget {
  final String extraCountLabel;

  const _AvatarStack({required this.extraCountLabel});

  @override
  Widget build(BuildContext context) {
    const double size = 24;
    const double overlap = 16;

    return SizedBox(
      height: size,
      width: size + overlap * 2,
      child: Stack(
        children: [
          _placeholderAvatar(left: 0, size: size),
          _placeholderAvatar(left: overlap, size: size),
          Positioned(
            left: overlap * 2,
            child: Container(
              height: size,
              width: size,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.accentBlue,
                shape: BoxShape.circle,
              ),
              child: Text(
                extraCountLabel,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 7,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderAvatar({required double left, required double size}) {
    return Positioned(
      left: left,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.featureCardBg,
          border: Border.all(color: AppColors.white, width: 1.5),
        ),
        child: const Icon(Icons.person, size: 14, color: AppColors.textSecondary),
      ),
    );
  }
}