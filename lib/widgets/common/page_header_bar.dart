import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'two_tone_title.dart';


class PageHeaderBar extends StatelessWidget {
  final String accentWord;
  final String restOfTitle;
  final VoidCallback? onBack;
  final VoidCallback onNotificationTap;
  final Widget avatarMenu;

  const PageHeaderBar({
    super.key,
    required this.accentWord,
    required this.restOfTitle,
    required this.onNotificationTap,
    required this.avatarMenu,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          ),
          TwoToneTitle(
            accentWord: accentWord,
            restOfTitle: restOfTitle,
            fontSize: 17,
          ),
          const Spacer(),
          IconButton(
            onPressed: onNotificationTap,
            icon: const Icon(
              Icons.notifications_none_rounded,
              size: 22,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 4),
          avatarMenu,
        ],
      ),
    );
  }
}