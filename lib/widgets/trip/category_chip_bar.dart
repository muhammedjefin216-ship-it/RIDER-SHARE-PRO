import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


class CategoryChipBar extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const CategoryChipBar({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return ChoiceChip(
            label: Text(categories[index]),
            selected: isSelected,
            showCheckmark: false,
            selectedColor: AppColors.primaryNavy,
            backgroundColor: AppColors.lightInputBg,
            labelStyle: TextStyle(
              color: isSelected ? AppColors.white : AppColors.textLabel,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide.none,
            onSelected: (_) => onSelected(index),
          );
        },
      ),
    );
  }
}