import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BottomNavItemData {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const BottomNavItemData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// Bottom navigation bar — supports any number of items (the Figma
/// Home screen shows 6: Home, Find a Ride, Post a Trip, Trips,
/// Earnings, Profile). [selectedIndex]/[onTap] are driven by the
/// screen so existing IndexedStack logic keeps working unchanged.
class AppBottomNavBar extends StatelessWidget {
  final List<BottomNavItemData> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.lightInputBg
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      isSelected ? item.selectedIcon : item.icon,
                      size: 21,
                      color: isSelected
                          ? AppColors.primaryNavy
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primaryNavy
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}