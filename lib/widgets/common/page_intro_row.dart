import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class PageIntroRow extends StatelessWidget {
  final String title;
  final String linkLabel;
  final VoidCallback onLinkTap;

  const PageIntroRow({
    super.key,
    required this.title,
    required this.onLinkTap,
    this.linkLabel = '← Dashboard',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: onLinkTap,
          child: Text(
            linkLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryNavy,
            ),
          ),
        ),
      ],
    );
  }
}