import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../common/brand_logo.dart';


class DashboardTopBar extends StatelessWidget {
  final VoidCallback onNotificationTap;
  final bool hasUnreadNotification;
  final Widget avatarMenu;

  const DashboardTopBar({
    super.key,
    required this.onNotificationTap,
    required this.avatarMenu,
    this.hasUnreadNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 8),
      child: Row(
        children: [
          const BrandLogo(iconSize: 38, fontSize: 19),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: onNotificationTap,
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  size: 22,
                  color: AppColors.textPrimary,
                ),
              ),
              if (hasUnreadNotification)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
          avatarMenu,
        ],
      ),
    );
  }
}